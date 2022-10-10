local levels = {
    ["easy"] = {
        duration = 3000,
        width = 30
    },
    ["normal"] = {
        duration = 1500 ,
        width = 20,
    },
    ["medium"] = {
        duration = 2000,
        width = 1
    },
    ["0"] = {
        duration = 1250,
        width = 0.75,
    },
    ["1"] = {
        duration = 1500,
        width = 0.7,
    },
    ["2"] = {
        duration = 1750,
        width = 0.75,
    },
    ["3"] = {
        duration = 2000,
        width = 0.8,
    },
    ["4"] = {
        duration = 2100,
        width = 0.85,
    },
    ["5"] = {
        duration = 2200,
        width = 0.95,
    },
    ["6"] = {
        duration = 2300,
        width = 0.85,
    },
    ["7"] = {
        duration = 2400,
        width = 0.9,
    },
    ["8"] = {
        duration = 2000,
        width = 1.15,
    },
    ["9"] = {
        duration = 2250,
        width = 1.3,
    },
}

local activePromise = nil
local inProgress = false

function CreateSkillbar(amount,level)
    if not inProgress then
        if type(level) == "string" then
            if not levels[level] then
                return false
            end
            level = levels[level]
        elseif type(level) == "table" then
            if not level.duration or not level.width then
                return false
            end
        end
        activePromise = promise:new()
        inProgress = true
        SendNUIMessage({
            action = "open",
            diff = level,
            amount=amount
        })
        CreateThread(listenToKeyCheck)
        return Citizen.Await(activePromise)
    else return false
    end
end

function listenToKeyCheck()
    while inProgress do
        Wait(0)
        if IsControlJustPressed(1,38) then
            SendNUIMessage({
                action = "check"
            })
        end
    end
end

RegisterNUICallback("finish",function(data,cb)
    local success = data.success
    inProgress = false
    if activePromise ~= nil then
        activePromise:resolve(success)
        activePromise = nil
    end
end)

AddEventHandler('esx:onPlayerDeath', function()
    if activePromise and inProgress then
        activePromise:resolve(false)
        activePromise = nil
        inProgress = false
        SendNUIMessage({
            action = "hide"
        })
    end
end)

AddEventHandler('skilbar:stop',function()
    inProgress = false
    SendNUIMessage({
        action = "hide"
    })
end)

exports("CreateSkillbar",CreateSkillbar)
