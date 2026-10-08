-- ~/.config/nvim/colors/custom-paper-black.lua

-- 1. Reset everything FIRST
vim.cmd("hi clear")
if vim.fn.exists("syntax_on") then
  vim.cmd("syntax reset")
end

-- 2. Force the environment variables to LIGHT mode
vim.o.termguicolors = true
vim.o.background = "light"
vim.g.colors_name = "custom-paper-black"

local my_bg = "#EDE9E1"

-- Force Neovide's window background to match the warm paper color
if vim.g.neovide then
  vim.g.neovide_background_color = my_bg
end

-- 3. ANTI-GLARE LIGHT PALETTE
-- Warm paper background with softened foreground contrast.
-- Avoids pure white and pure black to reduce visual bloom.

local bg = my_bg
-- NOTE(jlima): Unified subtle and floating background states to reference my_bg
-- directly to prevent palette fragmentation across LSP hover float buffers.
local bg_subtle = my_bg
local bg_visual = "#D9D4CA"
local bg_highlight = "#E5E1D9"
local bg_inactive = my_bg

-- Dark charcoal instead of pure black.
local text_black = "#242424"

local fg_dim = "#59616B"
local fg_muted = "#747D87"
local fg_faint = "#9DA4AB"

local c = {
  bg = bg,
  fg = text_black,
  dim = fg_dim,
  muted = fg_muted,
  faint = fg_faint,

  subtle = bg_subtle,
  visual = bg_visual,
  highlight = bg_highlight,
  inactive = bg_inactive,

  line_nr = "#9DA4AB",

  status_active = "#DDD8CE",
  status_inactive = "#D8D3C9",

  border = "#9299A1",

  -- Text Elements
  comment = "#7B858F",
  string = "#46664F",
  keyword = "#B63E46",

  type = text_black,
  fn = text_black,
  param = text_black,
  constant = text_black,

  -- Structural & Special
  bracket = "#59616B",
  special = "#96583E",

  -- UI, Diagnostics & Git
  error = "#B63E46",
  warn = "#8C6615",
  info = "#35659A",
  ok = "#467252",

  cursor = "#C66B32",

  diff_add_bg = "#DCE7DE",
  diff_add_fg = "#2E4C35",

  diff_del_bg = "#F3DAD7",
  diff_del_fg = "#8F242B",

  diff_txt_bg = "#C9DCCB",
}

-- 4. Terminal ANSI
-- Dark ANSI foregrounds are intentionally softened for the light canvas.

vim.g.terminal_color_0 = "#242424"
vim.g.terminal_color_1 = "#8F242B"
vim.g.terminal_color_2 = "#355B3F"
vim.g.terminal_color_3 = "#76520D"
vim.g.terminal_color_4 = "#274F7D"
vim.g.terminal_color_5 = "#57345A"
vim.g.terminal_color_6 = "#1A5962"
vim.g.terminal_color_7 = "#E8E4DC"

-- Bright ANSI variants
vim.g.terminal_color_8 = "#59616B"
vim.g.terminal_color_9 = "#A3262E"
vim.g.terminal_color_10 = "#2E4C35"
vim.g.terminal_color_11 = "#624508"
vim.g.terminal_color_12 = "#1F3D60"
vim.g.terminal_color_13 = "#472A49"
vim.g.terminal_color_14 = "#174B53"
vim.g.terminal_color_15 = "#F2EFE9"

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
    -- fg = c.line_nr,
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
    fg = c.line_nr,
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
    -- bg = c.diff_add_bg,
    bg = "none",
  },

  DiffText = {
    fg = c.bg,
    bg = c.keyword,
  },

  DiffTextAdd = { link = "DiffText" },

  DiffDelete = {
    fg = c.diff_del_fg,
    -- bg = c.diff_del_bg,
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
