-- ~/.config/nvim/colors/ayu-carbon.lua

-- 1. Reset state
vim.cmd("hi clear")
if vim.fn.exists("syntax_on") then
  vim.cmd("syntax reset")
end

-- 2. Environment invariants
vim.o.termguicolors = true
vim.o.background = "dark"
vim.g.colors_name = "ayu-carbon"

local my_bg = "#151F2D"

if vim.g.neovide then
  vim.g.neovide_background_color = my_bg
end

-- 3. Palette Definition
-- Aligned strictly with Emacs ayu-carbon variables and verified dark-slate values.

local bg = my_bg
-- NOTE(jlima): Normalize subtle and floating canvas states directly to my_bg
-- to prevent container boundary fragmentation across LSP hover float buffers.
local bg_subtle = my_bg
local bg_visual = "#223E65"
local bg_cursorl = "#1E2E45"
local bg_inactive = my_bg

local text_fg = "#BEBEBC"
local line_nr = "#3A4555"
local nontext = "#5A6B85"
local comment = "#5F6C77"

local c = {
  bg = bg,
  fg = text_fg,
  subtle = bg_subtle,
  visual = bg_visual,
  cursorl = bg_cursorl,
  inactive = bg_inactive,

  line_nr = line_nr,
  nontext = nontext,
  comment = comment,

  border = line_nr,
  status_active = bg_cursorl,
  status_inactive = bg_cursorl,

  -- Accent Syntax
  string = "#8CA64A",
  special = "#D89F5C",
  type = "#7AA7D8",
  fn = "#AABFD9",
  keyword = "#D89F5C",

  -- Uniform Identifiers & Operators
  constant = text_fg,
  param = text_fg,
  bracket = nontext,

  -- UI, Search & Diagnostics
  search_bg = "#3A6FB0",
  search_fg = "#FFFFFF",
  cursor = "#FFB454",

  error = "#D35A63",
  warn = "#D89F5C",
  info = "#7AA7D8",
  ok = "#8CA64A",

  -- Diff Tones
  diff_add_bg = "#1C2E2E",
  diff_add_fg = "#8CA64A",
  diff_change_bg = "#2A3245",
  diff_change_fg = text_fg,
  diff_del_bg = "#2A1E1E",
  diff_del_fg = "#D35A63",
}

-- 4. Terminal ANSI
vim.g.terminal_color_0 = "#151F2D"
vim.g.terminal_color_1 = "#D35A63"
vim.g.terminal_color_2 = "#8CA64A"
vim.g.terminal_color_3 = "#D89F5C"
vim.g.terminal_color_4 = "#7AA7D8"
vim.g.terminal_color_5 = "#AABFD9"
vim.g.terminal_color_6 = "#5A6B85"
vim.g.terminal_color_7 = "#BEBEBC"

-- Bright ANSI variants
vim.g.terminal_color_8 = "#3A4555"
vim.g.terminal_color_9 = "#E06C75"
vim.g.terminal_color_10 = "#98C379"
vim.g.terminal_color_11 = "#E5C07B"
vim.g.terminal_color_12 = "#61AFEF"
vim.g.terminal_color_13 = "#C678DD"
vim.g.terminal_color_14 = "#56B6C2"
vim.g.terminal_color_15 = "#FFFFFF"

-- 5. Highlights
local highlights = {
  Normal = { fg = c.fg, bg = c.bg },
  NormalNC = { link = "Normal" },

  MatchParen = {
    fg = c.bg,
    bg = c.fn,
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
    fg = c.special,
    bg = "none",
    bold = true,
  },

  CursorLine = { bg = c.cursorl },
  CursorColumn = { bg = c.cursorl },
  ColorColumn = { bg = c.cursorl },

  SignColumn = { bg = "none" },

  Folded = {
    fg = c.nontext,
    bg = c.cursorl,
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
    fg = c.comment,
    bg = c.bg,
  },

  WinSeparator = {
    fg = c.line_nr,
    bg = "none",
  },

  VertSplit = { link = "WinSeparator" },

  WinBar = { bg = "none" },

  WinBarNC = {
    fg = c.comment,
    bg = "none",
  },

  FidgetBorder = {
    fg = c.bg,
    bg = c.bg,
  },

  -- Completion menu
  Pmenu = {
    fg = c.fg,
    bg = "#1D2738",
  },

  PmenuSel = {
    fg = c.search_fg,
    bg = c.search_bg,
    bold = true,
  },

  PmenuKind = {
    fg = c.type,
    bg = "#1D2738",
  },

  PmenuKindSel = {
    fg = c.search_fg,
    bg = c.search_bg,
    bold = true,
  },

  PmenuExtra = {
    fg = c.comment,
    bg = "#1D2738",
  },

  PmenuExtraSel = {
    fg = c.search_fg,
    bg = c.search_bg,
  },

  PmenuSbar = {
    bg = "#1D2738",
  },

  PmenuThumb = {
    bg = c.line_nr,
  },

  WildMenu = {
    fg = c.search_fg,
    bg = c.search_bg,
  },

  -- nvim-cmp
  CmpItemAbbr = {
    fg = c.fg,
  },

  CmpItemAbbrDeprecated = {
    fg = c.comment,
    strikethrough = true,
  },

  CmpItemAbbrMatch = {
    fg = c.search_fg,
    bold = true,
  },

  CmpItemAbbrMatchFuzzy = {
    fg = c.search_fg,
    bold = true,
  },

  CmpItemMenu = {
    fg = c.comment,
    italic = true,
  },

  CmpItemKindFunction = { fg = c.fn },
  CmpItemKindMethod = { fg = c.fn },
  CmpItemKindVariable = { fg = c.fg },
  CmpItemKindField = { fg = c.fg },
  CmpItemKindProperty = { fg = c.fg },
  CmpItemKindClass = { fg = c.type },
  CmpItemKindInterface = { fg = c.type },
  CmpItemKindStruct = { fg = c.type },
  CmpItemKindKeyword = { fg = c.keyword },
  CmpItemKindSnippet = { fg = c.special },
  CmpItemKindText = { fg = c.fg },
  CmpItemKindFile = { fg = c.fg },
  CmpItemKindFolder = { fg = c.fg },

  -- Syntax
  String = { fg = c.string },
  Special = { fg = c.special },
  SpecialKey = { fg = c.special },
  SpecialChar = { fg = c.special },

  Statement = { fg = c.keyword, bold = true },
  Keyword = { fg = c.keyword, bold = true },

  Type = { fg = c.type },
  Function = { fg = c.fn },
  Identifier = { fg = c.fg },
  Operator = { fg = c.fg },

  Delimiter = { fg = c.bracket },

  Question = { fg = c.fg },

  Todo = {
    fg = c.error,
    bold = true,
  },

  NonText = {
    fg = c.nontext,
  },

  -- Statusline
  StatusLine = {
    fg = c.fg,
    bg = c.status_active,
    bold = true,
  },

  StatusLineNC = {
    fg = c.comment,
    bg = c.status_inactive,
  },

  Cursor = {
    bg = c.cursor,
    fg = c.bg,
  },

  TermCursor = { link = "Cursor" },
  TermCursorNC = { link = "Cursor" },

  Search = {
    fg = c.search_fg,
    bg = c.search_bg,
  },

  CurSearch = {
    fg = c.bg,
    bg = c.special,
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
    fg = c.diff_change_fg,
    bg = c.diff_change_bg,
  },

  DiffText = {
    fg = c.search_fg,
    bg = c.search_bg,
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

  ["@function"] = {
    fg = c.fn,
  },

  ["@function.builtin"] = {
    fg = c.fn,
  },

  ["@function.method"] = {
    fg = c.fn,
  },

  ["@type"] = {
    fg = c.type,
  },

  ["@type.builtin"] = {
    fg = c.type,
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

  -- Markdown
  ["@markup.raw"] = {
    fg = c.nontext,
    bg = c.bg,
  },

  ["@markup.raw.block.markdown"] = {
    fg = c.fg,
    bg = c.bg,
  },

  ["@markup.raw.delimiter.markdown"] = {
    fg = c.nontext,
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

  -- Treesitter Headings
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
    fg = c.nontext,
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
    fg = c.nontext,
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
    fg = c.nontext,
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
    fg = c.nontext,
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
    fg = c.nontext,
  },

  markdownHeadingDelimiter = {
    fg = c.line_nr,
  },

  markdownCode = {
    fg = c.fg,
    bg = c.bg,
  },

  markdownCodeBlock = {
    fg = c.nontext,
    bg = c.bg,
  },

  markdownCodeDelimiter = {
    fg = c.nontext,
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
    bg = c.cursorl,
  },

  TreesitterContextBottom = {
    sp = c.line_nr,
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
    fg = c.line_nr,
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
    fg = c.comment,
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
    sp = c.comment,
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
    fg = c.comment,
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
    fg = c.comment,
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
    bg = c.diff_change_bg,
  },

  GitSignsDeleteLn = {
    bg = c.diff_del_bg,
  },

  GitSignsAddInline = {
    bg = c.diff_add_bg,
  },

  GitSignsChangeInline = {
    bg = c.diff_change_bg,
  },

  GitSignsDeleteInline = {
    fg = c.error,
    strikethrough = true,
  },

  -- LSP Document Highlight
  -- NOTE(jlima): Provide visual selection background with sp-bound underlines
  -- to isolate write targets without colliding with diagnostics undercurls.
  LspReferenceText = {
    bg = c.visual,
  },

  LspReferenceRead = {
    bg = c.visual,
  },

  LspReferenceWrite = {
    bg = c.visual,
    underline = true,
    sp = c.special,
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
