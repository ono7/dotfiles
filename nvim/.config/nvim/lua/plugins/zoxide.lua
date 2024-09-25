local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"

-- Function to integrate zoxide with Neovim
local function zoxide_cd()
  -- Get zoxide query results
  local handle = io.popen("zoxide query -ls")
  local result = handle:read("*a")
  handle:close()

  -- Parse the results
  local items = {}
  for line in result:gmatch("[^\r\n]+") do
    local score, path = line:match("(%S+)%s+(.*)")
    table.insert(items, { score = tonumber(score), path = path })
  end

  -- Sort items by score (highest first)
  table.sort(items, function(a, b) return a.score > b.score end)

  -- Use Telescope picker
  pickers.new({}, {
    prompt_title = "Zoxide Directories",
    finder = finders.new_table {
      results = items,
      entry_maker = function(entry)
        return {
          value = entry,
          display = entry.path,
          ordinal = entry.path,
        }
      end,
    },
    sorter = conf.generic_sorter({}),
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        -- Change directory for the current buffer
        vim.cmd('lcd ' .. selection.value.path)
        print("Changed to directory: " .. selection.value.path)
      end)
      return true
    end,
  }):find()
end

-- Command to call the function
vim.api.nvim_create_user_command('ZoxideCD', zoxide_cd, {})

-- Optional: Add a keymap
vim.api.nvim_set_keymap('n', '<leader>z', ':ZoxideCD<CR>', { noremap = true, silent = true })
