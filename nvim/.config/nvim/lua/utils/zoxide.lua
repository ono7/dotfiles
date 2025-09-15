local M = {}

function M.setup()
  if M.loaded then
    return
  end

  local fzf = require("fzf-lua")

  local function zoxide_cd()
    local handle = io.popen("zoxide query -ls")
    if not handle then
      print("Error: Could not execute zoxide command")
      return
    end

    local result = handle:read("*a")
    handle:close()

    local items = {}
    for line in result:gmatch("[^\r\n]+") do
      local score, path = line:match("(%S+)%s+(.*)")
      if score and path then
        table.insert(items, { score = tonumber(score), path = path })
      end
    end

    -- Sort by score descending
    table.sort(items, function(a, b)
      return a.score > b.score
    end)

    -- Convert to fzf entries (just the paths)
    local entries = {}
    for _, item in ipairs(items) do
      table.insert(entries, item.path)
    end

    fzf.fzf_exec(entries, {
      prompt = "Zoxide> ",
      actions = {
        ["default"] = function(selected)
          if selected and selected[1] then
            local path = selected[1]
            vim.cmd("lcd " .. path)
            print("Changed to directory: " .. path)
          end
        end,
        ["ctrl-f"] = function(selected)
          if selected and selected[1] then
            local path = selected[1]
            vim.cmd("lcd " .. path)
            print("Changed to directory: " .. path)
            -- Open find_files in the selected directory
            vim.defer_fn(function()
              fzf.files({ cwd = path })
            end, 100)
          end
        end,
      },
      winopts = {
        title = " Zoxide Directories ",
        title_pos = "center",
      },
    })
  end

  vim.api.nvim_create_user_command("ZoxideCD", zoxide_cd, {})
  vim.api.nvim_set_keymap("n", "<leader>z", ":ZoxideCD<CR>", { noremap = true, silent = true })

  M.loaded = true
end

return M
