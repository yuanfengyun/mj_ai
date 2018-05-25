local analyse = require "analyse"

analyse.init()

local out_cards = {
	2,2,0,0,0,1,1,0,1,
	2,2,0,0,1,1,1,1,1,
	2,0,1,0,0,1,2,2,3
}

local hand_cards = {
	0,0,0,1,2,1,1,0,0,
	0,0,0,0,1,1,0,0,0,
	1,0,1,1,0,1,1,1,1
}

local begin = os.time()
for i=1,20 do
	analyse.analyse(out_cards, hand_cards)
end

print(os.time()-begin,"秒")