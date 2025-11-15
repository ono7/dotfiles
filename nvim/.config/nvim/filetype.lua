vim.filetype.add({
  filename = {
    ["Jenkinsfile"] = "groovy",
    ["Jenkinsfile-1"] = "groovy",
    ["Jenkinsfile-2"] = "groovy",
    ["Jenkinsfile-3"] = "groovy",
    ["Jenkinsfile-4"] = "groovy",
    [".env"] = "dotenv",
    ["env"] = "dotenv",
    [".eslintrc"] = "json",
    [".prettierrc"] = "json",
    [".babelrc"] = "json",
    [".stylelintrc"] = "json",
  },
  pattern = {
    ["[jt]sconfig.*.json"] = "jsonc",
    ["%.env%.[%w_.-]+"] = "dotenv",
    [".*config/git/config"] = "gitconfig",
    [".env.*"] = "sh",
  },
  extension = {
    env = "dotenv",
    csv = "csv",
    cl = "opencl",
    gohtml = "html",
    j2 = "jinja",
    conf = "config",
    -- yml = "yaml.ansible",
    -- yaml = "yaml.ansible",
    md = "markdown",
    ts = "typescript",
    tf = "terraform",
    tfvars = "terraform",
    tfstate = "json",
    hcl = "terraform",
    asm = "nasm",
    cfg = "ini",
    es6 = "javascript",
    mts = "typescript",
    cts = "typescript",
  },
})

--- force overrides

local ft_overrides = {
  ["*.cfg"] = "ini",
  -- add any future forced overrides here
}

local grp = vim.api.nvim_create_augroup("ForceFiletypeOverrides", { clear = true })

vim.api.nvim_create_autocmd("BufWinEnter", {
  group = grp,
  pattern = vim.tbl_keys(ft_overrides),
  callback = function(ev)
    vim.bo[ev.buf].filetype = ft_overrides[ev.match]
  end,
})
