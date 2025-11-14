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
        -- 🔥 delete arglist so no stale files get written into the session
        vim.cmd("argglobal")
        vim.cmd("%argdel")

        sessions.write("last")
      end,
    })
  end,
}
