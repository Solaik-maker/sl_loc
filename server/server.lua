ESX = exports["es_extended"]:getSharedObject()

RegisterNetEvent('sl_loc:rent')
AddEventHandler('sl_loc:rent', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local PlayerMoney = xPlayer.getMoney() 

    if PlayerMoney >= Config.prix then 
      xPlayer.removeMoney(Config.prix) 
      TriggerClientEvent('sl_loc:spawncar', _source)
    else
      TriggerClientEvent('sl_loc:NotEnoughMoney', _source)
    end
end)


