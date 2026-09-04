QBCore = {}
QBCore.Config = {}

-- Server Settings
QBCore.Config.Server = {
    Closed = false,
    ClosedReason = 'Server Maintenance',
    Uptime = 0,
    Whitelist = false,
    DefaultMaxPlayers = 48,
    PVP = true,
    Discord = '',
    CheckDuplicateLicense = true,
    Permissions = { 'god', 'admin', 'mod' }
}

-- Money Settings (Freeroam starting money)
QBCore.Config.Money = {
    MoneyTypes = { cash = 100000, bank = 500000, crypto = 0 },
    DontClearOnDeath = true
}

-- Player Settings
QBCore.Config.Player = {
    HungerRate = 0, -- Disabled for freeroam
    ThirstRate = 0, -- Disabled for freeroam
    Bloodtypes = { "A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-" },
}

-- Commands Setup
QBCore.Config.Commands = {
    ['tp'] = 'admin',
    ['car'] = 'admin',
    ['dv'] = 'admin',
    ['givemoney'] = 'admin',
    ['setmoney'] = 'admin',
}

-- Default Spawn Location for Freeroam (Legion Square / Airport spawn)
QBCore.Config.DefaultSpawn = vector4(294.2, -584.2, 43.2, 69.0)
