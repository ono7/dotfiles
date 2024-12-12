return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  config = function()
    require("nvim-autopairs").setup({
      disable_filetype = { "TelescopePrompt", "vim" },
      fast_wrap = {},
      check_ts = true,
      ts_config = {
        lua = { "sting" }, -- dont add autopairs in lua string treesitter nodes
        javascript = { "template_string" }, -- dont add in javascript template_strings
        java = false, -- dont check treesitter in java files
      },
    })
  end,
}
