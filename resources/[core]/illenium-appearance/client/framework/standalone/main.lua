if not Framework.Standalone() then return end

local client = client
local isLoaded = false

RegisterNetEvent("playerSpawned", function()
    if not isLoaded then
        isLoaded = true
        InitAppearance()
    end
end)

function Framework.GetPlayerGender()
    local model = client.getPedModel(cache.ped)
    if model == "mp_f_freemode_01" then
        return "Female"
    end
    return "Male"
end

function Framework.UpdatePlayerData()
    client.job = { name = "unemployed", grade = { level = 0 } }
    client.gang = { name = "none", grade = { level = 0 } }
    client.citizenid = "standalone"
end

function Framework.HasTracker()
    return false
end

function Framework.CheckPlayerMeta()
    return IsPedDeadOrDying(cache.ped, true) or IsPedCuffed(cache.ped)
end

function Framework.IsPlayerAllowed(citizenid)
    return true
end

function Framework.GetRankInputValues()
    return {}
end

function Framework.GetJobGrade()
    return 0
end

function Framework.GetGangGrade()
    return 0
end

function Framework.CachePed() end

function Framework.RestorePlayerArmour() end
