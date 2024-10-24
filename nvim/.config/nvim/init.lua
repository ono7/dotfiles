--- 🐇 Follow the white Rabbit...
-- :write ++p (creates directories if they dont exists)
vim.cmd [[syntax off]]
vim.g.syntax_on = false
vim.opt.syntax = "off"

local opt = { noremap = true }
local silent = { noremap = true, silent = true }

-- improve matchparen performance
vim.g.matchparen_timeout = 20        -- default is 300
vim.g.matchparen_insert_timeout = 20 -- default is 60
vim.g.loaded_matchparen = 1

-- if nothing else, this are the bare minimum necessities
vim.opt.path:append({ "**" })
vim.opt.shell = "zsh"
vim.opt.clipboard = "unnamedplus"
vim.opt.wrap = false

vim.opt.shada = "'40,<200,s100,:300,/100,h,r~/COMMIT_EDITMSG"

--- syntax off to avoid tree-sitter issues
vim.opt.syntax = "off"
vim.g.mapleader = " "

vim.keymap.set("n", "+", ":e ~/todo.md<cr>", opt)

--- visual select last paste
vim.keymap.set("n", "gp", "`[v`]", silent)

--- keep cursor in same position when yanking in visual
vim.keymap.set("x", "y", [[ygv<Esc>]], silent)

vim.g.markdown_fold_style = "nested"

-- reuse same window
vim.g.netrw_banner = 0
vim.g.netrw_browse_split = 0
vim.g.netrw_liststyle = 3

vim.opt.winbar = "%=%-.75F %-m"

require("themes.notheme") -- basic HL groups for no colorscheme
require("config.disabled")
require("config.legacy")
require("config.abbreviations")
require("config.diff-settings")
require("config.vars")
require("config.settings")
require("config.helper-functions")
require("config.lazy-config")
require("config.keymaps")
require("config.cmds")

-- home made plugins go here
require("plugins.jira-base")
require("plugins.jira")
require("plugins.jira-move")
require("plugins.jira-fetch-issues")
require("plugins.jira-fetch-issues-empty")
require("plugins.jira-clone").setup()
require("plugins.create-table").setup()
require("plugins.claude-commit").setup()
require("plugins.claude-general").setup()
require("plugins.zoxide").setup()

-- this needs fixing
vim.api.nvim_create_user_command('JiraIssues', function()
  require('plugins.jira_viewer').open_issues_file()
  vim.keymap.set("n", "<leader>j", function()
    -- Load and setup the module
    local ok, jira_viewer = pcall(require, 'plugins.jira_viewer')
    if not ok then
      vim.notify(string.format("Failed to load jira_viewer module %s %s", ok, jira_viewer), vim.log.levels.ERROR)
      return
    end
    jira_viewer.setup()
    -- Schedule the command execution to ensure it's available
    vim.schedule(function()
      vim.cmd("JiraIssues")
    end)
  end, { silent = true, desc = "Open Jira Issues" })
end, {})


vim.keymap.set("n", "]d", "<cmd>lua vim.diagnostic.goto_prev({ float = true })<CR>")
vim.keymap.set("n", "[d", "<cmd>lua vim.diagnostic.goto_next({ float = true })<CR>")

-- comment for beam cursor
vim.opt.guicursor = ""
vim.opt.mouse = "n"

vim.cmd [[ syntax off ]]
