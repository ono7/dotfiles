return {
  "rachartier/tiny-inline-diagnostic.nvim",
  event = "VeryLazy", -- Or `LspAttach`
  priority = 1000,    -- needs to be loaded in first
  config = function()
    require("tiny-inline-diagnostic").setup({
      preset = "classic",
      transparent_bg = true, -- Set
      transparent_cursorline = true,
      throttle = 100,
      hi = {

        -- this is the gutter
        error = "DiagnosticError",
        warn = "DiagnosticWarn",
        info = "DiagnosticInfo",
        hint = "DiagnosticHint",
        arrow = "DiffAdd",

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
      update_in_insert = false,
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = "•",
          [vim.diagnostic.severity.WARN] = "•",
          [vim.diagnostic.severity.HINT] = "•",
          [vim.diagnostic.severity.INFO] = "•",
        },
      },
    })

    -- this should be handles with the option, but this works for now
    -- vim.api.nvim_set_hl(0, "TinyInlineDiagnosticVirtualTextBg", { bg = "#1d2433" })
    -- vim.api.nvim_set_hl(0, "TinyInlineDiagnosticVirtualTextArrow", {})
  end,
}
