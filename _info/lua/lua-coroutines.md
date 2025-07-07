## lua coroutine examples and use cases

```lua
--- example of coroutine parsing log file
local function process_log(filename)
    return coroutine.create(function()
        local file = io.open(filename, "r")
        if not file then return end

        for line in file:lines() do
            if line:match("ERROR") then
                coroutine.yield("error", line)
            elseif line:match("WARNING") then
                coroutine.yield("warning", line)
            elseif line:match("INFO") then
                coroutine.yield("info", line)
            end
        end

        file:close()
    end)
end

local function handle_log_entry(level, message)
    if level == "error" then
        print("Alerting team about error: " .. message)
        -- Code to send alert would go here
    elseif level == "warning" then
        print("Logging warning: " .. message)
        -- Code to log warning would go here
    elseif level == "info" then
        print("Recording info: " .. message)
        -- Code to record info would go here
    end
end

local log_processor = process_log("system.log")

while true do
    local status, level, message = coroutine.resume(log_processor)
    if not status then break end
    handle_log_entry(level, message)
end

```
