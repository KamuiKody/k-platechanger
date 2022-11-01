local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Functions.CreateCallback('k-platechange:checkowned', function(source, cb, plate)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local citizenid = QBCore.Functions.GetPlayer(src).PlayerData.citizenid
    local result = MySQL.query.await('SELECT * FROM player_vehicles WHERE plate = @plate AND citizenid = @citizenid', {['@plate'] = plate, ['@citizenid'] = citizenid  })
    local old = string.upper(result[1].plate)
    local id = result[1].citizenid
    if old == plate and id == citizenid then
        cb(true)
    else 
        TriggerClientEvent('QBCore:Notify', source, 'This is not your vehicle!', 'error', 5000) 
        cb(false)	
    end
end)

RegisterServerEvent('k-platechange:server:platetext', function(pin, plate, props, owned)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local citizenid = QBCore.Functions.GetPlayer(src).PlayerData.citizenid
    if Config.UseItem[owned] then
        if Player.Functions.RemoveItem(Config.Item[owned], 1) then
            if owned then
                MySQL.query("UPDATE `player_vehicles` SET `plate` = '"..pin.."' WHERE plate = @plate AND citizenid = @citizenid", { ['@plate'] = plate, ['@citizenid'] = citizenid })	
            elseif not Config.Owned and not owned then
                return
            end
            TriggerClientEvent('k-platechange:endgame', src, pin)
        else 
            TriggerClientEvent('QBCore:Notify', source, 'You Don\'t Have The Required Item', 'error', 5000) 
        end
    else
        if Player.PlayerData.money.cash >= Config.Cash[owned] then 
            Player.Functions.RemoveMoney("cash", Config.Cash[owned])
            if owned then
                MySQL.query("UPDATE `player_vehicles` SET `plate` = '"..pin.."' WHERE plate = @plate AND citizenid = @citizenid", { ['@plate'] = plate, ['@citizenid'] = citizenid })	
            elseif not Config.Owned and not owned then
                return
            end
            TriggerClientEvent('k-platechange:endgame', src, pin)
        else 
            TriggerClientEvent('QBCore:Notify', source, 'You Don\'t Have Enough Cash', 'error', 5000) 
        end
    end
end)