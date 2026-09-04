Config = {}

-- Secret token required in HTTP Authorization header: "Bearer maxain_secret_api_key_2026"
Config.APISecretKey = "maxain_secret_api_key_2026"

Config.Debug = false

-- Storage path for illenium-appearance shared peds
Config.PedsFilePath = "resources/[core]/illenium-appearance/shared/peds.lua"

-- Initial catalog data (if database table is not present)
Config.DefaultVehicles = {
    { spawnName = "elegy", label = "Annis Elegy RH8", category = "Drift", price = 45000 },
    { spawnName = "sultan", label = "Karin Sultan", category = "JDM", price = 32000 },
    { spawnName = "futogts", label = "Karin Futo GTS", category = "Drift", price = 28000 },
    { spawnName = "banshee", label = "Bravado Banshee", category = "Sports", price = 65000 },
    { spawnName = "comet2", label = "Pfister Comet SR", category = "Super", price = 120000 }
}
