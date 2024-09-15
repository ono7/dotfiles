local my_background = "#1f2937"
local my_background_lighter = "#24364b"
local my_background_darker = "#192636"

vim.api.nvim_set_hl(0, "Normal", {})
vim.api.nvim_set_hl(0, "MsgSeparator", {})
vim.api.nvim_set_hl(0, "Error", { fg = "#F38BA8", bold = false, italic = true })
vim.api.nvim_set_hl(0, "ErrorMsg", { link = "Error" })
vim.api.nvim_set_hl(0, "DiagnosticError", { link = "Error" })
vim.api.nvim_set_hl(0, "@text.todo", { link = "ErrorMsg" })
vim.api.nvim_set_hl(0, "@text.danger", { link = "ErrorMsg" })
vim.api.nvim_set_hl(0, "@text.note", { link = "Normal" })
vim.api.nvim_set_hl(0, "Todo", { link = "ErrorMsg" })
vim.api.nvim_set_hl(0, "TelescopeMatching", { link = "ErrorMsg" })
vim.api.nvim_set_hl(0, "ModeMsg", {})
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
vim.api.nvim_set_hl(0, "Winbar", { fg = "#a89984" })
vim.api.nvim_set_hl(0, "WinbarNc", { fg = "#a89984" })
vim.api.nvim_set_hl(0, "StatusLine", { bg = "#182a44" })
vim.api.nvim_set_hl(0, "TelescopeSelection", { bg = "#2b3b55" })
vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "#171c28", fg = "#8186a1" })
vim.api.nvim_set_hl(0, "Folded", { bg = "none", fg = "#8186a1", bold = true, italic = true })
vim.api.nvim_set_hl(0, "Visual", { bg = "#4a6898", fg = "#d4d4d4" })
vim.api.nvim_set_hl(0, "Search", { bg = "#ceeac8", })
vim.api.nvim_set_hl(0, "MatchParen", { bg = "none", fg = "none", underline = true, bold = true })
vim.api.nvim_set_hl(0, "TreesitterContext", { bg = my_background_lighter })
vim.api.nvim_set_hl(0, "DiffAdd", { fg = "#ceeac8" })
vim.api.nvim_set_hl(0, "DiffDelete", { fg = "#212c3e" })
vim.api.nvim_set_hl(0, "DiffChange", { bg = "#2b3b55" })
vim.api.nvim_set_hl(0, "DiffText", { bg = "#9eb0ce", fg = "#000000" })
vim.api.nvim_set_hl(0, "Pmenu", { bg = "#161c29", fg = "#9eb0ce" })
vim.api.nvim_set_hl(0, "PmenuSel", { bg = "#4a6898", fg = "#000000" })
-- vim.api.nvim_set_hl(0, "cmpSelect", { bg = "#4a6898", fg = "#000000" })
vim.api.nvim_set_hl(0, "cmpSelect", { bg = "#ffa5c3", fg = "#000000" })
vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#2b3b55" })
vim.api.nvim_set_hl(0, "cmpBorder", { fg = "#2b3b55" })
vim.api.nvim_set_hl(0, "TelescopeBorder", { fg = "#2b3b55" })
vim.api.nvim_set_hl(0, "TelescopeTitle", { fg = "#9eb0ce" })
