local M = {
	tables = {}
}

function M:init()
	for i=1,4 do
		self:init_one(i)
	end
end

function M:init_one(n)
	local tbl = {}
	local t = {}
	table.insert(t,2)
	for i=1,n do
		table.insert(t, 3)
	end

	local cache = {}
	local result = {}
	local bucket = {0,0,0}
	self:init_one_part(1,n+1,bucket,t,cache,result)
	self.tables[2+3*n] = result
end

function M:init_one_part(level,max_level,bucket,t,cache,result)
	for i=1,3 do
		bucket[i] = bucket[i] + t[level]
		if level < max_level then
			self:init_one_part(level+1,max_level,bucket,t,cache,result)
		else
			local key = (bucket[1]<<8) + (bucket[2]<<4) + bucket[3]
			if not cache[key] then
				cache[key] = true
				table.insert(result, {bucket[1],bucket[2],bucket[3]})
			end
		end
		bucket[i] = bucket[i] - t[level]
	end
end

function M:get(sum)
	return self.tables[sum]
end

return M