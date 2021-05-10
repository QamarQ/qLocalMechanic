ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('qLocalMechanic:zaplac')
AddEventHandler('qLocalMechanic:zaplac', function(kwota)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	if xPlayer.getMoney() >= kwota then		
		xPlayer.removeMoney(kwota)
		TriggerClientEvent('qLocalMechanic:naprawFurke', _source)
		-- extended v1 final: xPlayer.showNotification(_U('naprawa_koszt', kwota))
		TriggerClientEvent('esx:showNotification', _source, _U('naprawa_koszt', kwota))
	else
		TriggerClientEvent('esx:showNotification', _source, _U('brak_kasy'))
	end
end)