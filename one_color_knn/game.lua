local analyse = require "analyse"

local M = {}

function M:init()
	self.out_cards = 0
	self.cards = {}
	
	self.player1_hand_cards = 0
	self.player2_hand_cards = 0

	self.player1_out_cards = {}
	self.player2_out_cards = {}
	analyse.init()
end

-- 随机洗牌
function M:shuffle()
	local t = {}
	for i=1,9 do
	    table.insert(t,i)
		table.insert(t,i)
		table.insert(t,i)
		table.insert(t,i)
	end
	
	self.cards = t
end

function M:start()
	print("===============新的一局游戏开始===============")
	self:shuffle()
	-- 发牌
	for i=1,10 do
		local card = table.remove(self.cards, math.random(1,#self.cards))
		self.player1_hand_cards = self.player1_hand_cards + 1*(10^(card-1))

		card = table.remove(self.cards, math.random(1,#self.cards))
		self.player2_hand_cards = self.player2_hand_cards + 1*(10^(card-1))
	end
	self.status = "ai"
end

-- 发牌
function M:dispatch(index)
	if not next(self.cards) then
		return
	end
	local card
	if index == 1 then
		card = table.remove(self.cards, math.random(1,#self.cards))
		self.player1_hand_cards = self.player1_hand_cards + 1*(10^(card-1))
	else
		card = table.remove(self.cards, math.random(1,#self.cards))
		self.player2_hand_cards = self.player2_hand_cards + 1*(10^(card-1))
	end
	return card
end

-- 显示
function M:show()
    local hand_cards1 = ""
	local hand_cards2 = ""
	local out_cards1 = ""
	local out_cards2 = ""
	local aim = ""
	local v = 1
	for i=1,9 do
		local n_hand = math.floor(self.player1_hand_cards/v)%10
		if n_hand > 0 then
			hand_cards1 = hand_cards1 .. string.rep(i,n_hand)
		end

		n_hand = math.floor(self.player2_hand_cards/v)%10
		if n_hand > 0 then
			hand_cards2 = hand_cards2 .. string.rep(i,n_hand)
		end
		
		if self.ai_aim then
			n_hand = math.floor(self.ai_aim/v)%10
			if n_hand > 0 then
				aim = aim .. string.rep(i,n_hand)
			end
		end
		v = v * 10
	end

    for _,v in ipairs(self.player1_out_cards) do
		out_cards1 = out_cards1 .. v
	end
	
	for _,v in ipairs(self.player2_out_cards) do
		out_cards2 = out_cards2 .. v
	end

	print("电脑手牌",hand_cards1)
	print("电脑出牌",out_cards1)
	print("候选牌型",aim)
	print()
	print("自己出牌",out_cards2)
	print("自己手牌",hand_cards2)
end

function M:sleep(n)
   os.execute("ping -n " .. tonumber(n + 1) .. " localhost > NUL")
end

function M:cls()
	--os.execute("cls")
	print("====================================================================")
	print("")
	print("")
end

function M:ai()
	local dispatch_card = self:dispatch(1)
	if not dispatch_card then
		self.status = "gameover"
		print("平局")
		return
	end
	self:cls()
	print("ai摸牌"..dispatch_card.."，思考中。。。")
	self:show()
	self:sleep(4)
	self:cls()
	if analyse.check_hu(self.player1_hand_cards) then
		print("ai胡牌")
		self:show()
		self.status = "gameover"
		return
	end
	local card, ting_key = analyse.analyse(self.out_cards, self.player1_hand_cards)
	self.ai_aim = ting_key
	self.player1_hand_cards = self.player1_hand_cards - 1*(10^(card-1))
	self.out_cards = self.out_cards + (10^(card-1))
	table.insert(self.player1_out_cards,card)
	print("ai出牌"..card)
	self:show()
	self.status = "player"
	self:sleep(5)
end

function M:player()
	local dispatch_card = self:dispatch(2)
	if not dispatch_card then
		self.status = "gameover"
		print("平局")
		return
	end
	self:cls()
	print("玩家请出牌。。。")
	self:show()
	while true do
		local card = io.read("*num")
		local n = math.floor(self.player2_hand_cards/(10^(card-1)))%10
		if n > 0 then
			self.player2_hand_cards = self.player2_hand_cards - 1*(10^(card-1))
			self.out_cards = self.out_cards + (10^(card-1))
			table.insert(self.player2_out_cards,card)
			self.status = "ai"
			self:cls()
			print("玩家已出牌。。。")
			self:show()
			self:sleep(5)
			break
		else
			self:cls()
			print("请重新输入。。。")
			self:show()
		end
	end
end

function M:loop()
	while true do
		if self.status == "ai" then
			self:ai()
	    elseif self.status == "player" then
			self:player()
		elseif self.status == "gameover" then
			break
    	end
	end
end

return M