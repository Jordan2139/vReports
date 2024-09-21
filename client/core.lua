Script = {
    state = {
        settingsLoaded = false,
    }
}

PlayerData = {}

---@type ActiveReport[]
MyReports = {}

staffTracker = {}

SetTimeout(2000, function()
    Debug("[client/core] Sending the scriptConfig to the NUI.")
    UIMessage("nui:state:scriptconfig", Config)
end)

RegisterNetEvent('staffTracker:client:updateTracker', function(data)
    staffTracker = data
    nuiData = {}
    for k, v in pairs(staffTracker) do
        table.insert(nuiData, {
            id = v.discord,
            reports = v.reports,
            name = v.discordName,
        })
    end
    table.sort(nuiData, function(a, b) return a.reports > b.reports end)
    UIMessage("nui:state:leaderboard", nuiData)
end)