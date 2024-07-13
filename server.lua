--    ______    ___   ______   ________  
--  .' ___  | .'   `.|_   _ `.|_   __  | --
-- / .'   \_|/  .-.  \ | | `. \ | |_ \_| --
-- | |       | |   | | | |  | | |  _| _  --
-- \ `.___.'\\  `-'  /_| |_.' /_| |__/ | --
--  `.____ .' `.___.'|______.'|________| --

-- server.lua

local ESX = exports["es_extended"]:getSharedObject()

-- Ensure Config is loaded
Config = Config or {}

ESX.RegisterCommand(
    "carros",
    "user",  -- Allow all users to trigger the command but we'll handle permissions manually
    function(xPlayer, args, showError)
        if not xPlayer then
            return showError("[^1ERROR^7] The xPlayer value is nil")
        end

        -- Check if the player's group is allowed
        local playerGroup = xPlayer.getGroup()
        if not hasPermission(playerGroup) then
            notify(xPlayer.source, "You don't have permission to use this command.", "error")
            return
        end

        TriggerClientEvent("esx_car:openMenu", xPlayer.source)
    end,
    false,
    {
        help = "Open the car spawning menu",
        validate = false,
        arguments = {}
    }
)

RegisterServerEvent('esx_car:spawnCar')
AddEventHandler('esx_car:spawnCar', function(carName)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if not xPlayer then
        return
    end

    local playerPed = GetPlayerPed(xPlayer.source)
    local playerCoords = GetEntityCoords(playerPed)
    local playerHeading = GetEntityHeading(playerPed)
    local playerVehicle = GetVehiclePedIsIn(playerPed, false)

    if playerVehicle then
        DeleteEntity(playerVehicle)
    end

    ESX.OneSync.SpawnVehicle(carName, playerCoords, playerHeading, nil, function(networkId)
        if networkId then
            local vehicle = NetworkGetEntityFromNetworkId(networkId)
            for _ = 1, 20 do
                Wait(0)
                SetPedIntoVehicle(playerPed, vehicle, -1)

                if GetVehiclePedIsIn(playerPed, false) == vehicle then
                    break
                end
            end
        end
    end)

    notify(_source, "Vehicle spawned: " .. carName, "success")
end)

-- Check if a player's group has permission
function hasPermission(playerGroup)
    for _, group in ipairs(Config.AllowedGroups) do
        if group == playerGroup then
            return true
        end
    end
    return false
end

-- Send notification based on the configured notification system
function notify(source, message, type)
    if Config.NotificationSystem == "okokNotify" then
        TriggerClientEvent('okokNotify:Alert', source, "Notification", message, 5000, type)
    else
        TriggerClientEvent('esx:showNotification', source, message)
    end
end

-- VERSION CHECK --

Citizen.CreateThread(function()
    Citizen.Wait(5500)

    -- ASCII Art Header
    local label = [[
                ======================== POWERED BY =========================
                 ▄████████  ▄██████▄     ▄████████   ▄▄▄▄███▄▄▄▄    ▄██████▄  
                ███    ███ ███    ███   ███    ███ ▄██▀▀▀███▀▀▀██▄ ███    ███ 
                ███    █▀  ███    ███   ███    █▀  ███   ███   ███ ███    ███ 
                ███        ███    ███   ███        ███   ███   ███ ███    ███ 
                ███        ███    ███ ▀███████████ ███   ███   ███ ███    ███ 
                ███    █▄  ███    ███          ███ ███   ███   ███ ███    ███ 
                ███    ███ ███    ███    ▄█    ███ ███   ███   ███ ███    ███ 
                ████████▀   ▀██████▀   ▄████████▀   ▀█   ███   █▀   ▀██████▀  
                =========================== AND =============================
                 ^1██   ██ ███████ ██ ██    ██  █████  ██████   █████  ███████ 
                 ██  ██  ██      ██  ██  ██  ██   ██ ██   ██ ██   ██ ██      
                 █████   █████   ██    ██    ███████ ██   ██ ███████ ███████ 
                 ██  ██  ██      ██  ██  ██  ██   ██ ██   ██ ██   ██      ██ 
                 ██   ██ ███████ ██ ██    ██ ██   ██ ██████  ██   ██ ███████ 
                                                                            ^0]]

    local ver = "1.1"
    print("                     ^2**Tudo pronto! Iniciando script na versão: v"..ver.."**^3")
    Citizen.Wait(1000)
    print(label)
    Citizen.Wait(1000)

    -- Changelog
    local changelog = [[
╔═════════════════════════════════╗
║            CHANGELOG            ║
╠═════════════════════════════════╣
║ Version: ]]..ver..[[                  ║
║ Changes:                           ║
║ - Adicionado Config               ║
║ - Adicionado sistema de permissoes                       ║
║ - Adicionado sistema de notificações             ║
╚═════════════════════════════════╝
]]

    print(changelog)
end)

