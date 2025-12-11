return {
  'nanozuki/tabby.nvim',
  dependencies = 'nvim-tree/nvim-web-devicons',
  config = function()
    -- Theme extracted from your Vim script config
    local palette = {
      bg = '#151F2D',       -- Normal guibg
      fg = '#BEBEBC',       -- Normal guifg
      accent = '#3A6FB0',   -- Search guibg (Blue)
      accent_fg = '#FFFFFF' -- Search guifg (White)
    }

    local theme = {
      fill = { bg = palette.bg, fg = palette.fg },
      head = { fg = palette.accent, bg = palette.bg, style = 'italic' },
      current_tab = { fg = palette.accent_fg, bg = palette.accent, style = 'italic' },
      tab = { fg = palette.fg, bg = palette.bg, style = 'italic' },
      win = { fg = palette.fg, bg = palette.bg, style = 'italic' },
      tail = { fg = palette.accent, bg = palette.bg, style = 'italic' },
    }

    require('tabby.tabline').set(function(line)
      return {
        {
          { ' 🐇 ', hl = theme.head },
          line.sep('', theme.head, theme.fill),
        },
        line.tabs().foreach(function(tab)
          local hl = tab.is_current() and theme.current_tab or theme.tab

          -- remove count of wins in tab with [n+] included in tab.name()
          local name = tab.name()
          local index = string.find(name, "%[%d")
          local tab_name = index and string.sub(name, 1, index - 1) or name

          -- indicate if any of buffers in tab have unsaved changes
          local modified = false
          -- Use safe call to prevent errors if window/buffer invalid
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
            modified and ' ', -- Added space for breathing room
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
