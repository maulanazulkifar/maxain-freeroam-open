QBCore = QBCore or {}
QBCore.PlayerData = QBCore.PlayerData or {}
QBCore.Functions = QBCore.Functions or {}
QBCore.isLoggedIn = false

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    QBCore.isLoggedIn = true
    QBCore.PlayerData = QBCore.Functions.GetPlayerData()
    TriggerEvent('QBCore:Client:OnPlayerInitialSpawn')
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    QBCore.isLoggedIn = false
    QBCore.PlayerData = {}
end)

AddEventHandler('playerSpawned', function()
    TriggerServerEvent('QBCore:Server:PlayerJoined')
end)

CreateThread(function()
    while true do
        if NetworkIsPlayerActive(PlayerId()) then
            TriggerServerEvent('QBCore:Server:PlayerJoined')
            break
        end
        Wait(500)
    end
end)
