local table_mgr = require "table_mgr"
local part = require "part"

local M = {}

function M.init()
	table_mgr:load()
	part:init()
end

function M.check_hu(hand_cards)
	return false
end

-- 随机出牌
function M.get_random(hand_cards)
	local t = {}
	local v = 1
	for i=1,9 do
		local n_hand = math.floor(hand_cards/v)%10
		if n_hand > 0 then
			table.insert(t,i)
		end
		v = v * 10
	end

	print("出随机牌")
	return t[math.random(1,#t)],0
end

function M.analyse(out_cards, hand_cards)
    local sum=0
	for i=1,27 do
        sum = sum + hand_cards[i]
	end

	local tbl = part:get(sum)
	local max_score = 0
	local max_card
	for i=1,27 do
		local c = hand_cards[i]
		if c > 0 then
			hand_cards[i] = hand_cards[i] - 1
			local score = M.get_score(tbl, out_cards, hand_cards)
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

function M.get_score(tbl, out_cards, hand_cards)
	local sum = 0
	for _,v in ipairs(tbl) do
		local mul = 1
		for i=1,3 do
			local sum_score = 1
			if v[i] > 0 then
				sum_score = 0
				local t = table_mgr:get_tbl(v[i])
				local begin = (i-1)*9
				local total = 0
				for _,cards in pairs(t) do
					total = total + 1
					local br = false
					local s = 1
					for c=1,9 do
						local card = begin + c
						local need = cards[c]
						if need > 0 then
							--满足不了条件了
							local left = 4 - hand_cards[card] - out_cards[card]
							local lack = need - hand_cards[card]
							if lack > left then
								br = true
								break
							end
							if lack > 0 then
								for i=1,left do
									if i <= lack then
										s = s * 0.25
									else
										s = s * 0.75
									end
								end
							end
						end
					end

					if not br then
						--sum_score = sum_score + s/total
						if s > sum_score then
							sum_score = s
						end
					end
				end
			end
			mul = mul * sum_score
		end
		sum = sum + mul
	end
	
	return sum
end

return M