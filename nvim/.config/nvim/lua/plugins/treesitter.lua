return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  branch = "main", -- Using the v1.0 native API branch
  build = ":TSUpdate",
  config = function()
    -- 1. Register custom filetypes
    vim.filetype.add({
      extension = {
        csproj = "xml",
        esproj = "xml",
        keymap = "c",
        mdx = "markdown",
        uproject = "json",
        wsdl = "xml",
      },
    })

    -- 2. Define minimum required parsers
    local ensure_installed = {
      "c",
      "cpp",
      "lua",
      "qmljs",
      "vim",
      "vimdoc",
      "query",
      "gitcommit",
      "python",
      "yaml",
      "json",
    }

    -- 3. Install core parsers
    require("nvim-treesitter").install(ensure_installed)

    -- 4. Native Autocmd for Highlighting & Auto-Install
    local ignored_filetypes = {
      fzf = true,
      lazy = true,
      DiffviewFileHistory = true,
      oil = true,
      oil_preview = true,
      netrw = true,
      qf = true,
      harpoon = true,
      snippets = true,
      TelescopePrompt = true,
      mason = true,
      ["conform-info"] = true,
      fugitive = true,
      dropbar_menu = true,
      noice = true,
      tabby = true,
      text = true,
      fidget = true,
      notify = true,
    }

    -- Cache installation attempts to avoid repeatedly triggering compiler jobs per buffer switch
    local attempted_installs = {}

    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("TreesitterNativeSetup", { clear = true }),
      pattern = "*",
      callback = function(args)
        -- Guard against large files (>10,000 lines or flagged)
        if vim.b[args.buf].large_file or vim.api.nvim_buf_line_count(args.buf) > 10000 then
          return
        end

        if ignored_filetypes[args.match] then
          return
        end

        -- Start Treesitter highlighting
        local success = pcall(vim.treesitter.start, args.buf)
        if not success then
          local lang = vim.treesitter.language.get_lang(args.match) or args.match
          if lang and lang ~= "" and not attempted_installs[lang] then
            attempted_installs[lang] = true
            pcall(function()
              require("nvim-treesitter").install(lang)
            end)
          end
        end
      end,
    })
  end,
}
