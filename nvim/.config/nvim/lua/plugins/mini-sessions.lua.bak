return {
  "echasnovski/mini.sessions",
  version = false,
  config = function()
    local sessions = require("mini.sessions")

    sessions.setup({
      autoread = true,  -- auto-load last session when opening without args
      autowrite = false, -- we handle saving ourselves
      directory = vim.fn.stdpath("data") .. "/sessions",
    })

    -- Load last session on empty launch
    if vim.fn.argc() == 0 then
      sessions.read("last")
    end

    -- Save clean session on exit
    vim.api.nvim_create_autocmd("VimLeavePre", {
      callback = function()
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
          if vim.bo[buf].buftype == "terminal" then
            pcall(vim.api.nvim_buf_delete, buf, { force = true })
          end
        end
        -- 🔥 delete arglist so no stale files get written into the session
        vim.cmd("argglobal")
        vim.cmd("%argdel")

        sessions.write("last")
      end,
    })
  end,
}
