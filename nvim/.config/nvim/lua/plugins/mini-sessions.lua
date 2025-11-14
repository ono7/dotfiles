--- restores vim to last working session with minimal fuzz or weird hacks
--- :q to save state
return {
  "echasnovski/mini.sessions",
  version = false,
  config = function()
    local sessions = require("mini.sessions")

    sessions.setup({
      autoread = true,  -- auto-load last session when opening nvim without args
      autowrite = true, -- auto-save session on exit
      directory = vim.fn.stdpath("data") .. "/sessions",
    })

    -- Always load the *default* session if nvim starts with no file args
    if vim.fn.argc() == 0 then
      sessions.read("last")
    end

    -- Save on exit
    vim.api.nvim_create_autocmd("VimLeavePre", {
      callback = function()
        sessions.write("last")
      end,
    })
  end,
}
