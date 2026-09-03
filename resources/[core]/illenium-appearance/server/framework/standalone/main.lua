if not Framework.Standalone() then return end

function Framework.GetPlayerID(src)
    if not src or src == 0 then return nil end
    local srcStr = tostring(src)

    -- 1. Try player-data export if available
    if GetResourceState("player-data") == "started" then
        local pData = exports["player-data"]
        if pData and pData.getPlayerId then
            local dbId = pData:getPlayerId(srcStr)
            if dbId then return tostring(dbId) end
        end
    end

    -- 2. Try state bag
    local playerState = Player(src)
    if playerState and playerState.state and playerState.state['cfx.re/playerData@id'] then
        return tostring(playerState.state['cfx.re/playerData@id'])
    end

    -- 3. Fallback to license identifier or first identifier or source ID
    if GetPlayerIdentifierByType then
        local license = GetPlayerIdentifierByType(srcStr, 'license')
        if license then return license end
    end

    for _, identifier in ipairs(GetPlayerIdentifiers(srcStr)) do
        if identifier:sub(1, 8) == "license:" then
            return identifier
        end
    end

    local ids = GetPlayerIdentifiers(srcStr)
    if ids and #ids > 0 then
        return ids[1]
    end

    return srcStr
end

function Framework.HasMoney(src, type, money)
    return true
end

function Framework.RemoveMoney(src, type, money)
    return true
end

function Framework.GetJob(src)
    return { name = "unemployed", grade = { level = 0 } }
end

function Framework.GetGang(src)
    return { name = "none", grade = { level = 0 } }
end

function Framework.SaveAppearance(appearance, citizenID)
    Database.PlayerSkins.UpdateActiveField(citizenID, 0)
    Database.PlayerSkins.DeleteByModel(citizenID, appearance.model)
    Database.PlayerSkins.Add(citizenID, appearance.model, json.encode(appearance), 1)
end

function Framework.GetAppearance(citizenID, model)
    local result = Database.PlayerSkins.GetByCitizenID(citizenID, model)
    if result then
        return json.decode(result)
    end
end
