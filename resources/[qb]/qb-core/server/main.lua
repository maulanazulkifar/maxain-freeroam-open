QBCore = QBCore or {}
QBCore.Players = {}
QBCore.Commands = {}
QBCore.Functions = QBCore.Functions or {}

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        print('^2[QBCore]^7 Framework (Freeroam Edition) successfully initialized.')
    end
end)
