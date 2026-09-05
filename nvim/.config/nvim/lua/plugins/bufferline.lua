return {
  "akinsho/bufferline.nvim",
  version = "*",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    vim.o.showtabline = 2

    local palette = {
      fill_bg = "#F2EFE9",
      active_bg = "#D5CFC4",
      active_fg = "#000000",
      inactive_bg = "#E6E2DA",
      inactive_fg = "#5C6A7B",
      accent = "#3B6EA8",
      modified = "#C4434B",
    }

    require("bufferline").setup({
      options = {
        mode = "buffers",
        style_preset = require("bufferline").style_preset.no_italic,
        separator_style = "slant",
        always_show_bufferline = true,
        show_buffer_close_icons = false,
        sort_by = "relative_directory",
        show_close_icon = false,
        show_tab_indicators = false,
        numbers = "none",
        left_trunc_marker = "",
        right_trunc_marker = "",
        max_name_length = 40,
        truncate_names = true,
        diagnostics = false,
        name_formatter = function(buf)
          if buf.path == "" then
            return "[No Name]"
          end

          local filename = vim.fn.fnamemodify(buf.path, ":t")
          local parent = vim.fn.fnamemodify(buf.path, ":p:h:t")

          if parent == "" or parent == "." then
            return filename
          end

          return parent .. "/" .. filename
        end,
        modified_icon = "",
        indicator = {
          style = "none",
        },
      },
      highlights = {
        fill = {
          bg = palette.fill_bg,
        },
        background = {
          fg = palette.inactive_fg,
          bg = palette.inactive_bg,
        },
        buffer_selected = {
          fg = palette.active_fg,
          bg = palette.active_bg,
          bold = true,
        },
        buffer_visible = {
          fg = palette.inactive_fg,
          bg = palette.inactive_bg,
        },
        separator = {
          fg = palette.fill_bg,
          bg = palette.inactive_bg,
        },
        separator_selected = {
          fg = palette.fill_bg,
          bg = palette.active_bg,
        },
        separator_visible = {
          fg = palette.fill_bg,
          bg = palette.inactive_bg,
        },
        tab = {
          fg = palette.inactive_fg,
          bg = palette.fill_bg,
        },
        tab_selected = {
          fg = palette.active_fg,
          bg = palette.fill_bg,
          bold = true,
        },
        tab_separator = {
          fg = palette.fill_bg,
          bg = palette.fill_bg,
        },
        tab_separator_selected = {
          fg = palette.fill_bg,
          bg = palette.fill_bg,
        },
        tab_close = {
          fg = palette.inactive_fg,
          bg = palette.fill_bg,
        },
        offset_separator = {
          fg = palette.fill_bg,
          bg = palette.fill_bg,
        },
        modified = {
          fg = palette.modified,
          bg = palette.inactive_bg,
        },
        modified_selected = {
          fg = palette.modified,
          bg = palette.active_bg,
          bold = true,
        },
        modified_visible = {
          fg = palette.modified,
          bg = palette.inactive_bg,
        },
        pick = {
          fg = palette.accent,
          bg = palette.inactive_bg,
          bold = true,
        },
        pick_selected = {
          fg = palette.accent,
          bg = palette.active_bg,
          bold = true,
        },
        pick_visible = {
          fg = palette.accent,
          bg = palette.inactive_bg,
          bold = true,
        },
      },
    })

    local map = vim.keymap.set
    local opts = { silent = true }

    -- map("n", "<Tab>", "<Cmd>BufferLineCycleNext<CR>", opts)
    -- map("n", "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", opts)
    map("n", "<c-]>", "<Cmd>BufferLineCycleNext<CR>", opts)
    map("n", "<c-[>", "<Cmd>BufferLineCyclePrev<CR>", opts)
    map("n", "<A->>", "<Cmd>BufferLineMoveNext<CR>", opts)
    map("n", "<A-<>", "<Cmd>BufferLineMovePrev<CR>", opts)
    map("n", "<leader>bp", "<Cmd>BufferLinePick<CR>", opts)
    map("n", "<leader>c", "<Cmd>bdelete<CR>", opts)
    map("n", "<leader>bc", "<Cmd>BufferLineCloseOthers<CR>", opts)
  end,
}
