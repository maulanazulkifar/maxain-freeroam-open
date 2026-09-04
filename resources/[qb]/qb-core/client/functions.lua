QBCore.Functions = QBCore.Functions or {}
QBCore.ClientCallbacks = {}

function QBCore.Functions.GetPlayerData(cb)
    if cb then
        cb(QBCore.PlayerData)
    end
    return QBCore.PlayerData
end

function QBCore.Functions.Notify(text, texttype, length)
    local msgType = texttype or 'primary'
    BeginTextCommandThefeedPost("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandThefeedPostTicker(false, true)
end

function QBCore.Functions.TriggerCallback(name, cb, ...)
    local requestId = #QBCore.ClientCallbacks + 1
    QBCore.ClientCallbacks[requestId] = cb
    TriggerServerEvent('QBCore:Server:TriggerCallback', name, requestId, ...)
end

RegisterNetEvent('QBCore:Client:ServerCallback', function(requestId, ...)
    if QBCore.ClientCallbacks[requestId] then
        QBCore.ClientCallbacks[requestId](...)
        QBCore.ClientCallbacks[requestId] = nil
    end
end)

function QBCore.Functions.SpawnVehicle(model, cb, coords, isnetworked)
    local modelHash = type(model) == 'number' and model or joaat(model)
    if not IsModelInCdimage(modelHash) then return end

    RequestModel(modelHash)
    while not HasModelLoaded(modelHash) do Wait(10) end

    local ped = PlayerPedId()
    local pCoords = coords or GetEntityCoords(ped)
    local heading = coords and coords.w or GetEntityHeading(ped)

    local veh = CreateVehicle(modelHash, pCoords.x, pCoords.y, pCoords.z, heading, isnetworked ~= false, false)
    SetEntityAsMissionEntity(veh, true, true)
    SetVehicleHasBeenOwnedByPlayer(veh, true)
    SetVehicleNeedsToBeHotwired(veh, false)
    SetModelAsNoLongerNeeded(modelHash)

    TaskWarpPedIntoVehicle(ped, veh, -1)

    if cb then cb(veh) end
    return veh
end

function QBCore.Functions.DeleteVehicle(vehicle)
    SetEntityAsMissionEntity(vehicle, true, true)
    DeleteVehicle(vehicle)
end

function QBCore.Functions.GetVehicles()
    return GetGamePool('CVehicle')
end
