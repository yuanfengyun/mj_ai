local game = require "game"

math.randomseed(os.time())
game:init()
game:start()

game:loop()