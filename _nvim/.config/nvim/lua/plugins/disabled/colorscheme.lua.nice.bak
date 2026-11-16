return {
  "catppuccin/nvim",
  name = "catppuccin",
  lazy = false,
  priority = 1000,
  config = function()
    local mycolors = {
      white = "#E3DED7",
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
      -- Updated to match Alacritty colors exactly
      red = "#C49A9A", -- Muted dusty rose
      baby_pink = "#D5AFAF", -- Lighter dusty rose (from bright.red)
      pink = "#f5c2e7",
      line = "#383747", -- for lines like vertsplit
      green = "#8CBBAD", -- Soft sage green
      vibrant_green = "#A2CFBF", -- Lighter sage (from bright.green)
      nord_blue = "#8bc2f0",
      blue = "#8CA7BE", -- Muted steel blue
      yellow = "#D4B97E", -- Gentle amber
      yellow2 = "#E1CA97", -- Lighter amber (from bright.yellow)
      sun = "#ffe9b6",
      purple = "#B097B6", -- Soft lavender
      purple2 = "#C4AFC8", -- Lighter lavender (from bright.magenta)
      dark_purple = "#c7a0dc",
      teal = "#93B5B3", -- Muted teal
      orange = "#B6A58B", -- Soft muted tan/bronze (from indexed colors)
      cyan = "#93B5B3", -- Muted teal
      statusline_bg = "#232232",
      lightbg = "#2f2e3e",
      pmenu_bg = "#8CBBAD",
      folder_bg = "#8CA7BE",
      lavender = "#A6B0C3", -- Soft muted periwinkle (from indexed colors)
      -- Additional colors for diagnostics
      bg_dark = "#1D2433", -- Primary background from Alacritty
      selection = "#364156", -- Selection background from Alacritty
      cursor_line = "#2D3343", -- Slightly lighter than background
    }

    require("catppuccin").setup({
      transparent_background = true,
      show_end_of_buffer = false,
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
        mocha = mycolors,
      },
    })
    vim.api.nvim_command("colorscheme catppuccin-mocha")

    -- Original highlights
    vim.api.nvim_set_hl(0, "TreesitterContextBottom", { fg = "#b0a0ff", bold = true, italic = true })
    vim.api.nvim_set_hl(0, "@text.todo", { link = "ErrorMsg" })
    vim.api.nvim_set_hl(0, "OilFile", { link = "Normal" })
    vim.api.nvim_set_hl(0, "@text.danger", { link = "ErrorMsg" })
    vim.api.nvim_set_hl(0, "@text.note", { link = "Normal" })
    vim.api.nvim_set_hl(0, "Function", { link = "Normal" })
    vim.api.nvim_set_hl(0, "TreesitterContext", { bg = "#242438" })
    vim.api.nvim_set_hl(0, "@text.uri", { fg = "#8186a1", undercurl = true })
    vim.api.nvim_set_hl(0, "WinBar", { fg = "#8186a1" })
    vim.api.nvim_set_hl(0, "Folded", { fg = "#3E485A", italic = true })
    vim.api.nvim_set_hl(0, "WinBarNC", { fg = "#384057" })
    vim.api.nvim_set_hl(0, "DiffDelete", { fg = "#2b3b55", bold = false })
    vim.api.nvim_set_hl(0, "DiffText", { bg = mycolors.yellow2, fg = "#000000", bold = false })
    vim.api.nvim_set_hl(0, "DiffAdd", { fg = "#ceeac8", bold = true })
    vim.api.nvim_set_hl(0, "diffAdded", { fg = "#ceeac8", bold = true })
    vim.api.nvim_set_hl(0, "Comment", { fg = "#384057" })
    vim.api.nvim_set_hl(0, "@punctuation.bracket", {})
    vim.api.nvim_set_hl(0, "TelescopeTitle", { fg = mycolors.red, bg = "none", bold = true })
    vim.api.nvim_set_hl(0, "TelescopePromptPrefix", { link = "Title" })
    vim.api.nvim_set_hl(0, "TelescopeSelectionCaret", { fg = "#ceeac8", bold = true })
    vim.api.nvim_set_hl(0, "TelescopeMatching", { fg = mycolors.red, bold = true })
    vim.api.nvim_set_hl(0, "TelescopeSelection", { bg = "#253d61" })
    vim.api.nvim_set_hl(0, "@type", { fg = mycolors.blue, bold = true })
    vim.api.nvim_set_hl(0, "Visual", { bg = "#253d61" })
    vim.api.nvim_set_hl(0, "LineNr", { fg = "#3A4057" })
    vim.api.nvim_set_hl(0, "Search", { bg = "#253d61" })
    vim.api.nvim_set_hl(0, "StatusLine", {})
    vim.api.nvim_set_hl(0, "StatusLine", {})
    vim.api.nvim_set_hl(0, "StatusLineNC", {})
    vim.api.nvim_set_hl(0, "@variable.builtin", {})
    vim.api.nvim_set_hl(0, "NeoTreeNormal", {})
    vim.api.nvim_set_hl(0, "MatchParen", { fg = mycolors.red, bg = "#161927", bold = true })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#161927" })
    vim.api.nvim_set_hl(0, "NeoTreeWinSeparator", { fg = "#1b192c" })
    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "cmpBorder", { fg = "#313244", bold = true })
    vim.api.nvim_set_hl(0, "FloatBorder", { link = "Comment", bold = true })
    vim.api.nvim_set_hl(0, "DiagnosticUnnecessary", { fg = "#4e5574" })

    vim.api.nvim_set_hl(0, "cmpDoc", {})

    -- Enhanced Diagnostic highlights with dark background matching Alacritty
    -- Virtual text (inline diagnostic messages)
    vim.api.nvim_set_hl(0, "DiagnosticFloatingError", { fg = mycolors.red, bg = mycolors.bg_dark })
    vim.api.nvim_set_hl(0, "DiagnosticFloatingWarn", { fg = mycolors.yellow, bg = mycolors.bg_dark })
    vim.api.nvim_set_hl(0, "DiagnosticFloatingInfo", { fg = mycolors.blue, bg = mycolors.bg_dark })
    vim.api.nvim_set_hl(0, "DiagnosticFloatingHint", { fg = mycolors.lavender, bg = mycolors.bg_dark })
    -- vim.api.nvim_set_hl(0, "DiagnosticError", { fg = mycolors.red, bg = mycolors.bg_dark })
    -- vim.api.nvim_set_hl(0, "DiagnosticWarn", { fg = mycolors.yellow, bg = mycolors.bg_dark })
    -- vim.api.nvim_set_hl(0, "DiagnosticInfo", { fg = mycolors.blue, bg = mycolors.bg_dark })
    -- vim.api.nvim_set_hl(0, "DiagnosticHint", { fg = mycolors.lavender, bg = mycolors.bg_dark })

    -- Underlines for diagnostics
    vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", { undercurl = true, sp = mycolors.red })
    vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn", { undercurl = true, sp = mycolors.yellow })
    vim.api.nvim_set_hl(0, "DiagnosticUnderlineInfo", { undercurl = true, sp = mycolors.blue })
    vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint", { undercurl = true, sp = mycolors.lavender })

    -- Virtual text with dark background
    -- vim.api.nvim_set_hl(0, "DiagnosticVirtualTextError", { fg = mycolors.red, bg = mycolors.bg_dark, italic = true })
    -- vim.api.nvim_set_hl(0, "DiagnosticVirtualTextWarn", { fg = mycolors.yellow, bg = mycolors.bg_dark, italic = true })
    -- vim.api.nvim_set_hl(0, "DiagnosticVirtualTextInfo", { fg = mycolors.blue, bg = mycolors.bg_dark, italic = true })
    -- vim.api.nvim_set_hl(
    --   0,
    --   "DiagnosticVirtualTextHint",
    --   { fg = mycolors.lavender, bg = mycolors.bg_dark, italic = true }
    -- )
    --
    -- Floating window diagnostics
    -- vim.api.nvim_set_hl(0, "TinyDiagnosticFloatingError", { fg = mycolors.red, bg = mycolors.bg_dark })
    -- vim.api.nvim_set_hl(0, "TinyDiagnosticFloatingWarn", { fg = mycolors.yellow, bg = mycolors.bg_dark })
    -- vim.api.nvim_set_hl(0, "TinyDiagnosticFloatingInfo", { fg = mycolors.blue, bg = mycolors.bg_dark })
    -- vim.api.nvim_set_hl(0, "TinyDiagnosticFloatingHint", { fg = mycolors.lavender, bg = mycolors.bg_dark })
    -- vim.api.nvim_set_hl(0, "TinyInlineDiagnosticVirtualTextBg", { bg = mycolors.bg_dark })
    vim.api.nvim_set_hl(0, "DiagnosticError", { fg = mycolors.red, bg = mycolors.bg_dark })
    vim.api.nvim_set_hl(0, "DiagnosticWarn", { fg = mycolors.yellow, bg = mycolors.bg_dark })
    vim.api.nvim_set_hl(0, "DiagnosticInfo", { fg = mycolors.blue, bg = mycolors.bg_dark })
    vim.api.nvim_set_hl(0, "DiagnosticHint", { fg = mycolors.lavender, bg = mycolors.bg_dark })
    --
    -- Sign column diagnostics with dark background
    -- vim.api.nvim_set_hl(0, "DiagnosticSignError", { fg = mycolors.red, bg = mycolors.bg_dark })
    -- vim.api.nvim_set_hl(0, "DiagnosticSignWarn", { fg = mycolors.yellow, bg = mycolors.bg_dark })
    -- vim.api.nvim_set_hl(0, "DiagnosticSignInfo", { fg = mycolors.blue, bg = mycolors.bg_dark })
    -- vim.api.nvim_set_hl(0, "DiagnosticSignHint", { fg = mycolors.lavender, bg = mycolors.bg_dark })

    -- CursorLine for tini-diagnostics background (using Alacritty background)
    vim.api.nvim_set_hl(0, "CursorLine", { bg = mycolors.bg_dark })
    vim.api.nvim_set_hl(0, "CursorLineNr", {})

    -- NonText for diagnostic arrows in tini-diagnostics
    vim.api.nvim_set_hl(0, "NonText", { fg = "#3E485A" })

    -- Additional diagnostic-related highlights with dark background
    vim.api.nvim_set_hl(0, "ErrorMsg", { fg = mycolors.baby_pink, bold = true })
    vim.api.nvim_set_hl(0, "WarningMsg", { fg = mycolors.yellow2, bold = true })
    vim.api.nvim_set_hl(0, "Question", { fg = mycolors.lavender })
    vim.api.nvim_set_hl(0, "MoreMsg", {})

    -- LSP-specific highlights
    vim.api.nvim_set_hl(0, "LspDiagnosticsDefaultError", { link = "DiagnosticError" })
    vim.api.nvim_set_hl(0, "LspDiagnosticsDefaultWarning", { link = "DiagnosticWarn" })
    vim.api.nvim_set_hl(0, "LspDiagnosticsDefaultInformation", { link = "DiagnosticInfo" })
    vim.api.nvim_set_hl(0, "LspDiagnosticsDefaultHint", { link = "DiagnosticHint" })

    -- Rest of original highlights
    vim.api.nvim_set_hl(0, "diffAdded", { fg = "#8CBBAD", bold = true })
    vim.api.nvim_set_hl(0, "diffRemoved", { fg = "#fa5057", bold = true })
    vim.api.nvim_set_hl(0, "Special", {})
    vim.api.nvim_set_hl(0, "String", { fg = "#8CBBAD" })
    vim.api.nvim_set_hl(0, "@punctuation.bracket", {})
    vim.api.nvim_set_hl(0, "@variable", {})
    vim.api.nvim_set_hl(0, "@property", {})
    vim.api.nvim_set_hl(0, "Operator", {})
    vim.api.nvim_set_hl(0, "Number", {})
    vim.api.nvim_set_hl(0, "@constant.builtin", {})
    vim.api.nvim_set_hl(0, "ModeMsg", {})
    vim.api.nvim_set_hl(0, "Constant", {})
    vim.api.nvim_set_hl(0, "@string.special.path.gitignore", {})
    vim.api.nvim_set_hl(0, "@variable.parameter", {})
    vim.api.nvim_set_hl(0, "@variable.member", {})
    vim.api.nvim_set_hl(0, "@parameter", {})
    vim.api.nvim_set_hl(0, "@module", {})
    vim.api.nvim_set_hl(0, "@markup.raw", {})
    vim.api.nvim_set_hl(0, "@constructor", {})
    vim.api.nvim_set_hl(0, "@string.documentation", {})
    vim.api.nvim_set_hl(0, "@nospell.markdown_inline", { fg = mycolors.blue })
    vim.api.nvim_set_hl(0, "Boolean", {})
    vim.api.nvim_set_hl(0, "Repeat", { fg = mycolors.yellow2, bold = false })
    vim.api.nvim_set_hl(0, "@keyword.function", { fg = mycolors.yellow2, italic = true, bold = false })
    vim.api.nvim_set_hl(0, "@keyword.return", { fg = mycolors.yellow2, italic = true, bold = false })
    vim.api.nvim_set_hl(0, "Conditional", { fg = mycolors.yellow2, bold = false })
    vim.api.nvim_set_hl(0, "Include", { fg = mycolors.yellow2, bold = true })
    vim.api.nvim_set_hl(0, "Keyword", { fg = mycolors.yellow2, bold = false })
    vim.api.nvim_set_hl(0, "@function.builtin", { fg = mycolors.yellow2 })
    vim.api.nvim_set_hl(0, "Exception", { fg = mycolors.yellow2 })
    vim.api.nvim_set_hl(0, "@label.markdown", { fg = "#2f3041" })
    vim.api.nvim_set_hl(0, "@property.yaml", { fg = mycolors.yellow2 })
    vim.api.nvim_set_hl(0, "@keyword.operator", { fg = mycolors.yellow2 })
    vim.api.nvim_set_hl(0, "@type.builtin", { fg = mycolors.red })
    vim.api.nvim_set_hl(0, "@function.method", { italic = true })
    vim.api.nvim_set_hl(0, "@string.yaml", {})
    vim.api.nvim_set_hl(0, "BlinkCmpMenuSelection", { link = "Visual" })
    vim.api.nvim_set_hl(0, "BlinkCmpScrollBarGutter", { bg = "none" })
    vim.api.nvim_set_hl(0, "PmenuSbar", { bg = "none" })
    vim.api.nvim_set_hl(0, "NeoTreeCursorLine", { link = "Visual" })

    vim.api.nvim_set_hl(0, "Pmenu", { bg = "#2D3343", fg = "#C9C2B8" })
    vim.api.nvim_set_hl(0, "PmenuSel", { bg = "#8CBBAD", fg = "#1D2433", bold = true })
    vim.api.nvim_set_hl(0, "PmenuSbar", { bg = "#3E485A" })
    vim.api.nvim_set_hl(0, "PmenuThumb", { bg = "#8087a2" })
  end,
}
