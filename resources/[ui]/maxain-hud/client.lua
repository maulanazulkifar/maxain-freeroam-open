local inVehicle = false
local driftActive = false

-- Export or Event to update Drift state from maxain-drift script
RegisterNetEvent('maxain-hud:setDriftState', function(state)
    driftActive = state
    SendNUIMessage({
        type = "updateDrift",
        drift = driftActive
    })
end)

CreateThread(function()
    while true do
        local sleep = 500
        local playerPed = PlayerPedId()

        if IsPedInAnyVehicle(playerPed, false) then
            sleep = 100
            local vehicle = GetVehiclePedIsIn(playerPed, false)
            
            -- Only show HUD if player is driver or passenger in vehicle
            if GetPedInVehicleSeat(vehicle, -1) == playerPed or GetPedInVehicleSeat(vehicle, 0) == playerPed then
                inVehicle = true
                
                -- Calculate metrics
                local speedMs = GetEntitySpeed(vehicle)
                local speedKmh = math.floor(speedMs * 3.6)
                local gear = GetVehicleCurrentGear(vehicle)
                if gear == 0 and speedKmh > 0 then
                    gear = "R"
                elseif gear == 0 then
                    gear = "N"
                end

                local rpm = math.floor(GetVehicleCurrentRpm(vehicle) * 100)
                local fuel = math.floor(GetVehicleFuelLevel(vehicle))
                
                -- Get Street Name
                local coords = GetEntityCoords(playerPed)
                local streetHash, crossingHash = GetStreetNameAtCoord(coords.x, coords.y, coords.z)
                local streetName = GetStreetNameFromHashKey(streetHash)
                local crossingName = GetStreetNameFromHashKey(crossingHash)
                local locationText = streetName
                if crossingName and crossingName ~= "" then
                    locationText = streetName .. " / " .. crossingName
                end

                SendNUIMessage({
                    type = "updateHud",
                    show = true,
                    speed = speedKmh,
                    gear = tostring(gear),
                    rpm = rpm,
                    fuel = fuel,
                    street = locationText,
                    drift = driftActive
                })
            else
                if inVehicle then
                    inVehicle = false
                    SendNUIMessage({ type = "updateHud", show = false })
                end
            end
        else
            if inVehicle then
                inVehicle = false
                SendNUIMessage({ type = "updateHud", show = false })
            end
        end

        Wait(sleep)
    end
end)
