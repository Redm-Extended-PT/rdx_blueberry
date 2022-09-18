RDX = nil
TriggerEvent('rdx:getSharedObject', function(obj) RDX = obj end)

RegisterServerEvent('rdx:addBlueBerry')
AddEventHandler('rdx:addBlueBerry', function() 
	local xPlayer = RDX.GetPlayerFromId(source)
	math.randomseed(GetGameTimer())
	local amount = math.random(1,2)
	
	xPlayer.addInventoryItem("item_blueberry", 1)  	
        xPlayer.removeInventoryItem("item_stick", 1)
	xPlayer.removeInventoryItem("item_cricket", 1)
end)

RDX.RegisterUsableItem("item_blueberry", function(source)
   local xPlayer = RDX.GetPlayerFromId(source)   
   xPlayer.removeInventoryItem("item_blueberry", 1)   
   TriggerClientEvent("rdx:EatBlueBerry", xPlayer)		
end)
