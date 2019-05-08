RegisterServerEvent("Takedown:PopTire")
AddEventHandler("Takedown:PopTire", function(selectedVehicle,tyreIndex)
	TriggerClientEvent("Takedown:PopTire", -1, selectedVehicle, tyreIndex)
end)

RegisterServerEvent("Takedown:ShutOffEngine")
AddEventHandler("Takedown:ShutOffEngine", function(selectedVehicle)
	TriggerClientEvent("Takedown:ShutOffEngine", -1, selectedVehicle)
end)

RegisterServerEvent("Takedown:DoublePower")
AddEventHandler("Takedown:DoublePower", function(selectedVehicle)
	TriggerClientEvent("Takedown:DoublePower", -1, selectedVehicle)
end)