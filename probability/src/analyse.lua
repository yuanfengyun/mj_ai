local table_mgr = require "table_mgr"

local M = {}

function M.init()
	table_mgr:init()
	print("加载胡牌表开始")
	table_mgr:load()
	print("加载胡牌表结束")
end

function M.check_hu(hand_cards)
	local k1=0
	local k2=0
	local k3=0
	local sum = 0
	for i=1,9 do
		k1 = (k1<<3) + hand_cards[i]
		k2 = (k2<<3) + hand_cards[i+9]
		k3 = (k3<<3) + hand_cards[i+17]
		sum = sum + hand_cards[i] + hand_cards[i+9] + hand_cards[i+18]
	end
	local key = string.format("%d %d %d",k1,k2,k3)
	return table_mgr:check(key, sum)
end

-- 随机出牌
function M.get_random(hand_cards)
	local t = {}
	for i=1,27 do
		local n_hand = hand_cards[i]
		if n_hand > 0 then
			table.insert(t,i)
		end
	end
	
	print("出随机牌")
	return t[math.random(1,#t)]
end

function mathC(n, m)
	local c_n = n
	local c_m = 1
	local n_i = 1
	while n_i < m do
		c_n = c_n * (n - n_i)
		n_i = n_i + 1
		c_m = c_m * n_i
	end
	return c_n/c_m
end

function M.analyse(out_cards, hand_cards)
	local sum = 0
	local out_cards_sum = 0
	for i=1,27 do
		sum = sum + hand_cards[i]
		out_cards_sum = out_cards_sum + out_cards[i]
	end

	local n = 108 - out_cards_sum - sum

	local m = 5
    --local c_n_m = mathC(n, m)
	
	local max_score = 0
	local max_card = 0
	local tbl = table_mgr:get_table(sum)
	for i=1,27 do
		-- 扣除1张牌以后的胡牌概率
		if hand_cards[i] > 0 then
			print(i)
			hand_cards[i] = hand_cards[i] - 1
			out_cards[i] = out_cards[i] + 1
			local score = M.get_score(out_cards, hand_cards, tbl, n, m)
			printf("card=%d, score=%d\n",i,score);

			if score > max_score then
				max_score = score
				max_card = i
			end
			out_cards[i] = out_cards[i] - 1
			hand_cards[i] = hand_cards[i] + 1
		end
	end
	
	if not max_card then
		return M.get_random(hand_cards)
	end
	
	return max_card
end

function M.get_score(out_cards, hand_cards, tbl, n, m)
    local score = 0
    for _,v in pairs(tbl) do
		local br = true
		local c_A_a = 1
		local total_need = 0
		for i=1,27 do
		    local index = math.floor((i-1)/9)+1
			local k =v[index]
			local bit = (i-(index-1)*9 - 1)*3
			local need = (k & (7 << bit)) >> bit
			if need > 0 then
				local left = 4 - hand_cards[i] - out_cards[i]
				if need > left then
					br = false
					break
				end
				local lack = need - hand_cards[i]
				if lack then
					total_need = total_need + lack
					c_A_a = c_A_a * mathC(left, lack)
				end
			end
		end
		if br then
			local c_need = 1
			if m > total_need then
				c_need = mathC(n-total_need, m-total_need)
			elseif m < total_need then
				c_need = 0
			end
			score = score + c_A_a * c_need
		end
	end
	return score
end

return M