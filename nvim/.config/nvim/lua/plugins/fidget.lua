return {
  "j-hui/fidget.nvim",
  config = function()
    -- Base transparent window highlight
    vim.api.nvim_set_hl(0, "FidgetWindow", { bg = "NONE" })

    -- Clean, background-free icon & text highlights
    local diag_ok = vim.api.nvim_get_hl(0, { name = "DiagnosticOk", link = false })
    local diag_info = vim.api.nvim_get_hl(0, { name = "DiagnosticInfo", link = false })
    local diag_warn = vim.api.nvim_get_hl(0, { name = "DiagnosticWarn", link = false })
    local special = vim.api.nvim_get_hl(0, { name = "Special", link = false })

    vim.api.nvim_set_hl(0, "FidgetDone", { fg = diag_ok.fg or "#a6e3a1", bg = "NONE", bold = true })
    vim.api.nvim_set_hl(0, "FidgetProgress", { fg = special.fg or "#89b4fa", bg = "NONE" })
    vim.api.nvim_set_hl(0, "FidgetIcon", { fg = diag_info.fg or "#89dceb", bg = "NONE" })
    vim.api.nvim_set_hl(0, "FidgetTitle", { fg = diag_warn.fg or "#f9e2af", bg = "NONE", bold = true })
    vim.api.nvim_set_hl(0, "FidgetSubtext", { link = "Comment" })

    require("fidget").setup({
      --==============================
      --  LSP Progress Subsystem
      --==============================
      progress = {
        poll_rate = 16,
        suppress_on_insert = false,
        ignore_done_already = true, -- Skip subtasks that finished instantly
        ignore_empty_message = true, -- Drop LSP tokens with no status payload

        clear_on_detach = function(client_id)
          local client = vim.lsp.get_client_by_id(client_id)
          return client and client.name or nil
        end,

        notification_group = function(msg)
          return msg.lsp_client.name
        end,

        -- Ignore Pyright progress tokens entirely (other LSPs like gopls or rust-analyzer will still show)
        ignore = { "pyright" },

        display = {
          render_limit = 5,
          done_ttl = 0.5, -- Dismiss completed items after 0.5s instead of 3s
          done_icon = "󰄬 ",
          done_style = "FidgetDone",

          progress_ttl = math.huge,
          progress_icon = { pattern = "dots_snake", period = 1 },

          progress_style = "FidgetProgress",
          group_style = "FidgetTitle",
          icon_style = "FidgetIcon",

          priority = 30,
          skip_history = true,

          format_message = function(msg)
            if not msg.message and msg.done then
              return nil
            end
            local message = msg.message or "In progress..."
            if msg.percentage then
              message = string.format("(%d%%) %s", msg.percentage, message)
            end
            return message
          end,

          format_annote = function(msg)
            return msg.title
          end,

          format_group_name = function(group)
            return string.format("󰒋 %s", tostring(group))
          end,

          overrides = {
            rust_analyzer = { name = "rust-analyzer" },
            clangd = { name = "clangd" },
            gopls = { name = "gopls" },
          },
        },

        lsp = {
          progress_ringbuf_size = 0,
          log_handler = false,
        },
      },

      --==============================
      --  Notification Subsystem
      --==============================
      notification = {
        poll_rate = 10,
        filter = vim.log.levels.INFO,
        history_size = 128,
        override_vim_notify = true,

        configs = {
          default = {
            name = "Notifications",
            icon = "󰍡 ",
            ttl = 4,
            group_style = "FidgetTitle",
            icon_style = "FidgetIcon",
            annote_style = "FidgetSubtext",
            debug_style = "FidgetSubtext",
            info_style = "FidgetIcon",
            warn_style = "DiagnosticWarn",
            error_style = "DiagnosticError",
          },
        },

        view = {
          stack_upwards = true,
          icon_separator = "  ",
          group_separator = " · ",
          group_separator_hl = "FidgetSubtext",
          reflow = true,
          align = "message",
        },

        window = {
          normal_hl = "FidgetWindow",
          winblend = 0, -- Set to 0 so Neovide does not apply composite tinting
          border = "none",
          zindex = 45,
          max_width = 50,
          max_height = 0,
          x_padding = 2,
          y_padding = 1,
          align = "bottom",
          relative = "editor",
        },
      },
    })
  end,
}
