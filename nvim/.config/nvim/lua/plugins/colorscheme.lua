return {
  "catppuccin/nvim",
  name = "catppuccin",
  lazy = false,
  priority = 1000,
  config = function()
    require("catppuccin").setup({
      transparent_background = true,
      show_end_of_buffer = false, -- show the '~' characters after the end of buffers
      term_colors = true,
      dim_inactive = {
        enabled = false,
        shade = "dark",
        percentage = 0.15,
      },
      -- no_italic = true, -- Force no italic
      -- no_bold = false, -- Force no bold
      styles = {
        comments = {},
        conditionals = { "italic" },
        loops = { "italic" },
        functions = {},
        keywords = {},
        strings = {},
        variables = {},
        numbers = {},
        booleans = { "italic" },
        parameters = {},
        properties = {},
        types = {},
        operators = {},
      },
    })
    vim.api.nvim_command("colorscheme catppuccin-mocha")

    vim.api.nvim_set_hl(0, "Folded", { link = "Comment" })
    vim.api.nvim_set_hl(0, "TreesitterContextBottom", { fg = "#B0A0FF", bold = true, italic = true })
    vim.api.nvim_set_hl(0, "String", { fg = "#a6e3a1" })
    vim.api.nvim_set_hl(0, "@text.todo", { link = "ErrorMsg" })
    vim.api.nvim_set_hl(0, "@text.danger", { link = "ErrorMsg" })
    vim.api.nvim_set_hl(0, "@text.note", { link = "Normal" })
    vim.api.nvim_set_hl(0, "Function", { link = "Normal" })
    vim.api.nvim_set_hl(0, "TreesitterContext", { bg = "#242438" })
    vim.api.nvim_set_hl(0, "Comment", { fg = "#45475a" })
    vim.api.nvim_set_hl(0, "@text.uri", { fg = "#8186a1", undercurl = true })
    vim.api.nvim_set_hl(0, "DiffDelete", { fg = "#2b3b55", bold = true })
    vim.api.nvim_set_hl(0, "DiffChange", { bg = "#2b3b55", bold = true })
    vim.api.nvim_set_hl(0, "DiffAdd", { fg = "#ceeac8", bold = true })
    vim.api.nvim_set_hl(0, "diffAdded", { fg = "#ceeac8", bold = true })
    vim.api.nvim_set_hl(0, "DiffText", { bg = "#9eb0ce", fg = "#000000" })
    vim.api.nvim_set_hl(0, "@variable.builtin", { fg = "#8bc2f0" })
    vim.api.nvim_set_hl(0, "@string.special.path.gitignore", {})
    vim.api.nvim_set_hl(0, "@variable.parameter", { fg = "#f2cdcd" })
    vim.api.nvim_set_hl(0, "@property", { fg = "#f38ba8" })
    vim.api.nvim_set_hl(0, "TelescopeTitle", { fg = "#f38ba8", bold = true })
    vim.api.nvim_set_hl(0, "Repeat", { fg = "#f38ba8", italic = true })
    vim.api.nvim_set_hl(0, "Conditional", { fg = "#f38ba8", italic = true })
    vim.api.nvim_set_hl(0, "@variable", { fg = "#c7d1ff" })
    vim.api.nvim_set_hl(0, "@type", { fg = "#D9E0EE", bold = false })
    vim.api.nvim_set_hl(0, "@type.builtin", { fg = "#D9E0EE" })
    vim.api.nvim_set_hl(0, "Visual", { bg = "#2f5293" })
    vim.api.nvim_set_hl(0, "Search", { bg = "#2f5293" })
    vim.api.nvim_set_hl(0, "StatusLine", { bg = "#444d69" })
    vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "#000000", fg = "#8186a1" })
    vim.api.nvim_set_hl(0, "@keyword.function", { fg = "#f38ba8", italic = true })
    vim.api.nvim_set_hl(0, "@punctuation.bracket", { fg = "#f38ba8" })
    vim.api.nvim_set_hl(0, "@property", {})
    vim.api.nvim_set_hl(0, "NeoTreeNormal", {})
    vim.api.nvim_set_hl(0, "MatchParen", { fg = "#fab387", bold = true })
    vim.api.nvim_set_hl(0, "NeoTreeWinSeparator", { fg = "#1B192C" })
    vim.api.nvim_set_hl(0, "NormalFloat", { link = "Comment" })
    vim.api.nvim_set_hl(0, "cmpBorder", { fg = "#2b2c36" })
    vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#474a59" })
    vim.api.nvim_set_hl(0, "cmpDoc", { bg = "#1B192C" })
    vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn", { underline = false })
    vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", { underline = false })
    vim.api.nvim_set_hl(0, "DiagnosticUnderlineInfo", { underline = false })
    vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint", { underline = false })
    -- TODO: fix this diagnostics text to be like the original
    -- vim.api.nvim_set_hl(0, "DiagnosticVirtualTextError", { link = "Error" })
    vim.api.nvim_set_hl(0, "diffAdded", { fg = "#50FA7B", bold = true })
    vim.api.nvim_set_hl(0, "diffRemoved", { fg = "#FA5057", bold = true })
  end,
}
