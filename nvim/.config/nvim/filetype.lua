vim.filetype.add({
  filename = {
    ['Jenkinsfile'] = 'groovy',
    ['Jenkinsfile-1'] = 'groovy',
    ['Jenkinsfile-2'] = 'groovy',
    ['Jenkinsfile-3'] = 'groovy',
    ['Jenkinsfile-4'] = 'groovy',
    [".env"] = "dotenv",
    ["env"] = "dotenv",
  },
  pattern = {
    ["[jt]sconfig.*.json"] = "jsonc",
    ["%.env%.[%w_.-]+"] = "dotenv",
  },
  extension = {
    -- h = function()
    --   -- Use a lazy heuristic that #including a C++ header means it's a
    --   -- C++ header
    --   if vim.fn.search("\\C^#include <[^>.]\\+>$", "nw") >= 1 then
    --     return "cpp"
    --   end
    --   return "c"
    -- end,
   env = "dotenv",
    csv = "csv",
    cl = "opencl",
    env = "env",
    gohtml = "html",
    j2 = "jinja",
    conf = "config",
    yml = "yaml.ansible",
    yaml = "yaml.ansible",
    md = "markdown",
    ts = "typescript",
    tf = "terraform",
    tfvars = "terraform",
    tfstate = "json",
    hcl = "terraform",
    asm = "nasm",
  },
})
