-----------------For support, scripts, and more----------------
-----------------https://discord.gg/XJFNyMy3Bv-----------------
---------------------------------------------------------------
local seconds, minutes = 1000, 60000
Config = {}
Config.SellShop = vector3(-1844.9635, -1195.5656, 19.1845) -- X, Y, Z Coords of where 
Config.Bait = {
    itemName = 'fishbait', -- Item name of bait
    loseChance = 90 -- Chance of loosing bait(Setting to 100 will use bait every cast)
}

Config.FishingRod = {
    itemName = 'fishingrod', -- Item name of fishing rod
    breakChance = 50 --Chance of breaking pole when failing skillbar (Setting to 0 means never break)
}

Config.Mista = { -- Name of obtainable fish (Must be in item database/table)
    {title='<FONT FACE="2">' .."Zóna pro lovení vzácných ryb", colour=78, id=762, x=-3592.9, y=-1183.2, z=2.6124, r = 350.0},
}

Config.Metin = {
    ['0'] = {
        pocet = 25,
        cekani = math.random(25000, 60000),
        req = {
        },
    },
    ['1'] = {
        pocet = 75,
        cekani = math.random(25000, 50000),
        req = {
        },
    },
    ['2'] = {
        pocet = 150,
        cekani = math.random(20000, 35000),
        req = {
            ["cervenaperla"] = 1,
            ["modraperla"] = 1,
            ["bilaperla"] = 1,
        },
    },
    ['3'] = {
        pocet = 300,
        cekani = math.random(20000, 30000),
        req = {
            ["cervenaperla"] = 3,
            ["modraperla"] = 3,
            ["bilaperla"] = 3,
        },
    },
    ['4'] = {
        pocet = 450,
        cekani = math.random(15000, 25000),
        req = {
            ["cervenaperla"] = 5,
            ["modraperla"] = 5,
            ["bilaperla"] = 5,
        },
    },
    ['5'] = {
        pocet = 600,
        cekani = math.random(15000, 22000),
        req = {
            ["cervenaperla"] = 10,
            ["modraperla"] = 10,
            ["bilaperla"] = 10,
        },
    },
    ['6'] = {
        pocet = 750,
        cekani = math.random(10000, 20000),
        req = {
            ["cervenaperla"] = 25,
            ["modraperla"] = 25,
            ["bilaperla"] = 25,
        },
    },
    ['7'] = {
        pocet = 900,
        cekani = math.random(7500, 20000),
        req = {
            ["cervenaperla"] = 50,
            ["modraperla"] = 50,
            ["bilaperla"] = 50,
        },
    },
    ['8'] = {
        pocet = 1050,
        cekani = math.random(5000, 20000),
        req = {
            ["cervenaperla"] = 75,
            ["modraperla"] = 75,
            ["bilaperla"] = 75,
        },
    },
    ['9'] = {
        pocet = 1500,
        cekani = math.random(1000, 22000),
        req = {
            ["cervenaperla"] = 50,
            ["modraperla"] = 50,
            ["bilaperla"] = 50,
        },
    },
}

Config.Fish = { -- Name of obtainable fish (Must be in item database/table)
    'tuna',
    'salmon',
    'trout',
    'anchovy',
    'musle',
    'mobil'
}

Config.SpecFish = { -- Name of obtainable fish (Must be in item database/table)
    'zralok',
    'delfin',
    'trout',
    'anchovy'
}

Config.FishPrices = { -- Price ranges for the items to sell (Must have the same as above)
    ['tuna'] = {1100, 1325},
    ['salmon'] = {1000, 1075},
    ['trout'] = {800, 965},
    ['anchovy'] = {800, 1225}
}




RegisterNetEvent('wasabi_fishing:notify')
AddEventHandler('wasabi_fishing:notify', function(message, typ)
    print(typ)
    if typ == "info" then
        exports['swt_notifications']:Icon(message,"top",3000,"dark","orange-5",true,"mdi-fish")
    elseif typ == "error" then
        exports['swt_notifications']:Icon(message,"top",3000,"dark","red-5",true,"mdi-fish")
    else
        exports['swt_notifications']:Icon(message,"top",3000,"green-10","white",true,"mdi-fish")
    end
    --Server
end)

Language = {
    --Help Text
    ['intro_instruction'] = '~INPUT_PICKUP~ nahodit lano, ~INPUT_FRONTEND_RRIGHT~ odejít.',
    ['rod_broke'] = 'Prut se zlomil!',
    ['cannot_perform'] = 'Tuto akci nelze provést.',
    ['failed_fish'] = 'Ryba uplavala..',
    ['no_water'] = 'Musíš být blíže k vodě.',
    ['no_bait'] = 'Nemáš žádnou návnadu.',
    ['bait_lost'] = 'Návnada ti z prutu vypadla.',
    ['fish_success'] = 'Chytl jsi 1x %s!',
    ['sell_shop_blip'] = 'Fish Market',
    ['sell_fish'] = '[~g~E~w~] k prodeji ryb',
    ['kicked'] = 'Retard',
    ['sold_for'] = 'Prodal jsi %sx %s za $%s',
    ['got_bite'] = 'Máš na prutu chycenou rybu, připrav se na tahání ven!',
    ['cannot_carry'] = 'Neuneseš úlovek!'
}
