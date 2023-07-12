local QBCore = exports['qb-core']:GetCoreObject()

local GrandmaFee = 2000
local AiDocFee = 5000
local CDTimer = 10 -- Cooldown in minutes
local CD = false
local debug = true

local Cooldown = function()
    CD = true
    if debug then
        print("Grandma Cooldown")
    end
	local timer = CDTimer * 60000
	while timer > 0 do
		Wait(1000)
		timer = timer - 1000
		if timer == 0 then
			CD = false
		end
	end
end

QBCore.Functions.CreateCallback('Invictus-Grandma:server:RevivePlayer', function(source, cb)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if Player.PlayerData.money.cash >= GrandmaFee then
        if not CD then
            Player.Functions.RemoveMoney('cash', GrandmaFee, "Grandma Visit")
            cb(true)
            Cooldown()
        else
            TriggerClientEvent('QBCore:Notify', src, "Grandma doesn\'t have any band-aids right now..", "error",  5000)
        end
    else
        TriggerClientEvent('QBCore:Notify', src, "Grandma isn\'t interested in helping..", "error",  5000)
        cb(false)
    end
end)

QBCore.Functions.CreateCallback('Invictus-Grandma:docOnline', function(source, cb)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local xPlayers = QBCore.Functions.GetPlayers()
    local doctor = 0

    if Player.PlayerData.money.cash >= AiDocFee then
        for i=1, #xPlayers, 1 do
            local xPlayer = QBCore.Functions.GetPlayer(xPlayers[i])
            if xPlayer.PlayerData.job.name == 'ambulance' and xPlayer.PlayerData.job.onduty then
                doctor = doctor + 1
            end
        end
        if doctor <= 1 then
            Player.Functions.RemoveMoney('cash', AiDocFee, "Ambulance Visit")
            cb(true)
        else
            TriggerClientEvent('QBCore:Notify', src, "Too many doctors online..", "error",  5000)
            cb(false)
        end

    else
        TriggerClientEvent('QBCore:Notify', src, "Not enough money for the ambulance..", "error",  5000)
        cb(false)
    end
end)
