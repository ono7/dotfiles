return {
  "m4xshen/autoclose.nvim",
  version = false,
  event = "InsertEnter",
  config = function()
    local config = {
      keys = {
        ["("] = { escape = false, close = false, pair = "()" },
        ["["] = { escape = false, close = false, pair = "[]" },
        ["{"] = { escape = false, close = true, pair = "{}" },

        [">"] = { escape = true, close = false, pair = "<>" },
        [")"] = { escape = true, close = false, pair = "()" },
        ["]"] = { escape = true, close = false, pair = "[]" },
        ["}"] = { escape = true, close = false, pair = "{}" },

        ['"'] = { escape = true, close = false, pair = '""' },
        ["'"] = { escape = true, close = false, pair = "''" },
        ["`"] = { escape = true, close = true, pair = "``" },
      },
      options = {
        -- disabled_filetypes = { "text" },
        disabled_filetypes = {},
        disable_when_touch = true,
        -- touch_regex = "[%w(%[{]",
        touch_regex = "[%w(%[{\"']",
        pair_spaces = false, --- inserts spaces after typing, a space { | }
        auto_indent = true,
        disable_command_mode = false,
      },
    }
    require("autoclose").setup(config)
  end,
}
