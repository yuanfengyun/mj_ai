local M = {
    tbl = {}
}

function M:init()
	for i=0,4 do
		self.tbl[i*3+2] = {}
	end
end

function M:add(key, num)
    self.tbl[num][key] = true
end

function M:check(key, num)
    return self.tbl[num][key]
end

function M:get_table(sum)
	return self.tbl[sum]
end

function M:load()
	for i=0,4 do
		self:load_one(i*3+2)
	end
end

function M:load_one(i)
	local tbl = self.tbl[i]
	local file = "../table/table_"..i..".tbl"
    local f = io.open(file, "r")
    while true do
        local line = f:read()
        if not line then
            break
        end
		
		local key_begin1 = string.find(line, "-")
		local key1 = string.sub(line, 1, key_begin1-1)
		local key_begin2 = string.find(line, "-", key_begin1+2)
		key2 = string.sub(line, key_begin1+1, key_begin2-1)
		key3 = string.sub(line, key_begin2+1)

        tbl[line] = {
			tonumber(key1),tonumber(key2),tonumber(key3)
		}
    end
    f:close()
end

function M:dump()
	for i=0,4 do
		self:dump_one(i*3+2)
	end
end

function M:dump_one(i)
	local tbl = self.tbl[i]
	local file = "../table/table_"..i..".tbl"
    local f = io.open(file, "w+")
    for k,_ in pairs(tbl) do
        f:write(k.."\n")
    end
    f:close()
end

return M