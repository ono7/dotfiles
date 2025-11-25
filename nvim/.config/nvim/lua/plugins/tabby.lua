return {
  'nanozuki/tabby.nvim',
  dependencies = 'nvim-tree/nvim-web-devicons',
  config = function()
    local theme = {
      -- this is carbonfox theme
      fill = 'TabLineFill',
      head = { fg = '#75beff', bg = '#1c1e26', style = 'italic' },
      current_tab = { fg = '#1c1e26', bg = '#75beff', style = 'italic' },
      tab = { fg = '#c5cdd9', bg = '#1c1e26', style = 'italic' },
      win = { fg = '#1c1e26', bg = '#75beff', style = 'italic' },
      tail = { fg = '#75beff', bg = '#1c1e26', style = 'italic' },
    }

    require('tabby.tabline').set(function(line)
      return {
        {
          { '  ', hl = theme.head },
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
          local win_ids = require('tabby.module.api').get_tab_wins(tab.id)
          for _, win_id in ipairs(win_ids) do
            if pcall(vim.api.nvim_win_get_buf, win_id) then
              local bufid = vim.api.nvim_win_get_buf(win_id)
              if vim.api.nvim_buf_get_option(bufid, "modified") then
                modified = true
                break
              end
            end
          end

          return {
            line.sep('', hl, theme.fill),
            tab_name,
            modified and '',
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
