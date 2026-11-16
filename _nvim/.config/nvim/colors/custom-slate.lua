-- ~/.config/nvim/colors/custom-slate.lua

-- 1. Reset everything FIRST
vim.cmd("hi clear")
if vim.fn.exists("syntax_on") then
  vim.cmd("syntax reset")
end

-- 2. Force the environment variables
vim.o.termguicolors = true
vim.o.background = "dark"
vim.g.colors_name = "custom-slate"

-- Force Neovide's window background to match exactly
if vim.g.neovide then
  vim.g.neovide_background_color = "#131720"
end

-- 3. HARMONIOUS SOOTHING PALETTE
local bg = "#131720"
local bg_subtle = "#19202C"
local bg_visual = "#222D3E"
local bg_highlight = "#1C2433"
local bg_inactive = "#151922"

-- Typography
local fg_main = "#D2D6DC"
local fg_dim = "#9DA7B3"
local fg_muted = "#5C6A7B"
local fg_faint = "#323D4D"

-- Syntax Accents
local c = {
  bg = bg,
  fg = fg_main,
  dim = fg_dim,
  muted = fg_muted,
  faint = fg_faint,
  subtle = bg_subtle,
  visual = bg_visual,
  line_nr = "#384354",
  comment = "#536070", -- Your chosen smoked ash color
  keyword = "#E59468",
  string = "#A3C78B",
  type = "#76A9E6",
  fn = "#89D0D8",
  param = "#B6C8E6",
  constant = "#E5B567",
  error = "#E06C75",
  cursor = "#FFB454",
  diff_add_bg = "#1C2E2E",
  diff_text_bg = "#2A3245",
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
vim.g.terminal_color_10 = "#B6DCA0"
vim.g.terminal_color_11 = "#F0C87A"
vim.g.terminal_color_12 = "#92BEF5"
vim.g.terminal_color_13 = "#C8B0CE"
vim.g.terminal_color_14 = "#A2E4EB"
vim.g.terminal_color_15 = "#E8ECEF"

-- 4. Highlights
local highlights = {
  Normal = { fg = c.fg, bg = c.bg },
  NormalNC = { link = "Normal" },
  NormalText = { fg = c.fg },
  MatchParen = { fg = c.fg, bold = true },
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
  PmenuSel = { fg = c.fg, bg = c.visual, bold = true },
  PmenuKind = { fg = c.type, bg = c.subtle },
  PmenuKindSel = { fg = c.type, bg = c.visual, bold = true },
  PmenuExtra = { fg = c.muted, bg = c.subtle },
  PmenuExtraSel = { fg = c.dim, bg = c.visual },
  PmenuSbar = { bg = c.subtle },
  PmenuThumb = { bg = c.line_nr },
  WildMenu = { fg = c.fg, bg = c.visual },

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
  Function = { fg = c.fg },
  Identifier = { fg = c.fg },
  Operator = { fg = c.dim },
  Delimiter = { fg = c.fg },
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

  DiffviewDiffAdd = { link = "DiffAdd" },
  DiffviewDiffChange = {},
  DiffviewDiffText = { link = "DiffText" },
  DiffviewDiffDelete = { fg = c.faint, bg = "none" },
  DiffviewDiffDeleteDim = { fg = c.faint, bg = "none" },
  DiffviewDiffAddAsDelete = { fg = c.faint, bg = "none" },
  DiffviewFilePanelTitle = { fg = c.keyword, bold = true },
  DiffviewFilePanelCounter = { fg = c.param, bold = true },
  DiffviewFilePanelFileName = { fg = c.fg },
  DiffviewFilePanelPath = { fg = c.muted },
  DiffviewFilePanelRootPath = { fg = c.muted, bold = true },
  DiffviewFilePanelInsertions = { fg = c.string },
  DiffviewFilePanelDeletions = { fg = c.faint },
  DiffviewFilePanelSelected = { fg = c.type },
  DiffviewStatusAdded = { fg = c.string },
  DiffviewStatusUntracked = { fg = c.string },
  DiffviewStatusModified = { fg = c.type },
  DiffviewStatusRenamed = { fg = c.constant },
  DiffviewStatusDeleted = { fg = c.faint },
  DiffviewStatusBroken = { fg = c.faint },
  DiffviewStatusUnknown = { fg = c.faint },
  DiffviewPrimary = { fg = c.keyword },
  DiffviewSecondary = { fg = c.type },
  DiffviewFolder = { fg = c.type },
  DiffviewFolderName = { fg = c.type },
  DiffviewDim1 = { fg = c.muted },
  DiffviewDim2 = { fg = c.faint },

  diffAdded = { fg = c.string },
  diffRemoved = { fg = c.faint, bg = "none" },
  diffChanged = {},
  diffOldFile = { fg = c.faint },
  diffNewFile = { fg = c.string },
  diffFile = { fg = c.type },
  diffLine = { fg = c.muted },
  diffIndexLine = { fg = c.muted },

  ["@diff.plus"] = { fg = c.string },
  ["@diff.minus"] = { fg = c.faint },
  ["@diff.delta"] = {},
  ["@punctuation.bracket"] = { fg = c.fg },
  ["@punctuation.delimiter"] = { fg = c.fg },
  ["@operator"] = { fg = c.fg },
  ["@variable"] = { fg = c.fg },
  ["@variable.builtin"] = { fg = c.type },
  ["@variable.parameter"] = { fg = c.fg },
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
}

for group, spec in pairs(highlights) do
  vim.api.nvim_set_hl(0, group, spec)
end
