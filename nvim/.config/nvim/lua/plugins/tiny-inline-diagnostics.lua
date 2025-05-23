return {
  "rachartier/tiny-inline-diagnostic.nvim",
  event = "VeryLazy", -- Or `LspAttach`
  priority = 1000, -- needs to be loaded in first
  config = function()
    require("tiny-inline-diagnostic").setup({
      preset = "classic",
      transparent_bg = false, -- Set
      transparent_cursorline = true,
      hi = {
        error = "DiagnosticError", -- Highlight group for error messages
        warn = "DiagnosticWarn", -- Highlight group for warning messages
        info = "DiagnosticInfo", -- Highlight group for informational messages
        hint = "DiagnosticHint", -- Highlight group for hint or suggestion messages
        arrow = "NonText", -- Highlight group for diagnostic arrows

        -- Background color for diagnostics
        -- Can be a highlight group or a hexadecimal color (#RRGGBB)
        background = "LineNr",

        -- Color blending option for the diagnostic background
        -- Use "None" or a hexadecimal color (#RRGGBB) to blend with another color
        mixing_color = "None",
      },
      options = {
        -- Display the source of the diagnostic (e.g., basedpyright, vsserver, lua_ls etc.)
        show_source = {
          enabled = true,
          if_many = true,
        },
      },
    })

    -- disable virtual text for this plugin to work (jlima)
    vim.diagnostic.config({
      virtual_text = false,
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = "X",
          [vim.diagnostic.severity.WARN] = "!",
          [vim.diagnostic.severity.HINT] = "h",
          [vim.diagnostic.severity.INFO] = "i",
        },
      },
    })

    -- this should be handles with the option, but this works for now
    vim.api.nvim_set_hl(0, "TinyInlineDiagnosticVirtualTextBg", {})
    vim.api.nvim_set_hl(0, "TinyInlineDiagnosticVirtualTextArrow", {})
  end,
}
