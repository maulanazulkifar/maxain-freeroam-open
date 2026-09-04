if not Framework.QBCore() then return end

local client = client

local QBCore = exports["qb-core"]:GetCoreObject()

local PlayerData = QBCore.Functions.GetPlayerData()

local function getRankInputValues(rankList)
    local rankValues = {}
    for k, v in pairs(rankList) do
        rankValues[#rankValues + 1] = {
            label = v.name,
            value = k
        }
    end
    return rankValues
end

local function setClientParams()
    if not PlayerData then return end
    client.job = PlayerData.job or { name = "unemployed", grade = { level = 0 } }
    client.gang = PlayerData.gang or { name = "none", grade = { level = 0 } }
    client.citizenid = PlayerData.citizenid
end

function Framework.GetPlayerGender()
    if PlayerData and PlayerData.charinfo and PlayerData.charinfo.gender == 1 then
        return "Female"
    end
    return "Male"
end

function Framework.UpdatePlayerData()
    PlayerData = QBCore.Functions.GetPlayerData() or {}
    setClientParams()
end

function Framework.HasTracker()
    local pd = QBCore.Functions.GetPlayerData()
    return pd and pd.metadata and pd.metadata["tracker"] or false
end

function Framework.CheckPlayerMeta()
    if not PlayerData or not PlayerData.metadata then return false end
    return PlayerData.metadata["isdead"] or PlayerData.metadata["inlaststand"] or PlayerData.metadata["ishandcuffed"]
end

function Framework.IsPlayerAllowed(citizenid)
    if not PlayerData or not PlayerData.citizenid then return true end
    return citizenid == PlayerData.citizenid
end

function Framework.GetRankInputValues(type)
    local jobName = (client.job and client.job.name) or "unemployed"
    local gangName = (client.gang and client.gang.name) or "none"
    local grades = (QBCore.Shared.Jobs[jobName] and QBCore.Shared.Jobs[jobName].grades) or {}
    if type == "gang" then
        grades = (QBCore.Shared.Gangs[gangName] and QBCore.Shared.Gangs[gangName].grades) or {}
    end
    return getRankInputValues(grades)
end

function Framework.GetJobGrade()
    return (client.job and client.job.grade and client.job.grade.level) or 0
end

function Framework.GetGangGrade()
    return (client.gang and client.gang.grade and client.gang.grade.level) or 0
end

RegisterNetEvent("QBCore:Client:OnJobUpdate", function(JobInfo)
    PlayerData.job = JobInfo
    client.job = JobInfo
    ResetBlips()
end)

RegisterNetEvent("QBCore:Client:OnGangUpdate", function(GangInfo)
    PlayerData.gang = GangInfo
    client.gang = GangInfo
    ResetBlips()
end)

RegisterNetEvent("QBCore:Client:SetDuty", function(duty)
    if PlayerData and PlayerData.job then
        PlayerData.job.onduty = duty
        client.job = PlayerData.job
    end
end)

RegisterNetEvent("QBCore:Client:OnPlayerLoaded", function()
    InitAppearance()
end)

RegisterNetEvent("qb-clothes:client:CreateFirstCharacter", function()
    QBCore.Functions.GetPlayerData(function(pd)
        PlayerData = pd
        setClientParams()
        InitializeCharacter(Framework.GetGender(true))
    end)
end)

function Framework.CachePed()
    return nil
end

function Framework.RestorePlayerArmour()
    Framework.UpdatePlayerData()
    if PlayerData and PlayerData.metadata then
        Wait(1000)
        SetPedArmour(cache.ped, PlayerData.metadata["armor"])
    end
end
