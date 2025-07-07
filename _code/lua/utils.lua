-- utils.lua
-- usage: local utils = require('utils')

local M = {}

local function is_identifier(str)
  return type(str) == "string" and str:match("^[%a_][%w_]*$")
end

local function sort_keys(t)
  local keys = {}
  for k in pairs(t) do table.insert(keys, k) end
  table.sort(keys, function(a, b)
    if type(a) == "number" and type(b) == "number" then
      return a < b
    else
      return tostring(a) < tostring(b)
    end
  end)
  return keys
end

function M.inspect(t, indent_level)
  if type(t) ~= "table" then
    if type(t) == "string" then
      return string.format("%q", t)
    else
      return tostring(t)
    end
  end

  indent_level = indent_level or 0
  local indent = string.rep("  ", indent_level)
  local result = "{"
  local keys = sort_keys(t)

  local max_sequential = 0
  for i, k in ipairs(keys) do
    if type(k) == "number" and k == i then
      max_sequential = i
    else
      break
    end
  end

  for i, k in ipairs(keys) do
    local v = t[k]
    result = result .. (i > 1 and "," or "") .. "\n" .. indent .. "  "
    if type(k) ~= "number" or k > max_sequential then
      if is_identifier(k) then
        result = result .. k
      else
        result = result .. "[" .. M.inspect(k, indent_level + 1) .. "]"
      end
      result = result .. " = "
    end
    result = result .. M.inspect(v, indent_level + 1)
  end

  if #keys > 0 then
    result = result .. "\n" .. indent
  end
  result = result .. "}"
  return result
end

return M
