return {
  "nanozuki/tabby.nvim",
  dependencies = "nvim-tree/nvim-web-devicons",
  config = function()
    vim.o.showtabline = 2
    vim.opt.switchbuf = "usetab,uselast"

    local palette = {
      fill_bg = "#F2EFE9",
      active_bg = "#D5CFC4",
      active_fg = "#000000",
      inactive_bg = "#E6E2DA",
      inactive_fg = "#5C6A7B",
      accent = "#3B6EA8",
      modified = "#C4434B",
    }

    local theme = {
      fill = { bg = palette.fill_bg, fg = palette.inactive_fg },
      head = { fg = palette.accent, bg = palette.fill_bg },
      tail = { fg = palette.accent, bg = palette.fill_bg },
      current_tab = { fg = palette.active_fg, bg = palette.active_bg, bold = true },
      tab = { fg = palette.inactive_fg, bg = palette.inactive_bg },
    }

    local function get_tab_label(tab_id)
      local current_win = tab_id.current_win()
      local bufid = current_win.buf().id
      local bufname = vim.api.nvim_buf_get_name(bufid)

      if bufname == "" then
        return "[No Name]"
      end

      local filename = vim.fn.fnamemodify(bufname, ":t")
      local parent = vim.fn.fnamemodify(bufname, ":p:h:t")

      if parent == "" or parent == "." then
        return filename
      end

      return parent .. "/" .. filename
    end

    -- NOTE(jlima): Slices the tab collection to fit a sliding viewport around the active tab.
    local function get_visible_tabs(all_tabs, max_visible)
      local total = #all_tabs
      if total <= max_visible then
        return all_tabs, false, false
      end

      local current_idx = 1
      for i, tab in ipairs(all_tabs) do
        if tab.is_current() then
          current_idx = i
          break
        end
      end

      local half = math.floor(max_visible / 2)
      local start_idx = math.max(1, current_idx - half)
      local end_idx = start_idx + max_visible - 1

      if end_idx > total then
        end_idx = total
        start_idx = math.max(1, end_idx - max_visible + 1)
      end

      local visible = {}
      for i = start_idx, end_idx do
        table.insert(visible, all_tabs[i])
      end

      return visible, start_idx > 1, end_idx < total
    end

    require("tabby.tabline").set(function(line)
      local all_tabs = line.tabs().tabs
      -- NOTE(jlima): Adjust max_tabs based on average tab character length vs standard columns.
      local visible_tabs, has_left, has_right = get_visible_tabs(all_tabs, 5)

      local tab_elements = {}

      if has_left then
        table.insert(tab_elements, {
          line.sep("", theme.tab, theme.fill),
          "  ",
          line.sep("", theme.tab, theme.fill),
          hl = theme.tab,
        })
      end

      for _, tab in ipairs(visible_tabs) do
        local is_current = tab.is_current()
        local hl = is_current and theme.current_tab or theme.tab
        local tab_name = get_tab_label(tab)

        local modified = false
        local win_ids = require("tabby.module.api").get_tab_wins(tab.id)
        for _, win_id in ipairs(win_ids) do
          local success, bufid = pcall(vim.api.nvim_win_get_buf, win_id)
          if success and vim.bo[bufid].modified then
            modified = true
            break
          end
        end

        table.insert(tab_elements, {
          line.sep("", hl, theme.fill),
          tab_name,
          modified and { " ", fg = palette.modified } or "",
          line.sep("", hl, theme.fill),
          hl = hl,
          margin = "",
        })
      end

      if has_right then
        table.insert(tab_elements, {
          line.sep("", theme.tab, theme.fill),
          "  ",
          line.sep("", theme.tab, theme.fill),
          hl = theme.tab,
        })
      end

      return {
        {
          { "🐇", hl = theme.head },
          line.sep("", theme.head, theme.fill),
        },
        tab_elements,
        line.spacer(),
        {
          line.sep("", theme.tail, theme.fill),
          { "", hl = theme.tail },
        },
        hl = theme.fill,
      }
    end)
  end,
}
