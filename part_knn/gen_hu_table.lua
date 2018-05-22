local table_mgr = require "table_mgr"

local cached = {}

local function add_to_table(t, level)
    local k = 0
    for i=1,9 do
        k = k | (t[i]) << ((i-1)*3)
    end
	
	if cached[k] then
		return false
	end

	table_mgr:add(level*3, k)

	-- 加将
	local eye = 2
	for i=9,1,-1 do
        if t[i] <= 2 then
			table_mgr:add(level*3+2, k+eye)
		end
		eye = eye * 10
    end

	return true
end

local function gen_table_sub(t, num)
    for j=1,16 do
        repeat
            local index
            if j <= 9 then
                if t[j] > 1 then
                    break
                end
                t[j] = t[j] + 3
            elseif j<= 16 then
                index = j - 9
                if t[index] >= 4 or t[index+1] >= 4 or t[index+2] >= 4 then
                    break
                end
            end
            if index then
                t[index] = t[index] + 1
                t[index + 1] = t[index + 1] + 1
                t[index + 2] = t[index + 2] + 1
            end

            if add_to_table(t, num) and num < 4 then
                gen_table_sub(t, num + 1)
            end

            if j<= 9 then
                t[j] = t[j] - 3
            else
                t[index] = t[index] - 1
                t[index + 1] = t[index + 1] - 1
                t[index + 2] = t[index + 2] - 1
            end
        until(true)
    end
end

local function gen_table()
    local t = {0,0,0,0,0,0,0,0,0}

	local eye = 2
	for i=1,9 do
		table_mgr:add(2, eye)
		eye = eye * 10
	end

    gen_table_sub(t, 1)
	table_mgr:dump()
end

gen_table()