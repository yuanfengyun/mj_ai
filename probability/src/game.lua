local analyse = require "analyse"

local M = {}

function M:init()
	analyse.init()
end

-- 随机洗牌
function M:shuffle()
	local t = {}
	for i=1,27 do
	    table.insert(t,i)
		table.insert(t,i)
		table.insert(t,i)
		table.insert(t,i)
	end
	
	self.cards = t
end

function M:start()
	print("===============新的一局游戏开始===============")
	self.out_cards = {}
	self.cards = {}
	
	self.player1_hand_cards = {}
	self.player2_hand_cards = {}
	for i=1,27 do
		table.insert(self.player1_hand_cards,0)
		table.insert(self.player2_hand_cards,0)
		table.insert(self.out_cards,0)
	end

	self.player1_out_cards = {}
	self.player2_out_cards = {}

	self:shuffle()
	-- 发牌
	for i=1,13 do
		local card = table.remove(self.cards, math.random(1,#self.cards))
		self.player1_hand_cards[card] = self.player1_hand_cards[card] + 1

		card = table.remove(self.cards, math.random(1,#self.cards))
		self.player2_hand_cards[card] = self.player2_hand_cards[card] + 1
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
		self.player1_hand_cards[card] = self.player1_hand_cards[card] + 1
	else
		card = table.remove(self.cards, math.random(1,#self.cards))
		self.player2_hand_cards[card] = self.player2_hand_cards[card] + 1
	end
	return card
end

function M:get_card_str(card)
	if card <= 9 then
		return card .. "万"
	elseif card <= 18 then
		return (card-9).."筒"
	else
		return (card-18).."条"
	end
end

-- 显示
function M:show()
    local hand_cards1 = ""
	local hand_cards2 = ""
	local out_cards1 = ""
	local out_cards2 = ""
	local aim = ""
	local v = 1
	for i=1,27 do
		local n_hand = self.player1_hand_cards[i]
		if n_hand > 0 then
			hand_cards1 = hand_cards1 .. string.rep(self:get_card_str(i),n_hand)
		end

		n_hand = self.player2_hand_cards[i]
		if n_hand > 0 then
			hand_cards2 = hand_cards2 .. string.rep(self:get_card_str(i),n_hand)
		end
	end

    for _,v in ipairs(self.player1_out_cards) do
		out_cards1 = out_cards1 .. self:get_card_str(v)
	end
	
	for _,v in ipairs(self.player2_out_cards) do
		out_cards2 = out_cards2 .. self:get_card_str(v)
	end

	print("电脑手牌",hand_cards1)
	print("电脑出牌",out_cards1)
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
	print("ai摸牌"..self:get_card_str(dispatch_card).."，思考中。。。")
	self:show()
	if analyse.check_hu(self.player1_hand_cards) then
		self:cls()
		print("ai胡牌")
		self:show()
		self.status = "gameover"
		return
	end
	local begin = os.time()
	local card = analyse.analyse(self.out_cards, self.player1_hand_cards)
	self:cls()

	self.player1_hand_cards[card] = self.player1_hand_cards[card] - 1
	self.out_cards[card] = self.out_cards[card] + 1
	table.insert(self.player1_out_cards,card)
	print("ai思考出牌"..self:get_card_str(card),"耗时"..(os.time()-begin).."秒")
	self:show()
	self.status = "player"
	self:sleep(5)
end

function M:ai_player()
	local dispatch_card = self:dispatch(2)
	if not dispatch_card then
		self.status = "gameover"
		print("平局")
		return
	end
	self:cls()
	print("ai_player摸牌"..self:get_card_str(dispatch_card).."，思考中。。。")
	self:show()
	if analyse.check_hu(self.player2_hand_cards) then
		self:cls()
		print("ai_player胡牌")
		self:show()
		self.status = "gameover"
		return
	end
	local begin = os.time()
	local card = analyse.analyse(self.out_cards, self.player2_hand_cards)
	self:cls()

	self.player2_hand_cards[card] = self.player2_hand_cards[card] - 1
	self.out_cards[card] = self.out_cards[card] + 1
	table.insert(self.player2_out_cards,card)
	print("ai_player思考出牌"..self:get_card_str(card),"耗时"..(os.time()-begin).."秒")
	self:show()
	self.status = "ai"
	self:sleep(5)
end

--[[
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
		print("输入",card)
		local n = self.player2_hand_cards[card]
		if n and n > 0 then
			self.player2_hand_cards[card] = self.player2_hand_cards[card] - 1
			self.out_cards[card] = self.out_cards[card] + 1
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
]]--

function M:loop()
	while true do
		if self.status == "ai" then
			self:ai()
	    elseif self.status == "player" then
			self:ai_player()
		elseif self.status == "gameover" then
			break
    	end
	end
end

return M