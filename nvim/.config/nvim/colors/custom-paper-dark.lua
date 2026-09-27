-- ~/.config/nvim/colors/custom-paper.lua

-- 1. Reset everything FIRST
vim.cmd("hi clear")
if vim.fn.exists("syntax_on") then
  vim.cmd("syntax reset")
end

-- 2. Force the environment variables to DARK mode
vim.o.termguicolors = true
vim.o.background = "dark"
vim.g.colors_name = "custom-paper-dark"

-- NOTE(jlima): Use deep charcoal instead of #000000 to suppress optical halation in astigmatic eyes.
local bg_canvas = "#14161B"
if vim.g.neovide then
  vim.g.neovide_background_color = bg_canvas
end

-- 3. LOW-HALATION DARK PALETTE
local bg = bg_canvas
local bg_subtle = "#1C1F26"
local bg_visual = "#2D333F"
local bg_highlight = "#232730"
local bg_inactive = "#181A20"

-- NOTE(jlima): Restrict foreground to muted off-white (#D4CFBF) to eliminate high-contrast edge blooming.
local text_main = "#D4CFBF"

local fg_dim = "#737D8C"
local fg_muted = "#5B6473"
local fg_faint = "#414754"

local c = {
  bg = bg,
  fg = text_main,
  dim = fg_dim,
  muted = fg_muted,
  faint = fg_faint,
  subtle = bg_subtle,
  visual = bg_visual,
  highlight = bg_highlight,
  inactive = bg_inactive,
  line_nr = "#4B5361",

  -- Text Elements
  -- NOTE(jlima): Avoid pure primary spectrums; chromatic aberration aggravates astigmatism.
  comment = "#6C7685",
  string = "#8FA892", -- Soft desaturated sage
  keyword = "#D47772", -- Warm terracotta, avoids pure red flare
  type = "#C2B093", -- Soft sand
  fn = text_main,
  param = text_main,
  constant = "#C2B093",

  -- Structural & Special
  bracket = "#8E99A8",
  special = "#C88E75",

  -- UI, Diagnostics & Git
  error = "#D47772",
  warn = "#C89E62",
  info = "#688DB5",
  ok = "#82A385",
  cursor = "#E08A56",
  diff_add_bg = "#1E2A22",
  diff_add_fg = "#9EC7A3",
  diff_del_bg = "#301B1D",
  diff_del_fg = "#DE8286",
  diff_txt_bg = "#273D2D",
}

-- Terminal ANSI
vim.g.terminal_color_0 = "#1C1F26"
vim.g.terminal_color_1 = "#C45B5F"
vim.g.terminal_color_2 = "#6E9974"
vim.g.terminal_color_3 = "#B88E4F"
vim.g.terminal_color_4 = "#567CA6"
vim.g.terminal_color_5 = "#8E698F"
vim.g.terminal_color_6 = "#4B858E"
vim.g.terminal_color_7 = "#B0ABA0"

vim.g.terminal_color_8 = "#4B5361"
vim.g.terminal_color_9 = "#D47772"
vim.g.terminal_color_10 = "#8FA892"
vim.g.terminal_color_11 = "#C89E62"
vim.g.terminal_color_12 = "#688DB5"
vim.g.terminal_color_13 = "#A883A9"
vim.g.terminal_color_14 = "#5FA3AE"
vim.g.terminal_color_15 = "#D4CFBF"

-- 4. Highlights
local highlights = {
  Normal = { fg = c.fg, bg = c.bg },
  NormalNC = { link = "Normal" },
  NormalText = { fg = c.fg },
  MatchParen = { fg = c.bg, bg = c.bracket, bold = true },
  ModeMsg = { fg = c.fg, bold = true },
  MoreMsg = { fg = c.fg, bold = true },
  Error = { fg = c.error, bold = true },
  Visual = { bg = c.visual },
  MsgSeparator = {},

  Comment = { fg = c.comment, italic = true },
  ["@lsp.type.comment"] = { fg = c.comment, italic = true },
  ["@comment"] = { fg = c.comment, italic = true },

  LineNr = { fg = c.line_nr, bg = c.bg },
  CursorLineNr = { fg = c.warn, bg = "none", bold = true },
  CursorLine = { bg = c.highlight },
  CursorColumn = { bg = c.highlight },
  ColorColumn = { bg = c.highlight },
  SignColumn = { bg = "none" },
  Folded = { fg = c.muted, bg = c.subtle },
  FoldColumn = { bg = "none" },
  EndOfBuffer = { fg = c.bg, bg = "none" },

  NormalFloat = { fg = c.fg, bg = c.subtle },
  FloatBorder = { fg = c.line_nr, bg = c.subtle },
  FloatTitle = { fg = c.fg, bg = c.subtle, bold = true },
  FloatFooter = { fg = c.muted, bg = c.subtle },
  WinSeparator = { fg = c.line_nr, bg = "none" },
  VertSplit = { link = "WinSeparator" },
  WinBar = { bg = "none" },
  WinBarNC = { fg = c.muted, bg = "none" },
  FidgetBorder = { fg = c.bg, bg = c.bg },

  Pmenu = { fg = c.fg, bg = c.subtle },
  PmenuSel = { fg = c.bg, bg = c.info, bold = true },
  PmenuKind = { fg = c.info, bg = c.subtle },
  PmenuKindSel = { fg = c.bg, bg = c.info, bold = true },
  PmenuExtra = { fg = c.muted, bg = c.subtle },
  PmenuExtraSel = { fg = c.bg, bg = c.info },
  PmenuSbar = { bg = c.subtle },
  PmenuThumb = { bg = c.line_nr },
  WildMenu = { fg = c.bg, bg = c.info },

  CmpItemAbbr = { fg = c.fg },
  CmpItemAbbrDeprecated = { fg = c.muted, strikethrough = true },
  CmpItemAbbrMatch = { fg = c.fg, bold = true },
  CmpItemAbbrMatchFuzzy = { fg = c.fg, bold = true },
  CmpItemMenu = { fg = c.muted, italic = true },
  CmpItemKindFunction = { fg = c.fg },
  CmpItemKindMethod = { fg = c.fg },
  CmpItemKindVariable = { fg = c.fg },
  CmpItemKindField = { fg = c.fg },
  CmpItemKindProperty = { fg = c.fg },
  CmpItemKindClass = { fg = c.fg },
  CmpItemKindInterface = { fg = c.fg },
  CmpItemKindStruct = { fg = c.fg },
  CmpItemKindKeyword = { fg = c.fg },
  CmpItemKindSnippet = { fg = c.fg },
  CmpItemKindText = { fg = c.fg },
  CmpItemKindFile = { fg = c.fg },
  CmpItemKindFolder = { fg = c.fg },

  String = { fg = c.string },
  Special = { fg = c.special },
  SpecialKey = { fg = c.special },
  SpecialChar = { fg = c.special },
  Statement = { fg = c.keyword },
  Keyword = { fg = c.keyword },
  Type = { fg = c.type },
  Function = { fg = c.fg },
  Identifier = { fg = c.fg },
  Operator = { fg = c.bracket },
  Delimiter = { fg = c.bracket },
  Question = { fg = c.fg },
  Todo = { fg = c.error, bold = true },
  NonText = { fg = c.line_nr },

  StatusLine = { fg = c.fg, bg = c.subtle },
  StatusLineNC = { fg = c.muted, bg = c.inactive },
  Cursor = { bg = c.cursor, fg = c.bg },
  TermCursor = { link = "Cursor" },
  TermCursorNC = { link = "Cursor" },
  Search = { fg = c.bg, bg = c.warn },
  CurSearch = { fg = c.bg, bg = c.fg, bold = true },
  IncSearch = { link = "CurSearch" },

  DiffAdd = { fg = c.diff_add_fg, bg = c.diff_add_bg },
  DiffAdded = { fg = c.ok, bg = "none" },
  DiffChange = { bg = c.diff_add_bg },
  DiffText = { fg = c.fg, bg = c.diff_txt_bg, bold = true },
  DiffTextAdd = { link = "DiffText" },
  DiffDelete = { fg = c.diff_del_fg, bg = c.diff_del_bg },
  DiffRemoved = { fg = c.error, bg = "none" },

  ["@diff.plus"] = { fg = c.ok },
  ["@diff.minus"] = { fg = c.error },
  ["@diff.delta"] = { fg = c.warn },

  -- Syntax & Treesitter Mappings
  ["@punctuation.bracket"] = { fg = c.bracket },
  ["@punctuation.special"] = { fg = c.special },
  ["@punctuation.delimiter"] = { fg = c.bracket },
  ["@string"] = { fg = c.string },
  ["@string.escape"] = { fg = c.special, bold = true },
  ["@character.special"] = { fg = c.special, bold = true },

  ["@operator"] = { fg = c.bracket },
  ["@variable"] = { fg = c.fg },
  ["@variable.builtin"] = { fg = c.fg },
  ["@variable.parameter"] = { fg = c.fg },
  ["@variable.member"] = { fg = c.fg },
  ["@variable.field"] = { fg = c.fg },
  ["@property"] = { fg = c.fg },
  ["@property.yaml"] = { fg = c.info },
  ["@function.builtin"] = { fg = c.fg },
  ["@constant"] = { fg = c.constant },
  ["@constant.builtin"] = { fg = c.constant, bold = true },
  ["@module"] = { fg = c.fg },
  ["@markup.heading"] = { fg = c.fg, bold = true },
  ["@constructor"] = { fg = c.bracket },
  ["@constructor.python"] = { fg = c.fg },
  ["@lsp.type.method.yaml.ansible"] = { fg = c.fg },
  ["@lsp.typemod.property.definition.yaml.ansible"] = { fg = c.error },
  ["@text.todo"] = { fg = c.error, bold = true },
  ["@text.danger"] = { fg = c.error, bold = true },
  ["@text.note"] = { fg = c.fg },
  ["@spell.markdown"] = { link = "NormalText" },
  ["@markup.raw"] = { fg = c.fg },
  ["@markup.raw.block.markdown"] = { fg = c.faint },
  ["@markup.raw.delimiter.markdown"] = { fg = c.faint },
  ["@lsp.typedecl"] = { fg = c.fg },

  -- Treesitter Context
  TreesitterContext = { bg = c.subtle },
  TreesitterContextBottom = { sp = c.line_nr, underline = true },
  OilFile = { link = "NormalText" },

  -- FZF-Lua Overrides
  FzfLuaBackdrop = { bg = c.inactive },
  FzfLuaBorder = { fg = c.line_nr },
  FzfLuaTitle = { fg = c.fg, bold = true },
  FzfLuaTitleFlags = { fg = c.info, bold = true },
  FzfLuaHeaderBind = { fg = c.info },
  FzfLuaHeaderText = { fg = c.warn },
  FzfLuaPathColNr = { fg = c.warn },
  FzfLuaPathLineNr = { fg = c.ok },
  FzfLuaLivePrompt = { fg = c.error, bold = true },
  FzfLuaLiveSym = { fg = c.error },
  FzfLuaBufNr = { fg = c.info },
  FzfLuaBufFlagCur = { fg = c.warn },
  FzfLuaBufFlagAlt = { fg = c.info },
  FzfLuaTabTitle = { fg = c.info, bold = true },
  FzfLuaTabMarker = { fg = c.ok, bold = true },
  FzfLuaFzfMatch = { fg = c.error, bold = true },
  DropBarFzfMatch = { fg = c.error, bold = true },

  fzf1 = { fg = c.error, bg = c.subtle },
  fzf2 = { fg = c.ok, bg = c.subtle },
  fzf3 = { fg = c.info, bg = c.subtle },

  -- Diagnostics
  DiagnosticError = { fg = c.error },
  DiagnosticWarn = { fg = c.warn },
  DiagnosticInfo = { fg = c.info },
  DiagnosticHint = { fg = c.muted },
  DiagnosticOk = { fg = c.ok },

  DiagnosticUnderlineError = { sp = c.error, undercurl = true },
  DiagnosticUnderlineWarn = { sp = c.warn, undercurl = true },
  DiagnosticUnderlineInfo = { sp = c.info, undercurl = true },
  DiagnosticUnderlineHint = { sp = c.muted, undercurl = true },
  DiagnosticUnderlineOk = { sp = c.ok, undercurl = true },

  DiagnosticVirtualTextError = { fg = c.error, bg = c.subtle },
  DiagnosticVirtualTextWarn = { fg = c.warn, bg = c.subtle },
  DiagnosticVirtualTextInfo = { fg = c.info, bg = c.subtle },
  DiagnosticVirtualTextHint = { fg = c.muted, bg = c.subtle },
  DiagnosticVirtualTextOk = { fg = c.ok, bg = c.subtle },

  DiagnosticSignError = { fg = c.error, bg = "none" },
  DiagnosticSignWarn = { fg = c.warn, bg = "none" },
  DiagnosticSignInfo = { fg = c.info, bg = "none" },
  DiagnosticSignHint = { fg = c.muted, bg = "none" },
  DiagnosticSignOk = { fg = c.ok, bg = "none" },

  -- GitSigns
  GitSignsAdd = { fg = c.ok, bg = "none" },
  GitSignsChange = { fg = c.info, bg = "none" },
  GitSignsDelete = { fg = c.error, bg = "none" },
  GitSignsStagedAdd = { fg = c.ok },
  GitSignsStagedChange = { fg = c.info },
  GitSignsStagedDelete = { fg = c.error },
  GitSignsStagedChangedelete = { fg = c.info },
  GitSignsAddNr = { fg = c.ok, bg = "none" },
  GitSignsChangeNr = { fg = c.info, bg = "none" },
  GitSignsDeleteNr = { fg = c.error, bg = "none" },
  GitSignsAddLn = { bg = c.diff_add_bg },
  GitSignsChangeLn = { bg = c.diff_txt_bg },
  GitSignsDeleteLn = { bg = c.subtle },
  GitSignsAddInline = { bg = c.diff_add_bg },
  GitSignsChangeInline = { bg = c.diff_txt_bg },
  GitSignsDeleteInline = { fg = c.error, strikethrough = true },

  -- LSP Document Highlight
  LspReferenceText = { bg = c.visual },
  LspReferenceRead = { bg = c.visual },
  LspReferenceWrite = { bg = c.visual, underline = true },
  IlluminatedWordText = { link = "LspReferenceText" },
  IlluminatedWordRead = { link = "LspReferenceRead" },
  IlluminatedWordWrite = { link = "LspReferenceWrite" },
}

for group, spec in pairs(highlights) do
  vim.api.nvim_set_hl(0, group, spec)
end
