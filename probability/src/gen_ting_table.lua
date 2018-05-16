local hu_table = require "hu_table"
local ting_table = require "ting_table"

hu_table:load("hu_table.txt")

for k,_ in pairs(hu_table.tbl) do
	local v = 1
	for i=1,9 do
	    if v > k then
		    break
		end
		local value = math.floor(k/v)%10
		if value > 0 then
			ting_table:add(k-v,i)
		end
		v = v * 10
	end
end

ting_table:dump("ting_table.txt")
