local M = {}

function M.setup()
  if M.loaded then
    return
  end

  local fzf = require("fzf-lua")

  local function delete_all_buffers()
    -- local buffers = vim.api.nvim_list_bufs()
    -- for _, buf in ipairs(buffers) do
    --   if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buflisted then
    --     -- Skip terminal buffers or force delete them
    --     local buftype = vim.bo[buf].buftype
    --     if buftype == "terminal" then
    --       vim.api.nvim_buf_delete(buf, { force = true })
    --     else
    --       -- Check if buffer is modified
    --       local modified = vim.bo[buf].modified
    --       vim.api.nvim_buf_delete(buf, { force = modified })
    --     end
    --   end
    -- end
  end

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
    table.sort(items, function(a, b)
      return a.score > b.score
    end)
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
            delete_all_buffers()
            vim.cmd("tcd " .. path)
            vim.notify("cwd: \n" .. path)
            vim.defer_fn(function()
              fzf.files({
                cwd = path,
                previewer = false,
              })
            end, 120)
          end
        end,
        ["ctrl-f"] = function(selected)
          if selected and selected[1] then
            local path = selected[1]
            delete_all_buffers()
            vim.cmd("tcd " .. path)
            vim.notify("cwd: \n" .. path)
            vim.defer_fn(function()
              fzf.files({
                cwd = path,
                previewer = false,
              })
            end, 80)
          end
        end,
      },
      winopts = {
        title = " Zoxide Directories ",
        title_pos = "center",
        width = 0.9, -- Use 90% of screen width
        height = 0.9, -- Use 90% of screen height
      },
      fzf_opts = {
        ["--scheme"] = "path",
      },
    })
  end

  vim.api.nvim_create_user_command("ZoxideCD", zoxide_cd, {})
  vim.api.nvim_set_keymap("n", "<leader>z", ":ZoxideCD<CR>", { noremap = true, silent = true })

  M.loaded = true
end

return M
