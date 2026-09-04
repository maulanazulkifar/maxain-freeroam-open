local QBCore = exports['qb-core']:GetCoreObject()
local isOpen = false

function ToggleSpawner(state)
    isOpen = state
    SetNuiFocus(isOpen, isOpen)
    SendNUIMessage({
        type = "TOGGLE_SPAWNER",
        show = isOpen,
        categories = Config.Categories
    })
end

RegisterCommand(Config.Command or 'qbspawner', function()
    ToggleSpawner(not isOpen)
end, false)

RegisterKeyMapping(Config.Command or 'qbspawner', 'Open QBCore Vehicle Spawner', 'keyboard', Config.Hotkey or 'F6')

RegisterNUICallback('close', function(_, cb)
    ToggleSpawner(false)
    cb('ok')
end)

RegisterNUICallback('spawnVehicle', function(data, cb)
    local model = data.model
    if model then
        local ped = PlayerPedId()
        local currentVeh = GetVehiclePedIsIn(ped, false)
        if currentVeh ~= 0 then
            QBCore.Functions.DeleteVehicle(currentVeh)
        end

        QBCore.Functions.SpawnVehicle(model, function(veh)
            SetVehicleNumberPlateText(veh, "QB " .. math.random(100, 999))
            QBCore.Functions.Notify("Spawned: " .. model, "success")
        end, nil, true)
    end
    ToggleSpawner(false)
    cb('ok')
end)
