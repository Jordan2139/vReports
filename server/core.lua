---@type OnlineStaff[]
OnlineStaff = {}

---@type ActiveReport[]
ActiveReports = {}

staffTracker = {}

AddEventHandler("playerJoining", function(_srcString, _oldId)
    if source <= 0 then
        Debug("(Error) [eventHandler:playerJoining] source is nil, returning.")
        return
    end

    local playerName = GetPlayerName(source)

    if type(playerName) ~= "string" then
        return Debug("(Error) [eventHandler:playerJoining] Invalid Player name type: ",
            type(playerName))
    end

    CPlayer:new(source)
end)

AddEventHandler("playerDropped", function(reason)
    if OnlineStaff[source] then
        OnlineStaff[source] = nil
        Debug(("[eventHandler:playerDropped] %s was removed from the OnlineStaff table."):format(GetPlayerName(source)))
    end
end)

SetTimeout(1000, function()
    Debug("[Thread:LoopPlayerList] beginning.")
    CreateThread(function()
        local Players = GetPlayers()
        for i = 1, #Players do
            local player = Players[i]
            if OnlineStaff[player] then
                return Debug(("(Error) [Thread:LoopPlayerList] %s (ID - %s) is already in the OnlineStaff table.")
                    :format(GetPlayerName(player), player))
            end

            CPlayer:new(player)
        end
    end)
end)

AddEventHandler('onResourceStart', function(resourceName)
	if (GetCurrentResourceName() ~= resourceName) then
		return
	end
    local staffTrackerFile = LoadResourceFile(resourceName, "tracker.json")
    local staff = json.decode(staffTrackerFile)
    print('staffTrackerFile', json.encode(staffTrackerFile))
    for i = 1, #staff do
        table.insert(staffTracker, {
            discord = staff[i].discord,
            reports = staff[i].reports,
            discordName = GetDiscordName(staff[i].discord),
        })
    end
    print('sending staffTracker', json.encode(staffTracker))
    TriggerClientEvent('staffTracker:client:updateTracker', -1, staffTracker)
end)

AddEventHandler('playerJoining', function()
    TriggerClientEvent('staffTracker:client:updateTracker', source, staffTracker)
end)

function updateReports(userId)
    for i = 1, #staffTracker do
        if staffTracker[i].discord == userId then
            staffTracker[i].reports = staffTracker[i].reports + 1
            SaveResourceFile(GetCurrentResourceName(), "tracker.json", json.encode(staffTracker, { indent = true }), -1)
            TriggerClientEvent('staffTracker:client:updateTracker', -1, staffTracker)
            return
        end
    end
    table.insert(staffTracker, {
        discord = userId,
        reports = 1,
        discordName = GetDiscordName(userId),
    })
    SaveResourceFile(GetCurrentResourceName(), "tracker.json", json.encode(staffTracker, { indent = true }), -1)
    TriggerClientEvent('staffTracker:client:updateTracker', -1, staffTracker)
end