if not Framework.QBCore() then return end

local QBCore = exports["qb-core"]:GetCoreObject()

function Framework.GetPlayerID(src)
    if not src or src == 0 then return nil end
    local Player = QBCore.Functions.GetPlayer(src)
    if Player and Player.PlayerData and Player.PlayerData.citizenid then
        return Player.PlayerData.citizenid
    end

    local srcStr = tostring(src)
    if GetPlayerIdentifierByType then
        local license = GetPlayerIdentifierByType(srcStr, 'license')
        if license then return license end
    end

    local ids = GetPlayerIdentifiers(srcStr)
    if ids and #ids > 0 then
        for _, id in ipairs(ids) do
            if id:sub(1, 8) == "license:" then return id end
        end
        return ids[1]
    end

    return srcStr
end

function Framework.HasMoney(src, type, money)
    local Player = QBCore.Functions.GetPlayer(src)
    if Player and Player.PlayerData and Player.PlayerData.money then
        return (Player.PlayerData.money[type] or 0) >= money
    end
    return true
end

function Framework.RemoveMoney(src, type, money)
    local Player = QBCore.Functions.GetPlayer(src)
    if Player then
        return Player.Functions.RemoveMoney(type, money)
    end
    return true
end

function Framework.GetJob(src)
    local Player = QBCore.Functions.GetPlayer(src)
    if Player and Player.PlayerData and Player.PlayerData.job then
        return Player.PlayerData.job
    end
    return { name = "unemployed", grade = { level = 0 } }
end

function Framework.GetGang(src)
    local Player = QBCore.Functions.GetPlayer(src)
    if Player and Player.PlayerData and Player.PlayerData.gang then
        return Player.PlayerData.gang
    end
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
