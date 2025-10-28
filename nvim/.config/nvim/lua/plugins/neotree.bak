return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    "MunifTanjim/nui.nvim",
    -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
  },
  keys = {
    { "<leader><tab>", ":Neotree toggle left<cr>", silent = true, desc = "Neotree: Float file explorer" },
    { "<leader>e", ":Neotree toggle float<cr>", silent = true, desc = "Neotree: Float file explorer" },
  },
  config = function()
    require("neo-tree").setup({
      enable_git_status = false,
      enable_diagnostics = false,
      window = { width = 35 },
      filesystem = {
        filtered_items = {
          visible = false, -- This is what you want: If you set this to `true`, all "hide" just mean "dimmed out"
          hide_dotfiles = false,
          hide_gitignored = true,
        },
        follow_current_file = { enabled = true },
      },
      buffers = {
        follow_current_file = {
          enabled = true, -- This will find and focus the file in the active buffer every time
          --              -- the current file is changed while the tree is open.
          leave_dirs_open = true, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
        },
      },
    })
  end,
}
