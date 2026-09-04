-- Client background loops (keep lightweight for freeroam)
CreateThread(function()
    while true do
        Wait(1000)
        if QBCore.isLoggedIn then
            -- Optional player stats tick if needed
        end
    end
end)
