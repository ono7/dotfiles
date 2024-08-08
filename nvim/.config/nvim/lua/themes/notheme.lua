local mycolors = {
  white = "#C9C8C0",
  -- normal = "#C9C8C0",
  normal = "#C9C8C0",
  green = "#B3E053",
  -- normal = "#dcd6cd",
  bright_white = "#C9C8C0",
  darker_black = "#191828",
  black = "#1E1D2D",   --  nvim bg
  black2 = "#252434",
  one_bg = "0x1e293b", -- bg for this theme (jlima)
  one_bg2 = "#363545",
  one_bg3 = "#3e3d4d",
  grey = "#474656",
  grey_fg = "#4e4d5d",
  grey_fg2 = "#555464",
  light_grey = "#605f6f",
  red = "#F38BA8",
  baby_pink = "#ffa5c3",
  pink = "#F5C2E7",
  line = "#383747", -- for lines like vertsplit
  vibrant_green = "#b6f4be",
  nord_blue = "#8bc2f0",
  blue = "#9DBBF4",
  yellow = "#FAE3B0",
  sun = "#ffe9b6",
  purple = "#d0a9e5",
  dark_purple = "#c7a0dc",
  orange = "#F8BD96",
  teal = "#89DCEB",
  cyan = "#89DCEB",
  statusline_bg = "#232232",
  lightbg = "#2f2e3e",
  pmenu_bg = "#ABE9B3",
  folder_bg = "#9DBBF4",
  lavender = "#c7d1ff",
  mauve = "#caa1fd"
}
-- vim.cmd("colorscheme gruvbox")
vim.api.nvim_set_hl(0, "@markup.heading.1.markdown", { fg = mycolors.pmenu_bg })
vim.api.nvim_set_hl(0, "@markup.heading.2.markdown", { fg = mycolors.red })
vim.api.nvim_set_hl(0, "@markup.heading.3.markdown", { fg = mycolors.mauve })
vim.api.nvim_set_hl(0, "@markup.heading.4.markdown", { fg = mycolors.cyan })
vim.api.nvim_set_hl(0, "cmpSelect", { bg = mycolors.baby_pink, fg = mycolors.darker_black })
vim.api.nvim_set_hl(0, "WildMenu", { bg = "#29354a" })
vim.api.nvim_set_hl(0, "Pmenu", { bg = "#29354a" })
vim.api.nvim_set_hl(0, "Normal", {})
vim.api.nvim_set_hl(0, "ModeMsg", {})
vim.api.nvim_set_hl(0, "WildMenuSelect", { bg = mycolors.baby_pink, fg = mycolors.darker_black })
vim.api.nvim_set_hl(0, "NormalFloat", { link = "Comment" })
vim.api.nvim_set_hl(0, "LineNr", { fg = "#213a5f" })
vim.api.nvim_set_hl(0, "WinSeparator", { link = "Comment" })
vim.api.nvim_set_hl(0, "cmpBorder", { fg = "#2b2c36" })
vim.api.nvim_set_hl(0, "MatchParen", { bg = "#43536d", fg = "#ef9c40" })
vim.api.nvim_set_hl(0, "DiffDelete", { fg = "#2b3b55" })
vim.api.nvim_set_hl(0, "DiffChange", { bg = "#2b3b55" })
vim.api.nvim_set_hl(0, "DiffAdd", { fg = "#ceeac8" })
vim.api.nvim_set_hl(0, "DiffText", { bg = "#9eb0ce", fg = "#000000" })
vim.api.nvim_set_hl(0, "StatusLine", { bg = "#182a44" })
vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "#0a121e", fg = "#8186a1" })
vim.api.nvim_set_hl(0, "Winbar", { fg = "#a89984" })
vim.api.nvim_set_hl(0, "WinbarNc", { fg = "#a89984" })
vim.api.nvim_set_hl(0, "diffRemoved", { link = "Comment" })
vim.api.nvim_set_hl(0, "TreesitterContext", { bg = "#242438" })
-- vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#474a59" })
vim.api.nvim_set_hl(0, "@text.uri", { fg = "#8186a1", undercurl = true })
vim.api.nvim_set_hl(0, "TelescopeBorder", { fg = "#8186a1" })
vim.api.nvim_set_hl(0, "NormalFloat", { fg = "#8186a1" })
vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#8186a1" })
vim.api.nvim_set_hl(0, "TelescopePreviewBorder", { fg = "#8186a1" })
vim.api.nvim_set_hl(0, "TelescopeResultsBorder", { fg = "#8186a1" })
-- vim.api.nvim_set_hl(0, "Comment", { fg = "#8186a1" })
vim.api.nvim_set_hl(0, "Folded", { link = "Comment" })
vim.api.nvim_set_hl(0, "@string.special.path.gitignore", {})
vim.api.nvim_set_hl(0, "@text.todo", { link = "ErrorMsg" })
vim.api.nvim_set_hl(0, "@text.danger", { link = "ErrorMsg" })
vim.api.nvim_set_hl(0, "@text.note", { link = "Normal" })
vim.api.nvim_set_hl(0, "Todo", { link = "ErrorMsg" })
-- vim.api.nvim_set_hl(0, "Error", { fg = "#e53f73", bg = "none" })
vim.api.nvim_set_hl(0, "Error", { fg = mycolors.red, bg = "none" })
vim.api.nvim_set_hl(0, "ErrorMsg", { fg = mycolors.red, bg = "none" })
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextError", { link = "Error" })
vim.api.nvim_set_hl(0, "DiagnosticSignError", { link = "Error" })
vim.api.nvim_set_hl(0, "MsgSeparator", { bg = "none" })
vim.api.nvim_set_hl(0, "Visual", { bg = "#2b3b55" })
vim.api.nvim_set_hl(0, "Search", { bg = "#2b3b55", })
vim.api.nvim_set_hl(0, "IncSearch", { bg = "#9eb0ce", fg = "#000000", })
vim.api.nvim_set_hl(0, "@method.call", { fg = mycolors.normal })
vim.api.nvim_set_hl(0, "TreesitterContext", { bg = "#182a44" })
vim.api.nvim_set_hl(0, "GruvboxOrange", { fg = "#ef9c40" })
vim.api.nvim_set_hl(0, "JinjaVarBlock", { fg = "#ef9c40" })
vim.api.nvim_set_hl(0, "JinjaVarDelim", { fg = "#ef9c40" })
vim.api.nvim_set_hl(0, "JinjaTagBlock", { fg = "#ef9c40" })
vim.api.nvim_set_hl(0, "JinjaTagDelim", { fg = "#ef9c40" })
vim.api.nvim_set_hl(0, "ColorColumn", { bg = "#2b3b55" })
vim.api.nvim_set_hl(0, "NeoTreeCursorLine", { bg = "#2b3b55" })
vim.api.nvim_set_hl(0, "TelescopeSelection", { bg = "#2b3b55" })
vim.api.nvim_set_hl(0, "GruvboxRed", { fg = "#e53f73" })
vim.api.nvim_set_hl(0, "GruvboxBlue", { fg = "#84D6EC" })
vim.api.nvim_set_hl(0, "GruvboxGreen", { fg = "#84D6EC" })
vim.api.nvim_set_hl(0, "diffAdded", { fg = "#B3E053", bold = true })
vim.api.nvim_set_hl(0, "diffRemoved", { fg = "#e53f73" })
