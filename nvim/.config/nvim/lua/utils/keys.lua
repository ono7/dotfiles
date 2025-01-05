local M = {}

M.prefix = function(s)
  -- local c = vim.g.neovide and "D" or "C"
  local c = "C"
  if vim.loop.os_uname().sysname == "Darwin" then
    c = "C"
  end
  return string.format("<%s-%s>", c, s)
end

return M
