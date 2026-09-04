RegisterNetEvent('QBCore:Command:Teleport', function(x, y, z)
    local ped = PlayerPedId()
    SetEntityCoords(ped, x, y, z, false, false, false, false)
end)

RegisterNetEvent('QBCore:Command:SpawnVehicle', function(model)
    QBCore.Functions.SpawnVehicle(model)
end)

RegisterNetEvent('QBCore:Command:DeleteVehicle', function()
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped, false)
    if veh ~= 0 then
        QBCore.Functions.DeleteVehicle(veh)
    end
end)

RegisterNetEvent('QBCore:Client:Notify', function(text, type, length)
    QBCore.Functions.Notify(text, type, length)
end)
