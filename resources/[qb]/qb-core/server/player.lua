QBCore.Player = {}

function QBCore.Player.Login(source, citizenid, newData)
    local src = source
    local license = QBCore.Functions.GetIdentifier(src, 'license') or ('license:' .. tostring(src))
    local playerCitizenId = citizenid or QBCore.Shared.CreateCitizenId()
    
    local PlayerData = {
        source = src,
        citizenid = playerCitizenId,
        license = license,
        name = GetPlayerName(src) or ('Player_' .. src),
        money = { cash = QBCore.Config.Money.MoneyTypes.cash, bank = QBCore.Config.Money.MoneyTypes.bank },
        charinfo = { firstname = GetPlayerName(src) or 'Freeroamer', lastname = '', birthdate = '2000-01-01', gender = 0 },
        job = { name = 'unemployed', label = 'Freeroamer', grade = { name = 'Freeroamer', level = 0 } },
        gang = { name = 'none', label = 'No Gang', grade = { name = 'None', level = 0 } },
        metadata = { armor = 100, isdead = false }
    }

    local self = {}
    self.Functions = {}
    self.PlayerData = PlayerData

    function self.Functions.SetPlayerData(key, val)
        self.PlayerData[key] = val
    end

    function self.Functions.AddMoney(type, amount, reason)
        local moneyType = tostring(type):lower()
        if self.PlayerData.money[moneyType] then
            self.PlayerData.money[moneyType] = self.PlayerData.money[moneyType] + amount
            TriggerClientEvent('QBCore:Client:OnMoneyChange', self.PlayerData.source, moneyType, self.PlayerData.money[moneyType], amount, 'add')
            return true
        end
        return false
    end

    function self.Functions.RemoveMoney(type, amount, reason)
        local moneyType = tostring(type):lower()
        if self.PlayerData.money[moneyType] then
            self.PlayerData.money[moneyType] = math.max(0, self.PlayerData.money[moneyType] - amount)
            TriggerClientEvent('QBCore:Client:OnMoneyChange', self.PlayerData.source, moneyType, self.PlayerData.money[moneyType], amount, 'remove')
            return true
        end
        return false
    end

    function self.Functions.SetMoney(type, amount, reason)
        local moneyType = tostring(type):lower()
        if self.PlayerData.money[moneyType] then
            self.PlayerData.money[moneyType] = amount
            TriggerClientEvent('QBCore:Client:OnMoneyChange', self.PlayerData.source, moneyType, self.PlayerData.money[moneyType], amount, 'set')
            return true
        end
        return false
    end

    QBCore.Players[src] = self
    TriggerClientEvent('QBCore:Client:OnPlayerLoaded', src)
    print(string.format('^2[QBCore]^7 Player loaded: %s (CitizenID: %s)', PlayerData.name, PlayerData.citizenid))
    return true
end

function QBCore.Player.Logout(source)
    local src = source
    if QBCore.Players[src] then
        TriggerClientEvent('QBCore:Client:OnPlayerUnload', src)
        QBCore.Players[src] = nil
    end
end

function QBCore.Functions.GetIdentifier(source, idtype)
    local src = source
    local idtype = idtype or 'license'
    for _, identifier in pairs(GetPlayerIdentifiers(src)) do
        if string.find(identifier, idtype) then
            return identifier
        end
    end
    return nil
end
