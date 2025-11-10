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
        -- python = { "isort", "black" },
        python = function(bufnr)
          if require("conform").get_formatter_info("ruff_format", bufnr).available then
            return { "isort", "ruff_fix", "ruff_format" }
          else
            return { "isort", "black" }
          end
        end,
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
      },
      formatters = {
        shfmt = {
          prepend_args = { "-i", "2" },
        },
      },
      format_after_save = function(bufnr)
        -- disable with a global or buffer-local variable
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end
        return { timeout_ms = 1000, lsp_format = "fallback" }
      end,
    })
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
