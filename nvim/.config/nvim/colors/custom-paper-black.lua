-- ~/.config/nvim/colors/custom-paper.lua

-- 1. Reset everything FIRST
vim.cmd("hi clear")
if vim.fn.exists("syntax_on") then
  vim.cmd("syntax reset")
end

-- 2. Force the environment variables to LIGHT mode
vim.o.termguicolors = true
vim.o.background = "light"
vim.g.colors_name = "custom-paper-black"

-- Force Neovide's window background to match the warm oatmeal color
if vim.g.neovide then
  vim.g.neovide_background_color = "#F2EFE9"
end

-- 3. ANTI-GLARE LIGHT PALETTE (Monochrome Text Edition)
local bg                = "#F2EFE9"
local bg_subtle         = "#E6E2DA"
local bg_visual         = "#D5CFC4"
local bg_highlight      = "#EAE6DF"
local bg_inactive       = "#EBE7E0"

-- Base text is forced to pitch black
local text_black        = "#000000"

local fg_dim            = "#5C6A7B"
local fg_muted          = "#7B8A9C"
local fg_faint          = "#A9B3C1"

local c                 = {
  bg          = bg,
  fg          = text_black,
  dim         = fg_dim,
  muted       = fg_muted,
  faint       = fg_faint,
  subtle      = bg_subtle,
  visual      = bg_visual,
  highlight   = bg_highlight,
  inactive    = bg_inactive,
  line_nr     = "#A9B3C1",

  -- Text Elements
  comment     = "#8C96A4", -- Light graphite pencil
  string      = "#4A6B53", -- Deep, desaturated olive ink
  -- keyword     = text_black,
  keyword     = "#C4434B",
  type        = text_black,
  fn          = text_black,
  param       = text_black,
  constant    = text_black,

  -- Structural & Special
  bracket     = "#5C6A7B",
  -- special     = "#B85C38", -- Rust color for \n, \t, and special chars
  special     = "#9E5A3F",

  -- UI, Diagnostics & Git
  error       = "#C4434B",
  warn        = "#996E14",
  info        = "#3B6EA8",
  ok          = "#4A7A59",
  cursor      = "#D97736",
  diff_add_bg = "#DCE8DE",
  diff_add_fg = "#2B4B34",
  diff_del_bg = "#F7DCDA",
  diff_del_fg = "#961C24",
  diff_txt_bg = "#BED8C2",
}

-- Terminal ANSI (Hardcoded high-contrast values for light background)
vim.g.terminal_color_0  = "#D5CFC4" -- Black (Normal / Subtle BG)
vim.g.terminal_color_1  = "#961C24" -- Red (Normal)
vim.g.terminal_color_2  = "#355B3F" -- Green (Normal)
vim.g.terminal_color_3  = "#80550B" -- Yellow / Orange (Normal)
vim.g.terminal_color_4  = "#274F7D" -- Blue (Normal)
vim.g.terminal_color_5  = "#5A315C" -- Magenta (Normal)
vim.g.terminal_color_6  = "#1A5C66" -- Cyan (Normal)
vim.g.terminal_color_7  = "#38414D" -- White / Gray (Normal)

-- Bright ANSI variants
vim.g.terminal_color_8  = "#424B57" -- Bright Black
vim.g.terminal_color_9  = "#A8222A" -- Bright Red
vim.g.terminal_color_10 = "#2B4B34" -- Bright Green
vim.g.terminal_color_11 = "#664308" -- Bright Yellow
vim.g.terminal_color_12 = "#1D3B5E" -- Bright Blue
vim.g.terminal_color_13 = "#472649" -- Bright Magenta
vim.g.terminal_color_14 = "#144850" -- Bright Cyan
vim.g.terminal_color_15 = "#111417" -- Bright White

-- 4. Highlights
local highlights        = {
  Normal                                            = { fg = c.fg, bg = c.bg },
  NormalNC                                          = { link = "Normal" },
  NormalText                                        = { fg = c.fg },
  MatchParen                                        = { fg = c.comment, bg = c.fg, bold = true },
  ModeMsg                                           = { fg = c.fg, bold = true },
  MoreMsg                                           = { fg = c.fg, bold = true },
  Error                                             = { fg = c.error, bold = true },
  Visual                                            = { bg = c.visual },
  MsgSeparator                                      = {},

  Comment                                           = { fg = c.comment, italic = true },
  ["@lsp.type.comment"]                             = { fg = c.comment, italic = true },
  ["@comment"]                                      = { fg = c.comment, italic = true },

  LineNr                                            = { fg = c.line_nr, bg = c.bg },
  CursorLineNr                                      = { fg = c.warn, bg = "none", bold = true },
  CursorLine                                        = { bg = c.highlight },
  CursorColumn                                      = { bg = c.highlight },
  ColorColumn                                       = { bg = c.highlight },
  SignColumn                                        = { bg = "none" },
  Folded                                            = { fg = c.muted, bg = c.subtle },
  FoldColumn                                        = { bg = "none" },
  EndOfBuffer                                       = { fg = c.bg, bg = "none" },

  NormalFloat                                       = { fg = c.fg, bg = c.subtle },
  FloatBorder                                       = { fg = c.line_nr, bg = c.subtle },
  FloatTitle                                        = { fg = c.fg, bg = c.subtle, bold = true },
  FloatFooter                                       = { fg = c.muted, bg = c.subtle },
  WinSeparator                                      = { fg = c.line_nr, bg = "none" },
  VertSplit                                         = { link = "WinSeparator" },
  WinBar                                            = { bg = "none" },
  WinBarNC                                          = { fg = c.muted, bg = "none" },
  FidgetBorder                                      = { fg = c.bg, bg = c.bg },

  Pmenu                                             = { fg = c.fg, bg = c.subtle },
  PmenuSel                                          = { fg = c.bg, bg = c.info, bold = true },
  PmenuKind                                         = { fg = c.info, bg = c.subtle },
  PmenuKindSel                                      = { fg = c.bg, bg = c.info, bold = true },
  PmenuExtra                                        = { fg = c.muted, bg = c.subtle },
  PmenuExtraSel                                     = { fg = c.bg, bg = c.info },
  PmenuSbar                                         = { bg = c.subtle },
  PmenuThumb                                        = { bg = c.line_nr },
  WildMenu                                          = { fg = c.bg, bg = c.info },

  CmpItemAbbr                                       = { fg = c.fg },
  CmpItemAbbrDeprecated                             = { fg = c.muted, strikethrough = true },
  CmpItemAbbrMatch                                  = { fg = c.fg, bold = true },
  CmpItemAbbrMatchFuzzy                             = { fg = c.fg, bold = true },
  CmpItemMenu                                       = { fg = c.muted, italic = true },
  CmpItemKindFunction                               = { fg = c.fg },
  CmpItemKindMethod                                 = { fg = c.fg },
  CmpItemKindVariable                               = { fg = c.fg },
  CmpItemKindField                                  = { fg = c.fg },
  CmpItemKindProperty                               = { fg = c.fg },
  CmpItemKindClass                                  = { fg = c.fg },
  CmpItemKindInterface                              = { fg = c.fg },
  CmpItemKindStruct                                 = { fg = c.fg },
  CmpItemKindKeyword                                = { fg = c.fg },
  CmpItemKindSnippet                                = { fg = c.fg },
  CmpItemKindText                                   = { fg = c.fg },
  CmpItemKindFile                                   = { fg = c.fg },
  CmpItemKindFolder                                 = { fg = c.fg },

  String                                            = { fg = c.string },
  Special                                           = { fg = c.special },
  SpecialKey                                        = { fg = c.special },
  SpecialChar                                       = { fg = c.special },
  Statement                                         = { fg = c.keyword },
  Keyword                                           = { fg = c.keyword },
  Type                                              = { fg = c.type },
  Function                                          = { fg = c.fg },
  Identifier                                        = { fg = c.fg },
  Operator                                          = { fg = c.fg },
  Delimiter                                         = { fg = c.bracket },
  Question                                          = { fg = c.fg },
  Todo                                              = { fg = c.error, bold = true },
  NonText                                           = { fg = c.line_nr },

  StatusLine                                        = { fg = c.fg, bg = c.subtle },
  StatusLineNC                                      = { fg = c.muted, bg = c.inactive },
  Cursor                                            = { bg = c.cursor, fg = c.bg },
  TermCursor                                        = { link = "Cursor" },
  TermCursorNC                                      = { link = "Cursor" },
  Search                                            = { fg = c.bg, bg = c.warn },
  CurSearch                                         = { fg = c.bg, bg = text_black, bold = true },
  IncSearch                                         = { link = "CurSearch" },

  DiffAdd                                           = { fg = c.diff_add_fg, bg = c.diff_add_bg },
  DiffAdded                                         = { fg = c.ok, bg = "none" },
  DiffChange                                        = { bg = c.diff_add_bg },
  DiffText                                          = { fg = c.fg, bg = c.diff_txt_bg, bold = true },
  DiffTextAdd                                       = { link = "DiffText" },
  DiffDelete                                        = { fg = c.diff_del_fg, bg = c.diff_del_bg },
  DiffRemoved                                       = { fg = c.error, bg = "none" },

  ["@diff.plus"]                                    = { fg = c.ok },
  ["@diff.minus"]                                   = { fg = c.error },
  ["@diff.delta"]                                   = { fg = c.warn },

  -- Syntax & Treesitter Mappings
  ["@punctuation.bracket"]                          = { fg = c.bracket },
  ["@punctuation.delimiter"]                        = { fg = c.bracket },
  ["@string"]                                       = { fg = c.string },
  ["@string.escape"]                                = { fg = c.special, bold = true },
  ["@character.special"]                            = { fg = c.special, bold = true },

  ["@operator"]                                     = { fg = c.fg },
  ["@variable"]                                     = { fg = c.fg },
  ["@variable.builtin"]                             = { fg = c.fg },
  ["@variable.parameter"]                           = { fg = c.fg },
  ["@variable.member"]                              = { fg = c.fg },
  ["@variable.field"]                               = { fg = c.fg },
  ["@property"]                                     = { fg = c.fg },
  ["@property.yaml"]                                = { fg = c.fg },
  ["@function.builtin"]                             = { fg = c.fg },
  ["@constant"]                                     = { fg = c.fg },
  ["@constant.builtin"]                             = { fg = c.fg, bold = true },
  ["@module"]                                       = { fg = c.fg },
  ["@markup.heading"]                               = { fg = c.fg, bold = true },
  ["@constructor"]                                  = { fg = c.bracket },
  ["@constructor.python"]                           = { fg = c.fg },
  ["@lsp.type.method.yaml.ansible"]                 = { fg = c.fg },
  ["@lsp.typemod.property.definition.yaml.ansible"] = { fg = c.error },
  ["@text.todo"]                                    = { fg = c.error, bold = true },
  ["@text.danger"]                                  = { fg = c.error, bold = true },
  ["@text.note"]                                    = { fg = c.fg },
  ["@spell.markdown"]                               = { link = "NormalText" },
  ["@markup.raw"]                                   = { fg = c.fg },
  ["@markup.raw.block.markdown"]                    = { fg = c.faint },
  ["@markup.raw.delimiter.markdown"]                = { fg = c.faint },
  ["@lsp.typedecl"]                                 = { fg = c.fg },

  -- Treesitter Context
  TreesitterContext                                 = { bg = c.subtle },
  TreesitterContextBottom                           = { sp = c.line_nr, underline = true },
  OilFile                                           = { link = "NormalText" },

  -- FZF-Lua Overrides
  FzfLuaBackdrop                                    = { bg = c.inactive },
  FzfLuaBorder                                      = { fg = c.line_nr },
  FzfLuaTitle                                       = { fg = c.fg, bold = true },
  FzfLuaTitleFlags                                  = { fg = c.info, bold = true },
  FzfLuaHeaderBind                                  = { fg = c.info },
  FzfLuaHeaderText                                  = { fg = c.warn },
  FzfLuaPathColNr                                   = { fg = c.warn },
  FzfLuaPathLineNr                                  = { fg = c.ok },
  FzfLuaLivePrompt                                  = { fg = c.error, bold = true },
  FzfLuaLiveSym                                     = { fg = c.error },
  FzfLuaBufNr                                       = { fg = c.info },
  FzfLuaBufFlagCur                                  = { fg = c.warn },
  FzfLuaBufFlagAlt                                  = { fg = c.info },
  FzfLuaTabTitle                                    = { fg = c.info, bold = true },
  FzfLuaTabMarker                                   = { fg = c.ok, bold = true },
  FzfLuaFzfMatch                                    = { fg = c.error, bold = true },
  DropBarFzfMatch                                   = { fg = c.error, bold = true },

  fzf1                                              = { fg = c.error, bg = c.subtle },
  fzf2                                              = { fg = c.ok, bg = c.subtle },
  fzf3                                              = { fg = c.info, bg = c.subtle },

  -- Diagnostics
  DiagnosticError                                   = { fg = c.error },
  DiagnosticWarn                                    = { fg = c.warn },
  DiagnosticInfo                                    = { fg = c.info },
  DiagnosticHint                                    = { fg = c.muted },
  DiagnosticOk                                      = { fg = c.ok },

  DiagnosticUnderlineError                          = { sp = c.error, undercurl = true },
  DiagnosticUnderlineWarn                           = { sp = c.warn, undercurl = true },
  DiagnosticUnderlineInfo                           = { sp = c.info, undercurl = true },
  DiagnosticUnderlineHint                           = { sp = c.muted, undercurl = true },
  DiagnosticUnderlineOk                             = { sp = c.ok, undercurl = true },

  DiagnosticVirtualTextError                        = { fg = c.error, bg = c.subtle },
  DiagnosticVirtualTextWarn                         = { fg = c.warn, bg = c.subtle },
  DiagnosticVirtualTextInfo                         = { fg = c.info, bg = c.subtle },
  DiagnosticVirtualTextHint                         = { fg = c.muted, bg = c.subtle },
  DiagnosticVirtualTextOk                           = { fg = c.ok, bg = c.subtle },

  DiagnosticSignError                               = { fg = c.error, bg = "none" },
  DiagnosticSignWarn                                = { fg = c.warn, bg = "none" },
  DiagnosticSignInfo                                = { fg = c.info, bg = "none" },
  DiagnosticSignHint                                = { fg = c.muted, bg = "none" },
  DiagnosticSignOk                                  = { fg = c.ok, bg = "none" },

  -- GitSigns
  GitSignsAdd                                       = { fg = c.ok, bg = "none" },
  GitSignsChange                                    = { fg = c.info, bg = "none" },
  GitSignsDelete                                    = { fg = c.error, bg = "none" },
  GitSignsStagedAdd                                 = { fg = c.ok },
  GitSignsStagedChange                              = { fg = c.info },
  GitSignsStagedDelete                              = { fg = c.error },
  GitSignsStagedChangedelete                        = { fg = c.info },
  GitSignsAddNr                                     = { fg = c.ok, bg = "none" },
  GitSignsChangeNr                                  = { fg = c.info, bg = "none" },
  GitSignsDeleteNr                                  = { fg = c.error, bg = "none" },
  GitSignsAddLn                                     = { bg = c.diff_add_bg },
  GitSignsChangeLn                                  = { bg = c.diff_txt_bg },
  GitSignsDeleteLn                                  = { bg = c.subtle },
  GitSignsAddInline                                 = { bg = c.diff_add_bg },
  GitSignsChangeInline                              = { bg = c.diff_txt_bg },
  GitSignsDeleteInline                              = { fg = c.error, strikethrough = true },

  -- LSP Document Highlight
  LspReferenceText                                  = { bg = c.visual },
  LspReferenceRead                                  = { bg = c.visual },
  LspReferenceWrite                                 = { bg = c.visual, underline = true },
  IlluminatedWordText                               = { link = "LspReferenceText" },
  IlluminatedWordRead                               = { link = "LspReferenceRead" },
  IlluminatedWordWrite                              = { link = "LspReferenceWrite" },
}

for group, spec in pairs(highlights) do
  vim.api.nvim_set_hl(0, group, spec)
end
