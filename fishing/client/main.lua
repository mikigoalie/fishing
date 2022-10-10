ESX = exports["es_extended"]:getSharedObject()
local fishing, lovi = false, false
CreateThread(function()
    CreateBlip(Config.SellShop, 356, 1, Language['sell_shop_blip'], 0.80)
    --[[for _, info in pairs(Config.Mista) do
		info.blip =	AddBlipForRadius(info.x, info.y, info.z, info.r)-- you can use a higher number for a bigger zone
		SetBlipHighDetail(info.blip, true)
		SetBlipColour(info.blip, info.colour)
		SetBlipAlpha (info.blip, 25)
		info.blip = AddBlipForCoord(info.x, info.y, info.z)
		SetBlipSprite(info.blip, info.id)
		SetBlipDisplay(info.blip, 4)
		SetBlipScale(info.blip, 0.5)
		SetBlipAsShortRange(info.blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(info.title)
		EndTextCommandSetBlipName(info.blip)
	end]]
end)

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


local showing, inmenu = false
 --Sell Shop Functionality
CreateThread(function()
	while true do
        local Sleep = 1500
		local player = PlayerPedId()
		local playerCoords = GetEntityCoords(player)
		local dist = #(playerCoords - Config.SellShop)
		if dist <= 10.0 then
            Sleep = 0
            DrawMarker(0, vector3(Config.SellShop.x, Config.SellShop.y, Config.SellShop.z-0.5), 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.25, 0.25, 0.25, 255, 205, 0, 100, false, true, 2, true, false, false, false) 
            if dist <= 1.5 then
                if not inmenu then
                    Ukaz(true)
                end
                if IsControlJustReleased(0, 38) and dist <= 1.5 then
                    UkazRybare(dist)
                    Ukaz(false)
                    inmenu = true
                end
            elseif dist > 1.5 and showing then
                Ukaz(false)
            end
        end
    Wait(Sleep)
	end
end)

function UkazRybare(dist)
    lib.registerMenu({
        id = 'rybar',
        title = 'Rybář',
        position = 'top-right',
        onSideScroll = function(selected, scrollIndex, args)
            print(selected, scrollIndex, args)
        end,
        onSelected = function(selected, scrollIndex, args)
            print(selected, scrollIndex, args)
        end,
        onClose = function(keyPressed)
            inmenu = false
        end,
        options = {
            {label = 'Prodat rybu', description = 'Prodej rybářovi své úlovky', icon = 'fish'},
            {label = 'Otevřít obchod rybáře', icon = 'shop'},
        }
    }, function(selected, scrollIndex, args)
        if selected == 1 then
            FishingSellItems(dist)
        elseif selected == 2 then
            exports.ox_inventory:openInventory('shop', { type = 'Rybar', id = 1 })
        end
    end)
    lib.showMenu('rybar')
end

function Ukaz(bool)
    if bool and not showing then
        print('WTF2?')
        showing = true
        lib.showTextUI('[E] - Otevřít obchod', {
            position = "top-center",
            icon = 'fish',
            style = {
                borderRadius = 0,
                backgroundColor = '#000000',
                color = 'white'
            }
        })
    elseif bool == false then
        showing = false
        lib.hideTextUI()
    end
end

RegisterNetEvent('wasabi_fishing:startFishing')
AddEventHandler('wasabi_fishing:startFishing', function()
    print('StartFishing')
    local ped = PlayerPedId()
    local specialarea = false
    if IsPedInAnyVehicle(ped) or IsPedSwimming(ped) then
        TriggerEvent('wasabi_fishing:notify', Language['cannot_perform'], "info")
        return
    end

    ESX.TriggerServerCallback('wasabi_fishing:checkItem', function(cb)
        if cb.maprut == true then
            local water, waterLoc = waterCheck()
            local prut  = exports.ox_inventory:Search('slots', Config.FishingRod.itemname)
            for k,v in pairs(Config.Mista) do
                if IsEntityAtCoord(ped, v.x, v.y, v.z, v.r, v.r, 10.0, 0, 1, 0) == 1 then
                    specialarea = true
                end
            end
            if water then
                if not fishing then
                    fishing = true
                    local modelHash = `prop_fishing_rod_02`
                    local model = loadModel(modelHash)
                    local pole = CreateObject(model, GetEntityCoords(PlayerPedId()), true, false, false)
                    AttachEntityToEntity(pole, ped, GetPedBoneIndex(ped, 18905), 0.1, 0.05, 0, 80.0, 120.0, 160.0, true, true, false, true, 1, true)
                    SetModelAsNoLongerNeeded(pole)
                    local castDict = loadDict('mini@tennis')
                    local idleDict = loadDict('amb@world_human_stand_fishing@idle_a')
                    TaskPlayAnim(ped, castDict, 'forehand_ts_md_far', 1.0, -1.0, 1.0, 48, 0, 0, 0, 0)
                    Wait(3000)
                    TaskPlayAnim(ped, idleDict, 'idle_c', 1.0, -1.0, 1.0, 11, 0, 0, 0, 0)
                    local Cekani = tonumber(Config.Metin[tostring(cb.meta)].cekani)
                    while fishing do
                        Wait(0)
                        local unarmed = `WEAPON_UNARMED`
                        SetCurrentPedWeapon(ped, unarmed)
                        ShowHelp(Language['intro_instruction'])
                        DisableControlAction(0, 38, true)
                        if IsDisabledControlJustReleased(0, 38) and not lovi then
                            TriggerServerEvent('fishing:meta')
                            lovi = true
                            TaskPlayAnim(ped, castDict, 'forehand_ts_md_far', 1.0, -1.0, 1.0, 48, 0, 0, 0, 0)
                            TriggerEvent('cS.Saving','Nahodil jsi lano, nyní ulov rybu.', 2, Cekani, true)
                            Wait(Cekani)
                            TriggerEvent('wasabi_fishing:notify', Language['got_bite'], "info")
                            Wait(250)
                            print(cb.meta)
                            print(tostring(cb.meta))
                            local skillbar = CreateSkillbar(1, tostring(cb.meta))
                            if skillbar then
                                ClearPedTasks(ped)
                                tryFish(specialarea)
                                TaskPlayAnim(ped, idleDict, 'idle_c', 1.0, -1.0, 1.0, 11, 0, 0, 0, 0)
                                TriggerServerEvent('fishing:meta', true)
                            else
                            --[[    local breakChance = math.random(1,100)
                                if breakChance < Config.FishingRod.breakChance then
                                    TriggerServerEvent('wasabi_fishing:rodBroke')
                                    TriggerEvent('wasabi_fishing:notify', Language['rod_broke'], "error")
                                    ClearPedTasks(ped)
                                    fishing = false
                                    break
                                end]]
                                TriggerEvent('wasabi_fishing:notify', Language['failed_fish'], "error")
                            end
                            lovi = false
                            Wait(250)
                        elseif IsControlJustReleased(0, 194) then
                            ClearPedTasks(ped)
                            break
                        elseif #(GetEntityCoords(ped) - waterLoc) > 30 then
                            break
                        end
                    end
                    fishing = false
                    DeleteObject(pole)
                    RemoveAnimDict('mini@tennis')
                    RemoveAnimDict('amb@world_human_stand_fishing@idle_a')
                end
            else
                TriggerEvent('wasabi_fishing:notify', Language['no_water'], "info")
            end
        elseif cb.maprut == false then
            TriggerEvent('wasabi_fishing:notify', Language['no_bait'], "info")
        end
    end, Config.Bait.itemName)
end)


RegisterNetEvent('wasabi_fishing:interupt')
AddEventHandler('wasabi_fishing:interupt', function()
    local ped = PlayerPedId()
    fishing = false
    DeleteObject(pole)
    ClearPedTasks(ped)
end)


RegisterNetEvent('fishing:vylepsit')
AddEventHandler('fishing:vylepsit', function(slot)
    print(slot)
    TriggerServerEvent('fishing:vylepsit', slot)
end)


RegisterNetEvent('fishing:musle')
AddEventHandler('fishing:musle', function()
    TriggerServerEvent('fishing:musle')
end)
