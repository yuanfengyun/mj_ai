local M = {
    tbls = {
		[2] = {},
		[3] = {},
		[5] = {},
		[6] = {},
		[8] = {},
		[9] = {},
		[11] = {},
		[12] = {},
		[14] = {}
	}
}

function M:add(index, key)
    self.tbls[index][key] = true
end

function M:check(index, key)
    return self.tbls[index][key]
end

function M:get_tbl(index)
	return self.tbls[index]
end

function M:load()
	for k,v in pairs(self.tbls) do
		self:load_one(k,v)
	end
end

function M:load_one(index, tbl)
	local file = string.format("./table/%d.tbl", index)
    local f = io.open(file, "r")
    while true do
        local line = f:read()
        if not line then
            break
        end

        local k = tonumber(line)
		local t = {}
		for i=1,9 do
			local bit = (i-1)*3
			t[i] = (k & (7 << bit)) >> bit
		end
		tbl[k] = t
    end
    f:close()
end

function M:dump()
	for k,v in pairs(self.tbls) do
		self:dump_one(k,v)
	end
end

function M:dump_one(index, tbl)
	local file = string.format("./table/%d.tbl", index)
    local f = io.open(file, "w+")
    for k,_ in pairs(tbl) do
        f:write(k.."\n")
    end
    f:close()
end

return M