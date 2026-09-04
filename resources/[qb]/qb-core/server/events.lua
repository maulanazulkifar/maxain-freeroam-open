RegisterNetEvent('QBCore:Server:PlayerJoined', function()
    local src = source
    QBCore.Player.Login(src)
end)

AddEventHandler('playerDropped', function(reason)
    local src = source
    QBCore.Player.Logout(src)
end)

RegisterNetEvent('QBCore:GetObject', function(cb)
    cb(QBCore)
end)
