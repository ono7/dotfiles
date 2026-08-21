return {
  dir = "~/.config/nvim", -- Local spec, no external git repo needed
  name = "custom-theme",
  lazy = false,
  priority = 1000,
  config = function()
    -- 1. BASE PALETTE
    -- Easily swap background here: "#0D131C" (Obsidian), "#12151A" (Charcoal), "#16181D" (Graphite)
    local bg = "#0D131C"
    local bg_subtle = "#161F2E"
    local bg_visual = "#1F3350"
    local fg_main = "#BEBEBC"
    local fg_muted = "#5F6C77"
    local fg_line = "#3A4555"

    local c = {
      bg = bg,
      fg = fg_main,
      muted = fg_muted,
      line_nr = fg_line,
      visual = bg_visual,
      subtle = bg_subtle,
      string = "#8FB47E",
      special = "#D89F5C",
      type = "#7AA7D8",
      fn = "#AABFD9",
      error = "#D35A63",
      cursor = "#FFB454",
      diff_add_bg = "#1C2E2E",
      diff_text_bg = "#2A3245",
      diff_del_fg = "#222A38",
      context = "#B396B8",
      winbar_nc = "#5A6B85",
    }

    -- Reset previous highlights
    if vim.g.colors_name then
      vim.cmd("hi clear")
    end
    vim.o.termguicolors = true
    vim.g.colors_name = "custom-slate"

    -- 2. HIGHLIGHT DEFINITIONS
    local highlights = {
      -- Core Editor & Text
      Normal = { fg = c.fg, bg = c.bg },
      NormalNC = { fg = c.fg, bg = c.bg },
      NormalText = { fg = c.fg },
      MatchParen = { fg = c.bg, bg = c.fg },
      ModeMsg = { link = "NormalText" },
      MoreMsg = { link = "NormalText" },
      Visual = { bg = c.visual },
      MsgSeparator = {},

      Comment = { fg = c.muted, italic = true },
      LineNr = { fg = c.line_nr, bg = c.bg },
      CursorLineNr = { fg = c.fg, bg = "none" },
      CursorLine = { link = "Visual" },
      CursorColumn = { bg = "none" },
      ColorColumn = { bg = "none" },
      SignColumn = { bg = "none" },
      Folded = { bg = "none" },
      FoldColumn = { bg = "none" },
      EndOfBuffer = { fg = c.bg, bg = "none" },

      -- Window Chrome & Floating Windows
      NormalFloat = { fg = c.fg, bg = "none" },
      FloatBorder = { fg = c.muted, bg = "none" },
      WinSeparator = { fg = c.line_nr, bg = "none" },
      VertSplit = { link = "WinSeparator" },
      WinBar = { bg = "none" },
      WinBarNC = { fg = c.winbar_nc, bg = "none" },
      FidgetBorder = { fg = c.bg, bg = c.bg },

      -- Syntax
      String = { fg = c.string },
      Special = { fg = c.special },
      Statement = { fg = c.special },
      Type = { fg = c.type },
      Function = { fg = c.fn },
      Identifier = { link = "NormalText" },
      Operator = { link = "NormalText" },
      Delimiter = { link = "NormalText" },
      Question = { link = "String" },
      Todo = { fg = c.error },
      SpecialKey = { fg = c.muted },
      NonText = { fg = c.winbar_nc },

      -- UI Elements & Cursors
      StatusLine = { fg = c.fg, bg = "#233045" },
      StatusLineNC = { fg = c.muted, bg = "#1A2330" },
      Cursor = { bg = c.cursor, fg = c.bg },
      TermCursor = { link = "Cursor" },
      TermCursorNC = { link = "Cursor" },
      Search = { fg = c.bg, bg = c.fg },
      IncSearch = { fg = c.bg, bg = c.fg },
      GitSignsStagedAdd = { link = "NormalText" },

      -- Diff & Git
      DiffAdd = { fg = c.fg, bg = c.diff_add_bg },
      DiffAdded = { link = "DiffAdd" },
      DiffChange = {},
      DiffText = { fg = c.fg, bg = c.diff_text_bg },
      DiffDelete = { fg = c.diff_del_fg, bg = "none" },
      DiffRemoved = { fg = c.error, bg = "none" },

      -- Treesitter & Fine-Grained
      ["@punctuation.bracket"] = { fg = c.fg },
      ["@punctuation.delimiter"] = { fg = c.fg },
      ["@operator"] = { fg = c.fg },
      ["@variable.field"] = { fg = c.fn },
      ["@parameter"] = { fg = c.fn },
      ["@variable.parameter"] = { link = "NormalText" },
      ["@variable.member"] = { link = "NormalText" },
      ["@variable"] = { link = "NormalText" },
      ["@variable.builtin"] = { link = "NormalText" },
      ["@property"] = { link = "NormalText" },
      ["@function.builtin"] = { link = "NormalText" },
      ["@constant.builtin"] = { link = "NormalText" },
      ["@property.yaml"] = { link = "Type" },
      ["@module"] = { link = "NormalText" },
      ["@markup.raw"] = { link = "NormalText" },
      ["@markup.heading"] = {},
      ["@constructor"] = { link = "NormalText" },
      ["@constructor.python"] = { link = "NormalText" },
      ["@function.method"] = { italic = false },
      ["@text.todo"] = { link = "ErrorMsg" },
      ["@text.danger"] = { link = "ErrorMsg" },
      ["@text.note"] = { link = "NormalText" },
      ["@spell.markdown"] = { link = "NormalText" },

      -- LSP & Context
      ["@lsp.typedecl"] = { fg = c.type },
      ["@lsp.type.comment"] = { fg = c.muted, italic = true },
      TreesitterContextBottom = { fg = c.context, italic = false },
      OilFile = { link = "NormalText" },
    }

    -- 3. APPLY HIGHLIGHTS
    for group, spec in pairs(highlights) do
      vim.api.nvim_set_hl(0, group, spec)
    end
  end,
}
