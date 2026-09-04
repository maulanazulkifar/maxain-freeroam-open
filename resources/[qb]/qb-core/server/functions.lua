QBCore.Functions = QBCore.Functions or {}
QBCore.ServerCallbacks = {}

function QBCore.Functions.GetPlayer(source)
    local src = tonumber(source)
    if not src then return nil end
    return QBCore.Players[src]
end

function QBCore.Functions.GetPlayerByCitizenId(citizenid)
    for _, player in pairs(QBCore.Players) do
        if player.PlayerData.citizenid == citizenid then
            return player
        end
    end
    return nil
end

function QBCore.Functions.GetPlayers()
    local sources = {}
    for src, _ in pairs(QBCore.Players) do
        sources[#sources + 1] = src
    end
    return sources
end

function QBCore.Functions.CreateCallback(name, cb)
    QBCore.ServerCallbacks[name] = cb
end

function QBCore.Functions.TriggerCallback(name, requestId, source, cb, ...)
    local src = source
    if QBCore.ServerCallbacks[name] then
        QBCore.ServerCallbacks[name](src, function(...)
            TriggerClientEvent('QBCore:Client:ServerCallback', src, requestId, ...)
        end, ...)
    end
end

RegisterNetEvent('QBCore:Server:TriggerCallback', function(name, requestId, ...)
    local src = source
    QBCore.Functions.TriggerCallback(name, requestId, src, nil, ...)
end)

function QBCore.Functions.HasPermission(source, permission)
    if IsPlayerAceAllowed(tostring(source), 'command') or IsPlayerAceAllowed(tostring(source), 'group.admin') then
        return true
    end
    return false
end

function QBCore.Functions.SpawnVehicle(source, model, coords, warp)
    local src = source
    local ped = GetPlayerPed(src)
    local modelHash = type(model) == 'number' and model or joaat(model)
    local veh = CreateVehicleServerSetter(modelHash, 'automobile', coords.x, coords.y, coords.z, coords.w)
    while not DoesEntityExist(veh) do Wait(10) end
    if warp then
        TaskWarpPedIntoVehicle(ped, veh, -1)
    end
    return veh
end
