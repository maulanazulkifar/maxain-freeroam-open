local QBCore = exports['qb-core']:GetCoreObject({ 'Functions' })

QBCore.Functions.CreateCallback('qb-spawn:server:getOwnedHouses', function(_, cb, cid)
    if cid ~= nil then
        local success, houses = pcall(MySQL.query.await, 'SELECT * FROM player_houses WHERE citizenid = ?', { cid })
        if success and houses and houses[1] ~= nil then
            cb(houses)
        else
            cb({})
        end
    else
        cb({})
    end
end)
