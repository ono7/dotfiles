return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  opts = {
    check_ts = true,
    enable_check_bracket_line = true,
    -- NOTE(jlima): Disable explicit after-quote override so ignored_next_char is honored before quotes
    enable_afterquote = false,
    enable_bracket_in_quote = false,
    ignored_next_char = [=[[%w%%%'%[%\"%.%`%$]]=],
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
