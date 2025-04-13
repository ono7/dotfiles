local M = {}

-- returns <D-?> macos or neovide else <C-?>
M.prefix = function(s)
  local c = "C"
  if vim.fn.has("macunix") == 1 or vim.g.neovide then
    c = "D"
  else
    c = "C"
  end
  return string.format("<%s-%s>", c, s)
end

return M
