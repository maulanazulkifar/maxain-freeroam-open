Framework = {}

function Framework.ESX()
    return GetResourceState("es_extended") ~= "missing"
end

function Framework.QBCore()
    return GetResourceState("fpx_core") ~= "missing"
end

function Framework.Ox()
    return GetResourceState("ox_core") ~= "missing"
end
