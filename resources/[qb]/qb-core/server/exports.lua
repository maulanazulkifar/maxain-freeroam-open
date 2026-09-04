exports('GetFunctions', function()
    return QBCore.Functions
end)

exports('GetPlayerData', function(source)
    local player = QBCore.Functions.GetPlayer(source)
    if player then
        return player.PlayerData
    end
    return nil
end)
