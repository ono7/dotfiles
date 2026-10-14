return {
  "rachartier/tiny-inline-diagnostic.nvim",
  event = "VeryLazy",
  priority = 1000,
  config = function()
    require("tiny-inline-diagnostic").setup({
      preset = "classic",
      transparent_bg = true,
      enable_on_insert = false,
      transparent_cursorline = true,
      hi = {
        error = "DiagnosticError",
        warn = "DiagnosticWarn",
        info = "DiagnosticInfo",
        hint = "DiagnosticHint",
        arrow = "DiffAdd",
        background = "LineNr",
        mixing_color = "None",
      },
      options = {
        -- NOTE(jlima): Placed inside options table so it actually applies
        throttle = 250,
        softwrap = false,
        multilines = {
          enabled = false,
        },
        show_all_diags_on_cursorline = false,
        show_source = {
          enabled = true,
          if_many = false,
        },
      },
    })

    -- Disable standard virtual text to prevent dual-render overhead
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
  end,
}
