local M = {}

function M.setup()
  if M.loaded then
    return
  end

  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local conf = require("telescope.config").values
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")
  local builtin = require("telescope.builtin")

  local function zoxide_cd()
    local handle = io.popen("zoxide query -ls")
    local result = handle:read("*a")
    handle:close()

    local items = {}
    for line in result:gmatch("[^\r\n]+") do
      local score, path = line:match("(%S+)%s+(.*)")
      table.insert(items, { score = tonumber(score), path = path })
    end

    table.sort(items, function(a, b)
      return a.score > b.score
    end)

    pickers
      .new({}, {
        prompt_title = "Zoxide Directories",
        finder = finders.new_table({
          results = items,
          entry_maker = function(entry)
            return {
              value = entry,
              display = entry.path,
              ordinal = entry.path,
            }
          end,
        }),
        sorter = conf.generic_sorter({}),
        attach_mappings = function(prompt_bufnr, map)
          actions.select_default:replace(function()
            actions.close(prompt_bufnr)
            local selection = action_state.get_selected_entry()
            vim.cmd("lcd " .. selection.value.path)
            print("Changed to directory: " .. selection.value.path)

            -- Open Telescope find_files in the selected directory
            -- vim.defer_fn(function()
            --   builtin.find_files({
            --     cwd = selection.value.path,
            --     prompt_title = "Find Files in " .. selection.value.path,
            --   })
            -- end, 100)
          end)
          return true
        end,
      })
      :find()
  end

  vim.api.nvim_create_user_command("ZoxideCD", zoxide_cd, {})
  vim.api.nvim_set_keymap("n", "<leader>z", ":ZoxideCD<CR>", { noremap = true, silent = true })

  M.loaded = true
end

return M
