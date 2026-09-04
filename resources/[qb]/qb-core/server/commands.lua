RegisterCommand('tp', function(source, args)
    local src = source
    if not QBCore.Functions.HasPermission(src, 'admin') then return end
    local x, y, z = tonumber(args[1]), tonumber(args[2]), tonumber(args[3])
    if x and y and z then
        TriggerClientEvent('QBCore:Command:Teleport', src, x, y, z)
    end
end, false)

RegisterCommand('car', function(source, args)
    local src = source
    if not QBCore.Functions.HasPermission(src, 'admin') then return end
    local model = args[1] or 'adder'
    TriggerClientEvent('QBCore:Command:SpawnVehicle', src, model)
end, false)

RegisterCommand('dv', function(source)
    local src = source
    if not QBCore.Functions.HasPermission(src, 'admin') then return end
    TriggerClientEvent('QBCore:Command:DeleteVehicle', src)
end, false)
