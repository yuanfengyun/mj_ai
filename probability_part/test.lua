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

print("choose card:",analyse.analyse(out_cards, hand_cards))