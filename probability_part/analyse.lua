local table_mgr = require "table_mgr"
local part = require "part"

local cached = {}
function mathC(n, m)
	if m == 0 or m == n then
		return 1
	end

	if n - m < m then
		m = n - m
	end

	local key = n*256 + m
	local cache = cached[key]
	if cache then
		return cache
	end
	
	local a = 1
    local b = 1

	for i = n,n - m + 1,-1 do
		a = a*i
	end
	for i = 1,m do
		b = b*i
	end
	cache = a / b
	cached[key] = cache
	return cache
end

local M = {}

function M.init()
	table_mgr:load()
	part:init()
end

function M.check_hu(t)
	local k1=0
	local k2=0
	local k3=0

	local sum1 = 0
	local sum2 = 0
	local sum3 = 0

	for i=1,9 do
		local bit = (i-1)*3
        k1 = k1 | (t[i]) << bit
		k2 = k2 | (t[i+9]) << bit
		k3 = k3 | (t[i+18]) << bit
		
		sum1 = sum1 + t[i]
		sum2 = sum2 + t[i+9]
		sum3 = sum3 + t[i+18]
	end

	return (sum1 == 0 or table_mgr:check(sum1, k1)) and (sum2 == 0 or table_mgr:check(sum2, k2)) and (sum3 == 0 or table_mgr:check(sum3, k3))
end

-- 随机出牌
function M.get_random(hand_cards)
	local t = {}
	local v = 1
	for i=1,27 do
		local n_hand = hand_cards[i]
		if n_hand > 0 then
			table.insert(t,i)
		end
	end

	print("出随机牌")
	return t[math.random(1,#t)],0
end

function M.analyse(out_cards, hand_cards)
    local sum=0
	local sum_out = 0
	for i=1,27 do
        sum = sum + hand_cards[i]
		sum_out = sum_out + out_cards[i]
	end

	local n = 108 - sum - sum_out
	
	local pro = {
		[1] = {0,0,0,0,0,0},
		[2] = {0,0,0,0,0,0},
		[3] = {0,0,0,0,0,0},
	}
	pro[1][0]=0
	pro[2][0]=0
	pro[3][0]=0
	
	local tbl = part:get(sum)
	local max_score = 0
	local max_card
	for i=1,27 do
		local c = hand_cards[i]
		if c > 0 then
			hand_cards[i] = hand_cards[i] - 1
			local score = M.get_score(tbl, out_cards, hand_cards, n, pro)
			--print(i, score)
			if score > max_score then
				max_score = score
				max_card = i
			end
			hand_cards[i] = hand_cards[i] + 1
		end
	end

	if max_card then
		return max_card
	end
	
	return M.get_random(hand_cards)
end

function M.get_score(tbl, out_cards, hand_cards, n, pro)
	local hand_nums = {0,0,0}
	for i=1,9 do
		hand_nums[1] = hand_nums[1] + hand_cards[i]
		hand_nums[2] = hand_nums[2] + hand_cards[i+9]
		hand_nums[3] = hand_nums[3] + hand_cards[i+18]
	end
	local sum_pro = {0,0,0,0,0,0}
	
	for _,v in ipairs(tbl) do
		for i=1,3 do
			local pro_i = pro[i]
			for j=0,6 do
				pro_i[j] = 0
			end
		end
		for i=1,3 do
			local color_cards_num = v[i]
			if color_cards_num > 0 then
  			    if color_cards_num - hand_nums[i] <= 6 then
					local pro_i = pro[i]
					local t = table_mgr:get_tbl(color_cards_num)
					local begin = (i-1)*9
					for _,cards in pairs(t) do
						local br = false
						local c_A_a = 1
						local total_need = 0
						for c=1,9 do
							local card = begin + c
							local need = cards[c]
							if need > 0 then
								local hand = hand_cards[card]
								local left = 4 - hand - out_cards[card]
								local lack = need - hand
								if lack > 0 then
									total_need = total_need + lack
									if lack > left or total_need > 6 or total_need > color_cards_num then
										br = true
										break
									end
									c_A_a = c_A_a * mathC(left, lack)
								end
							end
						end

						if not br then
							pro_i[total_need] = pro_i[total_need] + c_A_a
						end
					end
				else
					break
				end
			else
			    if pro[i][0] == 0 then
					pro[i][0] = 1
				end
			end
		end
		
		local pro1 = pro[1]
		local pro2 = pro[2]
		local pro3 = pro[3]
		for i=0,6 do
			for j=0,6 do
				if i+j <= 6 then
					for k=0,6 do
						local sum = i + j + k
						if sum > 0 and sum <= 6 then
							local mul = pro1[i]*pro2[j]*pro3[k]
							if mul > 0 then
								sum_pro[sum] = sum_pro[sum] + mul
							end
						end
					end
				end
			end
		end
	end

	local params = {
		1,
		4,
		4,
		4,
		4,
		4
	}

	for i=1,6 do
		sum_pro[i] = sum_pro[i]/mathC(n,i)
	end

	local result = 0
	local param = 1
	for i=1,6 do
		result = result + sum_pro[i] * param / params[i]
	end
	return result
end

return M