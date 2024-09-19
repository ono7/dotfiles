local curl = require('plenary.curl')
local jira_main = require('plugins.jira-base')

local function clone_issue(issue_key, num_clones)
  if not jira_main.setup() then
    return
  end

  -- Encode credentials
  local auth = vim.base64.encode(jira_main.config.jira_email .. ':' .. jira_main.config.jira_api_token)

  for i = 1, num_clones do
    local clone_payload = {
      summary = string.format("CLONE - %s, %d", issue_key, i),
      -- optionalFields = {},
      includeAttachments = false
    }
    -- this endpoint only valid for cloud base deployments of jira
    local clone_response = curl.post(jira_main.config.jira_url .. '/rest/internal/2/issue/' .. issue_key .. '/clone', {
      body = vim.fn.json_encode(clone_payload),
      headers = {
        Authorization = 'Basic ' .. auth,
        ['Content-Type'] = 'application/json',
      },
    })

    if clone_response.status ~= 200 then
      P(clone_response)
    end
    print(string.format("cloned copy %d from %s, success\n", i, issue_key))
  end
end

local function jira_clone_command(args)
  if #args ~= 2 then
    jira_main.display_message("Usage: JiraClone <issue-key> <number-of-clones>", vim.log.levels.ERROR)
    return
  end

  local issue_key = ""

  local preissue = args[1]
  if preissue:match("^[Nn][Tt][Ww][Kw]-") then
    issue_key = preissue
  elseif preissue:match("^%d+") then
    issue_key = string.format("NTWK-%d", preissue)
  end

  local num_clones = tonumber(args[2])

  if not num_clones or num_clones < 1 then
    jira_main.display_message("Number of clones must be a positive integer", vim.log.levels.ERROR)
    return
  end

  clone_issue(issue_key, num_clones)
end

-- New command to clone issues
vim.api.nvim_create_user_command('JiraClone', function(opts)
  jira_clone_command(opts.fargs)
end, { nargs = '+' })

return {
  clone_issue = clone_issue
}
