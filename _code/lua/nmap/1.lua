local x = require "utils"
local ip = "192.168.1.12"

-- handy way to unpact matches right into a table
local octects = { ip:match("(%d+).(%d+).(%d+).(%d+)") }

print(x.inspect(octects))
