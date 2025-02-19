
local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('qb_frauding:server:AddMoney', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    local StolenCard = Player.Functions.GetItemByName('stolen_card')
    
    if StolenCard then
        Player.Functions.RemoveItem('stolen_card', 1)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['stolen_card'], 'remove', 1)
        local reward = math.random(1000, 5000)
        Player.Functions.AddMoney('cash', reward, 'ATM withdrawal')
        TriggerClientEvent('QBCore:Notify', src, ('ATM\'den $' .. reward .. ' çektin!'), 'success')
        TriggerClientEvent('qb_frauding:client:PoliceAlert', -1, src)
    else
        TriggerClientEvent('QBCore:Notify', src, 'Üstünde çalıntı kredi kartı yok!', 'error')
    end
end)
RegisterNetEvent('qb_frauding:client:PoliceAlert', function(source)
    local Players = QBCore.Functions.GetQBPlayers()

    for _, player in pairs(Players) do
        if player and player.PlayerData.job.type == 'leo' then
            TriggerClientEvent('QBCore:Notify', player.PlayerData.source, 'Bir ATM hackleniyor!', 'error')
            TriggerClientEvent('qb-core:client:PoliceBlip', player.PlayerData.source, source)
        end
    end
end)
