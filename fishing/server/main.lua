-- # [ INIT ] # --

ESX = exports["es_extended"]:getSharedObject()

local ox_inventory = exports.ox_inventory

function dump(o)
	if type(o) == 'table' then
	   local s = '{ '
	   for k,v in pairs(o) do
		  if type(k) ~= 'number' then k = '"'..k..'"' end
		  s = s .. '['..k..'] = ' .. dump(v) .. ','
	   end
	   return s .. '} '
	else
	   return tostring(o)
	end
end

-- #  # #  ##  # #  ##  # #  # --
-- #  # #  ##  # #  ##  # #  # --
ESX.RegisterServerCallback('wasabi_fishing:checkItem', function(source, cb, itemname)
    local xPlayer = ESX.GetPlayerFromId(source)
    local item = xPlayer.getInventoryItem(itemname).count
    local water = ox_inventory:Search(source, 1, Config.FishingRod.itemName)
    for k, v in pairs(water) do
        water = v
        break
    end
    if not water.metadata.lvl then
        water.metadata.lvl = 0
        water.metadata.prog = 0
        water.metadata.label = 'Rybářský prut +'..tostring(water.metadata.lvl)
        water.metadata.type = tostring(water.metadata.prog) .. "/" .. Config.Metin[tostring(water.metadata.lvl)].pocet
        ox_inventory:SetMetadata(source, water.slot, water.metadata)
    end
    if item >= 1 then
        local c = {
            maprut = true,
            meta = water.metadata.lvl,
        }
        cb(c)
    else
        local c = {
            maprut = false,
            meta = water.metadata.lvl,
        }
        cb(c)
    end
end)

RegisterServerEvent('wasabi_fishing:rodBroke')
AddEventHandler('wasabi_fishing:rodBroke', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem(Config.FishingRod.itemName, 1)
    TriggerClientEvent('wasabi_fishing:interupt', source)
end)



-- # ?ušle # --

RegisterServerEvent('fishing:musle')
AddEventHandler('fishing:musle', function(slot, arg)
    local srs = source
    local xPlayer = ESX.GetPlayerFromId(srs)
    local musle = exports.ox_inventory:Search(srs, 'count', 'musle')
    local perly = {
        "bilaperla",
        "modraperla",
        "cervenaperla"
    }
    if musle > 0 then
        local rewitem = perly[math.random(3)]
        if arg == "vše" then
            for i=1, musle do
                exports.ox_inventory:AddItem(srs, perly[math.random(3)], 1, nil, nil, function(success, reason)
                    if success then
                        exports.ox_inventory:RemoveItem(srs, 'musle', 1)
                    end
                end)
            end
        else
            exports.ox_inventory:AddItem(srs, rewitem, 1, nil, nil, function(success, reason)
                if success then
                    exports.ox_inventory:RemoveItem(srs, 'musle', 1)
                else
                    TriggerClientEvent("swt_notifications:Icon",srs,"Nemáš u sebe dostatek místa.","top",3000,"dark","white",true,"mdi-exclamation")
                end
            end)
        end
    else
        print('Hráč ' .. xPlayer.getName() .. ' chtěl otevřít mušli, aniž by nějakou měl, wtf?')
    end
    --[[
    if prut.metadata.type ~= nil then
        if prut.metadata.prog <= Config.Metin[tostring(prut.metadata.lvl)].pocet then
            prut.metadata.prog = 0
            prut.metadata.lvl = prut.metadata.lvl +1
            prut.metadata.label = 'Rybářský prut +'..tostring(prut.metadata.lvl)
            prut.metadata.type = tostring(prut.metadata.prog) .. "/" .. Config.Metin[tostring(prut.metadata.lvl)].pocet 
            ox_inventory:SetMetadata(srs, prut.slot, prut.metadata)
        else
            TriggerClientEvent('wasabi_fishing:notify', source, "Ještě je na vylepšování příliš brzy.. Potřebuješ ulovit alespoň " .. tonumber(Config.Metin[tostring(prut.metadata.lvl)].pocet) - prut.metadata.prog .. " ryb(y)", "error")
        end
    else
        print(xPlayer.getName() .. " chtěl vylepšit prut, když nemohl. Probably cheating")
        TriggerClientEvent('wasabi_fishing:notify', source, "Tohle vylepšit nejde..", "error")
    end]]
end)


-- # Logic for metadata durability # --
RegisterServerEvent('fishing:meta')
AddEventHandler('fishing:meta', function(chytl)
    local xPlayer = ESX.GetPlayerFromId(source)
    local water = ox_inventory:Search(source, 1, Config.FishingRod.itemName)
    for k, v in pairs(water) do
        water = v
        break
    end
    if chytl then
        if (water.metadata.prog + 1 < Config.Metin[tostring(water.metadata.lvl)].pocet) then
            water.metadata.prog = water.metadata.prog + 1
        else
            water.metadata.prog = water.metadata.prog
        end
        print(water.metadata.type, "TYPE")
        print(water.metadata.prog, "PROG")
        water.metadata.type = tostring(water.metadata.prog) .. "/" .. Config.Metin[tostring(water.metadata.lvl)].pocet 
    else
        xPlayer.removeInventoryItem(Config.Bait.itemName, 1)
    end
    ox_inventory:SetMetadata(source, water.slot, water.metadata)
end)


RegisterServerEvent('fishing:vylepsit')
AddEventHandler('fishing:vylepsit', function(slot)
    local srs = source
    local xPlayer = ESX.GetPlayerFromId(srs)
    local prut = exports.ox_inventory:GetSlot(srs, slot)
    if prut.metadata.type ~= nil then
        local raq = {}
        if prut.metadata.prog == Config.Metin[tostring(prut.metadata.lvl)].pocet then
            local perly = exports.ox_inventory:Search(srs, 'count', {'cervenaperla', 'bilaperla', 'modraperla'})
            for k, v in pairs(perly) do
                if Config.Metin[tostring(prut.metadata.lvl)].req['cervenaperla'] ~= nil then
                    if v >= Config.Metin[tostring(prut.metadata.lvl)].req[k] then
                        raq[k] = true
                        exports.ox_inventory:RemoveItem(srs, k, Config.Metin[tostring(prut.metadata.lvl)].req[k])
                    end
                else
                    raq[k] = true
                end
            end
            if raq["cervenaperla"] and raq["bilaperla"] and raq["modraperla"] then
                prut.metadata.prog = 0
                prut.metadata.lvl = prut.metadata.lvl +1
                prut.metadata.label = 'Rybářský prut +'..tostring(prut.metadata.lvl)
                prut.metadata.type = tostring(prut.metadata.prog) .. "/" .. Config.Metin[tostring(prut.metadata.lvl)].pocet 
                ox_inventory:SetMetadata(srs, prut.slot, prut.metadata)
            else
                TriggerClientEvent('okokNotify:Alert', source, "Rybaření", "Na vylepšení potřebuješ x".. Config.Metin[tostring(prut.metadata.lvl)].req["cervenaperla"] .. " od každé perly.", 5000, 'error')
            end
        else
            TriggerClientEvent('wasabi_fishing:notify', source, "Ještě je na vylepšování příliš brzy.. Potřebuješ ulovit alespoň " .. tonumber(Config.Metin[tostring(prut.metadata.lvl)].pocet) - prut.metadata.prog .. " ryb(y)", "error")
        end
    else
        print(xPlayer.getName() .. " chtěl vylepšit prut, když nemohl. Probably cheating")
        TriggerClientEvent('wasabi_fishing:notify', source, "Tohle vylepšit nejde..", "error")
    end
end)


RegisterServerEvent('wasabi_fishing:tryFish')
AddEventHandler('wasabi_fishing:tryFish', function(specialarea)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xPole = xPlayer.getInventoryItem(Config.FishingRod.itemName).count
    local xBait = xPlayer.getInventoryItem(Config.Bait.itemName).count
    if xPole > 0 and xBait > 0 then
        --[[local chance = math.random(1,100)
        if chance <= Config.Bait.loseChance then
            xPlayer.removeInventoryItem(Config.Bait.itemName, 1)
            TriggerClientEvent('wasabi_fishing:notify', source, Language['bait_lost'])
        end]]
        local awardItem
        if specialarea then
            awardItem = Config.Fish[math.random(#Config.SpecFish)]
        else
            awardItem = Config.Fish[math.random(#Config.Fish)]
        end
        local awardLabel = ESX.GetItemLabel(awardItem)
        if xPlayer.canCarryItem(awardItem, 1) then
            xPlayer.addInventoryItem(awardItem, 1)
            TriggerClientEvent('wasabi_fishing:notify', source, string.format(Language['fish_success'], awardLabel))
        else
            TriggerClientEvent('wasabi_fishing:notify', source, Language['cannot_carry'])
        end
    elseif xPole > 0 and xBait < 1 then
        TriggerClientEvent('wasabi_fishing:interupt', source)
        TriggerClientEvent('wasabi_fishing:notify', source, Language['no_bait'])
    elseif xPole < 1 then
        xPlayer.kick(Language['kicked'])
    end
end)

RegisterServerEvent('wasabi_fishing:sellFish')
AddEventHandler('wasabi_fishing:sellFish', function(distance)
    if distance ~= nil then
        if distance <= 3 then
            for k, v in pairs(Config.FishPrices) do
                local xPlayer = ESX.GetPlayerFromId(source)
                if xPlayer.getInventoryItem(k).count > 0 then
                    local rewardAmount = 0
                    for i = 1, xPlayer.getInventoryItem(k).count do
                        rewardAmount = rewardAmount + math.random(v[1], v[2])
                    end
                    xPlayer.addMoney(rewardAmount)
                    TriggerClientEvent('wasabi_fishing:notify', source, (Language['sold_for']):format(xPlayer.getInventoryItem(k).count, xPlayer.getInventoryItem(k).label, addCommas(rewardAmount)))
                    xPlayer.removeInventoryItem(k, xPlayer.getInventoryItem(k).count)
                end
            end
        else
            xPlayer.kick(Language['kicked'])
        end
    else
        xPlayer.kick(Language['kicked'])
    end
end)

ESX.RegisterUsableItem(Config.FishingRod.itemName, function(source)
    TriggerClientEvent('wasabi_fishing:startFishing', source)
end)

ESX.RegisterUsableItem('musle', function(source)
    TriggerClientEvent('fishing:musle', source)
end)

addCommas = function(n)
	return tostring(math.floor(n)):reverse():gsub("(%d%d%d)","%1,")
								  :gsub(",(%-?)$","%1"):reverse()
end