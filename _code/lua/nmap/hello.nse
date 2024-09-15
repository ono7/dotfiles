-- The head

local utils = require "utils"

local shortport = require "shortport"

description = [[
  Hello world!
]]

categories = { "safe" } -- or nmap wont run it

-- The rule

-- portrule = shortport.port_or_service(80, { "http" }, { "open" })
portrule = shortport.http

-- The action

action = function(host, port)
  print(utils.inspect(host))
  print(utils.inspect(port))
  return "Done!"
end
