-- return {
--   'windwp/nvim-autopairs',
--   event = "InsertEnter",
--   opts = {
--     enable_check_bracket_line = true,
--     ignored_next_char = "[%w%(%[{\"']" -- don't autopair if next char is '(', '[', '{', or alphanumeric
--   },
-- }

return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  opts = {
    check_ts = true, -- Enable treesitter integration
    enable_check_bracket_line = true,
    ignored_next_char = "[%w%(%[{\"']", -- don't autopair if next char is '(', '[', '{', or alphanumeric
    ts_config = {
      lua = { "string" }, -- Don't add pairs in lua string treesitter nodes
      javascript = { "template_string" },
    },
    fast_wrap = {
      map = "<M-e>", -- Alt+e to quickly wrap existing text in pairs
      chars = { "{", "[", "(", '"', "'" },
    },
  },
}
