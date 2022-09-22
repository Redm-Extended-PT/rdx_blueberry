RDX = nil
Citizen.CreateThread(function()	while RDX == nil do TriggerEvent('rdx:getSharedObject', function(obj) RDX = obj end) Citizen.Wait(300) end end)

local CollectPrompt
local active = false
local stomach = 0
local cooldown = 0
local oldBush = {}
local checkbush = 0
local bush
local BlueBerrygroup = GetRandomIntInRange(0, 0xffffff)
print('BlueBerrygroup: ' .. BlueBerrygroup)

function CollectBlueberry()
    Citizen.CreateThread(function()
        local str = 'Collect'
        local wait = 0
        CollectPrompt = Citizen.InvokeNative(0x04F97DE45A519419)
        PromptSetControlAction(CollectPrompt, 0xD9D0E1C0)
        str = CreateVarString(10, 'LITERAL_STRING', str)
        PromptSetText(CollectPrompt, str)
        PromptSetEnabled(CollectPrompt, true)
        PromptSetVisible(CollectPrompt, true)
        PromptSetHoldMode(CollectPrompt, true)
        PromptSetGroup(CollectPrompt, BlueBerrygroup)
        PromptRegisterEnd(CollectPrompt)
    end)
end

Citizen.CreateThread(function()
    Wait(2000)    
    CollectBlueberry()
    while true do
        Wait(1)
        local playerped = PlayerPedId()
        if checkbush < GetGameTimer() and not IsPedOnMount(playerped) and not IsPedInAnyVehicle(playerped) and not eat and cooldown < 1 then
            bush = GetClosestBush()
            checkbush = GetGameTimer() + 1500
        end
        if bush then
            if active == false then
                local BlueBerryGroupName  = CreateVarString(10, 'LITERAL_STRING', "BlueBerry")
                PromptSetActiveGroupThisFrame(BlueBerrygroup, BlueBerryGroupName)
            end
            if PromptHasHoldModeCompleted(CollectPrompt) then
                active = true
                oldBush[tostring(bush)] = true
                goCollect()
            end
        end
    end
end)

function goCollect()
    local playerPed = PlayerPedId()
    RequestAnimDict("mech_pickup@plant@berries")
    while not HasAnimDictLoaded("mech_pickup@plant@berries") do
        Wait(100)
    end
    TaskPlayAnim(playerPed, "mech_pickup@plant@berries", "enter_lf", 8.0, -0.5, -1, 0, 0, true, 0, false, 0, false)
    Wait(1000)
    TaskPlayAnim(playerPed, "mech_pickup@plant@berries", "base", 8.0, -0.5, -1, 0, 0, true, 0, false, 0, false)
    Wait(2500)
    PlaySfx()
    TriggerServerEvent('Blueberry:Add', playerPed)
    active = false
    ClearPedTasks(playerPed)
end

RegisterNetEvent('Blueberry:Eat')
AddEventHandler('Blueberry:Eat', function()
    local playerPed = PlayerPedId()
    RequestAnimDict("mech_pickup@plant@berries")
    while not HasAnimDictLoaded("mech_pickup@plant@berries") do
        Wait(100)
    end
    TaskPlayAnim(playerPed, "mech_pickup@plant@berries", "exit_eat", 8.0, -0.5, -1, 0, 0, true, 0, false, 0, false)
    Wait(2500)

    stomach = stomach + 1
    if stomach >= 5 then
        Wait(2000)
        startSickness()             
    end
    ClearPedTasks(playerPed)
end)

function startSickness()    
    local dict = "amb_misc@world_human_vomit_kneel@male_a@idle_c"
    local anim = "idle_g"
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(100)
    end
    local test = 10
    Citizen.CreateThread(function()
        while test > 0 do           
            if not IsEntityPlayingAnim( PlayerPedId() ,dict, anim, 31) then
                TaskPlayAnim( PlayerPedId(), dict, anim, 8.0, -8.0, -1, 31, 0, true, 0, false, 0, false)
            end
            Wait(10000)
            local hp = GetEntityHealth(PlayerPedId())
            SetEntityHealth(PlayerPedId(),hp-5)
            test = test - 1
        end
        ClearPedTasksImmediately(PlayerPedId())
       
    end)
end

function GetClosestBush()
    local playerped = PlayerPedId()
    local itemSet = CreateItemset(true)
    local size = Citizen.InvokeNative(0x59B57C4B06531E1E, GetEntityCoords(playerped), 2.0, itemSet, 3, Citizen.ResultAsInteger())
    if size > 0 then
        for index = 0, size - 1 do
            local entity = GetIndexedItemInItemset(index, itemSet)
            local model_hash = GetEntityModel(entity)
            if (model_hash ==  477619010 or model_hash ==  85102137 or model_hash ==  -1707502213) and not oldBush[tostring(entity)] then
              if IsItemsetValid(itemSet) then
                  DestroyItemset(itemSet)
              end
              return entity
            end
        end
    else
    end

    if IsItemsetValid(itemSet) then
        DestroyItemset(itemSet)
    end
end

Citizen.CreateThread(function()
    while true do
      Wait(30000)       
       if stomach > 0 then
          stomach = stomach - 1       
       end        
    end
end)

function PlaySfx()
    TriggerServerEvent('InteractSound_SV:PlayOnSource', Config.Sfx, Config.Volume) 
end
