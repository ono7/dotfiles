return {
  "rachartier/tiny-inline-diagnostic.nvim",
  event = "VeryLazy", -- Or `LspAttach`
  priority = 1000, -- needs to be loaded in first
  config = function()
    require("tiny-inline-diagnostic").setup({
      preset = "classic",
      transparent_bg = true, -- Set
      hi = {
        error = "DiagnosticError", -- Highlight group for error messages
        warn = "DiagnosticWarn", -- Highlight group for warning messages
        info = "DiagnosticInfo", -- Highlight group for informational messages
        hint = "DiagnosticHint", -- Highlight group for hint or suggestion messages
        arrow = "NonText", -- Highlight group for diagnostic arrows

        -- Background color for diagnostics
        -- Can be a highlight group or a hexadecimal color (#RRGGBB)
        background = "CursorLine",

        -- Color blending option for the diagnostic background
        -- Use "None" or a hexadecimal color (#RRGGBB) to blend with another color
        mixing_color = "None",
      },
    })
    vim.diagnostic.config({ virtual_text = false }) -- Only if needed in your configuration, if you already have native LSP diagnostics
    vim.api.nvim_set_hl(0, "TinyInlineDiagnosticVirtualTextBg", {})
    vim.api.nvim_set_hl(0, "TinyInlineDiagnosticVirtualTextArrow", {})
  end,
}
