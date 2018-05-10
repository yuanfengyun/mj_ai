local hu_table = require "hu_table"

local function add_to_table(t)
    local k = 0
    for i=1,9 do
        k = k * 10 + t[i]
    end
	hu_table:add(k)
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

            if num < 3 then
                gen_table_sub(t, num + 1)
			else
				-- 暂时只加14张牌
				add_to_table(t)
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

local function gen_eye_table()
    local t = {0,0,0,0,0,0,0,0,0}

    for i=1,9 do
        t[i] = 2
        gen_table_sub(t, 1)
        t[i] = 0
    end
	hu_table:dump("hu_table.txt")
end

gen_eye_table()