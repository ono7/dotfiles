-- ~/.config/nvim/colors/custom.lua
-- Create this file in your colors directory

local colors = {
  -- Your custom color palette
  white = "#E3DED7",
  black = "#1e1d2d",
  red = "#C49A9A",
  baby_pink = "#D5AFAF",
  green = "#8CBBAD",
  vibrant_green = "#A2CFBF",
  blue = "#8CA7BE",
  yellow = "#D4B97E",
  yellow2 = "#E1CA97",
  purple = "#B097B6",
  purple2 = "#C4AFC8",
  teal = "#93B5B3",
  orange = "#B6A58B",
  cyan = "#93B5B3",
  lavender = "#A6B0C3",

  -- UI colors
  bg_dark = "#1D2433",
  selection = "#364156",
  cursor_line = "#2D3343",
  comment = "#384057",
  line_nr = "#3A4057",
  border = "#3E485A",
  visual = "#253d61",
  search = "#253d61",
  match_paren_bg = "#161927",
  float_bg = "#161927",
  pmenu_bg = "#2D3343",
  pmenu_sel_bg = "#8CBBAD",
  pmenu_sel_fg = "#1D2433",
}

-- Clear existing highlights
vim.cmd("highlight clear")
if vim.fn.exists("syntax_on") then
  vim.cmd("syntax reset")
end

vim.g.colors_name = "custom"

-- Helper function to set highlights
local function hl(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

-- Base highlights
hl("Normal", { fg = colors.white, bg = "NONE" }) -- Use terminal background
hl("NormalNC", { fg = colors.white, bg = "NONE" }) -- Use terminal background
hl("NormalFloat", { bg = colors.float_bg })
hl("FloatBorder", { fg = colors.comment, bold = true })

-- UI Elements
hl("Visual", { bg = colors.visual })
hl("Search", { bg = colors.search })
hl("LineNr", { fg = colors.line_nr })
hl("CursorLine", { bg = "NONE" }) -- Use terminal background
hl("CursorLineNr", {})
hl("MatchParen", { fg = colors.red, bg = colors.match_paren_bg, bold = true })

-- Syntax highlighting
hl("Comment", { fg = colors.comment, italic = true })
hl("String", { fg = colors.green })
hl("Number", { fg = colors.yellow })
hl("Boolean", { fg = colors.purple })
hl("Function", { fg = colors.blue })
hl("Keyword", { fg = colors.red })
hl("Conditional", { fg = colors.red })
hl("Repeat", { fg = colors.red })
hl("Include", { fg = colors.red, bold = true })
hl("Exception", { fg = colors.red })
hl("Operator", { fg = colors.white })
hl("Type", { fg = colors.blue, bold = true })
hl("Constant", { fg = colors.yellow })
hl("Special", { fg = colors.purple })

-- Treesitter highlights
hl("@keyword.function", { fg = colors.red, italic = true })
hl("@keyword.return", { fg = colors.red })
hl("@keyword.operator", { fg = colors.red })
hl("@type", { fg = colors.blue, bold = true })
hl("@type.builtin", { fg = colors.white })
hl("@function.method", { italic = true })
hl("@function.builtin", { fg = colors.red })
hl("@property.yaml", { fg = colors.red })
hl("@variable", {})
hl("@variable.builtin", {})
hl("@variable.parameter", {})
hl("@variable.member", {})
hl("@property", {})
hl("@parameter", {})
hl("@module", {})
hl("@constructor", {})
hl("@punctuation.bracket", {})

-- Diagnostics
hl("DiagnosticError", { fg = colors.red })
hl("DiagnosticWarn", { fg = colors.yellow })
hl("DiagnosticInfo", { fg = colors.blue })
hl("DiagnosticHint", { fg = colors.lavender })
hl("DiagnosticUnnecessary", { fg = "#4e5574" })

hl("DiagnosticUnderlineError", { undercurl = true, sp = colors.red })
hl("DiagnosticUnderlineWarn", { undercurl = true, sp = colors.yellow })
hl("DiagnosticUnderlineInfo", { undercurl = true, sp = colors.blue })
hl("DiagnosticUnderlineHint", { undercurl = true, sp = colors.lavender })

-- Popup menu
hl("Pmenu", { bg = colors.pmenu_bg, fg = colors.white })
hl("PmenuSel", { bg = colors.pmenu_sel_bg, fg = colors.pmenu_sel_fg, bold = true })
hl("PmenuSbar", { bg = colors.border })
hl("PmenuThumb", { bg = "#8087a2" })

-- Telescope
hl("TelescopeTitle", { fg = colors.red, bold = true })
hl("TelescopePromptPrefix", { link = "Title" })
hl("TelescopeSelectionCaret", { fg = colors.vibrant_green, bold = true })
hl("TelescopeMatching", { fg = colors.red, bold = true })
hl("TelescopeSelection", { bg = colors.visual })

-- Diff
hl("DiffAdd", { fg = colors.vibrant_green, bold = true })
hl("DiffDelete", { fg = "#2b3b55" })
hl("DiffText", { bg = colors.yellow2, fg = "#000000" })
hl("diffAdded", { fg = colors.green, bold = true })
hl("diffRemoved", { fg = "#fa5057", bold = true })

-- Status line (minimal)
hl("StatusLine", {})
hl("StatusLineNC", {})

-- File tree
hl("NeoTreeNormal", {})
hl("NeoTreeCursorLine", { link = "Visual" })
hl("NeoTreeWinSeparator", { fg = colors.border })

-- Messages
hl("ErrorMsg", { fg = colors.baby_pink, bold = true })
hl("WarningMsg", { fg = colors.yellow2, bold = true })
hl("Question", { fg = colors.lavender })
hl("ModeMsg", {})
hl("MoreMsg", {})

-- Completion
hl("BlinkCmpMenuSelection", { link = "Visual" })
hl("BlinkCmpScrollBarGutter", { bg = "NONE" })

-- Other
hl("NonText", { fg = colors.border })
hl("WinBar", { fg = "#8186a1" })
hl("WinBarNC", { fg = colors.comment })
hl("TreesitterContext", { bg = "#242438" })
hl("TreesitterContextBottom", { fg = "#b0a0ff", bold = true, italic = true })
