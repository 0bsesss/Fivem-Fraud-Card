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
    else
        TriggerClientEvent('QBCore:Notify', src, 'Üstünde çalıntı kredi kartı yok!', 'error')
    end
end)
Config = {}
Config.RequiredPolice = 2 
Config.ATMRequiredItem = 'stolen_card' 
Config.ProgressBarTime = math.random(8000, 15000) 
Config.ATMProps = { 'prop_atm_01', 'prop_atm_02', 'prop_atm_03', 'prop_fleeca_atm' }
Config.ATMIcon = 'fas fa-credit-card'
Config.ATMLabel = 'ATM Hack'
Config.RewardMoney = math.random(1000, 5000)


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000) -- Döngüyü 1 saniyede bir çalıştır
        local playerCoords = GetEntityCoords(PlayerPedId())
        for _, atm in pairs(Config.ATMProps) do
            local atmObj = GetClosestObjectOfType(playerCoords, 3.0, GetHashKey(atm), false, false, false)
            local distance = #(playerCoords - GetEntityCoords(atmObj))
            if atmObj and distance < 3.0 then
                while distance < 3.0 do
                    Citizen.Wait(0)
                    if IsControlJustPressed(0, 38) then
                        local hasCard = QBCore.Functions.HasItem('stolen_card')
                        if hasCard then
                            TriggerEvent('animations:client:EmoteCommandStart', {"atm"})

                            
                            TriggerEvent('inventory:client:CloseInventory')
                            DisableControlAction(0, 24, true)
                            DisableControlAction(0, 25, true)
                            DisableControlAction(0, 37, true)
                            DisableControlAction(0, 199, true)

                            -- Progress bar
                            QBCore.Functions.Progressbar("atm_hack", "Çalıntı Kredi Kartı ATM'ye Takılıyor...", Config.ProgressBarTime, false, true, {
                                disableMovement = true,
                                disableCarMovement = false,
                                disableMouse = false,
                                disableCombat = true,
                            }, {}, {}, {}, function()
                                -- Minigame başlat
                                exports['ps-ui']:VarHack(function(success)
                                    Citizen.Wait(500)
                                    EnableControlAction(0, 24, true)
                                    EnableControlAction(0, 25, true)
                                    EnableControlAction(0, 37, true)
                                    EnableControlAction(0, 199, true)

                                    -- Animasyonu durdur
                                    TriggerEvent('animations:client:EmoteCommandStart', {"c"})

                                    if success then
                                        TriggerServerEvent('qb_frauding:server:AddMoney')
                                        TriggerEvent('QBCore:Notify', 'Kredi Kartında Para Var, Para Çekiliyor!', 'success')
                                    else
                                        TriggerEvent('QBCore:Notify', 'Kredi Kartının Şifresini Yanlış Girdin!', 'error')
                                    end
                                end, 5, 5)
                            end)
                        else
                            TriggerEvent('QBCore:Notify', 'Çalıntı Kredi Kartın Yok!', 'error')
                        end
                    end
                    distance = #(playerCoords - GetEntityCoords(atmObj))
                end
            end
        end
    end
end)