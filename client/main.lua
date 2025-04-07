local CurrentActionData = {}
local LastZone, CurrentAction, CurrentActionMsg
local HasAlreadyEnteredMarker = false

local Locale = Config.Locale
local _U = function(str)
    return Locales[Locale][str] or str
end

local DrawDistance = Config.DrawDistance

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

if Command.Enabled then
    RegisterCommand(Command.Name, function()
        ESX.UI.Menu.CloseAll()
        OpenMainMenu()
    end, false)
end

function OpenMainMenu()
    ESX.UI.Menu.CloseAll()
    
    local elements = {
        {label = _U('save_outfit'), value = 'save_outfit'},
        {label = _U('change_outfit'), value = 'change_outfit'},
        {label = _U('delete_outfit'), value = 'delete_outfit'},
    }

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'main_outfit', {
        title = _U('menu_title'),
        align = _U('top_left'),
        elements = elements
    }, function(data, menu)
        menu.close()

        if data.current.value == 'change_outfit' then
            ESX.TriggerServerCallback('cloakroom:getPlayerDressing', function(dressing)
                local elements = {}
                for i=1, #dressing, 1 do
                    elements[#elements + 1] = {label = dressing[i], value = dressing[i]}
                end

                ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'change_outfit', {
                    title = _U('change_outfit'),
                    align = _U('top_left'),
                    elements = elements
                }, function(data2, menu2)
                    TriggerServerEvent('cloakroom:getPlayerOutfit', data2.current.value)
                    ESX.ShowNotification(_U('outfit_changed'))
                    menu2.close()
                end, function(data2, menu2)
                    menu2.close()
                end)
            end)
        elseif data.current.value == 'delete_outfit' then
            ESX.TriggerServerCallback('cloakroom:getPlayerDressing', function(dressing)
                local elements = {}
                for i=1, #dressing, 1 do
                    elements[#elements + 1] = {label = dressing[i], value = dressing[i]}
                end

                ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'delete_outfit', {
                    title = _U('delete_outfit'),
                    align = _U('top_left'),
                    elements = elements
                }, function(data2, menu2)
                    TriggerServerEvent('cloakroom:deleteOutfit', data2.current.value)
                    ESX.ShowNotification(_U('outfit_deleted'))
                    menu2.close()
                end, function(data2, menu2)
                    menu2.close()
                end)
            end)
        elseif data.current.value == 'save_outfit' then
            ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'save_outfit', {
                title = _U('dialog_save_outfit')
            }, function(data2, menu2)
                local outfitLabel = data2.value
                if outfitLabel ~= nil and outfitLabel ~= '' then
                    TriggerEvent('skinchanger:getSkin', function(skin)
                        TriggerServerEvent('cloakroom:saveOutfit', outfitLabel, skin)
                        ESX.ShowNotification(_U('outfit_saved'))
                    end)
                    menu2.close()
                else
                    ESX.ShowNotification(_U('invalid_name'))
                end
            end, function(data2, menu2)
                menu2.close()
            end)
        end
    end, function(data, menu)
        menu.close()
    end)
end

AddEventHandler('cloakroom:hasEnteredMarker', function(zone)
    CurrentAction     = 'main_action'
    CurrentActionMsg  = _U('action_msg')
    CurrentActionData = {}
end)

AddEventHandler('cloakroom:hasExitedMarker', function(zone)
    CurrentAction = nil
    ESX.UI.Menu.CloseAll()
end)

-- Display markers
CreateThread(function()
    while true do
        local Sleep = 500
        local coords, letSleep = GetEntityCoords(PlayerPedId()), true

        for k,v in pairs(Config.Zones) do
            if #(coords - v) < DrawDistance then
                Sleep = 0
                DrawMarker(Config.MarkerType, v.x, v.y, v.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, nil, nil, false)
                letSleep = false
            end
        end
        Wait(Sleep)
    end
end)

CreateThread(function()
    while true do
        local Sleep = 500
        local coords = GetEntityCoords(PlayerPedId())
        local isInMarker = false
        local currentZone = nil

        for k,v in pairs(Config.Zones) do
            if(#(coords - v) < Config.MarkerSize.x) then
                Sleep = 0
                isInMarker  = true
                currentZone = 'main_action'
            end
        end

        if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
            HasAlreadyEnteredMarker = true
            LastZone                = currentZone
            TriggerEvent('cloakroom:hasEnteredMarker', currentZone)
        end

        if not isInMarker and HasAlreadyEnteredMarker then
            HasAlreadyEnteredMarker = false
            TriggerEvent('cloakroom:hasExitedMarker', LastZone)
        end
        
        Wait(Sleep)
    end
end)

Citizen.CreateThread(function()
    while true do
        local sleep = 500

        if CurrentAction then
            sleep = 0
            ESX.ShowHelpNotification(CurrentActionMsg)

            if IsControlPressed(0,  38) then
                if CurrentAction == 'main_action' then
                    OpenMainMenu()
                end
                CurrentAction = nil
            end
        end

        Wait(sleep)
    end
end)
