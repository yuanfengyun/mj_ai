local M = {
    tbl = {}
}

function M:add(key)
    self.tbl[key] = true
end

function M:check(key)
    return self.tbl[key]
end

function M:load(file)
    local f = io.open(file, "r")
	local tbl = self.tbl
    while true do
        local line = f:read()
        if not line then
            break
        end

        tbl[tonumber(line)] = true
    end
    f:close()
end

function M:dump(file)
    local f = io.open(file, "w+")
    for k,_ in pairs(self.tbl) do
        f:write(k.."\n")
    end
    f:close()
end

return M