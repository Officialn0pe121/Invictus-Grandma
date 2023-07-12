local QBCore = exports['qb-core']:GetCoreObject()

local lady = {}
local GrandmaCoords = vector4(2435.63, 4965.12, 45.81, 8.76)
local NotifySystem = "tnj-notify" -- "okok-notify"/"tnj-notify"/"ps-ui"

local function loadAnimDict(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Wait(1)
    end
end

local SpawnGrandma = function()
    RequestModel(`ig_mrs_thornhill`)
    while not HasModelLoaded(`ig_mrs_thornhill`) do
        Wait(0)
    end

    lady = CreatePed(0, `ig_mrs_thornhill`, GrandmaCoords.x, GrandmaCoords.y, GrandmaCoords.z, GrandmaCoords.w, false, false)
    SetEntityAsMissionEntity(lady)
    SetPedFleeAttributes(lady, 0, 0)
    SetBlockingOfNonTemporaryEvents(lady, true)
    FreezeEntityPosition(lady, true)
    loadAnimDict("timetable@reunited@ig_10")
    TaskPlayAnim(lady, "timetable@reunited@ig_10", "base_amanda", 8.0, 1.0, -1, 01, 0, 0, 0, 0)

    exports['qb-target']:AddTargetEntity(lady, {
        options = {
            { 
                type = "client",
                event = "Invictus-Grandma:client:checkshit",
                icon = "fa-solid fa-house-medical",
                label = "Get A Band-Aid",
            },
        },
        distance = 2.5 
    })
end

local DeleteGrandma = function()
    if DoesEntityExist(lady) then
        DeletePed(lady)
    end
end

local GrandmaSit = function()
    loadAnimDict("timetable@reunited@ig_10")        
    TaskPlayAnim(lady, "timetable@reunited@ig_10", "base_amanda", 8.0, 1.0, -1, 01, 0, 0, 0, 0)
end

-- Revive the dumb cunt

local ReviveDeadPlayer = function()
    SetEntityCoords(PlayerPedId(), 2435.58, 4966.11, GrandmaCoords.z)
    TaskStartScenarioInPlace(lady, "CODE_HUMAN_MEDIC_TEND_TO_DEAD", 0, true)
    QBCore.Functions.Progressbar("grandma", "Grandma is healing your wounds..", 10000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
     }, {}, {}, {}, function()
        exports['tnj-notify']:Notify("You feel much better now.", "success", 5000)
        TriggerEvent('hospital:client:Revive')
        ClearPedTasks(PlayerPedId())
        ClearPedTasksImmediately(lady)
        GrandmaSit()
     end, function() -- Cancel
        ClearPedTasks(PlayerPedId())
        ClearPedTasksImmediately(lady)
        GrandmaSit()
    end)
end

-- Event Handlers

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        SpawnGrandma()
    end
end)

AddEventHandler('onResourceStop', function(resourceName) 
	if GetCurrentResourceName() == resourceName then
        DeleteGrandma()
	end 
end)

-- Status and Money Check

RegisterNetEvent("Invictus-Grandma:client:checkshit", function()
    local ped = PlayerPedId()
    local Player = PlayerId()

    QBCore.Functions.GetPlayerData(function(PlayerData)
        if PlayerData.metadata["inlaststand"] or PlayerData.metadata["isdead"] then
            QBCore.Functions.TriggerCallback('Invictus-Grandma:server:RevivePlayer', function(canRevive)
                if canRevive then
                    ReviveDeadPlayer()
                end
            end)
        else
            exports[NotifySystem]:Notify("You don\'t need a band-aid!", "error", 5000)
        end
    end)
end)
