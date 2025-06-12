---@param action string The action you wish to target
---@param data any The data you wish to send along with this action
function SendReactMessage(action, data)
    SendNUIMessage({
        action = action,
        data = data
    })
end

cam = nil
charPed = nil
opened = false
QBCore = exports[Config.Core]:GetCoreObject()
local checkState = false

-- Main Thread
AddEventHandler("playerSpawned", function()
    if not checkState then
        if NetworkIsSessionStarted() then
            TriggerEvent('multicharacter:client:chooseCharX')
        end
        checkState = true
    end
end)

AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        if NetworkIsSessionStarted() then
            TriggerEvent('multicharacter:client:chooseCharX')
        end
    end
end)

-- Functions
function cameraDoF(cam)
    SetCamUseShallowDofMode(cam, true)
    SetCamNearDof(cam, Config.CameraNearDof)
    SetCamFarDof(cam, Config.CameraFarDof)
    SetCamDofStrength(cam, Config.CameraDofStrength)
    SetCamActive(cam, true)
    RenderScriptCams(true, true, 2000, true, true)

    while DoesCamExist(cam) do
        SetUseHiDof()
        Wait(0)
    end
end

function skyCam(bool)
    TriggerEvent('qb-weathersync:client:DisableSync')
    if bool then
        SetTimecycleModifier('default')
        DoScreenFadeIn(1000)
        FreezeEntityPosition(PlayerPedId(), false)
        cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", Config.CamCoords.x, Config.CamCoords.y, Config.CamCoords.z,
                0.0, 0.0, Config.CamCoords.w, 60.00, false, 0)
        SetCamActive(cam, true)
        RenderScriptCams(true, false, 1000, true, true)
        ShakeCam(cam, Config.ShakeType, Config.CameraShake)
        cameraDoF(cam)
    else
        SetTimecycleModifier('default')
        SetCamActive(cam, false)
        DestroyCam(cam, true)
        RenderScriptCams(false, false, 1000, true, true)
        FreezeEntityPosition(PlayerPedId(), false)
    end
end

function openCharMenu(bool)
    local result = lib.callback.await('multicharacter:server:GetNumberOfCharacters', false)
    local defaultOpenCharSlot = Config.DefaultOpenCharSlot + result.addedCount
    if bool then
        opened = false
        while not opened do
            SetNuiFocus(bool, bool)
            SendReactMessage('setVisible', {
                toggle = bool,
                nChar = result.numOfChars,
                enableDeleteButton = Config.EnableDeleteButton,
                defaultCharCount = Config.MaxCharSlot,
                mySlotCount = defaultOpenCharSlot,
                Link = Config.Link,
            })
            Wait(1000)
        end
    else
        SetNuiFocus(bool, bool)
        SendReactMessage('setVisible', {
            toggle = bool,
            nChar = result.numOfChars,
            enableDeleteButton = Config.EnableDeleteButton,
            defaultCharCount = Config.MaxCharSlot,
            mySlotCount = defaultOpenCharSlot,
            Link = Config.Link,
        })
    end
    skyCam(bool)
end

-- Events

RegisterNetEvent('multicharacter:client:closeNUIdefault', function()
    openCharMenu(false)
    DeleteEntity(charPed)
    SetNuiFocus(false, false)
    DoScreenFadeOut(500)
    Wait(2000)
    SetEntityCoords(PlayerPedId(), Config.DefaultSpawn.x, Config.DefaultSpawn.y, Config.DefaultSpawn.z)
    SetEntityHeading(PlayerPedId(), Config.DefaultSpawn.h)
    TriggerServerEvent('QBCore:Server:OnPlayerLoaded')
    TriggerEvent('QBCore:Client:OnPlayerLoaded')
    TriggerServerEvent('qb-houses:server:SetInsideMeta', 0, false)
    TriggerServerEvent('qb-apartments:server:SetInsideMeta', 0, 0, false)
    SetEntityVisible(PlayerPedId(), true)
    Wait(500)
    DoScreenFadeIn(250)
    TriggerEvent('qb-weathersync:client:EnableSync')
    TriggerEvent('qb-clothes:client:CreateFirstCharacter')
end)

RegisterNetEvent('multicharacter:client:closeNUI', function()
    DeleteEntity(charPed)
    SetNuiFocus(false, false)
end)

RegisterNetEvent('multicharacter:client:chooseCharX', function(check)
    SetNuiFocus(false, false)
    Wait(1000)
    TriggerEvent('multicharacter:client:setupCharacters')
    FreezeEntityPosition(PlayerPedId(), true)
    SetEntityCoords(PlayerPedId(), Config.HiddenCoords.x, Config.HiddenCoords.y, Config.HiddenCoords.z)
    Wait(1500)
    ShutdownLoadingScreen()
    ShutdownLoadingScreenNui()
    if check == 'delete' then
        SendReactMessage("DeleteAlert", true)
    end
    openCharMenu(true)
end)


-- NUI Callbacks

RegisterNUICallback('closeUI', function(_, cb)
    ExecuteCommand('e c')
    openCharMenu(false)
    cb("ok")
end)

RegisterNUICallback('disconnectButton', function(_, cb)
    SetEntityAsMissionEntity(charPed, true, true)
    DeleteEntity(charPed)
    TriggerServerEvent('multicharacter:server:disconnect')
    cb("ok")
end)

RegisterNUICallback('selectCharacter', function(data, cb)
    local cData = data.cData
    print('cData', cData)
    DoScreenFadeOut(1)
    Config.PlayerLoaded(cData)
    TriggerServerEvent('multicharacter:server:loadUserData', cData)
    openCharMenu(false)
    RemoveAnimDict("anim@amb@business@bgen@bgen_no_work@")
    StopAnimTask(charPed, "anim@amb@business@bgen@bgen_no_work@", "sit_phone_phoneputdown_idle_nowork", 10)
    SetEntityAsMissionEntity(charPed, true, true)
    DeleteEntity(charPed)
    cb("ok")
end)

RegisterNetEvent('multicharacter:client:setupCharacters', function()
    local count = lib.callback.await('multicharacter:server:setupCharacters', false)
    SendReactMessage('setupCharacters', count)
end)

RegisterNUICallback('refreshCharacters', function(_, cb)
    local count = lib.callback.await('multicharacter:server:setupCharacters', false)
    SendReactMessage('setupCharacters', count)
end)

RegisterNUICallback('removeBlur', function(_, cb)
    SetTimecycleModifier('default')
    cb("ok")
end)

RegisterNUICallback('createNewCharacter', function(data, cb)
    local cData = data
    DoScreenFadeOut(150)
    if cData.gender == "male" then
        cData.gender = 0
    elseif cData.gender == "female" then
        cData.gender = 1
    end
    TriggerServerEvent('multicharacter:server:createCharacter', cData)
    Wait(500)
    cb("ok")
end)

RegisterNUICallback('removeCharacter', function(data, cb)
    TriggerServerEvent('multicharacter:server:deleteCharacter', data.citizenid)
    DeletePed(charPed)
    opened = false
    TriggerEvent('multicharacter:client:chooseCharX', 'delete')
    cb("ok")
end)

RegisterNUICallback('sendInput', function(data, cb)
    local result = lib.callback.await('multicharacter:sendInput', false, data)
    if result then
        DeletePed(charPed)
        opened = false
        TriggerEvent('multicharacter:client:chooseCharX')
        cb(result)
    end
end)

RegisterNUICallback('started', function(_, cb)
    opened = true
end)