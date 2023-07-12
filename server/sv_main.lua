local QBCore = exports['qb-core']:GetCoreObject()

local GrandmaFee = 2000
local CDTimer = 10 -- Cooldown in minutes
local CD = false
local debug = true
local payType = "cash" -- "cash" / "bank" / "crypto"

local Cooldown = function()
    CD = true
    if debug then
        print("Grandma Cooldown Started")
    end
	local timer = CDTimer * 60000
	while timer > 0 do
		Wait(1000)
		timer = timer - 1000
		if timer == 0 then
			CD = false
			if debug then
        			print("Grandma Cooldown Ended")
    			end
		end
	end
end

QBCore.Functions.CreateCallback('Invictus-Grandma:server:RevivePlayer', function(source, cb)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if payType == "cash" then
        if Player.PlayerData.money.cash >= GrandmaFee then
            if not CD then
                Player.Functions.RemoveMoney("cash", GrandmaFee, "Grandma Visit")
                cb(true)
                Cooldown()
            else
                TriggerClientEvent('QBCore:Notify', src, "Grandma doesn\'t have any band-aids right now..", "error",  5000)
            end
        else
            TriggerClientEvent('QBCore:Notify', src, "Grandma isn\'t interested in helping..", "error",  5000)
            cb(false)
        end
    elseif payType == "bank" then
        if Player.PlayerData.money.bank >= GrandmaFee then
            if not CD then
                Player.Functions.RemoveMoney("bank", GrandmaFee, "Grandma Visit")
                cb(true)
                Cooldown()
            else
                TriggerClientEvent('QBCore:Notify', src, "Grandma doesn\'t have any band-aids right now..", "error",  5000)
            end
        else
            TriggerClientEvent('QBCore:Notify', src, "Grandma isn\'t interested in helping..", "error",  5000)
            cb(false)
        end
    else
        if Player.PlayerData.money.crypto >= GrandmaFee then
            if not CD then
                Player.Functions.RemoveMoney("crypto", GrandmaFee, "Grandma Visit")
                cb(true)
                Cooldown()
            else
                TriggerClientEvent('QBCore:Notify', src, "Grandma doesn\'t have any band-aids right now..", "error",  5000)
            end
        else
            TriggerClientEvent('QBCore:Notify', src, "Grandma isn\'t interested in helping..", "error",  5000)
            cb(false)
        end
    end
end)
