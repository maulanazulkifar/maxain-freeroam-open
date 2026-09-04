QBCore.Shared.Player = {}

function QBCore.Shared.CreateCitizenId()
    local UniqueFound = false
    local CitizenId = nil
    while not UniqueFound do
        CitizenId = tostring(string.upper(QBCore.Shared.RandomStr(3) .. QBCore.Shared.RandomInt(5)))
        UniqueFound = true
    end
    return CitizenId
end

function QBCore.Shared.RandomStr(length)
    if length <= 0 then return '' end
    local res = ''
    for _ = 1, length do
        res = res .. string.char(math.random(65, 90))
    end
    return res
end

function QBCore.Shared.RandomInt(length)
    if length <= 0 then return '' end
    local res = ''
    for _ = 1, length do
        res = res .. tostring(math.random(0, 9))
    end
    return res
end
