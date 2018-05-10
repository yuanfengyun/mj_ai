local ting_table = require "ting_table"

local diff_tbl = {
	[1] = {1000},
	[2] = {200,1200},
	[3] = {100,600,5000},
	[4] = {50,300,800,2000}
}

local M = {}

function M.init()
	math.randomseed(os.time())
    ting_table:load("ting_table.txt")
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
	
	return t[math.random(1,#t)]
end

function M.analyse(out_cards, hand_cards)
	local ting_key = M.get_ting_key(out_cards, hand_cards)
	if not ting_key then
		return M.get_random(hand_cards)
	end
	
	-- 根据目标选择出哪张牌
	
	-- 候选
	local t = {}
	local v = 1
	for i=1,9 do
	    if v > ting_key then
		    break
		end
	    local n_ting = math.floor(ting_key/v)%10
		local n_hand = math.floor(hand_cards/v)%10
		if n_hand > n_ting then
			table.insert(t,10-i)
		end
		v = v * 10
	end
	
	return t[math.random(1,#t)]
end

function M.get_ting_key(out_cards, hand_cards)
    local t = {}
	for ting_key, ting_cards in pairs(ting_table.tbl) do
	    local diff = M.get_diff(out_cards, hand_cards, ting_key, ting_cards)
		if diff >= 0 then
			local v = t[4]
			if not v or diff < v.diff then
				t[4] = {diff=diff, ting_key = ting_key}
				
				for i=3,1,-1 do
					local me = t[i+1]
					local cur = t[i]
					if cur and me.diff > cur.diff then
					    break
					end

					t[i+1],t[i] = cur,me
				end
			end
		end
	end

	if not next(t) then
	    return
	end

	-- 选取1种
	local max_index = #t
	local last_diff = t[1].diff
	for i=2,4 do
	    if t[i].diff > last_diff + 1000 then
			max_index = i - 1
			break
		end
	end
	
	for _,v in ipairs(t) do 
		print("候选听牌",v.ting_key," 差异值:",v.diff)
	end
	
	local index = math.random(1,max_index)
	local ting_key = t[index].ting_key
	print("选中听牌",ting_key)
	return ting_key
end

function M.get_diff(out_cards, hand_cards, ting_key, ting_cards)
    -- 牌没有了
	local v = 1
	for i=1,9 do
	    if v > ting_key then
		    break
		end
	    local n_ting = math.floor(ting_key/v)%10
        if n_ting > 0 then
			local n_hand = math.floor(hand_cards/v)%10
			local n_out = math.floor(out_cards/v)%10
			-- 永远摸不到这张牌
			if n_ting > 4-n_out then
				return -1
			end
		end
		v = v * 10
	end
	
	-- 听的牌没有了
	local ting_num = 0
	for card,_ in pairs(ting_cards) do
		local n_hand = math.floor(hand_cards/v)%10
		local n_out = math.floor(out_cards/v)%10
		if n_hand + n_out < 4 then
			ting_num = ting_num + (4 - n_hand - n_out)
		end
	end
	
	if ting_num == 0 then
	    return -1
	end
	
	-- 获取差异牌的数量
	local diff = 0
	local v = 1
	for i=1,9 do
	    if v > ting_key then
		    break
		end
	    local n_ting = math.floor(ting_key/v)%10
        if n_ting > 0 then
			local n_hand = math.floor(hand_cards/v)%10
			local n_out = math.floor(out_cards/v)%10
			if n_ting > n_hand then
			    diff = diff + diff_tbl[4-n_out-n_hand][n_ting-n_hand]
			end
		end
		v = v * 10
	end

	return diff
end

return M