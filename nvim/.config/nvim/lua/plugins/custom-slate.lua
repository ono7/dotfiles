-- ~/.config/nvim/lua/plugins/custom-slate.lua
return {
  {
    "custom-slate",
    virtual = true,
    lazy = false,
    priority = 1000,
    config = function()
      -- 1. HARMONIOUS SOOTHING PALETTE
      -- Base layers
      local bg = "#131720" -- Deep velvet ink; rich, soft on eyes, zero glare
      local bg_subtle = "#19202C" -- Floating windows, popups & active statusline
      local bg_visual = "#222D3E" -- Selection / CursorLine
      local bg_highlight = "#1C2433"
      local bg_inactive = "#151922" -- Inactive statusline background

      -- Typography
      local fg_main = "#D2D6DC" -- Warm ivory/platinum (crisp without harsh glare)
      local fg_dim = "#9DA7B3" -- Secondary elements & punctuation
      local fg_muted = "#5C6A7B" -- Comments & line numbers (soft slate)

      -- Syntax Accents (Warm & Balanced)
      local c = {
        bg = bg,
        fg = fg_main,
        dim = fg_dim,
        muted = fg_muted,
        subtle = bg_subtle,
        visual = bg_visual,
        line_nr = "#384354",

        -- Color tokens
        keyword = "#E59468", -- Warm apricot / terracotta
        string = "#A3C78B", -- Soothing sage green
        type = "#76A9E6", -- Clear soft cornflower blue
        fn = "#89D0D8", -- Crisp calm cyan/teal
        param = "#B6C8E6", -- Gentle periwinkle
        constant = "#E5B567", -- Soft gold/amber
        error = "#E06C75", -- Muted coral red
        cursor = "#FFB454",
        diff_add = "#182C28",
        diff_text = "#24334A",
      }

      -- Reset & apply
      if vim.g.colors_name then
        vim.cmd("hi clear")
      end
      vim.o.termguicolors = true
      vim.g.colors_name = "custom-slate"

      -- 2. HIGHLIGHT DEFINITIONS
      local highlights = {
        -- Core Editor
        Normal = { fg = c.fg, bg = c.bg },
        NormalNC = { fg = c.dim, bg = c.bg },
        NormalText = { fg = c.fg },
        -- MatchParen = { fg = c.keyword, bg = c.visual, bold = true },
        MatchParen = { fg = c.fg, bold = true },
        ModeMsg = { fg = c.fg },
        MoreMsg = { fg = c.fg },
        Visual = { bg = c.visual },
        MsgSeparator = {},

        Comment = { fg = c.muted, italic = true },
        LineNr = { fg = c.line_nr, bg = c.bg },
        CursorLineNr = { fg = c.constant, bg = "none", bold = true },
        CursorLine = { bg = bg_highlight },
        CursorColumn = { bg = bg_highlight },
        ColorColumn = { bg = bg_highlight },
        SignColumn = { bg = "none" },
        Folded = { fg = c.muted, bg = c.subtle },
        FoldColumn = { bg = "none" },
        EndOfBuffer = { fg = c.bg, bg = "none" },

        -- Window Chrome & Floats
        NormalFloat = { fg = c.fg, bg = c.subtle },
        FloatBorder = { fg = c.line_nr, bg = c.subtle },
        WinSeparator = { fg = c.line_nr, bg = "none" },
        VertSplit = { link = "WinSeparator" },
        WinBar = { bg = "none" },
        WinBarNC = { fg = c.muted, bg = "none" },
        FidgetBorder = { fg = c.bg, bg = c.bg },

        -- Syntax
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

        -- UI Elements & Statusline
        StatusLine = { fg = c.fg, bg = c.subtle },
        StatusLineNC = { fg = c.muted, bg = bg_inactive },
        Cursor = { bg = c.cursor, fg = c.bg },
        TermCursor = { link = "Cursor" },
        TermCursorNC = { link = "Cursor" },
        Search = { fg = c.bg, bg = c.constant },
        IncSearch = { fg = c.bg, bg = c.keyword },
        GitSignsStagedAdd = { fg = c.string },

        -- Diff & Git
        DiffAdd = { fg = c.fg, bg = c.diff_add },
        DiffAdded = { link = "DiffAdd" },
        DiffChange = {},
        DiffText = { fg = c.fg, bg = c.diff_text },
        DiffDelete = { fg = c.muted, bg = "none" },
        DiffRemoved = { fg = c.error, bg = "none" },

        -- Treesitter & Fine-Grained
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
        ["@markup.raw"] = { fg = c.string },
        ["@markup.heading"] = { fg = c.keyword, bold = true },
        ["@constructor"] = { fg = c.type },
        ["@constructor.python"] = { fg = c.type },
        ["@text.todo"] = { fg = c.error, bold = true },
        ["@text.danger"] = { fg = c.error, bold = true },
        ["@text.note"] = { fg = c.fn },
        ["@spell.markdown"] = { link = "NormalText" },

        -- LSP & Breadcrumbs
        ["@lsp.typedecl"] = { fg = c.type },
        ["@lsp.type.comment"] = { fg = c.muted, italic = true },
        TreesitterContextBottom = { fg = c.param, italic = false },
        OilFile = { link = "NormalText" },
      }

      -- 3. APPLY
      for group, spec in pairs(highlights) do
        vim.api.nvim_set_hl(0, group, spec)
      end
    end,
  },
}
