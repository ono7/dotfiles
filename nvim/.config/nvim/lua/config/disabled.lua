-- NOTE(jlima): Guard names must match exact exists() checks in $VIMRUNTIME/plugin/*; autoload guards are omitted as unreachable once plugin registration is skipped.
vim.g.loaded_gzip = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_tutor_mode_plugin = 1
vim.g.loaded_2html_plugin = 1

-- NOTE(jlima): Disables synchronous bracket scanning on CursorMovedI, which altrimenti blocks the UI loop on every character inserted.
vim.g.loaded_matchparen = 1

vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_python3_provider = 0
