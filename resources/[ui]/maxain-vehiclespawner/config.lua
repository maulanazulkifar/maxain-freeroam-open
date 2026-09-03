Config = {}

-- Key mapping and commands
Config.CommandName = "spawner"
Config.AlternativeCommand = "vspawner"
Config.PropCommand = "propspawner"
Config.DefaultKey = "F6" -- Toggle hotkey via RegisterKeyMapping

-- Spawner behavior
Config.DeleteOldVehicle = true  -- Automatically delete previous vehicle when spawning a new one
Config.SpawnInsideVehicle = true -- Auto teleport player into driver seat
Config.WarpPlayerIn = true      -- Warp inside immediately
Config.MaxPlayerProps = 20      -- Max props a player can spawn at once

-- Vehicle categories
Config.Categories = {
    { id = "all", label = "All Vehicles", icon = "fas fa-th-large" },
    { id = "super", label = "Super", icon = "fas fa-bolt" },
    { id = "sports", label = "Sports", icon = "fas fa-tachometer-alt" },
    { id = "drift", label = "Drift / Tuners", icon = "fas fa-fire" },
    { id = "muscle", label = "Muscle", icon = "fas fa-dumbbell" },
    { id = "suv", label = "SUVs & Off-Road", icon = "fas fa-mountain" },
    { id = "motorcycles", label = "Motorcycles", icon = "fas fa-motorcycle" },
    { id = "compacts", label = "Sedans & Compacts", icon = "fas fa-car" },
    { id = "emergency", label = "Emergency", icon = "fas fa-shield-alt" },
}

-- Prop categories
Config.PropCategories = {
    { id = "all_props", label = "All Objects", icon = "fas fa-cubes" },
    { id = "ramps", label = "Ramps & Stunts", icon = "fas fa-chart-line" },
    { id = "barriers", label = "Barriers & Cones", icon = "fas fa-road" },
    { id = "containers", label = "Containers & Sheds", icon = "fas fa-box" },
    { id = "furniture", label = "Furniture & Decor", icon = "fas fa-chair" },
    { id = "lights", label = "Lighting & Signs", icon = "fas fa-lightbulb" }
}

-- Default vehicle image base URL
Config.CDNImageBase = "https://docs.fivem.net/vehicles/"

-- Vehicle Database
Config.Vehicles = {
    -- Super
    { model = "adder", name = "Truffade Adder", brand = "Truffade", category = "super", class = "Super", seats = 2, speed = 95, accel = 92, image = "https://docs.fivem.net/vehicles/adder.webp" },
    { model = "t20", name = "Progen T20", brand = "Progen", category = "super", class = "Super", seats = 2, speed = 98, accel = 96, image = "https://docs.fivem.net/vehicles/t20.webp" },
    { model = "zentorno", name = "Pegassi Zentorno", brand = "Pegassi", category = "super", class = "Super", seats = 2, speed = 96, accel = 95, image = "https://docs.fivem.net/vehicles/zentorno.webp" },
    { model = "nero2", name = "Truffade Nero Custom", brand = "Truffade", category = "super", class = "Super", seats = 2, speed = 97, accel = 94, image = "https://docs.fivem.net/vehicles/nero2.webp" },
    { model = "emerus", name = "Progen Emerus", brand = "Progen", category = "super", class = "Super", seats = 2, speed = 99, accel = 97, image = "https://docs.fivem.net/vehicles/emerus.webp" },
    { model = "krieger", name = "Benefactor Krieger", brand = "Benefactor", category = "super", class = "Super", seats = 2, speed = 99, accel = 98, image = "https://docs.fivem.net/vehicles/krieger.webp" },
    { model = "entityxf", name = "Överflöd Entity XF", brand = "Överflöd", category = "super", class = "Super", seats = 2, speed = 94, accel = 90, image = "https://docs.fivem.net/vehicles/entityxf.webp" },
    { model = "turismor", name = "Grotti Turismo R", brand = "Grotti", category = "super", class = "Super", seats = 2, speed = 95, accel = 93, image = "https://docs.fivem.net/vehicles/turismor.webp" },
    { model = "osiris", name = "Pegassi Osiris", brand = "Pegassi", category = "super", class = "Super", seats = 2, speed = 96, accel = 94, image = "https://docs.fivem.net/vehicles/osiris.webp" },

    -- Sports
    { model = "elegy", name = "Annis Elegy RH8", brand = "Annis", category = "sports", class = "Sports", seats = 2, speed = 90, accel = 88, image = "https://docs.fivem.net/vehicles/elegy.webp" },
    { model = "elegy2", name = "Annis Elegy Retro Custom", brand = "Annis", category = "drift", class = "Sports/Drift", seats = 2, speed = 91, accel = 89, image = "https://docs.fivem.net/vehicles/elegy2.webp" },
    { model = "jester", name = "Dinka Jester", brand = "Dinka", category = "sports", class = "Sports", seats = 2, speed = 89, accel = 87, image = "https://docs.fivem.net/vehicles/jester.webp" },
    { model = "jester3", name = "Dinka Jester Classic", brand = "Dinka", category = "sports", class = "Sports", seats = 2, speed = 90, accel = 88, image = "https://docs.fivem.net/vehicles/jester3.webp" },
    { model = "feltzer2", name = "Benefactor Feltzer", brand = "Benefactor", category = "sports", class = "Sports", seats = 2, speed = 87, accel = 85, image = "https://docs.fivem.net/vehicles/feltzer2.webp" },
    { model = "massacro", name = "Dewbauchee Massacro", brand = "Dewbauchee", category = "sports", class = "Sports", seats = 2, speed = 92, accel = 89, image = "https://docs.fivem.net/vehicles/massacro.webp" },
    { model = "comet2", name = "Pfister Comet", brand = "Pfister", category = "sports", class = "Sports", seats = 2, speed = 88, accel = 86, image = "https://docs.fivem.net/vehicles/comet2.webp" },
    { model = "sultanrs", name = "Karin Sultan RS", brand = "Karin", category = "sports", class = "Super/Sports", seats = 2, speed = 93, accel = 92, image = "https://docs.fivem.net/vehicles/sultanrs.webp" },
    { model = "banshee2", name = "Bravado Banshee 900R", brand = "Bravado", category = "sports", class = "Super/Sports", seats = 2, speed = 94, accel = 91, image = "https://docs.fivem.net/vehicles/banshee2.webp" },
    { model = "pariah", name = "Ocelot Pariah", brand = "Ocelot", category = "sports", class = "Sports", seats = 2, speed = 97, accel = 93, image = "https://docs.fivem.net/vehicles/pariah.webp" },

    -- Drift / Tuners
    { model = "remus", name = "Annis Remus", brand = "Annis", category = "drift", class = "Tuner/Drift", seats = 2, speed = 84, accel = 82, image = "https://docs.fivem.net/vehicles/remus.webp" },
    { model = "rt3000", name = "Dinka RT3000", brand = "Dinka", category = "drift", class = "Tuner/Drift", seats = 2, speed = 85, accel = 83, image = "https://docs.fivem.net/vehicles/rt3000.webp" },
    { model = "zr350", name = "Annis ZR350", brand = "Annis", category = "drift", class = "Tuner/Drift", seats = 2, speed = 88, accel = 86, image = "https://docs.fivem.net/vehicles/zr350.webp" },
    { model = "calico", name = "Karin Calico GTF", brand = "Karin", category = "drift", class = "Tuner", seats = 2, speed = 92, accel = 94, image = "https://docs.fivem.net/vehicles/calico.webp" },
    { model = "futo", name = "Karin Futo", brand = "Karin", category = "drift", class = "Drift", seats = 2, speed = 78, accel = 76, image = "https://docs.fivem.net/vehicles/futo.webp" },
    { model = "futo2", name = "Karin Futo GTX", brand = "Karin", category = "drift", class = "Drift", seats = 2, speed = 80, accel = 79, image = "https://docs.fivem.net/vehicles/futo2.webp" },
    { model = "euros", name = "Annis Euros", brand = "Annis", category = "drift", class = "Tuner/Drift", seats = 2, speed = 87, accel = 85, image = "https://docs.fivem.net/vehicles/euros.webp" },

    -- Muscle
    { model = "dominator", name = "Vapid Dominator", brand = "Vapid", category = "muscle", class = "Muscle", seats = 2, speed = 86, accel = 84, image = "https://docs.fivem.net/vehicles/dominator.webp" },
    { model = "dominator3", name = "Vapid Dominator GTX", brand = "Vapid", category = "muscle", class = "Muscle", seats = 2, speed = 88, accel = 85, image = "https://docs.fivem.net/vehicles/dominator3.webp" },
    { model = "gauntlet4", name = "Bravado Gauntlet Hellfire", brand = "Bravado", category = "muscle", class = "Muscle", seats = 2, speed = 92, accel = 90, image = "https://docs.fivem.net/vehicles/gauntlet4.webp" },

    -- SUV & Off-Road
    { model = "dubsta", name = "Benefactor Dubsta", brand = "Benefactor", category = "suv", class = "SUV", seats = 4, speed = 78, accel = 72, image = "https://docs.fivem.net/vehicles/dubsta.webp" },
    { model = "baller2", name = "Gallivanter Baller II", brand = "Gallivanter", category = "suv", class = "SUV", seats = 4, speed = 80, accel = 74, image = "https://docs.fivem.net/vehicles/baller2.webp" },
    { model = "kamacho", name = "Canis Kamacho", brand = "Canis", category = "suv", class = "Off-Road", seats = 4, speed = 83, accel = 81, image = "https://docs.fivem.net/vehicles/kamacho.webp" },

    -- Motorcycles
    { model = "bati", name = "Pegassi Bati 801", brand = "Pegassi", category = "motorcycles", class = "Motorcycle", seats = 2, speed = 92, accel = 94, image = "https://docs.fivem.net/vehicles/bati.webp" },
    { model = "hakuchou2", name = "Shitzu Hakuchou Drag", brand = "Shitzu", category = "motorcycles", class = "Motorcycle", seats = 1, speed = 97, accel = 98, image = "https://docs.fivem.net/vehicles/hakuchou2.webp" },
    { model = "shotaro", name = "Nagasaki Shotaro", brand = "Nagasaki", category = "motorcycles", class = "Motorcycle", seats = 1, speed = 95, accel = 96, image = "https://docs.fivem.net/vehicles/shotaro.webp" },

    -- Sedans & Compacts
    { model = "sultan", name = "Karin Sultan", brand = "Karin", category = "compacts", class = "Sedan", seats = 4, speed = 82, accel = 80, image = "https://docs.fivem.net/vehicles/sultan.webp" },
    { model = "schafter2", name = "Benefactor Schafter V12", brand = "Benefactor", category = "compacts", class = "Sedan", seats = 4, speed = 89, accel = 86, image = "https://docs.fivem.net/vehicles/schafter2.webp" },

    -- Emergency
    { model = "police3", name = "Vapid Police Interceptor", brand = "Vapid", category = "emergency", class = "Emergency", seats = 4, speed = 88, accel = 85, image = "https://docs.fivem.net/vehicles/police3.webp" }
}

-- Prop / Object Database
Config.Props = {
    -- Ramps & Stunts
    { model = "prop_mp_ramp_01", name = "Large Stunt Ramp", category = "ramps", type = "Ramp", image = "https://vignette.wikia.nocookie.net/gtawiki/images/3/3d/Ramp-GTA5.png" },
    { model = "prop_mp_ramp_02", name = "Medium Curved Ramp", category = "ramps", type = "Ramp", image = "https://vignette.wikia.nocookie.net/gtawiki/images/3/3d/Ramp-GTA5.png" },
    { model = "prop_mp_ramp_03", name = "Small Jump Ramp", category = "ramps", type = "Ramp", image = "https://vignette.wikia.nocookie.net/gtawiki/images/3/3d/Ramp-GTA5.png" },

    -- Barriers & Cones
    { model = "prop_roadcone_02a", name = "Orange Traffic Cone", category = "barriers", type = "Cone", image = "https://vignette.wikia.nocookie.net/gtawiki/images/a/a2/TrafficCone-GTA5.png" },
    { model = "prop_barrier_work05", name = "Concrete Jersey Barrier", category = "barriers", type = "Barrier", image = "" },
    { model = "prop_barrier_wat_03b", name = "Red Water Barrier", category = "barriers", type = "Barrier", image = "" },
    { model = "prop_bkr_bar_01", name = "Metal Fence Barrier", category = "barriers", type = "Fence", image = "" },

    -- Containers & Sheds
    { model = "prop_container_01a", name = "Shipping Container (Red)", category = "containers", type = "Container", image = "" },
    { model = "prop_container_05a", name = "Shipping Container (Blue)", category = "containers", type = "Container", image = "" },

    -- Furniture & Decor
    { model = "prop_chair_01a", name = "Modern Office Chair", category = "furniture", type = "Furniture", image = "" },
    { model = "prop_couch_01", name = "Comfy Leather Sofa", category = "furniture", type = "Furniture", image = "" },
    { model = "prop_table_01", name = "Wooden Table", category = "furniture", type = "Furniture", image = "" },

    -- Lighting & Signs
    { model = "prop_worklight_01a", name = "Construction Floodlight", category = "lights", type = "Light", image = "" },
    { model = "prop_sign_road_01a", name = "Road Sign", category = "lights", type = "Sign", image = "" }
}
