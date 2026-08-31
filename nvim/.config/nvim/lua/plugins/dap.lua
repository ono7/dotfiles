return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio",
  },
  keys = {
    {
      "<F8>",
      function()
        require("dap").continue()
      end,
      desc = "DAP: Continue / Start",
    },
    {
      "<F9>",
      function()
        require("dap").step_over()
      end,
      desc = "DAP: Step Over",
    },
    {
      "<F10>",
      function()
        require("dap").step_into()
      end,
      desc = "DAP: Step Into",
    },
    {
      "<F7>",
      function()
        require("dap").step_out()
      end,
      desc = "DAP: Step Out",
    },
    {
      "<leader>db",
      function()
        require("dap").toggle_breakpoint()
      end,
      desc = "DAP: Toggle Breakpoint",
    },
    {
      "<leader>dB",
      function()
        require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
      end,
      desc = "DAP: Conditional Breakpoint",
    },
    {
      "<leader>du",
      function()
        require("dapui").toggle()
      end,
      desc = "DAP: Toggle UI",
    },
    {
      "<leader>dr",
      function()
        require("dap").repl.open()
      end,
      desc = "DAP: Open REPL",
    },
    {
      "<leader>dq",
      function()
        require("dap").terminate()
      end,
      desc = "DAP: Terminate",
    },
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

    dapui.setup()

    -- Automatically open/close DAP UI when debugging starts/ends
    dap.listeners.before.attach.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.launch.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated.dapui_config = function()
      dapui.close()
    end
    dap.listeners.before.event_exited.dapui_config = function()
      dapui.close()
    end

    -- Custom breakpoint icons
    vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError", linehl = "", numhl = "" })
    vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DiagnosticWarn", linehl = "", numhl = "" })
    vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DiagnosticOk", linehl = "Visual", numhl = "" })

    -- Resolve Mason codelldb path dynamically
    local mason_registry = vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/adapter/codelldb"

    dap.adapters.codelldb = {
      type = "server",
      port = "${port}",
      executable = {
        command = mason_registry,
        args = { "--port", "${port}" },
      },
    }

    -- C and C++ Launch Configuration
    dap.configurations.cpp = {
      {
        name = "Launch binary",
        type = "codelldb",
        request = "launch",
        program = function()
          return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
        args = function()
          local input = vim.fn.input("CLI args (optional): ")
          return input ~= "" and vim.split(input, " ") or {}
        end,
        runInTerminal = false,
      },
    }

    dap.configurations.c = dap.configurations.cpp
  end,
}
