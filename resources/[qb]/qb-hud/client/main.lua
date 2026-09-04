local QBCore = exports['qb-core']:GetCoreObject()
local isHUDVisible = true

CreateThread(function()
    while true do
        Wait(Config.UpdateInterval or 200)
        local ped = PlayerPedId()
        
        if isHUDVisible and DoesEntityExist(ped) and not IsPauseMenuActive() then
            local health = math.max(0, GetEntityHealth(ped) - 100)
            local armor = GetPedArmour(ped)
            local stamina = 100 - GetPlayerStamina(PlayerId())
            
            local inVehicle = IsPedInAnyVehicle(ped, false)
            local speed = 0
            local gear = 0
            local fuel = 100

            if inVehicle then
                local vehicle = GetVehiclePedIsIn(ped, false)
                local speedMs = GetEntitySpeed(vehicle)
                speed = math.floor(Config.SpeedometerUnit == 'KMH' and (speedMs * 3.6) or (speedMs * 2.236936))
                gear = GetVehicleCurrentGear(vehicle)
                fuel = math.floor(GetVehicleFuelLevel(vehicle))
            end

            SendNUIMessage({
                type = "UPDATE_HUD",
                show = true,
                health = health,
                armor = armor,
                stamina = math.floor(stamina),
                inVehicle = inVehicle,
                speed = speed,
                unit = Config.SpeedometerUnit or 'KMH',
                gear = gear,
                fuel = fuel
            })
        else
            SendNUIMessage({
                type = "UPDATE_HUD",
                show = false
            })
        end
    end
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    isHUDVisible = true
end)

RegisterNetEvent('qb-hud:client:ToggleHUD', function(state)
    isHUDVisible = state
end)
