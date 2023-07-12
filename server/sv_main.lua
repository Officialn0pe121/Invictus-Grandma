local QBCore = exports['qb-core']:GetCoreObject()

local GrandmaFee = 2000
local AiDocFee = 5000
local CDTimer = 10 -- Cooldown in minutes
local CD = false
local debug = true
local payType = "cash" -- "cash" / "bank" / "crypto"

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
            Player.Functions.RemoveMoney(payType, GrandmaFee, "Grandma Visit")
            cb(true)
            Cooldown()
        else
            TriggerClientEvent('QBCore:Notify', src, "Grandma doesn\'t have any band-aids right now..", "error",  5000)  -- Default Notify
        end
    else
        TriggerClientEvent('QBCore:Notify', src, "Grandma isn\'t interested in helping..", "error",  5000)
        cb(false)
    end
end)
