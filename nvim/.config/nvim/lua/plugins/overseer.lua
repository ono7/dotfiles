return {
  "stevearc/overseer.nvim",
  cmd = {
    "OverseerOpen",
    "OverseerClose",
    "OverseerToggle",
    "OverseerSaveBundle",
    "OverseerLoadBundle",
    "OverseerDeleteBundle",
    "OverseerRunCmd",
    "OverseerRun",
    "OverseerInfo",
    "OverseerBuild",
    "OverseerQuickAction",
    "OverseerTaskAction",
    "OverseerClearCache",
  },
  keys = {
    { "<leader>to", "<cmd>OverseerToggle<cr>", desc = "Overseer: Toggle Task List" },
    { "<leader>tr", "<cmd>OverseerRun<cr>", desc = "Overseer: Run Task" },
    { "<leader>tb", "<cmd>OverseerBuild<cr>", desc = "Overseer: Build" },
    { "<leader>ta", "<cmd>OverseerTaskAction<cr>", desc = "Overseer: Task Action" },
    { "<leader>tc", "<cmd>OverseerClearCache<cr>", desc = "Overseer: Clear Cache" },
    { "<leader>tq", "<cmd>OverseerQuickAction<cr>", desc = "Overseer: Quick Action" },
  },
  opts = {
    -- Patch nvim-dap to support preLaunchTask and postDebugTask
    dap = true,
    strategy = {
      "terminal",
      use_terminal = true,
      quit_on_exit = "never",
      open_on_start = true,
    },
    task_list = {
      default_detail = 1,
      direction = "bottom",
      min_height = 8,
      max_height = 15,
      bindings = {
        ["?"] = "ShowHelp",
        ["g?"] = "ShowHelp",
        ["<CR>"] = "RunAction",
        ["<C-e>"] = "Edit",
        ["o"] = "Open",
        ["<C-v>"] = "OpenVsplit",
        ["<C-s>"] = "OpenSplit",
        ["<C-f>"] = "OpenFloat",
        ["p"] = "TogglePreview",
        ["<C-l>"] = "IncreaseDetail",
        ["<C-h>"] = "DecreaseDetail",
        ["L"] = "IncreaseAllDetail",
        ["H"] = "DecreaseAllDetail",
        ["["] = "DecreaseWidth",
        ["]"] = "IncreaseWidth",
        ["{"] = "PrevTask",
        ["}"] = "NextTask",
        ["<C-k>"] = "ScrollOutputUp",
        ["<C-j>"] = "ScrollOutputDown",
        ["q"] = "Close",
      },
    },
    form = {
      border = "rounded",
      zindex = 40,
      min_width = 80,
      max_width = 0.9,
      min_height = 10,
      max_height = 0.9,
    },
    task_win = {
      border = "rounded",
      padding = 2,
    },
    component_aliases = {
      default = {
        { "display_duration", detail_level = 2 },
        "on_output_summarize",
        "on_exit_set_status",
        "on_complete_notify",
        "unique",
      },
    },
  },
  config = function(_, opts)
    local overseer = require("overseer")
    overseer.setup(opts)

    -- Custom command to quickly run an ad-hoc shell command as an overseer task
    vim.api.nvim_create_user_command("OverseerRunCmd", function(params)
      overseer
        .new_task({
          cmd = vim.split(params.args, "%s+"),
          components = {
            { "on_output_quickfix", open = true },
            "default",
          },
        })
        :start()
    end, { nargs = "+", complete = "shellcmd" })
  end,
}
