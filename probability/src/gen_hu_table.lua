local table_mgr = require "table_mgr"

local cached = {}

local function add_to_table(t, num)
    local k1 = 0
	local k2 = 0
	local k3 = 0
    for i=1,9 do
        k1 = (k1 << 3) + t[i]
		k2 = (k2 << 3) + t[i+9]
		k3 = (k3 << 3) + t[i+18]
    end
	local key = k1 .." ".. k2 .." ".. k3
	if cached[key] then
		return true
	end
	cached[key] = true

	table_mgr:add(key, num)
end

local function gen_table_sub(t, num)
	for j=1,48 do
        repeat
            local index
            if j <= 27 then
                if t[j] > 1 then
                    break
                end
                t[j] = t[j] + 3
            else
				index = j - 27 + 2*math.floor((j-27-1)/7)
				--print(index,j,2*math.floor((j-27-1)/7))
                if t[index] >= 4 or t[index+1] >= 4 or t[index+2] >= 4 then
                    break
                end
				t[index] = t[index] + 1
                t[index + 1] = t[index + 1] + 1
                t[index + 2] = t[index + 2] + 1
            end

            if num < 4 then
				if not add_to_table(t, 2+num*3) then
					gen_table_sub(t, num + 1)
				end
			else
				-- 暂时只加14张牌
				add_to_table(t, 2+num*3)
            end

            if j<= 27 then
                t[j] = t[j] - 3
            else
                t[index] = t[index] - 1
                t[index + 1] = t[index + 1] - 1
                t[index + 2] = t[index + 2] - 1
            end
        until(true)
    end
end

local function gen_eye_table()
    local t = {
		0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0
	}

    for i=1,27 do
		print("进度"..i.."/27")
        t[i] = 2
		add_to_table(t, 2)
        gen_table_sub(t, 1)
        t[i] = 0
    end
	table_mgr:dump()
end

table_mgr:init()
gen_eye_table()