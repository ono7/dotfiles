-- Create a table to hold our functions
local winbar = {}

-- Function to get clean branch name
function winbar.get_git_branch()
  local fugitive_status = vim.fn.FugitiveStatusline()
  if fugitive_status ~= "" then
    -- Extract branch name from [Git(main)]
    local branch = fugitive_status:match("%[Git%((.-)%)]")
    return branch and ("{" .. branch .. "}") or ""
  end
  return ""
end

-- Function to get the winbar string
function winbar.get_winbar()
  local filename = "%-.75F"
  local modified = "%-m"
  local git_branch = winbar.get_git_branch()
  return string.format("%%=%s %s%s", filename, modified, git_branch)
end

-- Set up the winbar
vim.opt.winbar = "%{%v:lua.require'winbar'.get_winbar()%}"

-- Return the table
return winbar
