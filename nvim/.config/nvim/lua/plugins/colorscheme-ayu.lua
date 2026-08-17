-- Configuration file for the 'ayu' colorscheme with custom overrides.
return {
  "Shatur/neovim-ayu",
  lazy = false,
  priority = 1000,
  config = function()
    require("ayu").setup({
      overrides = {
        -- 1. CORE COLORS & COMFORT
        Normal = { bg = "#151F2D", fg = "#BEBEBC" },
        NormalBold = { fg = "#BEBEBC", bold = true }, -- Base bold group for neutral text
        MatchParen = { fg = "#151F2D", bg = "#BEBEBC" },
        ModeMsg = { link = "NormalBold" },
        MoreMsg = { link = "NormalBold" },
        Visual = { bg = "#1F3350" },
        MsgSeparator = {},

        Comment = { fg = "#5F6C77", italic = true, bold = true },
        LineNr = { fg = "#3A4555", bold = true },
        GitSignsStagedAdd = { link = "NormalBold" },
        FidgetBorder = { fg = "#151F2D", bg = "#151F2D" },

        -- 2. UTILITY & BACKGROUND ELEMENTS
        NormalFloat = { bg = "none" },
        CursorLineNr = { bg = "none", bold = true },
        CursorLine = { link = "Visual" },
        CursorColumn = { bg = "none" },
        ColorColumn = { bg = "none" },
        SignColumn = { bg = "none" },
        Folded = { bg = "none" },
        FoldColumn = { bg = "none" },
        EndOfBuffer = { fg = "#151f2d", bg = "none" },

        WinSeparator = { fg = "#3A4555", bg = "none" },
        VertSplit = { link = "WinSeparator" },

        WinBar = { bg = "none", bold = true },
        WinBarNC = { fg = "#5a6b85", bg = "none" },

        -- 3. MINIMAL SYNTAX COLORS
        String = { fg = "#8FB47E", bold = true },
        Special = { fg = "#D89F5C", bold = true },
        Statement = { fg = "#D89F5C", bold = true },
        Type = { fg = "#7aa7d8", bold = true },
        Function = { fg = "#AABFD9", bold = true },
        Identifier = { link = "NormalBold" },

        -- 4. ALERTS & MATCHING
        Question = { link = "String" },
        Todo = { fg = "#d35a63", bold = true },
        StatusLine = { fg = "#BEBEBC", bg = "#233045", bold = true },
        StatusLineNC = { fg = "#5F6C77", bg = "#1A2330" },
        Cursor = { bg = "#FFB454", fg = "#151F2D" },
        TermCursor = { link = "Cursor" },

        -- 5. DIFF & GIT
        DiffAdd = { fg = "#BEBEBC", bg = "#1C2E2E", bold = true },
        DiffAdded = { link = "DiffAdd" },
        DiffChange = { bold = true },
        DiffText = { fg = "#BEBEBC", bg = "#2A3245", bold = true },
        DiffDelete = { fg = "#222A38", bg = "none" },
        DiffRemoved = { fg = "#d35a63", bg = "none", bold = true },

        -- 6. RESET/NEUTRAL GROUPS (Linked to NormalBold)
        Operator = { link = "NormalBold" },
        Delimiter = { link = "NormalBold" },
        ["@punctuation.bracket"] = { fg = "#BEBEBC", bold = true },
        ["@punctuation.delimiter"] = { fg = "#BEBEBC", bold = true },
        ["@operator"] = { fg = "#BEBEBC", bold = true },

        -- 7. TREE-SITTER / FINE-GRAINED (Linked to NormalBold)
        ["@variable.field"] = { fg = "#AABFD9", bold = true },
        ["@parameter"] = { fg = "#AABFD9", bold = true },
        ["@variable.parameter"] = { link = "NormalBold" },
        ["@variable.member"] = { link = "NormalBold" },
        ["@variable"] = { link = "NormalBold" },
        ["@variable.builtin"] = { link = "NormalBold" },
        ["@property"] = { link = "NormalBold" },
        ["@function.builtin"] = { link = "NormalBold" },
        ["@constant.builtin"] = { link = "NormalBold" },
        ["@property.yaml"] = { link = "Type" },
        ["@module"] = { link = "NormalBold" },
        ["@markup.raw"] = { link = "NormalBold" },
        ["@markup.heading"] = { bold = true },
        ["@constructor"] = { link = "NormalBold" },
        ["@constructor.python"] = { link = "NormalBold" },
        ["@function.method"] = { bold = true, italic = false },

        ["@lsp.typedecl"] = { fg = "#7aa7d8", bold = true },
        ["@lsp.type.comment"] = { fg = "#5F6C77", italic = true, bold = true },

        NonText = { fg = "#5a6b85" },
        FloatBorder = { link = "Comment", bold = true },
        Search = { fg = "#151F2D", bg = "#BEBEBC", bold = true },
        IncSearch = { fg = "#151F2D", bg = "#BEBEBC", bold = true },
        NormalNC = { bg = "#151F2D", fg = "#BEBEBC" },
        SpecialKey = { fg = "#5F6C77" },
        TermCursorNC = { link = "Cursor" },
      },
    })

    -- Load colorscheme
    vim.cmd([[colorscheme ayu-dark]])

    -- External hlset calls
    vim.api.nvim_set_hl(0, "TreesitterContextBottom", { fg = "#b396b8", bold = true, italic = false })
    vim.api.nvim_set_hl(0, "OilFile", { link = "NormalBold" })
    vim.api.nvim_set_hl(0, "@text.todo", { link = "ErrorMsg" })
    vim.api.nvim_set_hl(0, "@text.danger", { link = "ErrorMsg" })
    vim.api.nvim_set_hl(0, "@text.note", { link = "NormalBold" })

    -- Loop over all defined groups and ensure bold is retained
    -- for name, hl in pairs(vim.api.nvim_get_hl(0, {})) do
    --   if name ~= "Normal" and name ~= "NormalNC" then
    --     local updated = vim.tbl_extend("force", hl, { bold = true })
    --     vim.api.nvim_set_hl(0, name, updated)
    --   end
    -- end
  end,
}
