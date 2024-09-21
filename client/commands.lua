-- Shared handler function for report commands
local function handleReportCommand(source, args, rawCommand)
    -- Trigger the NUI (HTML/CSS/JS interface) to open the report menu
    UIMessage("nui:state:reportmenu", true)

    -- Set NUI focus to true to capture user input
    SetNuiFocus(true, true)
end

-- Iterate over each command alias and register it with the handler
for _, commandName in ipairs(Config.ReportCommands) do
    RegisterCommand(commandName, function(source, args, rawCommand)
        handleReportCommand(source, args, rawCommand)
    end, false)
end
--[[
RegisterCommand(Config.ReportCommand, function()
    UIMessage("nui:state:reportmenu", true)
    SetNuiFocus(true, true)
end, false)
--]]
RegisterCommand(Config.ReportMenuCommand, function()
    if not Script.state.settingsLoaded then
        local settingsKvp = GetResourceKvpString("reportmenu:settings")
        if settingsKvp then
            local settings = json.decode(settingsKvp)
            UIMessage("nui:state:settings", settings)
            Debug("Settings loaded: ", settingsKvp)
        end
        Script.state.settingsLoaded = true
        if PlayerData.isStaff then
            Debug("Updating active reports. \n PlayerData: ", json.encode(PlayerData))
            TriggerServerEvent("reportmenu:server:cb:reports")
        end
    end

    UIMessage("nui:state:playerdata", PlayerData)
    UIMessage("nui:state:myreports", MyReports)

    ToggleNuiFrame(true)
    Debug("[command:show-nui] ToggleNuiFrame called and set to true.")
end, false)

RegisterKeyMapping(Config.ReportMenuCommand, "Open Reports Menu", "keyboard", "J");

RegisterCommand('testleaderboard', function()
    local leaderboardRes = {
        { id = 1, name = 'John Doe', reports = 10},
        { id = 2, name = 'Jane Doe', reports = 5},
        { id = 3, name = 'John Smith', reports = 3},
        { id = 4, name = 'Jane Smith', reports = 2},
        { id = 5, name = 'John Johnson', reports = 1},
        { id = 6, name = 'Jane Johnson', reports = 0},
        { id = 7, name = 'John Brown', reports = 20},
        { id = 8, name = 'Jane Brown', reports = 22},
        { id = 9, name = 'John White', reports = 45},
        { id = 10, name = 'Jane White', reports = 75},
        { id = 11, name = 'John Green', reports = 12 },
        { id = 12, name = 'Jane Green', reports = 24 },
        { id = 13, name = 'John Black', reports = 31 },
        { id = 14, name = 'Jane Black', reports = 9 },
        { id = 15, name = 'John Blue', reports = 45 },
        { id = 16, name = 'Jane Blue', reports = 60 },
        { id = 17, name = 'John Silver', reports = 78 },
        { id = 18, name = 'Jane Silver', reports = 55 },
        { id = 19, name = 'John Gold', reports = 36 },
        { id = 20, name = 'Jane Gold', reports = 20 },
        { id = 21, name = 'John Copper', reports = 50 },
        { id = 22, name = 'Jane Copper', reports = 72 },
        { id = 23, name = 'John Iron', reports = 5 },
        { id = 24, name = 'Jane Iron', reports = 84 },
        { id = 25, name = 'John Steel', reports = 18 },
        { id = 26, name = 'Jane Steel', reports = 67 },
        { id = 27, name = 'John Platinum', reports = 40 },
        { id = 28, name = 'Jane Platinum', reports = 90 },
        { id = 29, name = 'John Diamond', reports = 100 },
        { id = 30, name = 'Jane Diamond', reports = 80 }
    }
    table.sort(leaderboardRes, function(a, b) return a.reports > b.reports end)
    UIMessage("nui:state:leaderboard", leaderboardRes)
end)