local M = {
    tbl = {}
}

function M:add(key, card)
	local t = self.tbl[key]
	if not t then
		t = {}
		self.tbl[key] = t
	end
    t[card] = true
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

		local key_begin, key_end = string.find(line, "=")
		local key = string.sub(line, 1, key_begin-1)
		local t_str = string.sub(line, key_begin + 1)
		local t = {}
		string.gsub(t_str,'[^,]+',function ( w )
			table.insert(t,tonumber(w))
		end)
        tbl[tonumber(key)] = t
    end
    f:close()
end

function M:dump(file)
    local f = io.open(file, "w+")
    for k,t in pairs(self.tbl) do
        f:write(k.."=")
		for card,_ in pairs(t) do
		    f:write(card..",")
		end
		f:seek("cur",-1)
		f:write("\n")
    end
    f:close()
end

return M