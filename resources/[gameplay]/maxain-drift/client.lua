local isDrifting = false

local function toggleDriftMode()
    local ped = PlayerPedId()
    if not IsPedInAnyVehicle(ped, false) then
        if lib and lib.notify then
            lib.notify({ title = 'Maxain Drift', description = 'Anda harus berada di dalam kendaraan!', type = 'error' })
        end
        return
    end

    local vehicle = GetVehiclePedIsIn(ped, false)
    if GetPedInVehicleSeat(vehicle, -1) ~= ped then
        if lib and lib.notify then
            lib.notify({ title = 'Maxain Drift', description = 'Anda harus menjadi pengemudi!', type = 'error' })
        end
        return
    end

    isDrifting = not isDrifting
    SetVehicleReduceGrip(vehicle, isDrifting)

    -- Notify player via ox_lib notification
    if lib and lib.notify then
        if isDrifting then
            lib.notify({
                title = 'Maxain Drift Mode',
                description = 'DRIFT MODE: AKTIF 🏎️💨 (Tekan Shift/Command untuk nonaktif)',
                type = 'success',
                duration = 3000
            })
        else
            lib.notify({
                title = 'Maxain Drift Mode',
                description = 'DRIFT MODE: NON-AKTIF 🛑',
                type = 'inform',
                duration = 3000
            })
        end
    end

    -- Trigger event to update maxain-hud
    TriggerEvent('maxain-hud:setDriftState', isDrifting)
end

-- Command /drift
RegisterCommand('drift', function()
    toggleDriftMode()
end, false)

-- Register Keymapping (Default: Shift / LSHIFT key)
RegisterKeyMapping('drift', 'Toggle Drift Mode', 'keyboard', 'LSHIFT')

-- Reset grip if player leaves vehicle
CreateThread(function()
    while true do
        Wait(1000)
        local ped = PlayerPedId()
        if not IsPedInAnyVehicle(ped, false) and isDrifting then
            isDrifting = false
            TriggerEvent('maxain-hud:setDriftState', false)
        end
    end
end)
