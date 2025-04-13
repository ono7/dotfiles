local M = {}

M.prefix = function(s)
  -- local c = vim.g.neovide and "D" or "C"
  local c = "C"
  if vim.fn.has("macunix") == 1 then
    c = "D"
  else
    c = "C"
  end
  return string.format("<%s-%s>", c, s)
end

return M
