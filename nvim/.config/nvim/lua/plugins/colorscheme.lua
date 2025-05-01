return {
  "catppuccin/nvim",
  name = "catppuccin",
  lazy = false,
  priority = 1000,
  config = function()
    local mycolors = {
      white = "#d9e0ee",
      darker_black = "#191828",
      black = "#1e1d2d", --  nvim bg
      black2 = "#252434",
      one_bg = "#2d2c3c", -- real bg of onedark
      one_bg2 = "#363545",
      one_bg3 = "#3e3d4d",
      grey = "#474656",
      grey_fg = "#4e4d5d",
      grey_fg2 = "#555464",
      light_grey = "#605f6f",
      red = "#f38ba8",
      baby_pink = "#ffa5c3",
      pink = "#f5c2e7",
      line = "#383747", -- for lines like vertsplit
      green = "#abe9b3",
      vibrant_green = "#b6f4be",
      nord_blue = "#8bc2f0",
      blue = "#89b4fa",
      yellow = "#fae3b0",
      -- yellow2 = "#f9e2af",
      yellow2 = "#ffe9b6",
      -- yellow2 = "#e6c99d",
      -- yellow2 = "#5fd7ff",
      sun = "#ffe9b6",
      purple = "#d0a9e5",
      purple2 = "#cba6f7",
      dark_purple = "#c7a0dc",
      teal = "#b5e8e0",
      orange = "#f8bd96",
      cyan = "#89dceb",
      statusline_bg = "#232232",
      lightbg = "#2f2e3e",
      pmenu_bg = "#abe9b3",
      folder_bg = "#89b4fa",
      lavender = "#c7d1ff",
    }
    require("catppuccin").setup({
      transparent_background = true,
      show_end_of_buffer = false, -- show the '~' characters after the end of buffers
      term_colors = true,
      dim_inactive = {
        enabled = false,
        shade = "dark",
        percentage = 0.15,
      },
      styles = {
        comments = { "italic" },
        conditionals = { "italic" },
        loops = { "italic" },
        functions = {},
        keywords = {},
        strings = {},
        variables = {},
        numbers = {},
        booleans = {},
        parameters = {},
        properties = {},
        types = {},
        operators = {},
      },
      color_overrides = {
        -- see link below for override names
        -- https://github.com/catppuccin/catppuccin/blob/main/docs/style-guide.md
        mocha = mycolors,
      },
    })
    vim.api.nvim_command("colorscheme catppuccin-mocha")

    vim.api.nvim_set_hl(0, "Folded", { link = "Comment" })
    vim.api.nvim_set_hl(0, "TreesitterContextBottom", { fg = "#b0a0ff", bold = true, italic = true })
    vim.api.nvim_set_hl(0, "@text.todo", { link = "ErrorMsg" })
    vim.api.nvim_set_hl(0, "OilFile", { link = "Normal" })
    vim.api.nvim_set_hl(0, "@text.danger", { link = "ErrorMsg" })
    vim.api.nvim_set_hl(0, "@text.note", { link = "Normal" })
    vim.api.nvim_set_hl(0, "Function", { link = "Normal" })
    vim.api.nvim_set_hl(0, "TreesitterContext", { bg = "#242438" })
    vim.api.nvim_set_hl(0, "@text.uri", { fg = "#8186a1", undercurl = true })
    vim.api.nvim_set_hl(0, "DiffDelete", { fg = "#2b3b55", bold = false })
    vim.api.nvim_set_hl(0, "DiffText", { bg = mycolors.yellow2, fg = "#000000", bold = false })
    -- vim.api.nvim_set_hl(0, "DiffChange", { bg = "#2b3b55", bold = true })
    vim.api.nvim_set_hl(0, "DiffAdd", { fg = "#ceeac8", bold = true })
    vim.api.nvim_set_hl(0, "diffAdded", { fg = "#ceeac8", bold = true })
    -- vim.api.nvim_set_hl(0, "DiffText", { bg = "#9eb0ce", fg = "#000000" })
    -- vim.api.nvim_set_hl(0, "Comment", { fg = "#384057" })
    vim.api.nvim_set_hl(0, "Comment", { fg = "#666666" })
    -- vim.api.nvim_set_hl(0, "@variable.builtin", { fg = "#89b4fa" })
    -- vim.api.nvim_set_hl(0, "@variable.builtin", {})
    -- vim.api.nvim_set_hl(0, "@variable.member", { fg = "#89b4fa" })
    -- vim.api.nvim_set_hl(0, "@property", { fg = mycolors.teal })
    -- vim.api.nvim_set_hl(0, "@variable", { fg = mycolors.teal })
    vim.api.nvim_set_hl(0, "@punctuation.bracket", {})
    vim.api.nvim_set_hl(0, "TelescopeTitle", { fg = "#f38ba8", bg = "none", bold = true })
    vim.api.nvim_set_hl(0, "TelescopePromptPrefix", { link = "Title" })
    vim.api.nvim_set_hl(0, "TelescopeSelectionCaret", { fg = "#ceeac8", bold = true })
    vim.api.nvim_set_hl(0, "TelescopeMatching", { fg = "#f38ba8", bold = true })
    vim.api.nvim_set_hl(0, "TelescopeSelection", { bg = "#253d61" })
    vim.api.nvim_set_hl(0, "@type", { fg = "#d9e0ee", bold = false })
    vim.api.nvim_set_hl(0, "Visual", { bg = "#253d61" })
    vim.api.nvim_set_hl(0, "LineNr", { fg = "#3A4057" })
    vim.api.nvim_set_hl(0, "Search", { bg = "#253d61" })
    vim.api.nvim_set_hl(0, "StatusLine", {})
    vim.api.nvim_set_hl(0, "StatusLine", {})
    vim.api.nvim_set_hl(0, "StatusLineNC", {})
    -- vim.api.nvim_set_hl(0, "StatusLine", { bg = "#313244", fg = mycolors.white })
    -- vim.api.nvim_set_hl(0, "StatusLine", { bg = "#25293c", fg = mycolors.white })
    -- vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "#313244", fg = "#8186a1" })
    vim.api.nvim_set_hl(0, "@variable.builtin", {})
    vim.api.nvim_set_hl(0, "NeoTreeNormal", {})
    vim.api.nvim_set_hl(0, "MatchParen", { fg = "#f38ba8", bg = "#161927", bold = true })
    vim.api.nvim_set_hl(0, "NeoTreeWinSeparator", { fg = "#1b192c" })
    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "cmpBorder", { fg = "#313244", bold = true })
    vim.api.nvim_set_hl(0, "FloatBorder", { link = "Comment", bold = true })
    vim.api.nvim_set_hl(0, "cmpDoc", {})
    vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn", { undercurl = true, bold = true })
    vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", { undercurl = true, bold = true })
    vim.api.nvim_set_hl(0, "DiagnosticUnderlineInfo", { undercurl = true, bold = true })
    vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint", { undercurl = true, bold = true })
    vim.api.nvim_set_hl(0, "DiagnosticVirtualTextWarn", { undercurl = true, bold = true, italic = true })
    vim.api.nvim_set_hl(0, "diffAdded", { fg = "#a6e3a1", bold = true })
    vim.api.nvim_set_hl(0, "diffRemoved", { fg = "#fa5057", bold = true })
    -- vim.api.nvim_set_hl(0, "EndOfBuffer", {})
    vim.api.nvim_set_hl(0, "Special", {})

    --- make it more black and white ----

    vim.api.nvim_set_hl(0, "String", { fg = "#92b997" })
    -- vim.api.nvim_set_hl(0, "String", { fg = "#d7d787" })

    -- yellow2 = "",
    vim.api.nvim_set_hl(0, "@punctuation.bracket", {})
    vim.api.nvim_set_hl(0, "@variable", {})
    vim.api.nvim_set_hl(0, "@property", {})
    vim.api.nvim_set_hl(0, "Operator", {})
    vim.api.nvim_set_hl(0, "Number", {})
    vim.api.nvim_set_hl(0, "@constant.builtin", {})
    -- vim.api.nvim_set_hl(0, "@type.builtin", {})
    vim.api.nvim_set_hl(0, "ModeMsg", {})
    vim.api.nvim_set_hl(0, "Constant", {})
    vim.api.nvim_set_hl(0, "Type", {})
    vim.api.nvim_set_hl(0, "@string.special.path.gitignore", {})
    vim.api.nvim_set_hl(0, "@variable.parameter", {})
    vim.api.nvim_set_hl(0, "@variable.member", {})
    vim.api.nvim_set_hl(0, "@parameter", {})
    vim.api.nvim_set_hl(0, "@module", {})
    vim.api.nvim_set_hl(0, "@markup.raw", {})
    vim.api.nvim_set_hl(0, "@constructor", {})
    vim.api.nvim_set_hl(0, "@string.documentation", {})
    vim.api.nvim_set_hl(0, "@nospell.markdown_inline", { fg = "#89b4fa" })
    vim.api.nvim_set_hl(0, "Boolean", { italic = false })
    vim.api.nvim_set_hl(0, "Repeat", { fg = mycolors.yellow2, bold = false, italic = false })
    vim.api.nvim_set_hl(0, "@keyword.function", { fg = mycolors.yellow2, italic = false, bold = false })
    vim.api.nvim_set_hl(0, "@keyword.return", { fg = mycolors.yellow2, bold = false })
    vim.api.nvim_set_hl(0, "Conditional", { fg = mycolors.yellow2, bold = false, italic = false })
    vim.api.nvim_set_hl(0, "Include", { fg = mycolors.yellow2, bold = true })
    vim.api.nvim_set_hl(0, "Keyword", { fg = mycolors.yellow2, bold = false })
    vim.api.nvim_set_hl(0, "@function.builtin", { fg = mycolors.yellow2 })
    vim.api.nvim_set_hl(0, "Exception", { fg = mycolors.yellow2 })
    vim.api.nvim_set_hl(0, "@label.markdown", { fg = "#2f3041" })
    vim.api.nvim_set_hl(0, "@property.yaml", { fg = mycolors.yellow2 })
    vim.api.nvim_set_hl(0, "@keyword.operator", { fg = mycolors.yellow2 })
    vim.api.nvim_set_hl(0, "@type.builtin", { fg = mycolors.yellow2 })
    vim.api.nvim_set_hl(0, "@string.yaml", {})
    vim.api.nvim_set_hl(0, "BlinkCmpMenuSelection", { link = "Visual" })
    vim.api.nvim_set_hl(0, "BlinkCmpScrollBarGutter", { bg = "none" })
    vim.api.nvim_set_hl(0, "PmenuSbar", { bg = "none" })
    vim.api.nvim_set_hl(0, "NeoTreeCursorLine", { link = "Visual" })
  end,
}
