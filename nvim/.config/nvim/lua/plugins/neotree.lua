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
      window = { width = 25 },
      buffers = { follow_current_file = { enabled = true } },
    })
  end,
}
