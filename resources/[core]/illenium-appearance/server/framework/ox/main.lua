if not Framework.Ox() then return end

local Ox = require '@ox_core.lib.init'

function Framework.GetPlayerID(playerId)
    if not playerId or playerId == 0 then return nil end
    local player = Ox.GetPlayer(playerId)
    if player and player.charId then
        return player.charId
    end

    local srcStr = tostring(playerId)
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

function Framework.HasMoney(playerId, item, amount)
    return exports.ox_inventory:GetItemCount(playerId, item) >= amount
end

function Framework.RemoveMoney(playerId, type, amount)
    return exports.ox_inventory:RemoveItem(playerId, type, amount)
end

function Framework.GetJob()
    return ---@todo
end

function Framework.GetGang()
    return ---@todo
end

function Framework.SaveAppearance(appearance, charId)
    Database.PlayerSkins.UpdateActiveField(charId, 0)
    Database.PlayerSkins.DeleteByModel(charId, appearance.model)
    Database.PlayerSkins.Add(charId, appearance.model, json.encode(appearance), 1)
end

function Framework.GetAppearance(charId, model)
    local result = Database.PlayerSkins.GetByCitizenID(charId, model)
    if result then
        return json.decode(result)
    end
end
