RDX = nil
TriggerEvent('rdx:getSharedObject', function(obj) RDX = obj end)

RegisterServerEvent('rdx:addBlueBerry')
AddEventHandler('rdx:addBlueBerry', function() 
	local xPlayer = RDX.GetPlayerFromId(source)	
	local item = math.random(0,3)
	local amount = 1

	if item ~= nil then
	xPlayer.addInventoryItem(Config.ItemSet[item], amount)  
	math.randomseed(GetGameTimer())
	-- msg
    else
	-- msg
	end	
end)

RDX.RegisterUsableItem("item_blueberry", function(source)
   local xPlayer = RDX.GetPlayerFromId(source)   
   xPlayer.removeInventoryItem("item_blueberry", 1)   
   TriggerClientEvent("rdx:EatBlueBerry", xPlayer)
   -- msg		
end)
