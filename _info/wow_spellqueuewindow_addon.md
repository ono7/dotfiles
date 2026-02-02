# place this on the addons folder

-- Create a folder in _retail_/Interface/AddOns/ named AutoSQW.
-- Create AutoSQW.toc:

### get the current build for the toc file, toc file supports comma separated values for multiple game version

```
/run print((select(4, GetBuildInfo())))
```

```AutoSQW.toc
## Interface: 110007
## Title: Auto SpellQueue
## Notes: Dynamically sets SQW based on latency.
core.lua
```

```lua (core.lua)
local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_ENTERING_WORLD")

f:SetScript("OnEvent", function()
    -- 1. LATENCY LOGIC (Wait 5s for jitter to settle)
    C_Timer.After(5, function()
        local _, _, _, worldLag = GetNetStats()
        -- Safety floor: assume at least 20ms lag
        if worldLag < 20 then worldLag = 20 end

        local tolerance = 100
        local newSQW = worldLag + tolerance

        SetCVar("SpellQueueWindow", newSQW)
        print("|cff00ff00[AutoSQW]|r Latency: " .. worldLag .. "ms | Queue Window: " .. newSQW .. "ms")
    end)

    -- 2. PVP TARGETING LOGIC (Immediate)
    -- C_PvP.IsPVPMap() returns true for BGs, Arenas, and Brawl instances.
    local isPvPInstance = C_PvP.IsPVPMap()

    if isPvPInstance then
        -- Value 3: Aggressively prioritize players over pets/totems
        SetCVar("TargetPriorityPVP", 3)
        print("|cffFF0000[PvP Mode]|r Targeting Priority: PLAYERS")
    else
        -- Value 1: Standard prioritizing (allows easy targeting of quest mobs/adds)
        SetCVar("TargetPriorityPVP", 1)
        -- Optional: print("|cff00AAFF[PvE Mode]|r Targeting Priority: STANDARD")
    end
end)
```
