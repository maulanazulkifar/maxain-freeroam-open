local isMenuOpen = false
local previewVehicle = nil
local previewCam = nil
local isPreviewing = false
local previewHeading = 0.0
local spawnedProps = {}

-- Stop 3D Camera Preview
local function Stop3DPreview()
    isPreviewing = false
    if DoesEntityExist(previewVehicle) then
        DeleteVehicle(previewVehicle)
        previewVehicle = nil
    end
    if previewCam and DoesCamExist(previewCam) then
        RenderScriptCams(false, true, 500, true, true)
        DestroyCam(previewCam, false)
        previewCam = nil
    end
end

-- Start 3D Camera Preview in-game
local function Start3DPreview(modelName, primaryColor, secondaryColor)
    Stop3DPreview()

    if not modelName or modelName == "" then return end
    local modelHash = GetHashKey(modelName)

    if not IsModelInCdimage(modelHash) or not IsModelAVehicle(modelHash) then return end

    RequestModel(modelHash)
    local timeout = 0
    while not HasModelLoaded(modelHash) and timeout < 300 do
        Wait(10)
        timeout = timeout + 1
    end

    if not HasModelLoaded(modelHash) then return end

    local ped = PlayerPedId()
    local playerCoords = GetEntityCoords(ped)
    local forwardVector = GetEntityForwardVector(ped)
    local spawnCoords = playerCoords + (forwardVector * 4.5)
    local spawnHeading = GetEntityHeading(ped) + 180.0

    previewVehicle = CreateVehicle(modelHash, spawnCoords.x, spawnCoords.y, spawnCoords.z, spawnHeading, false, false)

    if DoesEntityExist(previewVehicle) then
        SetVehicleOnGroundProperly(previewVehicle)
        SetEntityCollision(previewVehicle, false, false)
        FreezeEntityPosition(previewVehicle, true)
        SetVehicleEngineOn(previewVehicle, false, false, true)
        SetVehicleAlpha(previewVehicle, 255, false)

        if primaryColor and secondaryColor then
            SetVehicleColours(previewVehicle, tonumber(primaryColor) or 0, tonumber(secondaryColor) or 0)
        end

        local camCoords = spawnCoords + (forwardVector * -4.0) + vector3(0.0, 0.0, 1.5)

        previewCam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
        SetCamCoord(previewCam, camCoords.x, camCoords.y, camCoords.z)
        PointCamAtEntity(previewCam, previewVehicle, 0.0, 0.0, 0.2, true)
        SetCamActive(previewCam, true)
        RenderScriptCams(true, true, 600, true, true)

        isPreviewing = true
        previewHeading = spawnHeading

        CreateThread(function()
            while isPreviewing and DoesEntityExist(previewVehicle) do
                previewHeading = previewHeading + 0.5
                if previewHeading >= 360.0 then previewHeading = 0.0 end
                SetEntityHeading(previewVehicle, previewHeading)
                Wait(20)
            end
        end)
    end

    SetModelAsNoLongerNeeded(modelHash)
end

-- Open/Close NUI Menu
local function ToggleSpawnerMenu(open, initialMode)
    if open == nil then open = not isMenuOpen end
    isMenuOpen = open

    SetNuiFocus(isMenuOpen, isMenuOpen)
    if isMenuOpen then
        SendNUIMessage({
            action = "openMenu",
            mode = initialMode or "vehicles",
            vehicles = Config.Vehicles,
            categories = Config.Categories,
            props = Config.Props,
            propCategories = Config.PropCategories
        })
    else
        Stop3DPreview()
        SendNUIMessage({
            action = "closeMenu"
        })
    end
end

-- Commands & Keybinds
RegisterCommand(Config.CommandName, function()
    ToggleSpawnerMenu(true, "vehicles")
end, false)

if Config.AlternativeCommand then
    RegisterCommand(Config.AlternativeCommand, function()
        ToggleSpawnerMenu(true, "vehicles")
    end, false)
end

if Config.PropCommand then
    RegisterCommand(Config.PropCommand, function()
        ToggleSpawnerMenu(true, "props")
    end, false)
end

RegisterKeyMapping(Config.CommandName, 'Toggle Vehicle/Prop Spawner Menu', 'keyboard', Config.DefaultKey)

-- NUI Callbacks
RegisterNUICallback('close', function(data, cb)
    ToggleSpawnerMenu(false)
    cb('ok')
end)

RegisterNUICallback('start3DPreview', function(data, cb)
    Start3DPreview(data.model, data.primaryColor, data.secondaryColor)
    cb('ok')
end)

RegisterNUICallback('stop3DPreview', function(data, cb)
    Stop3DPreview()
    cb('ok')
end)

RegisterNUICallback('spawnVehicle', function(data, cb)
    Stop3DPreview()

    local modelName = data.model
    if not modelName or modelName == "" then
        cb({ success = false, message = "Invalid vehicle model" })
        return
    end

    local modelHash = GetHashKey(modelName)

    if not IsModelInCdimage(modelHash) or not IsModelAVehicle(modelHash) then
        TriggerEvent('chat:addMessage', {
            color = { 255, 50, 50 },
            multiline = true,
            args = { "Spawner", "Vehicle model '" .. modelName .. "' is invalid!" }
        })
        cb({ success = false, message = "Vehicle model not found" })
        return
    end

    RequestModel(modelHash)
    local timeout = 0
    while not HasModelLoaded(modelHash) and timeout < 500 do
        Wait(10)
        timeout = timeout + 1
    end

    if not HasModelLoaded(modelHash) then
        cb({ success = false, message = "Model failed to load" })
        return
    end

    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local heading = GetEntityHeading(ped)

    if Config.DeleteOldVehicle and IsPedInAnyVehicle(ped, false) then
        local currentVeh = GetVehiclePedIsIn(ped, false)
        SetEntityAsMissionEntity(currentVeh, true, true)
        DeleteVehicle(currentVeh)
    end

    local vehicle = CreateVehicle(modelHash, coords.x, coords.y, coords.z + 0.5, heading, true, false)

    if DoesEntityExist(vehicle) then
        SetVehicleOnGroundProperly(vehicle)
        SetEntityAsMissionEntity(vehicle, true, true)
        
        if data.primaryColor and data.secondaryColor then
            SetVehicleColours(vehicle, tonumber(data.primaryColor) or 0, tonumber(data.secondaryColor) or 0)
        end

        if Config.SpawnInsideVehicle or Config.WarpPlayerIn then
            TaskWarpPedIntoVehicle(ped, vehicle, -1)
        end

        SetModelAsNoLongerNeeded(modelHash)

        TriggerEvent('chat:addMessage', {
            color = { 0, 230, 150 },
            multiline = true,
            args = { "Maxain Spawner", "Successfully spawned " .. (data.name or modelName) .. "!" }
        })

        ToggleSpawnerMenu(false)
        cb({ success = true })
    else
        SetModelAsNoLongerNeeded(modelHash)
        cb({ success = false, message = "Failed to create vehicle entity" })
    end
end)

-- Prop / Object Spawning
RegisterNUICallback('spawnProp', function(data, cb)
    local modelName = data.model
    if not modelName or modelName == "" then
        cb({ success = false })
        return
    end

    local modelHash = GetHashKey(modelName)
    if not IsModelInCdimage(modelHash) or not IsModelValid(modelHash) then
        TriggerEvent('chat:addMessage', {
            color = { 255, 50, 50 },
            multiline = true,
            args = { "Prop Spawner", "Prop model '" .. modelName .. "' not found!" }
        })
        cb({ success = false })
        return
    end

    RequestModel(modelHash)
    local timeout = 0
    while not HasModelLoaded(modelHash) and timeout < 300 do
        Wait(10)
        timeout = timeout + 1
    end

    if not HasModelLoaded(modelHash) then
        cb({ success = false })
        return
    end

    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local forward = GetEntityForwardVector(ped)
    local heading = GetEntityHeading(ped)

    local spawnCoords = coords + (forward * 2.5)

    local propObj = CreateObject(modelHash, spawnCoords.x, spawnCoords.y, spawnCoords.z, true, true, false)

    if DoesEntityExist(propObj) then
        PlaceObjectOnGroundProperly(propObj)
        SetEntityHeading(propObj, heading)
        FreezeEntityPosition(propObj, true)
        SetEntityAsMissionEntity(propObj, true, true)

        table.insert(spawnedProps, propObj)

        TriggerEvent('chat:addMessage', {
            color = { 0, 230, 150 },
            multiline = true,
            args = { "Maxain Spawner", "Spawned object: " .. (data.name or modelName) }
        })

        SetModelAsNoLongerNeeded(modelHash)
        cb({ success = true, count = #spawnedProps })
    else
        SetModelAsNoLongerNeeded(modelHash)
        cb({ success = false })
    end
end)

-- Clear Player Props
RegisterNUICallback('clearAllProps', function(data, cb)
    local deletedCount = 0
    for _, prop in ipairs(spawnedProps) do
        if DoesEntityExist(prop) then
            DeleteEntity(prop)
            deletedCount = deletedCount + 1
        end
    end
    spawnedProps = {}

    TriggerEvent('chat:addMessage', {
        color = { 255, 180, 0 },
        multiline = true,
        args = { "Maxain Spawner", "Cleared all (" .. deletedCount .. ") spawned objects!" }
    })
    cb({ success = true, deleted = deletedCount })
end)

RegisterNUICallback('deleteLastProp', function(data, cb)
    if #spawnedProps > 0 then
        local lastProp = table.remove(spawnedProps)
        if DoesEntityExist(lastProp) then
            DeleteEntity(lastProp)
        end
        cb({ success = true, remaining = #spawnedProps })
    else
        cb({ success = false, remaining = 0 })
    end
end)

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        Stop3DPreview()
        if isMenuOpen then
            SetNuiFocus(false, false)
        end
    end
end)
