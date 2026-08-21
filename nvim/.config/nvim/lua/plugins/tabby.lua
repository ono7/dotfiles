return {
  "nanozuki/tabby.nvim",
  dependencies = "nvim-tree/nvim-web-devicons",
  config = function()
    -- Harmonized with custom-slate theme
    local palette = {
      fill_bg = "#131720", -- Editor base background
      active_bg = "#222D3E", -- Selection/Visual pill background
      active_fg = "#D2D6DC", -- Warm ivory text
      inactive_bg = "#19202C", -- Floating/Subtle surface
      inactive_fg = "#5C6A7B", -- Soft slate for inactive tabs
      accent = "#89D0D8", -- Calm cyan/teal for icons
      modified = "#E06C75", -- Coral red dot for unsaved changes
    }

    local theme = {
      fill = { bg = palette.fill_bg, fg = palette.inactive_fg },
      head = { fg = palette.accent, bg = palette.fill_bg },
      tail = { fg = palette.accent, bg = palette.fill_bg },
      current_tab = { fg = palette.active_fg, bg = palette.active_bg, bold = true },
      tab = { fg = palette.inactive_fg, bg = palette.inactive_bg },
    }

    require("tabby.tabline").set(function(line)
      return {
        {
          { " 🐇 ", hl = theme.head },
          line.sep("", theme.head, theme.fill),
        },
        line.tabs().foreach(function(tab)
          local is_current = tab.is_current()
          local hl = is_current and theme.current_tab or theme.tab

          local name = tab.name()
          local index = string.find(name, "%[%d")
          local tab_name = index and string.sub(name, 1, index - 1) or name

          local modified = false
          local win_ids = require("tabby.module.api").get_tab_wins(tab.id)
          for _, win_id in ipairs(win_ids) do
            local success, bufid = pcall(vim.api.nvim_win_get_buf, win_id)
            if success and vim.bo[bufid].modified then
              modified = true
              break
            end
          end

          return {
            line.sep("", hl, theme.fill),
            tab_name,
            modified and { " ", fg = palette.modified } or "",
            line.sep("", hl, theme.fill),
            hl = hl,
            margin = " ",
          }
        end),
        line.spacer(),
        {
          line.sep("", theme.tail, theme.fill),
          { "  ", hl = theme.tail },
        },
        hl = theme.fill,
      }
    end)
  end,
}
