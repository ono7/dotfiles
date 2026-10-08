-- ~/.config/nvim/colors/custom-deep-slate.lua

-- 1. Reset everything FIRST
vim.cmd("hi clear")
if vim.fn.exists("syntax_on") then
  vim.cmd("syntax reset")
end

-- 2. Force the environment variables to DARK mode
vim.o.termguicolors = true
vim.o.background = "dark"
vim.g.colors_name = "custom-deep-slate"

local my_bg = "#151f2d"

-- Match Neovide window background
if vim.g.neovide then
  vim.g.neovide_background_color = my_bg
end

-- 3. DEEP SLATE DARK PALETTE
-- Grounded dark navy/slate canvas (#151f2d) with balanced low-bloom foregrounds (#bebebc).

local bg = my_bg
-- NOTE(jlima): Unified subtle and floating background states to reference my_bg
-- directly to prevent palette fragmentation across LSP hover float buffers.
local bg_subtle = my_bg
local bg_visual = "#223249"
local bg_highlight = "#1b2738"
local bg_inactive = my_bg

local text_main = "#bebebc"

local fg_dim = "#7d8b99"
local fg_muted = "#5c6977"
local fg_faint = "#3d4b5a"

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

  line_nr = "#415062",

  status_active = "#1d2b3e",
  status_inactive = "#182333",

  border = "#3a4a5e",

  -- Text Elements
  comment = "#657688",
  string = "#88b58e",
  keyword = "#df7179",

  type = text_main,
  fn = text_main,
  param = text_main,
  constant = text_main,

  -- Structural & Special
  bracket = "#7d8b99",
  special = "#d4976c",

  -- UI, Diagnostics & Git
  error = "#df7179",
  warn = "#d8aa58",
  info = "#6fa2d3",
  ok = "#78b886",

  cursor = "#e08d53",

  diff_add_bg = "#1c3228",
  diff_add_fg = "#8fd4a0",

  diff_del_bg = "#381f26",
  diff_del_fg = "#df7179",

  diff_txt_bg = "#254235",
}

-- 4. Terminal ANSI
-- Inverted & calibrated for dark slate backdrop

vim.g.terminal_color_0 = "#151f2d"
vim.g.terminal_color_1 = "#df7179"
vim.g.terminal_color_2 = "#78b886"
vim.g.terminal_color_3 = "#d8aa58"
vim.g.terminal_color_4 = "#6fa2d3"
vim.g.terminal_color_5 = "#ba8cc2"
vim.g.terminal_color_6 = "#5fb4b8"
vim.g.terminal_color_7 = "#bebebc"

-- Bright ANSI variants
vim.g.terminal_color_8 = "#415062"
vim.g.terminal_color_9 = "#e6858c"
vim.g.terminal_color_10 = "#8dd19c"
vim.g.terminal_color_11 = "#e2bc72"
vim.g.terminal_color_12 = "#88b5e2"
vim.g.terminal_color_13 = "#c89ecf"
vim.g.terminal_color_14 = "#76c4c8"
vim.g.terminal_color_15 = "#d8d8d6"

-- 5. Highlights
local highlights = {
  Normal = { fg = c.fg, bg = c.bg },
  NormalNC = { link = "Normal" },

  MatchParen = {
    fg = c.comment,
    bg = c.highlight,
    bold = true,
  },

  ModeMsg = { fg = c.fg, bold = true },
  MoreMsg = { fg = c.fg, bold = true },

  Error = { fg = c.error, bold = true },
  Visual = { bg = c.visual },

  MsgSeparator = {},

  Comment = { fg = c.comment, italic = true },
  ["@lsp.type.comment"] = { fg = c.comment, italic = true },
  ["@comment"] = { fg = c.comment, italic = true },

  LineNr = { fg = c.line_nr, bg = c.bg },
  CursorLineNr = {
    fg = c.warn,
    bg = "none",
    bold = true,
  },

  CursorLine = { bg = c.highlight },
  CursorColumn = { bg = c.highlight },
  ColorColumn = { bg = c.highlight },

  SignColumn = { bg = "none" },

  Folded = {
    fg = c.muted,
    bg = c.subtle,
  },

  FoldColumn = { bg = "none" },

  EndOfBuffer = {
    fg = c.bg,
    bg = "none",
  },

  -- Floating windows
  NormalFloat = {
    fg = c.fg,
    bg = c.bg,
  },

  FloatBorder = {
    fg = c.border,
    bg = c.bg,
  },

  FloatTitle = {
    fg = c.fg,
    bg = c.bg,
    bold = true,
  },

  FloatFooter = {
    fg = c.muted,
    bg = c.bg,
  },

  WinSeparator = {
    fg = c.border,
    bg = "none",
  },

  VertSplit = { link = "WinSeparator" },

  WinBar = { bg = "none" },

  WinBarNC = {
    fg = c.muted,
    bg = "none",
  },

  FidgetBorder = {
    fg = c.bg,
    bg = c.bg,
  },

  -- Completion menu
  Pmenu = {
    fg = c.fg,
    bg = c.subtle,
  },

  PmenuSel = {
    fg = c.bg,
    bg = c.info,
    bold = true,
  },

  PmenuKind = {
    fg = c.info,
    bg = c.subtle,
  },

  PmenuKindSel = {
    fg = c.bg,
    bg = c.info,
    bold = true,
  },

  PmenuExtra = {
    fg = c.muted,
    bg = c.subtle,
  },

  PmenuExtraSel = {
    fg = c.bg,
    bg = c.info,
  },

  PmenuSbar = {
    bg = c.subtle,
  },

  PmenuThumb = {
    bg = c.line_nr,
  },

  WildMenu = {
    fg = c.bg,
    bg = c.info,
  },

  -- nvim-cmp
  CmpItemAbbr = {
    fg = c.fg,
  },

  CmpItemAbbrDeprecated = {
    fg = c.muted,
    strikethrough = true,
  },

  CmpItemAbbrMatch = {
    fg = c.fg,
    bold = true,
  },

  CmpItemAbbrMatchFuzzy = {
    fg = c.fg,
    bold = true,
  },

  CmpItemMenu = {
    fg = c.muted,
    italic = true,
  },

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

  -- Syntax
  String = { fg = c.string },
  Special = { fg = c.special },
  SpecialKey = { fg = c.special },
  SpecialChar = { fg = c.special },

  Statement = { fg = c.keyword },
  Keyword = { fg = c.keyword },

  Type = { fg = c.type },
  Function = { fg = c.fg },
  Identifier = { fg = c.fg },
  Operator = { fg = c.fg },

  Delimiter = { fg = c.bracket },

  Question = { fg = c.fg },

  Todo = {
    fg = c.error,
    bold = true,
  },

  NonText = {
    fg = c.line_nr,
  },

  -- Statusline
  StatusLine = {
    fg = c.fg,
    bg = c.status_active,
    bold = true,
  },

  StatusLineNC = {
    fg = c.dim,
    bg = c.status_inactive,
  },

  Cursor = {
    bg = c.cursor,
    fg = c.bg,
  },

  TermCursor = { link = "Cursor" },
  TermCursorNC = { link = "Cursor" },

  Search = {
    fg = c.bg,
    bg = c.warn,
  },

  CurSearch = {
    fg = c.bg,
    bg = c.fg,
    bold = true,
  },

  IncSearch = { link = "CurSearch" },

  -- Diff
  DiffAdd = {
    fg = c.diff_add_fg,
    bg = c.diff_add_bg,
  },

  DiffAdded = {
    fg = c.ok,
    bg = "none",
  },

  DiffChange = {
    bg = c.diff_add_bg,
  },

  DiffText = {
    fg = c.fg,
    bg = c.diff_txt_bg,
    bold = true,
  },

  DiffTextAdd = { link = "DiffText" },

  DiffDelete = {
    fg = c.diff_del_fg,
    bg = c.diff_del_bg,
  },

  DiffRemoved = {
    fg = c.error,
    bg = "none",
  },

  ["@diff.plus"] = { fg = c.ok },
  ["@diff.minus"] = { fg = c.error },
  ["@diff.delta"] = { fg = c.warn },

  -- Treesitter
  ["@punctuation.bracket"] = {
    fg = c.bracket,
  },

  ["@punctuation.special"] = {
    fg = c.special,
  },

  ["@punctuation.delimiter"] = {
    fg = c.bracket,
  },

  ["@string"] = {
    fg = c.string,
  },

  ["@string.escape"] = {
    fg = c.special,
    bold = true,
  },

  ["@character.special"] = {
    fg = c.special,
    bold = true,
  },

  ["@operator"] = {
    fg = c.fg,
  },

  ["@variable"] = {
    fg = c.fg,
  },

  ["@variable.builtin"] = {
    fg = c.fg,
  },

  ["@variable.parameter"] = {
    fg = c.fg,
  },

  ["@variable.member"] = {
    fg = c.fg,
  },

  ["@variable.field"] = {
    fg = c.fg,
  },

  ["@property"] = {
    fg = c.fg,
  },

  ["@property.yaml"] = {
    fg = c.info,
  },

  ["@function.builtin"] = {
    fg = c.fg,
  },

  ["@constant"] = {
    fg = c.fg,
  },

  ["@constant.builtin"] = {
    fg = c.fg,
    bold = true,
  },

  ["@module"] = {
    fg = c.fg,
  },

  -- Markdown (Floating docs & buffers)
  ["@markup.raw"] = {
    fg = c.dim,
    bg = c.bg,
  },

  ["@markup.raw.block.markdown"] = {
    fg = c.fg,
    bg = c.bg,
  },

  ["@markup.raw.delimiter.markdown"] = {
    fg = c.dim,
    bg = c.bg,
  },

  ["@markup.normal"] = {
    fg = c.fg,
    bg = c.bg,
  },

  ["@text.literal"] = {
    fg = c.fg,
    bg = c.bg,
  },

  ["@spell.markdown"] = {
    link = "Normal",
  },

  -- Treesitter headings
  ["@markup.heading"] = {
    fg = c.keyword,
    bold = true,
  },

  ["@markup.heading.1.markdown"] = {
    fg = c.keyword,
    bold = true,
  },

  ["@markup.heading.2.markdown"] = {
    fg = c.info,
    bold = true,
  },

  ["@markup.heading.3.markdown"] = {
    fg = c.special,
    bold = true,
  },

  ["@markup.heading.4.markdown"] = {
    fg = c.warn,
    bold = true,
  },

  ["@markup.heading.5.markdown"] = {
    fg = c.string,
    bold = true,
  },

  ["@markup.heading.6.markdown"] = {
    fg = c.dim,
    bold = true,
  },

  ["@markup.heading.content"] = {
    fg = c.keyword,
    bold = true,
  },

  ["@markup.heading.1.content.markdown"] = {
    fg = c.keyword,
    bold = true,
  },

  ["@markup.heading.2.content.markdown"] = {
    fg = c.info,
    bold = true,
  },

  ["@markup.heading.3.content.markdown"] = {
    fg = c.special,
    bold = true,
  },

  ["@markup.heading.4.content.markdown"] = {
    fg = c.warn,
    bold = true,
  },

  ["@markup.heading.5.content.markdown"] = {
    fg = c.string,
    bold = true,
  },

  ["@markup.heading.6.content.markdown"] = {
    fg = c.dim,
    bold = true,
  },

  ["@markup.heading.1.delimiter.markdown"] = {
    fg = c.keyword,
  },

  ["@markup.heading.2.delimiter.markdown"] = {
    fg = c.info,
  },

  ["@markup.heading.3.delimiter.markdown"] = {
    fg = c.special,
  },

  ["@markup.heading.4.delimiter.markdown"] = {
    fg = c.warn,
  },

  ["@markup.heading.5.delimiter.markdown"] = {
    fg = c.string,
  },

  ["@markup.heading.6.delimiter.markdown"] = {
    fg = c.dim,
  },

  -- Built-in Vim regex syntax fallback
  markdownH1 = {
    fg = c.keyword,
    bold = true,
  },

  markdownH2 = {
    fg = c.info,
    bold = true,
  },

  markdownH3 = {
    fg = c.special,
    bold = true,
  },

  markdownH4 = {
    fg = c.warn,
    bold = true,
  },

  markdownH5 = {
    fg = c.string,
    bold = true,
  },

  markdownH6 = {
    fg = c.dim,
    bold = true,
  },

  markdownH1Delimiter = {
    fg = c.keyword,
  },

  markdownH2Delimiter = {
    fg = c.info,
  },

  markdownH3Delimiter = {
    fg = c.special,
  },

  markdownH4Delimiter = {
    fg = c.warn,
  },

  markdownH5Delimiter = {
    fg = c.string,
  },

  markdownH6Delimiter = {
    fg = c.dim,
  },

  markdownHeadingDelimiter = {
    fg = c.line_nr,
  },

  markdownCode = {
    fg = c.fg,
    bg = c.bg,
  },

  markdownCodeBlock = {
    fg = c.dim,
    bg = c.bg,
  },

  markdownCodeDelimiter = {
    fg = c.dim,
    bg = c.bg,
  },

  -- Languages & Extras
  ["@constructor"] = {
    fg = c.bracket,
  },

  ["@constructor.python"] = {
    fg = c.fg,
  },

  ["@lsp.type.method.yaml.ansible"] = {
    fg = c.fg,
  },

  ["@lsp.typemod.property.definition.yaml.ansible"] = {
    fg = c.error,
  },

  ["@text.todo"] = {
    fg = c.error,
    bold = true,
  },

  ["@text.danger"] = {
    fg = c.error,
    bold = true,
  },

  ["@text.note"] = {
    fg = c.fg,
  },

  ["@lsp.typedecl"] = {
    fg = c.fg,
  },

  -- Treesitter Context
  TreesitterContext = {
    bg = c.subtle,
  },

  TreesitterContextBottom = {
    sp = c.border,
    underline = true,
  },

  OilFile = {
    link = "Normal",
  },

  -- FZF-Lua
  FzfLuaBackdrop = {
    bg = c.inactive,
  },

  FzfLuaBorder = {
    fg = c.border,
  },

  FzfLuaTitle = {
    fg = c.fg,
    bold = true,
  },

  FzfLuaTitleFlags = {
    fg = c.info,
    bold = true,
  },

  FzfLuaHeaderBind = {
    fg = c.info,
  },

  FzfLuaHeaderText = {
    fg = c.warn,
  },

  FzfLuaPathColNr = {
    fg = c.warn,
  },

  FzfLuaPathLineNr = {
    fg = c.ok,
  },

  FzfLuaLivePrompt = {
    fg = c.error,
    bold = true,
  },

  FzfLuaLiveSym = {
    fg = c.error,
  },

  FzfLuaBufNr = {
    fg = c.info,
  },

  FzfLuaBufFlagCur = {
    fg = c.warn,
  },

  FzfLuaBufFlagAlt = {
    fg = c.info,
  },

  FzfLuaTabTitle = {
    fg = c.info,
    bold = true,
  },

  FzfLuaTabMarker = {
    fg = c.ok,
    bold = true,
  },

  FzfLuaFzfMatch = {
    fg = c.error,
    bold = true,
  },

  DropBarFzfMatch = {
    fg = c.error,
    bold = true,
  },

  fzf1 = {
    fg = c.error,
    bg = c.subtle,
  },

  fzf2 = {
    fg = c.ok,
    bg = c.subtle,
  },

  fzf3 = {
    fg = c.info,
    bg = c.subtle,
  },

  -- Diagnostics
  DiagnosticError = {
    fg = c.error,
  },

  DiagnosticWarn = {
    fg = c.warn,
  },

  DiagnosticInfo = {
    fg = c.info,
  },

  DiagnosticHint = {
    fg = c.muted,
  },

  DiagnosticOk = {
    fg = c.ok,
  },

  DiagnosticUnderlineError = {
    sp = c.error,
    undercurl = true,
  },

  DiagnosticUnderlineWarn = {
    sp = c.warn,
    undercurl = true,
  },

  DiagnosticUnderlineInfo = {
    sp = c.info,
    undercurl = true,
  },

  DiagnosticUnderlineHint = {
    sp = c.muted,
    undercurl = true,
  },

  DiagnosticUnderlineOk = {
    sp = c.ok,
    undercurl = true,
  },

  DiagnosticVirtualTextError = {
    fg = c.error,
    bg = c.subtle,
  },

  DiagnosticVirtualTextWarn = {
    fg = c.warn,
    bg = c.subtle,
  },

  DiagnosticVirtualTextInfo = {
    fg = c.info,
    bg = c.subtle,
  },

  DiagnosticVirtualTextHint = {
    fg = c.muted,
    bg = c.subtle,
  },

  DiagnosticVirtualTextOk = {
    fg = c.ok,
    bg = c.subtle,
  },

  DiagnosticSignError = {
    fg = c.error,
    bg = "none",
  },

  DiagnosticSignWarn = {
    fg = c.warn,
    bg = "none",
  },

  DiagnosticSignInfo = {
    fg = c.info,
    bg = "none",
  },

  DiagnosticSignHint = {
    fg = c.muted,
    bg = "none",
  },

  DiagnosticSignOk = {
    fg = c.ok,
    bg = "none",
  },

  -- GitSigns
  GitSignsAdd = {
    fg = c.ok,
    bg = "none",
  },

  GitSignsChange = {
    fg = c.info,
    bg = "none",
  },

  GitSignsDelete = {
    fg = c.error,
    bg = "none",
  },

  GitSignsStagedAdd = {
    fg = c.ok,
  },

  GitSignsStagedChange = {
    fg = c.info,
  },

  GitSignsStagedDelete = {
    fg = c.error,
  },

  GitSignsStagedChangedelete = {
    fg = c.info,
  },

  GitSignsAddNr = {
    fg = c.ok,
    bg = "none",
  },

  GitSignsChangeNr = {
    fg = c.info,
    bg = "none",
  },

  GitSignsDeleteNr = {
    fg = c.error,
    bg = "none",
  },

  GitSignsAddLn = {
    bg = c.diff_add_bg,
  },

  GitSignsChangeLn = {
    bg = c.diff_txt_bg,
  },

  GitSignsDeleteLn = {
    bg = c.subtle,
  },

  GitSignsAddInline = {
    bg = c.diff_add_bg,
  },

  GitSignsChangeInline = {
    bg = c.diff_txt_bg,
  },

  GitSignsDeleteInline = {
    fg = c.error,
    strikethrough = true,
  },

  -- LSP Document Highlight
  LspReferenceText = {
    bg = c.visual,
  },

  LspReferenceRead = {
    bg = c.visual,
  },

  LspReferenceWrite = {
    bg = c.visual,
    underline = true,
  },

  IlluminatedWordText = {
    link = "LspReferenceText",
  },

  IlluminatedWordRead = {
    link = "LspReferenceRead",
  },

  IlluminatedWordWrite = {
    link = "LspReferenceWrite",
  },
}

for group, spec in pairs(highlights) do
  vim.api.nvim_set_hl(0, group, spec)
end
