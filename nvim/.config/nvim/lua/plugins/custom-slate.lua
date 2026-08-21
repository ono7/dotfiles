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
      local bg = "#131720" -- Deep velvet ink
      local bg_subtle = "#19202C" -- Floating windows, popups & active statusline
      local bg_visual = "#222D3E" -- Selection / CursorLine / Pmenu active item
      local bg_highlight = "#1C2433"
      local bg_inactive = "#151922" -- Inactive statusline background

      -- Typography
      local fg_main = "#D2D6DC" -- Warm ivory/platinum
      local fg_dim = "#9DA7B3" -- Secondary elements & punctuation
      local fg_muted = "#5C6A7B" -- Comments & line numbers
      local fg_faint = "#323D4D" -- Dim raw markdown blocks, diff filler & deletions

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

        -- Color tokens
        keyword = "#E59468",
        string = "#A3C78B",
        type = "#76A9E6",
        fn = "#89D0D8",
        param = "#B6C8E6",
        constant = "#E5B567",
        error = "#E06C75",
        cursor = "#FFB454",

        -- Diff Colors
        diff_add_bg = "#1C2E2E",
        diff_text_bg = "#2A3245",
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
        NormalNC = { link = "Normal" },
        NormalText = { fg = c.fg },
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
        FloatTitle = { fg = c.keyword, bg = c.subtle, bold = true },
        FloatFooter = { fg = c.muted, bg = c.subtle },
        WinSeparator = { fg = c.line_nr, bg = "none" },
        VertSplit = { link = "WinSeparator" },
        WinBar = { bg = "none" },
        WinBarNC = { fg = c.muted, bg = "none" },
        FidgetBorder = { fg = c.bg, bg = c.bg },

        -- Popup Menu (Pmenu / Cmp)
        Pmenu = { fg = c.fg, bg = c.subtle },
        PmenuSel = { fg = c.fg, bg = c.visual, bold = true },
        PmenuKind = { fg = c.type, bg = c.subtle },
        PmenuKindSel = { fg = c.type, bg = c.visual, bold = true },
        PmenuExtra = { fg = c.muted, bg = c.subtle },
        PmenuExtraSel = { fg = c.dim, bg = c.visual },
        PmenuSbar = { bg = c.subtle },
        PmenuThumb = { bg = c.line_nr },
        WildMenu = { fg = c.fg, bg = c.visual },

        -- Cmp Autocompletion
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

        -- Native Diff Groups (Diff fill chars and deleted filler lines)
        DiffAdd = { fg = c.fg, bg = c.diff_add_bg },
        DiffAdded = { fg = c.string, bg = "none" },
        DiffChange = {},
        DiffText = { fg = c.fg, bg = c.diff_text_bg },
        DiffTextAdd = { link = "DiffText" },
        DiffDelete = { fg = c.faint, bg = "none" }, -- Diff fill chars (---) now match markdown blocks
        DiffRemoved = { fg = c.faint, bg = "none" },

        -- Diffview Core & Filler Highlights
        DiffviewDiffAdd = { link = "DiffAdd" },
        DiffviewDiffChange = {},
        DiffviewDiffText = { link = "DiffText" },
        DiffviewDiffDelete = { fg = c.faint, bg = "none" },
        DiffviewDiffDeleteDim = { fg = c.faint, bg = "none" }, -- Overrides default Comment link
        DiffviewDiffAddAsDelete = { fg = c.faint, bg = "none" },

        -- Diffview File Panel & Status
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

        -- Patch / Generic Diff Buffer Syntax
        diffAdded = { fg = c.string },
        diffRemoved = { fg = c.faint, bg = "none" },
        diffChanged = {},
        diffOldFile = { fg = c.faint },
        diffNewFile = { fg = c.string },
        diffFile = { fg = c.type },
        diffLine = { fg = c.muted },
        diffIndexLine = { fg = c.muted },

        -- Treesitter Diff Captures
        ["@diff.plus"] = { fg = c.string },
        ["@diff.minus"] = { fg = c.faint },
        ["@diff.delta"] = {},

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
        ["@markup.heading"] = { fg = c.keyword, bold = true },
        ["@constructor"] = { fg = c.type },
        ["@constructor.python"] = { fg = c.type },
        ["@text.todo"] = { fg = c.error, bold = true },
        ["@text.danger"] = { fg = c.error, bold = true },
        ["@text.note"] = { fg = c.fn },
        ["@spell.markdown"] = { link = "NormalText" },

        -- Markdown Raw & Code Blocks
        ["@markup.raw"] = { fg = c.string },
        ["@markup.raw.block.markdown"] = { fg = c.faint },
        ["@markup.raw.delimiter.markdown"] = { fg = c.faint },

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
