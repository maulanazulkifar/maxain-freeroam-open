local function replyJSON(res, statusCode, data)
    res.writeHead(statusCode, {
        ["Content-Type"] = "application/json",
        ["Access-Control-Allow-Origin"] = "*",
        ["Access-Control-Allow-Headers"] = "Content-Type, Authorization",
        ["Access-Control-Allow-Methods"] = "GET, POST, OPTIONS"
    })
    res.send(json.encode(data))
end

local function isAuthenticated(req)
    local authHeader = req.headers["authorization"] or req.headers["Authorization"]
    if not authHeader then return false end
    local token = authHeader:gsub("Bearer%s+", "")
    return token == Config.APISecretKey
end

local function readCurrentPeds()
    local fileContent = LoadResourceFile("illenium-appearance", "shared/peds.lua")
    if not fileContent then
        return { "mp_m_freemode_01", "mp_f_freemode_01" }
    end

    local peds = {}
    for ped in string.gmatch(fileContent, '"([^"]+)"') do
        if ped ~= "pedConfig" and ped ~= "peds" then
            peds[#peds + 1] = ped
        end
    end
    if #peds == 0 then
        peds = { "mp_m_freemode_01", "mp_f_freemode_01" }
    end
    return peds
end

local function writeCurrentPeds(pedsList)
    local formatted = "Config.Peds = {\n    pedConfig = {\n        {\n            peds = {\n"
    for i = 1, #pedsList do
        formatted = formatted .. '                "' .. pedsList[i] .. '"'
        if i < #pedsList then
            formatted = formatted .. ",\n"
        else
            formatted = formatted .. "\n"
        end
    end
    formatted = formatted .. "            }\n        }\n    }\n}\n"

    SaveResourceFile("illenium-appearance", "shared/peds.lua", formatted, -1)
    ExecuteCommand("restart illenium-appearance")
end

local vehicleCatalog = Config.DefaultVehicles

SetHttpHandler(function(req, res)
    local path = req.path
    local method = req.method

    -- Handle CORS Preflight OPTIONS
    if method == "OPTIONS" then
        res.writeHead(200, {
            ["Access-Control-Allow-Origin"] = "*",
            ["Access-Control-Allow-Headers"] = "Content-Type, Authorization",
            ["Access-Control-Allow-Methods"] = "GET, POST, OPTIONS"
        })
        res.send("")
        return
    end

    -- API Authentication Guard
    if not isAuthenticated(req) then
        replyJSON(res, 401, { error = "Unauthorized: Invalid or missing API Secret Key" })
        return
    end

    -- Route: GET /api/status
    if path == "/api/status" and method == "GET" then
        local players = GetNumPlayerIndices()
        local maxClients = GetConvar("sv_maxclients", "32")
        local serverName = GetConvar("sv_hostname", "Maxain Freeroam")
        local gameBuild = GetConvar("sv_enforceGameBuild", "3905")

        replyJSON(res, 200, {
            status = "online",
            serverName = serverName,
            playersOnline = players,
            maxClients = tonumber(maxClients),
            gameBuild = gameBuild,
            uptimeSeconds = math.floor(GetGameTimer() / 1000)
        })
        return
    end

    -- Route: GET /api/peds
    if path == "/api/peds" and method == "GET" then
        local peds = readCurrentPeds()
        replyJSON(res, 200, { peds = peds })
        return
    end

    -- Route: POST /api/peds
    if path == "/api/peds" and method == "POST" then
        req.setDataHandler(function(body)
            local parsed = json.decode(body)
            if parsed and parsed.peds and type(parsed.peds) == "table" then
                writeCurrentPeds(parsed.peds)
                replyJSON(res, 200, { success = true, message = "Peds list updated and illenium-appearance restarted!", peds = parsed.peds })
            else
                replyJSON(res, 400, { error = "Invalid body. Expected { peds: ['model1', 'model2'] }" })
            end
        end)
        return
    end

    -- Route: GET /api/vehicles
    if path == "/api/vehicles" and method == "GET" then
        replyJSON(res, 200, { vehicles = vehicleCatalog })
        return
    end

    -- Route: POST /api/vehicles
    if path == "/api/vehicles" and method == "POST" then
        req.setDataHandler(function(body)
            local parsed = json.decode(body)
            if parsed and parsed.spawnName and parsed.label then
                table.insert(vehicleCatalog, {
                    spawnName = parsed.spawnName,
                    label = parsed.label,
                    category = parsed.category or "General",
                    price = tonumber(parsed.price) or 0
                })
                replyJSON(res, 200, { success = true, vehicles = vehicleCatalog })
            else
                replyJSON(res, 400, { error = "Missing spawnName or label" })
            end
        end)
        return
    end

    -- Route: POST /api/rcon
    if path == "/api/rcon" and method == "POST" then
        req.setDataHandler(function(body)
            local parsed = json.decode(body)
            if parsed and parsed.command then
                ExecuteCommand(parsed.command)
                replyJSON(res, 200, { success = true, executedCommand = parsed.command })
            else
                replyJSON(res, 400, { error = "Missing command field" })
            end
        end)
        return
    end

    -- Fallback 404
    replyJSON(res, 404, { error = "Endpoint not found" })
end)

print("[Maxain-API] REST API Bridge initialized and ready for Web Admin Panel connections.")
