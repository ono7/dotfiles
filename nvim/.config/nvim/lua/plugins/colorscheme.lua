return {
  "catppuccin/nvim",
  name = "catppuccin",
  lazy = false,
  priority = 1000,
  config = function()
    local mycolors = {
      red = "#f38ba8",
      baby_pink = "#ffa5c3",
      pink = "#F5C2E7",
      line = "#383747", -- for lines like vertsplit
      vibrant_green = "#b6f4be",
      nord_blue = "#8bc2f0",
      blue = "#89b4fa",
      yellow = "#f9e2af",
      sun = "#f9e2af",
      orange = "#F8BD96",
      teal = "#89dceb",
      cyan = "#89dceb",
      statusline_bg = "#232232",
      lightbg = "#2f2e3e",
      green = "#ceeac8",
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
    vim.api.nvim_set_hl(0, "TreesitterContextBottom", { fg = "#B0A0FF", bold = true, italic = true })
    vim.api.nvim_set_hl(0, "@text.todo", { link = "ErrorMsg" })
    vim.api.nvim_set_hl(0, "OilFile", { link = "Normal" })
    vim.api.nvim_set_hl(0, "@text.danger", { link = "ErrorMsg" })
    vim.api.nvim_set_hl(0, "@text.note", { link = "Normal" })
    vim.api.nvim_set_hl(0, "Function", { link = "Normal" })
    vim.api.nvim_set_hl(0, "TreesitterContext", { bg = "#242438" })
    -- vim.api.nvim_set_hl(0, "Comment", { fg = "#45475a" })
    vim.api.nvim_set_hl(0, "@text.uri", { fg = "#8186a1", undercurl = true })
    vim.api.nvim_set_hl(0, "DiffDelete", { fg = "#2b3b55", bold = true })
    vim.api.nvim_set_hl(0, "DiffChange", { bg = "#2b3b55", bold = true })
    vim.api.nvim_set_hl(0, "DiffAdd", { fg = "#ceeac8", bold = true })
    vim.api.nvim_set_hl(0, "diffAdded", { fg = "#ceeac8", bold = true })
    vim.api.nvim_set_hl(0, "DiffText", { bg = "#9eb0ce", fg = "#000000" })
    -- vim.api.nvim_set_hl(0, "@variable.builtin", { fg = "#89b4fa" })
    vim.api.nvim_set_hl(0, "@variable.builtin", {})
    vim.api.nvim_set_hl(0, "@constant.builtin", {})
    vim.api.nvim_set_hl(0, "@string.special.path.gitignore", {})
    vim.api.nvim_set_hl(0, "@variable.parameter", { fg = "#f2cdcd" })
    -- vim.api.nvim_set_hl(0, "@variable.member", { fg = "#89b4fa" })
    vim.api.nvim_set_hl(0, "@variable.member", {})
    vim.api.nvim_set_hl(0, "@property", { fg = "#f38ba8" })
    vim.api.nvim_set_hl(0, "TelescopeTitle", { fg = "#f38ba8", bold = true })
    vim.api.nvim_set_hl(0, "TelescopePromptPrefix", { link = "Title" })
    vim.api.nvim_set_hl(0, "TelescopeSelectionCaret", { fg = "#ceeac8", bold = true })
    vim.api.nvim_set_hl(0, "TelescopeMatching", { fg = "#f38ba8", bold = true })
    vim.api.nvim_set_hl(0, "TelescopeSelection", { bg = "#243d61" })
    vim.api.nvim_set_hl(0, "Repeat", { fg = "#f38ba8", italic = true })
    vim.api.nvim_set_hl(0, "Conditional", { fg = "#f38ba8", italic = true })
    vim.api.nvim_set_hl(0, "@variable", {})
    vim.api.nvim_set_hl(0, "@type", { fg = "#D9E0EE", bold = false })
    vim.api.nvim_set_hl(0, "@type.builtin", { fg = "#D9E0EE" })
    vim.api.nvim_set_hl(0, "Visual", { bg = "#243d61" })
    vim.api.nvim_set_hl(0, "Search", { bg = "#243d61" })
    -- vim.api.nvim_set_hl(0, "Visual", { bg = "#2f5293" })
    -- vim.api.nvim_set_hl(0, "Search", { bg = "#2f5293" })
    vim.api.nvim_set_hl(0, "StatusLine", { bg = "#444d69" })
    vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "#313244", fg = "#8186a1" })
    vim.api.nvim_set_hl(0, "@keyword.function", { fg = "#f38ba8", italic = true })
    vim.api.nvim_set_hl(0, "@function.builtin", { italic = true })
    vim.api.nvim_set_hl(0, "@punctuation.bracket", { fg = "#f38ba8" })
    vim.api.nvim_set_hl(0, "@property", {})
    vim.api.nvim_set_hl(0, "NeoTreeNormal", {})
    vim.api.nvim_set_hl(0, "MatchParen", { fg = "#f9e2af", bold = true })
    vim.api.nvim_set_hl(0, "NeoTreeWinSeparator", { fg = "#1B192C" })
    vim.api.nvim_set_hl(0, "NormalFloat", {})
    vim.api.nvim_set_hl(0, "cmpBorder", { fg = "#313244", bold = true })
    vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#313244", bold = true })
    vim.api.nvim_set_hl(0, "cmpDoc", {})
    -- vim.api.nvim_set_hl(0, "@spell.markdown", { link = "Normal" })
    vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn", { underline = false, bold = false })
    vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", { underline = false, bold = false })
    vim.api.nvim_set_hl(0, "DiagnosticUnderlineInfo", { underline = false, bold = false })
    vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint", { underline = false, bold = false })
    vim.api.nvim_set_hl(0, "DiagnosticVirtualTextWarn", { underline = false, bold = false, italic = true })
    -- vim.api.nvim_set_hl(
    --   0,
    --   "DiagnosticVirtualTextError",
    --   { fg = "#f38ba9", bg = "#351f25", underline = false, bold = false, italic = true }
    -- )

    -- vim.api.nvim_set_hl(0, "DiagnosticVirtualTextInfo", { underline = false, bold = false, italic = true })
    -- vim.api.nvim_set_hl(0, "DiagnosticVirtualTextHint", { underline = false, bold = false, italic = true })

    -- DiagnosticVirtualTextError xxx cterm=italic gui=italic guifg=#f38ba9
    -- DiagnosticVirtualTextWarn xxx cterm=italic gui=italic guifg=#f9e2b0
    -- DiagnosticVirtualTextInfo xxx cterm=italic gui=italic guifg=#89dcec
    -- DiagnosticVirtualTextHint xxx cterm=italic gui=italic guifg=#89dcec
    -- DiagnosticVirtualTextOk xxx cterm=italic gui=italic guifg=#ceeac9
    -- TinyInlineDiagnosticVirtualTextError xxx cterm=italic gui=italic guifg=#f38ba9 guibg=#351f25
    -- TinyInlineDiagnosticVirtualTextWarn xxx cterm=italic gui=italic guifg=#f9e2b0 guibg=#373227
    -- TinyInlineDiagnosticVirtualTextInfo xxx cterm=italic gui=italic guifg=#89dcec guibg=#1e3034
    vim.api.nvim_set_hl(0, "diffAdded", { fg = "#a6e3a1", bold = true })
    vim.api.nvim_set_hl(0, "diffRemoved", { fg = "#FA5057", bold = true })
    vim.api.nvim_set_hl(0, "Keyword", { fg = "#cba6f8" })
    vim.api.nvim_set_hl(0, "Special", {})
  end,
}
