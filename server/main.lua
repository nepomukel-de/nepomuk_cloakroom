ESX.RegisterServerCallback('cloakroom:getPlayerDressing', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.identifier
    
    MySQL.query('SELECT label FROM wardrobes WHERE identifier = ?', {identifier}, function(result)
        local labels = {}
        for i, row in ipairs(result) do
            table.insert(labels, row.label)
        end
        cb(labels)
    end)
end)

ESX.RegisterServerCallback('cloakroom:getPlayerOutfit', function(source, cb, label)
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.identifier
    
    MySQL.query('SELECT outfit FROM wardrobes WHERE identifier = ? AND label = ?', {identifier, label}, function(result)
        if result[1] then
            cb(json.decode(result[1].outfit))
        else
            cb(nil)
        end
    end)
end)

RegisterServerEvent('cloakroom:saveOutfit')
AddEventHandler('cloakroom:saveOutfit', function(label, skin)
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.identifier
    
    MySQL.query('INSERT INTO wardrobes (identifier, label, outfit) VALUES (?, ?, ?) ON DUPLICATE KEY UPDATE outfit = ?',
        {identifier, label, json.encode(skin), json.encode(skin)})
    
    TriggerClientEvent('esx:showNotification', source, 'Outfit gespeichert!')
end)

RegisterServerEvent('cloakroom:deleteOutfit')
AddEventHandler('cloakroom:deleteOutfit', function(label)
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.identifier
    
    MySQL.query('DELETE FROM wardrobes WHERE identifier = ? AND label = ?', {identifier, label})
    
    TriggerClientEvent('esx:showNotification', source, 'Outfit gelöscht!')
end)
