-- ~/.config/nvim/colors/custom-paper.lua

-- 1. Reset everything FIRST
vim.cmd("hi clear")
if vim.fn.exists("syntax_on") then
  vim.cmd("syntax reset")
end

-- 2. Force the environment variables to LIGHT mode
vim.o.termguicolors = true
vim.o.background = "light"
vim.g.colors_name = "custom-paper"

-- Force Neovide's window background to match the warm oatmeal color
if vim.g.neovide then
  vim.g.neovide_background_color = "#F2EFE9"
end

-- 3. ANTI-GLARE LIGHT PALETTE
local bg = "#F2EFE9"
local bg_subtle = "#E6E2DA"
local bg_visual = "#D5CFC4"
local bg_highlight = "#EAE6DF"
local bg_inactive = "#EBE7E0"

local fg_main = "#38414D"
local fg_dim = "#5C6A7B"
local fg_muted = "#7B8A9C"
local fg_faint = "#A9B3C1"

local c = {
  bg = bg,
  fg = fg_main,
  dim = fg_dim,
  muted = fg_muted,
  faint = fg_faint,
  subtle = bg_subtle,
  visual = bg_visual,
  line_nr = "#A9B3C1",
  comment = "#7B8A9C",
  keyword = "#B85C38",
  string = "#4A7A59",
  type = "#3B6EA8",
  fn = "#2D7D8A",
  param = "#5C6A7B",
  constant = "#996E14",
  error = "#C4434B",
  cursor = "#D97736",
  diff_add_bg = "#DCE8DE",
  diff_text_bg = "#C6D8C9",
}

-- Terminal ANSI
vim.g.terminal_color_0 = c.subtle
vim.g.terminal_color_1 = c.error
vim.g.terminal_color_2 = c.string
vim.g.terminal_color_3 = c.constant
vim.g.terminal_color_4 = c.type
vim.g.terminal_color_5 = c.param
vim.g.terminal_color_6 = c.fn
vim.g.terminal_color_7 = c.fg
vim.g.terminal_color_8 = c.comment
vim.g.terminal_color_9 = c.error
vim.g.terminal_color_10 = "#3A6146"
vim.g.terminal_color_11 = "#7A570F"
vim.g.terminal_color_12 = "#2C5482"
vim.g.terminal_color_13 = "#734A7A"
vim.g.terminal_color_14 = "#21606B"
vim.g.terminal_color_15 = "#1A1F26"

-- 4. Highlights
local highlights = {
  Normal = { fg = c.fg, bg = c.bg },
  NormalNC = { link = "Normal" },
  NormalText = { fg = c.fg },
  MatchParen = { fg = c.keyword, bg = c.visual, bold = true },
  ModeMsg = { fg = c.fg },
  MoreMsg = { fg = c.fg },
  Visual = { bg = c.visual },
  MsgSeparator = {},

  Comment = { fg = c.comment, italic = true },
  ["@lsp.type.comment"] = { fg = c.comment, italic = true },
  ["@comment"] = { fg = c.comment, italic = true },

  LineNr = { fg = c.line_nr, bg = c.bg },
  CursorLineNr = { fg = c.constant, bg = "none", bold = true },
  CursorLine = { bg = bg_highlight },
  CursorColumn = { bg = bg_highlight },
  ColorColumn = { bg = bg_highlight },
  SignColumn = { bg = "none" },
  Folded = { fg = c.muted, bg = c.subtle },
  FoldColumn = { bg = "none" },
  EndOfBuffer = { fg = c.bg, bg = "none" },

  NormalFloat = { fg = c.fg, bg = c.subtle },
  FloatBorder = { fg = c.line_nr, bg = c.subtle },
  FloatTitle = { fg = c.keyword, bg = c.subtle, bold = true },
  FloatFooter = { fg = c.muted, bg = c.subtle },
  WinSeparator = { fg = c.line_nr, bg = "none" },
  VertSplit = { link = "WinSeparator" },
  WinBar = { bg = "none" },
  WinBarNC = { fg = c.muted, bg = "none" },
  FidgetBorder = { fg = c.bg, bg = c.bg },

  Pmenu = { fg = c.fg, bg = c.subtle },
  PmenuSel = { fg = c.bg, bg = c.type, bold = true },
  PmenuKind = { fg = c.type, bg = c.subtle },
  PmenuKindSel = { fg = c.bg, bg = c.type, bold = true },
  PmenuExtra = { fg = c.muted, bg = c.subtle },
  PmenuExtraSel = { fg = c.bg, bg = c.type },
  PmenuSbar = { bg = c.subtle },
  PmenuThumb = { bg = c.line_nr },
  WildMenu = { fg = c.bg, bg = c.type },

  CmpItemAbbr = { fg = c.fg },
  CmpItemAbbrDeprecated = { fg = c.muted, strikethrough = true },
  CmpItemAbbrMatch = { fg = c.fn, bold = true },
  CmpItemAbbrMatchFuzzy = { fg = c.fn, bold = true },
  CmpItemMenu = { fg = c.muted, italic = true },
  CmpItemKindFunction = { fg = c.fn },
  CmpItemKindMethod = { fg = c.fn },
  CmpItemKindVariable = { fg = c.param },
  CmpItemKindField = { fg = c.fg },
  CmpItemKindProperty = { fg = c.fg },
  CmpItemKindClass = { fg = c.type },
  CmpItemKindInterface = { fg = c.type },
  CmpItemKindStruct = { fg = c.type },
  CmpItemKindKeyword = { fg = c.keyword },
  CmpItemKindSnippet = { fg = c.constant },
  CmpItemKindText = { fg = c.dim },
  CmpItemKindFile = { fg = c.fg },
  CmpItemKindFolder = { fg = c.type },

  String = { fg = c.string },
  Special = { fg = c.constant },
  Statement = { fg = c.keyword },
  Keyword = { fg = c.keyword },
  Type = { fg = c.type },
  Function = { fg = c.fn },
  Identifier = { fg = c.fg },
  Operator = { fg = c.dim },
  Delimiter = { fg = c.dim },
  Question = { fg = c.string },
  Todo = { fg = c.error, bold = true },
  SpecialKey = { fg = c.muted },
  NonText = { fg = c.line_nr },

  StatusLine = { fg = c.fg, bg = c.subtle },
  StatusLineNC = { fg = c.muted, bg = bg_inactive },
  Cursor = { bg = c.cursor, fg = c.bg },
  TermCursor = { link = "Cursor" },
  TermCursorNC = { link = "Cursor" },
  Search = { fg = c.bg, bg = c.constant },
  IncSearch = { fg = c.bg, bg = c.keyword },
  GitSignsStagedAdd = { fg = c.string },

  DiffAdd = { fg = c.fg, bg = c.diff_add_bg },
  DiffAdded = { fg = c.string, bg = "none" },
  DiffChange = {},
  DiffText = { fg = c.fg, bg = c.diff_text_bg },
  DiffTextAdd = { link = "DiffText" },
  DiffDelete = { fg = c.faint, bg = "none" },
  DiffRemoved = { fg = c.faint, bg = "none" },

  ["@diff.plus"] = { fg = c.string },
  ["@diff.minus"] = { fg = c.error },
  ["@diff.delta"] = {},
  ["@punctuation.bracket"] = { fg = c.dim },
  ["@punctuation.delimiter"] = { fg = c.dim },
  ["@operator"] = { fg = c.dim },
  ["@variable"] = { fg = c.fg },
  ["@variable.builtin"] = { fg = c.type },
  ["@variable.parameter"] = { fg = c.param },
  ["@variable.member"] = { fg = c.fg },
  ["@variable.field"] = { fg = c.fg },
  ["@property"] = { fg = c.fg },
  ["@property.yaml"] = { fg = c.type },
  ["@function.builtin"] = { fg = c.fn },
  ["@constant"] = { fg = c.constant },
  ["@constant.builtin"] = { fg = c.constant, bold = true },
  ["@module"] = { fg = c.type },
  ["@markup.heading"] = { fg = c.keyword, bold = true },
  ["@constructor"] = { fg = c.type },
  ["@constructor.python"] = { fg = c.type },
  ["@text.todo"] = { fg = c.error, bold = true },
  ["@text.danger"] = { fg = c.error, bold = true },
  ["@text.note"] = { fg = c.fn },
  ["@spell.markdown"] = { link = "NormalText" },
  ["@markup.raw"] = { fg = c.string },
  ["@markup.raw.block.markdown"] = { fg = c.faint },
  ["@markup.raw.delimiter.markdown"] = { fg = c.faint },
  ["@lsp.typedecl"] = { fg = c.type },
  TreesitterContextBottom = { fg = c.param, italic = false },
  OilFile = { link = "NormalText" },

  -- ==========================================
  -- FZF-LUA SPECIFIC OVERRIDES
  -- ==========================================
  -- Base UI
  FzfLuaBackdrop = { bg = c.bg_inactive }, -- Overrides the harsh 'Black'
  FzfLuaBorder = { fg = c.line_nr, bg = c.subtle },
  FzfLuaTitle = { fg = c.keyword, bg = c.subtle, bold = true },

  -- Hardcoded X11 Color Replacements
  FzfLuaHeaderBind = { fg = c.fn }, -- Replaces 'MediumSpringGreen'
  FzfLuaHeaderText = { fg = c.keyword }, -- Replaces 'Brown4'
  FzfLuaPathColNr = { fg = c.constant }, -- Replaces 'CadetBlue4'
  FzfLuaPathLineNr = { fg = c.string }, -- Replaces 'MediumSpringGreen'

  FzfLuaLivePrompt = { fg = c.error, bold = true }, -- Replaces 'PaleVioletRed1'
  FzfLuaLiveSym = { fg = c.error },

  -- Buffer & Tab Colors
  FzfLuaBufNr = { fg = c.type }, -- Replaces 'Aquamarine3'
  FzfLuaBufFlagCur = { fg = c.keyword }, -- Replaces 'Brown4'
  FzfLuaBufFlagAlt = { fg = c.type }, -- Replaces 'CadetBlue4'
  FzfLuaTabTitle = { fg = c.type, bold = true },
  FzfLuaTabMarker = { fg = c.string, bold = true },

  -- Fuzzy search character hits (Forced to Bold Crimson for instant visibility)
  FzfLuaFzfMatch = { fg = c.error, bold = true },
  DropBarFzfMatch = { fg = c.error, bold = true },

  -- FZF terminal wrapper fallbacks
  fzf1 = { fg = c.error, bg = c.bg_subtle },
  fzf2 = { fg = c.string, bg = c.bg_subtle },
  fzf3 = { fg = c.type, bg = c.bg_subtle },
}

for group, spec in pairs(highlights) do
  vim.api.nvim_set_hl(0, group, spec)
end
