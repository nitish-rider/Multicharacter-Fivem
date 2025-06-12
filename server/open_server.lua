lib.callback.register('multicharacter:server:setupCharacters', function(source)
    local license = QBCore.Functions.GetIdentifier(source, 'license')
    local plyChars = {}
    local result = ExecuteSql("SELECT * FROM players WHERE license = '" .. license .. "'")

    for i = 1, (#result), 1 do
        result[i].charinfo = json.decode(result[i].charinfo)
        result[i].job = json.decode(result[i].job)
        plyChars[#plyChars + 1] = result[i]
    end
    table.sort(plyChars, function(a, b)
        return a.cid < b.cid
    end)

    return plyChars
end)

lib.callback.register('multicharacter:server:getSkin', function(source, cid)
    local result = MySQL.query.await('SELECT * FROM playerskins WHERE citizenid = ? AND active = ?', { cid, 1 })
    if result[1] ~= nil then
        return json.decode(result[1].skin)
    else
        return nil
    end
end)

function GiveStarterItems(source)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    Player.Functions.AddItem('starterkit', 1)
    local dlnumber = 'DL' ..
            math.random(00, 99) ..
            '' ..
            QBCore.Shared.RandomStr(2):upper() ..
            '' .. math.random(00, 99) .. '/' .. QBCore.Shared.RandomStr(2):upper() .. '' .. math.random(00, 99) .. ''
    Player.Functions.SetMetaData('drivinglicensenumber', dlnumber)
    -- MySQL.update('UPDATE players SET dlnumber = ? WHERE citizenid = ?', { dlnumber, Player.PlayerData.citizenid })
    local weaponlicensenumber = 'WP' ..
            math.random(00, 99) ..
            '' ..
            QBCore.Shared.RandomStr(2):upper() ..
            '' .. math.random(00, 99) .. '/' .. QBCore.Shared.RandomStr(2):upper() .. '' .. math.random(00, 99) .. ''
    Player.Functions.SetMetaData('weaponlicensenumber', weaponlicensenumber)
    -- MySQL.update('UPDATE players SET weaponlicensenumber = ? WHERE citizenid = ?', { weaponlicensenumber, Player.PlayerData.citizenid })
    local huntinglicensenumber = 'HNT' ..
            math.random(00, 99) ..
            '' ..
            QBCore.Shared.RandomStr(2):upper() ..
            '' .. math.random(00, 99) .. '/' .. QBCore.Shared.RandomStr(2):upper() .. '' .. math.random(00, 99) .. ''
    Player.Functions.SetMetaData('huntinglicensenumber', huntinglicensenumber)
    -- MySQL.update('UPDATE players SET huntinglicensenumber = ? WHERE citizenid = ?', { huntinglicense, Player.PlayerData.citizenid })
end

function loadHouseData(src)
    local HouseGarages = {}
    local Houses = {}
    local result = ExecuteSql('SELECT * FROM houselocations')
    if result[1] ~= nil then
        for _, v in pairs(result) do
            local owned = false
            if tonumber(v.owned) == 1 then
                owned = true
            end
            local garage = v.garage ~= nil and json.decode(v.garage) or {}
            Houses[v.name] = {
                coords = json.decode(v.coords),
                owned = owned,
                price = v.price,
                locked = true,
                adress = v.label,
                tier = v.tier,
                garage = garage,
                decorations = {},
            }
            HouseGarages[v.name] = {
                label = v.label,
                takeVehicle = garage,
            }
        end
    end
    TriggerClientEvent("qb-garages:client:houseGarageConfig", src, HouseGarages)
    TriggerClientEvent("qb-houses:client:setHouseConfig", src, Houses)
end

RegisterNetEvent('multicharacter:server:loadUserData', function(cData)
    local src = source
    if QBCore.Player.Login(src, cData) then
        repeat
            Wait(10)
        until hasDonePreloading[src]
        print(GetPlayerName(src) .. ' (Citizen ID: ' .. cData .. ') has succesfully loaded!')
        QBCore.Commands.Refresh(src)
        local varS = {
            citizenid = cData
        }
        if Config.UseQbApartments then
            loadHouseData(src)
            TriggerClientEvent('apartments:client:setupSpawnUI', src, varS)
        else
            TriggerClientEvent('qb-spawn:client:setupSpawns', src, cData, false, nil)
            TriggerClientEvent('qb-spawn:client:openUI', src, true)

        end
        TriggerClientEvent('ps-housing:client:setupSpawnUI', src, cData)
        TriggerEvent("qb-log:server:CreateLog", "joinleave", "Loaded", "green",
                "**" ..
                        GetPlayerName(src) ..
                        "** (" ..
                        (QBCore.Functions.GetIdentifier(src, 'discord') or 'undefined') ..
                        " |  ||" ..
                        (QBCore.Functions.GetIdentifier(src, 'ip') or 'undefined') ..
                        "|| | " ..
                        (QBCore.Functions.GetIdentifier(src, 'license') or 'undefined') .. " | " .. cData .. " | " ..
                        src .. ") loaded..")
    end
end)