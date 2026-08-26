-- ~/.config/nvim/colors/custom-macchiato.lua

-- 1. Reset everything FIRST
vim.cmd("hi clear")
if vim.fn.exists("syntax_on") then
  vim.cmd("syntax reset")
end

-- 2. Force the environment variables to DARK mode
vim.o.termguicolors = true
vim.o.background = "dark"
vim.g.colors_name = "custom-macchiato"

-- Force Neovide's window background to match the Macchiato base color
if vim.g.neovide then
  vim.g.neovide_background_color = "#24273A"
end

-- 3. ASTIGMATISM-FRIENDLY DARK PALETTE (Catppuccin Macchiato)
local bg = "#24273A" -- Base
local bg_subtle = "#1E2030" -- Mantle (slightly darker for UI elements)
local bg_inactive = "#181825" -- Crust (darkest for inactive statuslines)
local bg_visual = "#363A4F" -- Surface0 (visual selection)
local bg_highlight = "#494D64" -- Surface1 (cursorline / colorcolumn)

local fg_main = "#CAD3F5" -- Text (soft off-white to prevent halation)
local fg_dim = "#B8C0E0" -- Subtext1
local fg_muted = "#A5ADCB" -- Subtext0
local fg_faint = "#5B6078" -- Surface2 (very dim for non-text/borders)

local c = {
  bg = bg,
  fg = fg_main,
  dim = fg_dim,
  muted = fg_muted,
  faint = fg_faint,
  subtle = bg_subtle,
  visual = bg_visual,
  line_nr = "#6E738D", -- Overlay0 (visible but recedes)
  comment = "#8087A2", -- Overlay1 (soft, readable comments)
  keyword = "#C6A0F6", -- Mauve
  string = "#A6DA95", -- Green
  type = "#F5A97F", -- Peach
  fn = "#8AADF4", -- Blue
  param = "#F5BDE6", -- Pink
  constant = "#EED49F", -- Yellow
  error = "#ED8796", -- Red
  cursor = "#F4DBD6", -- Rosewater
  diff_add_bg = "#2F403B", -- Muted green overlay for git diffs
  diff_text_bg = "#323F54", -- Muted blue overlay for git diff text
}

-- Terminal ANSI (Mapped to Catppuccin Macchiato equivalents)
vim.g.terminal_color_0 = c.subtle
vim.g.terminal_color_1 = c.error
vim.g.terminal_color_2 = c.string
vim.g.terminal_color_3 = c.constant
vim.g.terminal_color_4 = c.fn
vim.g.terminal_color_5 = c.keyword
vim.g.terminal_color_6 = "#8BD5CA" -- Teal
vim.g.terminal_color_7 = c.fg
vim.g.terminal_color_8 = c.comment
vim.g.terminal_color_9 = c.error
vim.g.terminal_color_10 = c.string
vim.g.terminal_color_11 = c.constant
vim.g.terminal_color_12 = c.fn
vim.g.terminal_color_13 = c.keyword
vim.g.terminal_color_14 = "#8BD5CA" -- Teal
vim.g.terminal_color_15 = "#A5ADCB" -- Subtext0

-- 4. Highlights (Logic remains exactly the same as your setup)
local highlights = {
  Normal = { fg = c.fg, bg = c.bg },
  NormalNC = { link = "Normal" },
  NormalText = { fg = c.fg },
  MatchParen = { fg = c.bg, bg = c.fg, bold = true },
  ModeMsg = { fg = c.fg },
  MoreMsg = { fg = c.fg },
  Error = { fg = c.error },
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
  Todo = { fg = c.bg, bg = c.error, bold = true },
  SpecialKey = { fg = c.muted },
  NonText = { fg = c.faint },

  StatusLine = { fg = c.fg, bg = c.subtle },
  StatusLineNC = { fg = c.muted, bg = bg_inactive },
  Cursor = { bg = c.cursor, fg = c.bg },
  TermCursor = { link = "Cursor" },
  TermCursorNC = { link = "Cursor" },
  Search = { fg = c.bg, bg = c.constant },
  IncSearch = { fg = c.bg, bg = c.keyword },

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
  ["@punctuation.bracket"] = { fg = c.fg },
  ["@punctuation.delimiter"] = { fg = c.fg },
  ["@operator"] = { fg = c.fg },
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
  ["@text.todo"] = { fg = c.bg, bg = c.error, bold = true },
  ["@text.danger"] = { fg = c.bg, bg = c.error, bold = true },
  ["@text.note"] = { fg = c.bg, bg = c.fn, bold = true },
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
  FzfLuaBackdrop = { bg = c.bg_inactive },
  FzfLuaBorder = { fg = c.line_nr },
  FzfLuaTitle = { fg = c.keyword, bold = true },
  FzfLuaTitleFlags = { fg = c.type, bold = true },
  FzfLuaHeaderBind = { fg = c.fn },
  FzfLuaHeaderText = { fg = c.keyword },
  FzfLuaPathColNr = { fg = c.constant },
  FzfLuaPathLineNr = { fg = c.string },
  FzfLuaLivePrompt = { fg = c.error, bold = true },
  FzfLuaLiveSym = { fg = c.error },
  FzfLuaBufNr = { fg = c.type },
  FzfLuaBufFlagCur = { fg = c.keyword },
  FzfLuaBufFlagAlt = { fg = c.type },
  FzfLuaTabTitle = { fg = c.type, bold = true },
  FzfLuaTabMarker = { fg = c.string, bold = true },
  FzfLuaFzfMatch = { fg = c.error, bold = true },
  DropBarFzfMatch = { fg = c.error, bold = true },
  fzf1 = { fg = c.error, bg = c.subtle },
  fzf2 = { fg = c.string, bg = c.subtle },
  fzf3 = { fg = c.type, bg = c.subtle },

  -- ==========================================
  -- DIAGNOSTICS
  -- ==========================================
  DiagnosticError = { fg = c.error },
  DiagnosticWarn = { fg = c.constant },
  DiagnosticInfo = { fg = c.type },
  DiagnosticHint = { fg = c.muted },
  DiagnosticOk = { fg = c.string },
  DiagnosticUnderlineError = { sp = c.error, undercurl = true },
  DiagnosticUnderlineWarn = { sp = c.constant, undercurl = true },
  DiagnosticUnderlineInfo = { sp = c.type, undercurl = true },
  DiagnosticUnderlineHint = { sp = c.muted, undercurl = true },
  DiagnosticUnderlineOk = { sp = c.string, undercurl = true },
  DiagnosticVirtualTextError = { fg = c.error, bg = c.subtle },
  DiagnosticVirtualTextWarn = { fg = c.constant, bg = c.subtle },
  DiagnosticVirtualTextInfo = { fg = c.type, bg = c.subtle },
  DiagnosticVirtualTextHint = { fg = c.muted, bg = c.subtle },
  DiagnosticVirtualTextOk = { fg = c.string, bg = c.subtle },
  DiagnosticSignError = { fg = c.error, bg = "none" },
  DiagnosticSignWarn = { fg = c.constant, bg = "none" },
  DiagnosticSignInfo = { fg = c.type, bg = "none" },
  DiagnosticSignHint = { fg = c.muted, bg = "none" },
  DiagnosticSignOk = { fg = c.string, bg = "none" },

  -- ==========================================
  -- GITSIGNS
  -- ==========================================
  GitSignsAdd = { fg = c.string, bg = "none" },
  GitSignsChange = { fg = c.type, bg = "none" },
  GitSignsDelete = { fg = c.error, bg = "none" },
  GitSignsStagedAdd = { fg = c.string },
  GitSignsStagedChange = { fg = c.type },
  GitSignsStagedDelete = { fg = c.error },
  GitSignsStagedChangedelete = { fg = c.type },
  GitSignsAddNr = { fg = c.string, bg = "none" },
  GitSignsChangeNr = { fg = c.type, bg = "none" },
  GitSignsDeleteNr = { fg = c.error, bg = "none" },
  GitSignsAddLn = { bg = c.diff_add_bg },
  GitSignsChangeLn = { bg = c.diff_text_bg },
  GitSignsDeleteLn = { bg = c.subtle },
  GitSignsAddInline = { bg = c.diff_add_bg },
  GitSignsChangeInline = { bg = c.diff_text_bg },
  GitSignsDeleteInline = { fg = c.error, strikethrough = true },
}

for group, spec in pairs(highlights) do
  vim.api.nvim_set_hl(0, group, spec)
end
