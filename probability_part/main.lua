local part = require "part"

part:init()

local game = require "game"
math.randomseed(os.time())
game:init()
game:start()
game:loop()