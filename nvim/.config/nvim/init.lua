--- 🐇 Follow the white Rabbit...
-- :write ++p (creates directories if they dont exists)
vim.hl = vim.highlight

vim.cmd([[syntax off]])

if vim.opt.termguicolors then
  -- if truecolor is supported, lets make it better for neovim
  vim.cmd([[let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"]])
  vim.cmd([[let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"]])
end

vim.g.syntax_on = false
vim.opt.syntax = "off"

-- TODO: need to figure out how to start in home dir
if vim.g.neovide then
  -- see ~/.config/neovide/config.toml
  vim.g.neovide_window_blurred = true
  vim.g.neovide_scale_factor = 1.3
  vim.g.neovide_input_macos_option_key_is_meta = "both"
  vim.g.neovide_cursor_animation_length = 0.02

  --- change font size with
  local change_scale_factor = function(delta)
    vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
  end
  vim.keymap.set("n", "<D-=>", function()
    change_scale_factor(1.25)
  end)
  vim.keymap.set("n", "<D-->", function()
    change_scale_factor(1 / 1.25)
  end)
end

require("config.options")
require("config.keymaps")
require("config.disabled")
require("config.legacy")
require("config.abbreviations")
require("config.diff-settings")
require("config.vars")
require("config.helper-functions")
require("config.lazy")
require("utils.zoxide").setup()
require("utils.runner").setup() -- runs anything :M ps waux :)
require("utils.create-table").setup()
require("config.commands")
require("config.autocmds")
require("config.completion")

-- comment for beam cursor
-- vim.opt.guicursor = ""
vim.opt.mouse = "a"

-- home made plugins go here
-- require("plugins.jira-base")
-- require("plugins.jira")
-- require("plugins.jira-move")
-- require("plugins.jira-fetch-issues")
-- require("plugins.jira-fetch-issues-empty")
-- require("plugins.jira-clone").setup()
-- require("plugins.create-table").setup()

-- this needs fixing
-- vim.api.nvim_create_user_command('JiraIssues', function()
--   require('plugins.jira_viewer').open_issues_file()
--   vim.keymap.set("n", "<leader>j", function()
--     -- Load and setup the module
--     local ok, jira_viewer = pcall(require, 'plugins.jira_viewer')
--     if not ok then
--       vim.notify(string.format("Failed to load jira_viewer module %s %s", ok, jira_viewer), vim.log.levels.ERROR)
--       return
--     end
--     jira_viewer.setup()
--     -- Schedule the command execution to ensure it's available
--     vim.schedule(function()
--       vim.cmd("JiraIssues")
--     end)
--   end, { silent = true, desc = "Open Jira Issues" })
-- end, {})

if vim.g.neovide then
  vim.api.nvim_set_hl(0, "Normal", { bg = "#1b1f31", fg = "#cdd6f4" })
end
