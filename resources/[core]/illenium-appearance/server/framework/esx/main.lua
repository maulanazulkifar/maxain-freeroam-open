if not Framework.ESX() then return end

local ESX = exports["es_extended"]:getSharedObject()

function Framework.GetPlayerID(src)
    if not src or src == 0 then return nil end
    local Player = ESX.GetPlayerFromId(src)
    if Player and Player.identifier then
        return Player.identifier
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
    if type == "cash" then
        type = "money"
    end
    local Player = ESX.GetPlayerFromId(src)
    if Player and Player.getAccount then
        local account = Player.getAccount(type)
        return account and account.money >= money
    end
    return true
end

function Framework.RemoveMoney(src, type, money)
    if type == "cash" then
        type = "money"
    end
    local Player = ESX.GetPlayerFromId(src)
    if Player and Player.getAccount then
        local account = Player.getAccount(type)
        if account and account.money >= money then
            Player.removeAccountMoney(type, money)
            return true
        end
    end
    return true
end

function normalizeGrade(job)
    if not job then return { grade = { level = 0 } } end
    job.grade = {
        level = job.grade or 0
    }
    return job
end

function Framework.GetJob(src)
    local Player = ESX.GetPlayerFromId(src)
    if Player and Player.getJob then
        return normalizeGrade(Player.getJob())
    end
    return { name = "unemployed", grade = { level = 0 } }
end

function Framework.GetGang(src)
    local Player = ESX.GetPlayerFromId(src)
    if Player and Player.getJob then
        return normalizeGrade(Player.getJob())
    end
    return { name = "none", grade = { level = 0 } }
end

function Framework.SaveAppearance(appearance, citizenID)
    Database.Users.UpdateSkinForUser(citizenID, json.encode(appearance))
end

function Framework.GetAppearance(citizenID)
    local user = Database.Users.GetSkinByCitizenID(citizenID)
    if user then
        local skin = json.decode(user.skin)
        if skin then
            skin.sex = skin.model == "mp_m_freemode_01" and 0 or 1
            return skin
        end
    end
    return nil
end
