local dap_ok, dap = pcall(require, "dap")
if not dap_ok then
  print("Error in pcall dap -> ~/.dotfiles/nvim/.config/nvim/lua/plugins/dap.lua")
  return
end

local dapui_ok, dapui = pcall(require, "dapui")
if not dapui_ok then
  print("Error in pcall dapui -> ~/.dotfiles/nvim/.config/nvim/lua/plugins/dap.lua")
  return
end

require("dapui").setup()
require("dap-go").setup()

require("nvim-dap-virtual-text").setup {}

-- TODO(jlima): map this to a different key to free <space>b to buffer browsing
vim.keymap.set("n", "<space>b", dap.toggle_breakpoint)
-- vim.keymap.set("n", "<space>gb", dap.run_to_cursor)

-- Eval var under cursor
-- vim.keymap.set("n", "<space>?", function()
--   require("dapui").eval(nil, { enter = true })
-- end)

vim.keymap.set("n", "<F1>", dap.continue)
vim.keymap.set("n", "<F2>", dap.step_into)
vim.keymap.set("n", "<F3>", dap.step_over)
vim.keymap.set("n", "<F4>", dap.step_out)
vim.keymap.set("n", "<F5>", dap.step_back)
vim.keymap.set("n", "<F6>", dap.restart)

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
