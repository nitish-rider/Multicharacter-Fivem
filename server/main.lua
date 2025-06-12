if Config.Framework == "qb" then
    if not Config.CustomFrameWork then
        QBCore = exports[Config.Core]:GetCoreObject()
    else
        QBCore = exports[Config.CustomFrameWorkExport]:GetCoreObject()
    end
elseif Config.Framework == "oldqb" then
    QBCore = nil
    TriggerEvent('QBCore:GetObject', function(obj)
        QBCore = obj
    end)
end

hasDonePreloading = {}

--Fuctions
AddEventHandler('QBCore:Server:PlayerLoaded', function(Player)
    Wait(1000)
    hasDonePreloading[Player.PlayerData.source] = true
end)

AddEventHandler('QBCore:Server:OnPlayerUnload', function(src)
    hasDonePreloading[src] = false
end)

RegisterNetEvent('multicharacter:server:disconnect', function()
    local src = source
    DropPlayer(src, "Disconnected")
end)

RegisterNetEvent('multicharacter:server:createCharacter', function(data)
    local src = source
    local newData = {}
    newData.cid = data.cid
    newData.charinfo = data
    if QBCore.Player.Login(src, false, newData) then
        repeat
            Wait(10)
        until hasDonePreloading[src]
        if Config.UseQbApartments then
            local randbucket = (GetPlayerPed(src) .. math.random(1, 999))
            SetPlayerRoutingBucket(src, randbucket)
            print('^2[' .. Config.Core .. ']^7 ' .. GetPlayerName(src) .. ' has succesfully loaded!')
            QBCore.Commands.Refresh(src)
            loadHouseData(src)
            TriggerClientEvent("multicharacter:client:closeNUI", src)
            TriggerClientEvent('apartments:client:setupSpawnUI', src, newData)
            GiveStarterItems(src)
        else
            local randbucket = (GetPlayerPed(src) .. math.random(1, 999))
            SetPlayerRoutingBucket(src, randbucket)
            print('^2[' .. Config.Core .. ']^7 ' .. GetPlayerName(src) .. ' has succesfully loaded!')
            QBCore.Commands.Refresh(src)
            TriggerClientEvent('ps-housing:client:setupSpawnUI', src, newData)
            TriggerClientEvent("multicharacter:client:closeNUIdefault", src)
            GiveStarterItems(src)
        end
    end
end)

RegisterNetEvent('multicharacter:server:deleteCharacter', function(citizenid)
    local src = source
    local PlayerLicense = QBCore.Functions.GetIdentifier(src, 'license')
    QBCore.Player.DeleteCharacter(src, citizenid)
    TriggerClientEvent('QBCore:Notify', src, "Char Deleted", "Success")
    MySQL.query('SELECT cid,citizenid FROM players WHERE license = ? ORDER BY id ASC', { PlayerLicense },
            function(result)
                if result then
                    for i, data in ipairs(result) do
                        local newCID = i
                        MySQL.execute('UPDATE players SET cid = ? WHERE citizenid = ?', { newCID, data.citizenid })
                    end
                end
            end
    )
end)

-- Callbacks
lib.callback.register('multicharacter:server:GetNumberOfCharacters', function(source)
    local src = source
    local license = QBCore.Functions.GetIdentifier(src, 'license')
    local numofChars = 0
    local addedCount = 0

    local callBackData = {}

    if next(Config.PlayersNumberOfCharacters) then
        for _, v in pairs(Config.PlayersNumberOfCharacters) do
            if v.license == license then
                numOfChars = v.numberOfChars
                break
            else
                numOfChars = Config.DefaultNumberOfCharacters
            end
        end
    else
        numOfChars = Config.DefaultNumberOfCharacters
    end
    local result = ExecuteSql("SELECT * FROM multicharacter WHERE license = '" .. license .. "' ")
    if result[1] then
        addedCount = result[1].charCount
    end
    callBackData = {
        numOfChars = numOfChars,
        addedCount = addedCount,
    }
    return callBackData
end)

lib.callback.register('multicharacter:sendInput', function(source, data)
    local src = source
    local inputData = data
    local result = MySQL.query.await("SELECT * FROM multicharacter_codes WHERE code = ?", { inputData })
    if result[1] then
        if result[1].license then
            return false
        else
            local Name = GetPlayerName(src)
            if not Name then
                Name = "Unknown"
            end
            local license = QBCore.Functions.GetIdentifier(src, 'license')
            if not license then
                license = QBCore.Functions.GetIdentifier(src, 'license2')
            end
            local result2 = MySQL.query.await("SELECT * FROM multicharacter WHERE license = ?", { license })
            if result2[1] then
                MySQL.update.await("UPDATE multicharacter SET charCount = charCount + 1 WHERE license = ?", { license })
                MySQL.update.await("UPDATE multicharacter_codes SET license = ?, steam_name = ? Where code = ?",
                        { license, Name, inputData })
            else
                MySQL.insert.await('INSERT INTO multicharacter (license, charCount) VALUES (?, ?)', { license, 1 })
                MySQL.update.await('UPDATE multicharacter_codes SET license = ?, steam_name = ? WHERE code = ?',
                        { license, Name, inputData })
            end
            return true
        end
    else
        return false
    end
end)

function ExecuteSql(query)
    local IsBusy = true
    local result = nil
    if Config.Mysql == "oxmysql" then
        if MySQL == nil then
            exports.oxmysql:execute(query, function(data)
                result = data
                IsBusy = false
            end)
        else
            MySQL.query(query, {}, function(data)
                result = data
                IsBusy = false
            end)
        end
    end
    while IsBusy do
        Citizen.Wait(0)
    end
    return result
end

lib.addCommand('logout', {
    help = 'Logout (Admin Only)',
    params = {
        {
            name = 'target',
            type = 'playerId',
            help = 'Target player\'s server id',
            optional = true
        }
    },
    restricted = 'group.admin'
}, function(source, args, raw)
    if not args.target then
        args.target = source
    end
    QBCore.Player.Logout(args.target)
    TriggerClientEvent('multicharacter:client:chooseCharX', args.target)
end)