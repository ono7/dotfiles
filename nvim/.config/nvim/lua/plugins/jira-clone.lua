local curl = require('plenary.curl')
local jira_main = require('jira-base')



local function clone_issue(issue_key, num_clones)
  if not jira_main.setup() then
    return
  end

  -- Encode credentials
  local auth = vim.base64.encode(jira_main.config.jira_email .. ':' .. jira_main.config.jira_api_token)

  -- Prepare the payload for cloning
  local clone_payload = {
    summary = "CLONE - " .. issue_key,
    -- optionalFields = {},
    includeAttachments = false
  }


  -- def issueResult = post('/rest/internal/2/issue/[issue key]/clone')
  -- .header('Authorization', 'Basic [your base64 endcoded user:token ]')
  -- .header("Content-Type", "application/json")
  -- .body([summary : "CLONE - test"]).asString()
  -- return issueResult
  -- Clone the issue the specified number of times
  for i = 1, num_clones do
    local clone_response = curl.post(jira_main.config.jira_url .. '/rest/internal/2/issue/' .. issue_key .. '/clone', {
      body = vim.fn.json_encode(clone_payload),
      headers = {
        Authorization = 'Basic ' .. auth,
        ['Content-Type'] = 'application/json',
      },
    })

    if clone_response.status ~= 200 and clone_response.status ~= 201 then
      local error_body = vim.fn.json_decode(clone_response.body)
      local error_message = 'Failed to clone issue. '
      P(error_body)
      P(clone_response)
    end
  end
end
--       if error_body and error_body.errors then
--         for field, msg in pairs(error_body.errors) do
--           error_message = error_message .. field .. ': ' .. msg .. '; '
--         end
--       else
--         error_message = error_message .. 'Status: ' .. clone_response.status
--       end
--
--       jira_main.display_message(error_message, vim.log.levels.ERROR)
--     else
--       local new_issue = vim.fn.json_decode(clone_response.body)
--       jira_main.display_message('Created clone: ' .. new_issue.key, vim.log.levels.INFO)
--
--       -- Update the assignee
--       local assignee_payload = {
--         fields = {
--           assignee = { name = jira_main.config.jira_email:match("(.+)@") }
--         }
--       }
--
--       local assignee_response = curl.put(jira_main.config.jira_url .. '/rest/api/2/issue/' .. new_issue.key, {
--         body = vim.fn.json_encode(assignee_payload),
--         headers = {
--           Authorization = 'Basic ' .. auth,
--           ['Content-Type'] = 'application/json',
--         },
--       })
--
--       if assignee_response.status ~= 204 then
--         jira_main.display_message('Failed to update assignee. Status: ' .. assignee_response.status, vim.log.levels
--           .ERROR)
--       else
--         jira_main.display_message('Updated assignee for ' .. new_issue.key, vim.log.levels.INFO)
--       end
--     end
--   end
-- end
--
-- Function to handle the JiraClone command

local function jira_clone_command(args)
  if #args ~= 2 then
    jira_main.display_message("Usage: JiraClone <issue-key> <number-of-clones>", vim.log.levels.ERROR)
    return
  end

  local issue_key = args[1]
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
