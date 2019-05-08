local serverSize=64
--chance of hack working:
local hackProbability = 1/2
--hack cooldown time in milliseconds:
local cooldown = 2
--true = pop tires, false = deflate
local pop = false

local selectKeyNumber = 58 --G key
local tiresKeyNumber = 108 --numpad 4
local selectedVehicle = 0

local ped = GetPlayerPed(-1)
local pedVehicle = GetVehiclePedIsIn(ped,false)
Citizen.CreateThread(function()
	while true do
		Wait(0)
		if IsControlJustReleased(1, selectKeyNumber) then
			local pedInPassengerSeat = GetPedInVehicleSeat(pedVehicle,0)
			if IsPedInAnyPoliceVehicle(ped) and pedInPassengerSeat==ped then
				local isEntity, driverEntity = GetEntityPlayerIsFreeAimingAt(PlayerId())
				local entity = GetVehiclePedIsIn(driverEntity,false)

				print("Police Takedown Activated")
				print("Is entity: "..tostring(isEntity))
				print("Driver entity number: "..tostring(driverEntity))
				if isEntity~=false and IsEntityAVehicle(entity) then
					local aheadVehHash = GetEntityModel(entity)
			        local aheadVehName = GetDisplayNameFromVehicleModel(aheadVehHash)
			        local aheadVehNameText = GetLabelText(aheadVehName)
			        TriggerEvent("chatMessage", "^1Takedown: ^2Selected "..aheadVehNameText)
					print("Selected "..aheadVehNameText)
					selectedVehicle = entity
				end
			end
		end
		if IsControlJustReleased(1, tiresKeyNumber) then
			if(IsEntityAVehicle(selectedVehicle)) then
				local randomNum = math.random()
				if(randomNum < 0.25) then
					local tyreIndex = math.floor(math.random()*2)
					TriggerServerEvent("Takedown:PopTire",selectedVehicle, tyreIndex)
					TriggerEvent("chatMessage", "^1Takedown: ^2Hack Successful! Tire Temporarily Deflated")
					Wait(cooldown)
				elseif(randomNum < 0.4) then
					TriggerServerEvent("Takedown:ShutOffEngine",selectedVehicle)
					TriggerEvent("chatMessage", "^1Takedown: ^2Hack Successful! Fuel Emptied")
					Wait(cooldown)
				elseif(randomNum>0.85) then
					TriggerServerEvent("Takedown:ShutOffEngine",pedVehicle)
					TriggerEvent("chatMessage", "^1Takedown: Counterattack! Vehicle Shutdown")
					Wait(cooldown)
				else
					TriggerEvent("chatMessage", "^1Takedown: ^2Hack Failed!")
					Wait(cooldown)
				end
			else
				TriggerEvent("chatMessage", "^1Takedown: ^2No vehicle selected!")
			end
		end
	end
end)

RegisterNetEvent("Takedown:PopTire")
AddEventHandler("Takedown:PopTire", function(selectedVehicle, tyreIndex)
	if IsEntityAVehicle(selectedVehicle) then
		SetVehicleTyreBurst(selectedVehicle, tyreIndex, pop, 1000)
	end
end)

RegisterNetEvent("Takedown:ShutOffEngine")
AddEventHandler("Takedown:ShutOffEngine", function(selectedVehicle)
	if IsEntityAVehicle(selectedVehicle) then
		SetVehicleFuelLevel(selectedVehicle, 0)
	end
end)

function GetDriver(vehicle)
	local ped = GetPedInVehicleSeat(vehicle, -1)
	for x = 0, serverSize do
		if ped == GetPlayerPed(x) then
			return x
		end
	end
	return -1
end