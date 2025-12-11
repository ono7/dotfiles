return {
  'nanozuki/tabby.nvim',
  dependencies = 'nvim-tree/nvim-web-devicons',
  config = function()
    local palette = {
      bg = '#151F2D',        -- Normal guibg
      fg = '#BEBEBC',        -- Normal guifg
      active_bg = '#223E65', -- Visual guibg (Darker, subtle blue)
      active_fg = '#FFFFFF', -- White text for contrast
      accent = '#3A6FB0',    -- Search guibg (Used for the rabbit/icons)
    }

    local theme = {
      fill = { bg = palette.bg, fg = palette.fg },
      -- Head/Tail use the bright blue accent for icons only, not the whole tab
      head = { fg = palette.accent, bg = palette.bg, style = 'italic' },
      tail = { fg = palette.accent, bg = palette.bg, style = 'italic' },

      -- Active tab uses the darker Visual blue
      current_tab = { fg = palette.active_fg, bg = palette.active_bg, style = 'italic' },

      -- Inactive tabs blend into the background
      tab = { fg = palette.fg, bg = palette.bg, style = 'italic' },
      win = { fg = palette.fg, bg = palette.bg, style = 'italic' },
    }

    require('tabby.tabline').set(function(line)
      return {
        {
          { ' 🐇 ', hl = theme.head },
          line.sep('', theme.head, theme.fill),
        },
        line.tabs().foreach(function(tab)
          local hl = tab.is_current() and theme.current_tab or theme.tab

          local name = tab.name()
          local index = string.find(name, "%[%d")
          local tab_name = index and string.sub(name, 1, index - 1) or name

          local modified = false
          local win_ids = require('tabby.module.api').get_tab_wins(tab.id)
          for _, win_id in ipairs(win_ids) do
            local success, bufid = pcall(vim.api.nvim_win_get_buf, win_id)
            if success and vim.api.nvim_buf_get_option(bufid, "modified") then
              modified = true
              break
            end
          end

          return {
            line.sep('', hl, theme.fill),
            tab_name,
            modified and ' ',
            line.sep('', hl, theme.fill),
            hl = hl,
            margin = ' ',
          }
        end),
        line.spacer(),
        {
          line.sep('', theme.tail, theme.fill),
          { '  ', hl = theme.tail },
        },
        hl = theme.fill,
      }
    end)
  end,
}
