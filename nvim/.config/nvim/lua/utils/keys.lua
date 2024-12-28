local M = {}

M.prefix = function(s)
  local c = vim.g.neovide and "D" or "C"
  return string.format("<%s-%s>", c, s)
end

return M
