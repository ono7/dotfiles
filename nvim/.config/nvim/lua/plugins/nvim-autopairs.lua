return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  opts = {
    check_ts = true,
    enable_check_bracket_line = true,
    -- NOTE(jlima): Lua pattern set matching alphanumeric, quotes, and opening brackets without invalid escapes
    ignored_next_char = "[%w%(%[%{\"']",
    ts_config = {
      lua = { "string" },
      javascript = { "template_string" },
    },
    fast_wrap = {
      map = "<M-e>",
      chars = { "{", "[", "(", '"', "'" },
    },
  },
}
