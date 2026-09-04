Config = Config or {}

Config.Hotkey = 'F6' -- Hotkey to open vehicle spawner
Config.Command = 'qbspawner'

Config.Categories = {
    {
        id = 'super',
        label = 'Supercars',
        vehicles = {
            { name = 'Adder', model = 'adder', brand = 'Truffade' },
            { name = 'T20', model = 't20', brand = 'Progen' },
            { name = 'Zentorno', model = 'zentorno', brand = 'Pegassi' },
            { name = 'Osiris', model = 'osiris', brand = 'Pegassi' },
            { name = 'X80 Proto', model = 'prototipo', brand = 'Grotti' }
        }
    },
    {
        id = 'sports',
        label = 'Sports & Drift',
        vehicles = {
            { name = 'Elegy RH8', model = 'elegy', brand = 'Annis' },
            { name = 'Sultan RS', model = 'sultanrs', brand = 'Karin' },
            { name = 'Banshee 900R', model = 'banshee2', brand = 'Bravado' },
            { name = 'Comet SR', model = 'comet5', brand = 'Pfister' },
            { name = 'Jester Classic', model = 'jester3', brand = 'Dinka' }
        }
    },
    {
        id = 'motorcycles',
        label = 'Motorcycles',
        vehicles = {
            { name = 'Bati 801', model = 'bati', brand = 'Pegassi' },
            { name = 'Hakuchou Drag', model = 'hakuchou2', brand = 'Shitzu' },
            { name = 'Sanchez', model = 'sanchez', brand = 'Maibatsu' },
            { name = 'Akuma', model = 'akuma', brand = 'Dinka' }
        }
    },
    {
        id = 'offroad',
        label = 'Offroad & SUVs',
        vehicles = {
            { name = 'Trophy Truck', model = 'trophytruck', brand = 'Vapid' },
            { name = 'Kamacho', model = 'kamacho', brand = 'Canis' },
            { name = 'Dubsta 6x6', model = 'dubsta3', brand = 'Benefactor' }
        }
    }
}
