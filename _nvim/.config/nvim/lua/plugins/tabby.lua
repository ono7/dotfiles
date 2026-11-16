return {
  "nanozuki/tabby.nvim",
  dependencies = "nvim-tree/nvim-web-devicons",
  config = function()
    vim.o.showtabline = 2
    vim.opt.switchbuf = "usetab,uselast"

    -- Fast native path parsing (avoids vim.fn.fnamemodify C-bridge overhead)
    local function get_tab_label(tab_id)
      local current_win = tab_id.current_win()
      local bufid = current_win.buf().id
      local bufname = vim.api.nvim_buf_get_name(bufid)

      if bufname == "" then
        return "[No Name]"
      end

      local parent, filename = bufname:match("([^/\\]+)[/\\]([^/\\]+)$")
      if filename then
        return parent .. "/" .. filename
      end

      return bufname:match("([^/\\]+)$") or bufname
    end

    -- NOTE(jlima): Slices the tab collection to fit a sliding viewport around the active tab
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

    -- NOTE(jlima): Adjusts hex brightness to create distinct layer elevations
    local function adjust_color(hex, percent)
      local r = tonumber(hex:sub(2, 3), 16)
      local g = tonumber(hex:sub(4, 5), 16)
      local b = tonumber(hex:sub(6, 7), 16)

      local adjust = function(c)
        if percent >= 0 then
          return math.min(255, math.floor(c + (255 - c) * percent))
        else
          return math.max(0, math.floor(c * (1 + percent)))
        end
      end

      return string.format("#%02x%02x%02x", adjust(r), adjust(g), adjust(b))
    end

    local function get_hl(name)
      local hl = vim.api.nvim_get_hl(0, { name = name, link = false })
      local fg = hl.fg
      local bg = hl.bg
      if hl.reverse then
        fg, bg = bg, fg
      end
      return {
        fg = fg and string.format("#%06x", fg) or nil,
        bg = bg and string.format("#%06x", bg) or nil,
      }
    end

    -- NOTE(jlima): Cache computed palette outside render closure to prevent redraw latency
    local theme = {}
    local function update_theme()
      local is_dark = vim.o.background == "dark"
      local normal = get_hl("Normal")
      local base_bg = normal.bg or (is_dark and "#1e1e2e" or "#EDE9E1")
      local base_fg = normal.fg or (is_dark and "#cdd6f4" or "#242424")

      local comment = get_hl("Comment")
      local special = get_hl("Special")
      local diag_warn = get_hl("DiagnosticWarn")

      local active_bg = adjust_color(base_bg, is_dark and 0.15 or -0.10)
      local inactive_bg = adjust_color(base_bg, is_dark and 0.06 or -0.04)

      theme = {
        fill = {
          bg = base_bg,
          fg = comment.fg or base_fg,
        },
        head = {
          fg = special.fg or base_fg,
          bg = base_bg,
        },
        tail = {
          fg = special.fg or base_fg,
          bg = base_bg,
        },
        current_tab = {
          fg = base_fg,
          bg = active_bg,
          bold = true,
        },
        tab = {
          fg = comment.fg or base_fg,
          bg = inactive_bg,
        },
        modified = {
          fg = diag_warn.fg or (is_dark and "#f38ba8" or "#B63E46"),
        },
      }
    end

    update_theme()
    vim.api.nvim_create_autocmd("ColorScheme", {
      group = vim.api.nvim_create_augroup("TabbyThemeCache", { clear = true }),
      callback = update_theme,
    })

    local tabby_api = require("tabby.module.api")

    require("tabby.tabline").set(function(line)
      local all_tabs = line.tabs().tabs
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
        local win_ids = tabby_api.get_tab_wins(tab.id)
        for _, win_id in ipairs(win_ids) do
          -- NOTE(jlima): Use vim.api.nvim_get_option_value for robust, fast retrieval without proxy table overhead
          local success, is_mod = pcall(vim.api.nvim_get_option_value, "modified", { win = win_id })
          if success and is_mod then
            modified = true
            break
          end
        end

        table.insert(tab_elements, {
          line.sep("", hl, theme.fill),
          tab_name,
          modified and {
            icon = "",
            " ",
            fg = theme.modified.fg,
          } or "",
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
          {
            "🐇",
            hl = theme.head,
          },
          line.sep("", theme.head, theme.fill),
        },
        tab_elements,
        line.spacer(),
        {
          line.sep("", theme.tail, theme.fill),
          {
            "",
            hl = theme.tail,
          },
        },
        hl = theme.fill,
      }
    end)
  end,
}
