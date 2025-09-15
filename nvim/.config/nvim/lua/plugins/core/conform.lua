return {
  "stevearc/conform.nvim",
  opts = {},
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local conform = require("conform")
    conform.setup({
      log_level = vim.log.levels.ERROR,
      notify_on_error = true,
      notify_no_formatters = true,
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "isort", "black" },
        yaml = { "prettier" },
        ["yaml.ansible"] = { "ansible-lint" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        css = { "prettier" },
        scss = { "prettier" },
        html = { "prettier" },
        json = { "prettier" },
        markdown = { "prettier" },
        go = { "goimports", "goimports-reviser" },
        -- graphql = { "prettier", stop_after_first = true },
      },
      formatters = {
        shfmt = {
          prepend_args = { "-i", "2" },
        },
      },
      -- organize imports
      -- format_on_save = function(bufnr)
      --   if vim.bo.filetype == "python" then
      --     _ = bufnr
      --     vim.lsp.buf.code_action({
      --       context = {
      --         only = { "source.organizeImports.ruff" },
      --         diagnostics = {},
      --       },
      --       apply = true,
      --     })
      --   end
      -- end,
      format_after_save = function(bufnr)
        -- disable with a global or buffer-local variable
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end
        return { timeout_ms = 5000, lsp_format = "fallback" }
      end,
    })
    -- vim.keymap.set({ "n", "v" }, "<leader>mp", function()
    --   conform.format({
    --     lsp_fallback = true,
    --     async = false,
    --     timeout = 1000,
    --   })
    -- end)
    vim.api.nvim_create_user_command("FormatDisable", function(args)
      if args.bang then
        -- FormatDisable! will disable formatting just for this buffer
        vim.b.disable_autoformat = true
      else
        vim.g.disable_autoformat = true
        vim.notify("Conform: FormatDisabled")
      end
    end, {
      desc = "Disable autoformat-on-save",
      bang = true,
    })

    vim.api.nvim_create_user_command("FormatEnable", function()
      vim.b.disable_autoformat = false
      vim.g.disable_autoformat = false
    end, {
      desc = "Re-enable autoformat-on-save",
    })

    vim.api.nvim_create_user_command("Format", function(args)
      local range = nil
      if args.count ~= -1 then
        local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
        range = {
          start = { args.line1, 0 },
          ["end"] = { args.line2, end_line:len() },
        }
      end
      require("conform").format({ async = true, lsp_format = "fallback", range = range })
    end, { range = true })
  end,
}
