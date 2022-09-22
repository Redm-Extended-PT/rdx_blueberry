RDX = nil
TriggerEvent('rdx:getSharedObject', function(obj) RDX = obj end)

RegisterServerEvent('Blueberry:Add')
AddEventHandler('Blueberry:Add', function() 
	local xPlayer = RDX.GetPlayerFromId(source)	
	local item = math.random(1,3)
	local amount = 1
	--math.randomseed(GetGameTimer())

	--xPlayer.addInventoryItem('item_blueberry',amount)
	xPlayer.addInventoryItem(Config.ItemSet[item],amount)
	TriggerClientEvent('rdx:showNotification', Config.MsgSet[item], 0, 0, centre)  
	item = 0
end)

RDX.RegisterUsableItem('item_blueberry', function(source)
   local xPlayer = RDX.GetPlayerFromId(source)   
   xPlayer.removeInventoryItem('item_blueberry',1)   
   TriggerClientEvent('Blueberry:Eat', source)
   -- msg		
end)
