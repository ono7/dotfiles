-- Configuration file for the 'ayu' colorscheme with custom overrides.
return {
  "Shatur/neovim-ayu",
  lazy = false,
  priority = 1000,
  config = function()
    require("ayu").setup({
      overrides = {
        -- 1. CORE COLORS & COMFORT
        -- Change this variable to test: "#12151A" (Charcoal), "#0D131C" (Obsidian), or "#16181D" (Graphite)
        -- Normal = { bg = "#151F2D", fg = "#BEBEBC" },
        Normal = { bg = "#0D131C", fg = "#BEBEBC" },
        NormalText = { fg = "#BEBEBC" }, -- Base group for neutral text (renamed from NormalBold)
        MatchParen = { fg = "#151F2D", bg = "#BEBEBC" },
        ModeMsg = { link = "NormalText" },
        MoreMsg = { link = "NormalText" },
        Visual = { bg = "#1F3350" },
        MsgSeparator = {},

        Comment = { fg = "#5F6C77", italic = true },
        LineNr = { fg = "#3A4555" },
        GitSignsStagedAdd = { link = "NormalText" },
        FidgetBorder = { fg = "#151F2D", bg = "#151F2D" },

        -- 2. UTILITY & BACKGROUND ELEMENTS
        NormalFloat = { bg = "none" },
        CursorLineNr = { bg = "none" },
        CursorLine = { link = "Visual" },
        CursorColumn = { bg = "none" },
        ColorColumn = { bg = "none" },
        SignColumn = { bg = "none" },
        Folded = { bg = "none" },
        FoldColumn = { bg = "none" },
        EndOfBuffer = { fg = "#151f2d", bg = "none" },

        WinSeparator = { fg = "#3A4555", bg = "none" },
        VertSplit = { link = "WinSeparator" },

        WinBar = { bg = "none" },
        WinBarNC = { fg = "#5a6b85", bg = "none" },

        -- 3. MINIMAL SYNTAX COLORS
        String = { fg = "#8FB47E" },
        Special = { fg = "#D89F5C" },
        Statement = { fg = "#D89F5C" },
        Type = { fg = "#7aa7d8" },
        Function = { fg = "#AABFD9" },
        Identifier = { link = "NormalText" },

        -- 4. ALERTS & MATCHING
        Question = { link = "String" },
        Todo = { fg = "#d35a63" },
        StatusLine = { fg = "#BEBEBC", bg = "#233045" },
        StatusLineNC = { fg = "#5F6C77", bg = "#1A2330" },
        Cursor = { bg = "#FFB454", fg = "#151F2D" },
        TermCursor = { link = "Cursor" },

        -- 5. DIFF & GIT
        DiffAdd = { fg = "#BEBEBC", bg = "#1C2E2E" },
        DiffAdded = { link = "DiffAdd" },
        DiffChange = {},
        DiffText = { fg = "#BEBEBC", bg = "#2A3245" },
        DiffDelete = { fg = "#222A38", bg = "none" },
        DiffRemoved = { fg = "#d35a63", bg = "none" },

        -- 6. RESET/NEUTRAL GROUPS (Linked to NormalText)
        Operator = { link = "NormalText" },
        Delimiter = { link = "NormalText" },
        ["@punctuation.bracket"] = { fg = "#BEBEBC" },
        ["@punctuation.delimiter"] = { fg = "#BEBEBC" },
        ["@operator"] = { fg = "#BEBEBC" },

        -- 7. TREE-SITTER / FINE-GRAINED (Linked to NormalText)
        ["@variable.field"] = { fg = "#AABFD9" },
        ["@parameter"] = { fg = "#AABFD9" },
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

        ["@lsp.typedecl"] = { fg = "#7aa7d8" },
        ["@lsp.type.comment"] = { fg = "#5F6C77", italic = true },

        NonText = { fg = "#5a6b85" },
        FloatBorder = { link = "Comment" },
        Search = { fg = "#151F2D", bg = "#BEBEBC" },
        IncSearch = { fg = "#151F2D", bg = "#BEBEBC" },
        NormalNC = { bg = "#151F2D", fg = "#BEBEBC" },
        SpecialKey = { fg = "#5F6C77" },
        TermCursorNC = { link = "Cursor" },
      },
    })

    -- Load colorscheme
    -- vim.cmd([[colorscheme ayu-dark]])

    -- External hlset calls
    -- Change this variable to test: "#12151A" (Charcoal), "#0D131C" (Obsidian), or "#16181D" (Graphite)
    vim.api.nvim_set_hl(0, "Normal", { bg = "#0D131C" })
    vim.api.nvim_set_hl(0, "TreesitterContextBottom", { fg = "#b396b8", italic = false })
    vim.api.nvim_set_hl(0, "OilFile", { link = "NormalText" })
    vim.api.nvim_set_hl(0, "@text.todo", { link = "ErrorMsg" })
    vim.api.nvim_set_hl(0, "@text.danger", { link = "ErrorMsg" })
    vim.api.nvim_set_hl(0, "@text.note", { link = "NormalText" })
    vim.api.nvim_set_hl(0, "@spell.markdown", { link = "NormalText" })

    -- Loop over all defined groups (Commented out, bold overrides removed)
    -- for name, hl in pairs(vim.api.nvim_get_hl(0, {})) do
    --   if name ~= "Normal" and name ~= "NormalNC" then
    --     local updated = vim.tbl_extend("force", hl, {})
    --     vim.api.nvim_set_hl(0, name, updated)
    --   end
    -- end
  end,
}
