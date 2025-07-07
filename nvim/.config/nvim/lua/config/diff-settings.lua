local m = vim.api.nvim_set_keymap
local opt = { noremap = true }

if vim.opt.diff:get() then
  vim.opt.signcolumn = "no"
  vim.opt.foldcolumn = "0"
  vim.opt.numberwidth = 1
  vim.opt.number = true
  vim.opt.cmdheight = 2
  -- vim.opt.diffopt = "filler,context:6,internal,algorithm:histogram,indent-heuristic"
  vim.opt.diffopt = "vertical,filler,context:5,internal,algorithm:histogram,indent-heuristic,linematch:60,closeoff"
  vim.opt.laststatus = 3
  m("n", "]", "]c", opt)
  m("n", "[", "[c", opt)
end
