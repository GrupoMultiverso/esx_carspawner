--    ______    ___   ______   ________  
--  .' ___  | .'   `.|_   _ `.|_   __  | --
-- / .'   \_|/  .-.  \ | | `. \ | |_ \_| --
-- | |       | |   | | | |  | | |  _| _  --
-- \ `.___.'\\  `-'  /_| |_.' /_| |__/ | --
--  `.____ .' `.___.'|______.'|________| --

-- client.lua

local ESX = exports["es_extended"]:getSharedObject()

-- Ensure Config is loaded
Config = Config or {}

-- Register and handle the event for opening the car spawning menu
RegisterNetEvent("esx_car:openMenu")
AddEventHandler("esx_car:openMenu", function()
    local elements = {}

    for _, vehicle in ipairs(Config.Vehicles) do
        table.insert(elements, {label = vehicle, value = vehicle})
    end

    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'car_spawn_menu', {
        title    = 'Vehicles',
        align    = 'top-left',
        elements = elements
    }, function(data, menu)
        local selectedCar = data.current.value
        TriggerServerEvent('esx_car:spawnCar', selectedCar)
        menu.close()
    end, function(data, menu)
        menu.close()
    end)
end)
