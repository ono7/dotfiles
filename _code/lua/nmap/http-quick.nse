-- nmap -n -Pn -pT:80 --open --script 1.lua 100.64.0.134 -d
-- n = no dns, Pn = no ping, pT port and (T)protocol, --open, only open ports, -d debug
--
-- every script requires:
--
--   portrule(func) = this is the rule that says what will trigger this script
--   action(func) = this is what we are going to do
--   description(string) = what this is/does
--   category(table) = required usually { "safe", "discovery" }
--


local shortport = require "shortport"
local http = require "http"
local P = require "utils".inspect

description = [[get cookies]]

categories = { "safe", "discovery" }

-- the rule
--
-- portrule = shortport.http
--
-- portrule = function(host, port)
--   return port.protocol == "tcp" and
--       port.state == "open"
-- end
-- see docs for different portrule functions and their signature
portrule = shortport.port_or_service(80, "http", { "tcp" }, { "open" })


-- the action
action = function(host, port)
  local path = nmap.registry.args.path

  if path == nil then
    path = '/'
  end

  local response = http.get(host, port, path)

  --- bah...
  local getTitle = function(body)
    for line in body:gmatch("[^\r\n]+") do
      if line:match("^<title>") then
        return line:match("<title>(.-)</title>")
      end
    end
  end

  -- return count number of lines
  local getLines = function(body)
    local count = 0
    local x = {}
    -- match \n or \n\n
    for line in body:gmatch("([^\n]*)\n?") do
      count = count + 1
      table.insert(x, line:sub(1, 100))
      if count == 10 then break end
    end
    return table.concat(x, "\n")
  end

  local t = {}

  if type(response.body) == "table" then
    print(string.format("multiple tables in response body found for %v", host))
    for _, tbl in pairs(table) do
      table.insert(tbl, getLines(t.body))
    end
    return table.concat(t, ", ")
  end

  -- the port may not be a real webport
  if response.body == nil then
    P(response)
    return "body is nil...."
  end
  return getLines(response.body)
end
