local analyse = require "analyse"

analyse.init()

local out_cards = 

local hand_cards = 230011310

print("hand cards:",hand_cards)
print("out cards:",out_cards)
print("choose card:",analyse.analyse(out_cards, hand_cards))