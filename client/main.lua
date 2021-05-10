ESX = nil 
Citizen.CreateThread(function()
    while ESX == nil do
        Citizen.Wait(10)
        TriggerEvent("esx:getSharedObject", function(obj)
            ESX = obj
        end)
    end
end)

local chujNaprawia = false
local position = 0

Citizen.CreateThread(function()	
    while true do
		Citizen.Wait(5)	
		local czekaj = true
		local playerPed = GetPlayerPed(-1)
		local pos = GetEntityCoords(playerPed, true)		
		for k,v in pairs(Config.Lokacje) do
			if not chujNaprawia then
				if(Vdist(pos.x, pos.y, pos.z, v.x, v.y, v.z) < 100) then
					if IsPedInAnyVehicle(playerPed, false) then
						czekaj = false
						DrawMarker(36, v.x, v.y, v.z+1.1, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 2.0, 5.0, 1.0, Config.KolorMarkerow.r, Config.KolorMarkerow.g, Config.KolorMarkerow.b, 100, true, true, 2, true, false, false, false)
						DrawMarker(0, v.x, v.y, v.z-0.4, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 5.0, 5.0, 1.0, Config.KolorMarkerow.r, Config.KolorMarkerow.g, Config.KolorMarkerow.b, 100, false, false, 2, false, false, false, false)
						if(Vdist(pos.x, pos.y, pos.z, v.x, v.y, v.z) < 2.5) then							
							position = k
							if v.koszt == nil then
								ESX.ShowHelpNotification(_U('naprawa_free'))
								if IsControlJustPressed(0, 38) then	
									TriggerEvent('qLocalMechanic:naprawFurke')						
									SetPedCoordsKeepVehicle(playerPed, v.x, v.y, v.z)
								end								
							else
								ESX.ShowHelpNotification(_U('napraw_pytanie', v.koszt))
								if IsControlJustPressed(0, 38) then									
									TriggerServerEvent('qLocalMechanic:zaplac', v.koszt)
									SetPedCoordsKeepVehicle(playerPed, v.x, v.y, v.z)
								end																
							end
						end
					end
				end
			else		
				if position == k then
					czekaj = false
					DrawMarker(27, v.x, v.y, v.z + 0.6, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 5.0, 5.0, 1.0, Config.KolorMarkerow.r, Config.KolorMarkerow.g, Config.KolorMarkerow.b, 255, false, false, 2, true, false, false, false)
					DrawMarker(23, v.x, v.y, v.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 5.0, 5.0, 1.0, Config.KolorMarkerow.r, Config.KolorMarkerow.g, Config.KolorMarkerow.b, 255, false, false, 2, true, false, false, false)
					DrawMarker(27, v.x, v.y, v.z + -0.6, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 5.0, 5.0, 1.0, Config.KolorMarkerow.r, Config.KolorMarkerow.g, Config.KolorMarkerow.b, 255, false, false, 2, true, false, false, false)
				else
					czekaj = false
					DrawMarker(36, v.x, v.y, v.z+1.1, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 2.0, 5.0, 1.0, 255, 0, 0, 100, true, true, 2, true, false, false, false)
					DrawMarker(0, v.x, v.y, v.z-0.4, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 5.0, 5.0, 1.0, 255, 255, 0, 100, false, false, 2, false, false, false, false)							
				end
			end
		end
		if czekaj then
			Citizen.Wait(1500)
		end
    end
end)

RegisterNetEvent('qLocalMechanic:naprawFurke')
AddEventHandler('qLocalMechanic:naprawFurke', function()
	local playerPed = GetPlayerPed(-1)
	local vehicle = GetVehiclePedIsIn(playerPed, false)
	chujNaprawia = true
	FreezeEntityPosition(vehicle, true)
	for i=1,Config.CzasNaprawy do 
		ESX.ShowHelpNotification('Trwa naprawianie pojazdu: ~b~'..i.."s~s~/~b~"..Config.CzasNaprawy.."s")
		Citizen.Wait(1000)
	end
	SetVehicleFixed(vehicle)
	SetVehicleDeformationFixed(vehicle)
	FreezeEntityPosition(vehicle, false)
	chujNaprawia = false
	ESX.ShowNotification(_U('naprawa_koniec'))
end)

if Config.Blipy then
	Citizen.CreateThread(function()
		for i=1, #Config.Lokacje, 1 do
			local blip = AddBlipForCoord(Config.Lokacje[i].x, Config.Lokacje[i].y, Config.Lokacje[i].z)

			SetBlipSprite (blip, 402)
			SetBlipDisplay(blip, 4)
			SetBlipScale  (blip, 0.8)
			SetBlipColour (blip, 47)
			SetBlipAsShortRange(blip, true)

			BeginTextCommandSetBlipName("STRING")
			AddTextComponentSubstringPlayerName(_U('nazwy_blipow'))
			EndTextCommandSetBlipName(blip)
		end
	end)
end