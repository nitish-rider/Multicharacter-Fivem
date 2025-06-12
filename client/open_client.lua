RegisterNUICallback('cDataPed', function(nData, cb)
    local cData = nData
    SetEntityAsMissionEntity(charPed, true, true)
    print(1)
    if cData then
        print(2)
        lib.callback('multicharacter:server:getSkin', false, function(skinData)
            print(skinData)
            if skinData then
                DeleteEntity(charPed)
                local model = 'a_f_y_smartcaspat_01'
                CreateThread(function()
                    RequestModel(GetHashKey(model))
                    while not HasModelLoaded(GetHashKey(model)) do
                        Wait(10)
                    end
                    charPed = CreatePed(2, model, Config.PedCoords.x, Config.PedCoords.y, Config.PedCoords.z - 0.98,
                            Config.PedCoords.w, false, true)
                    SetPedCanPlayAmbientAnims(charPed, true)
                    RequestAnimDict('anim@amb@business@bgen@bgen_no_work@')
                    while not HasAnimDictLoaded('anim@amb@business@bgen@bgen_no_work@') do
                        Wait(0)
                    end
                    TaskPlayAnim(charPed, 'anim@amb@business@bgen@bgen_no_work@', 'sit_phone_phoneputdown_idle_nowork',
                            8.0, 1.0, -1, 1, 0.0, false, false, true)
                    SetPedComponentVariation(charPed, 0, 0, 0, 2)
                    FreezeEntityPosition(charPed, false)
                    SetEntityInvincible(charPed, true)
                    PlaceObjectOnGroundProperly(charPed)
                    SetBlockingOfNonTemporaryEvents(charPed, true)
                    --exports['qb-clothing']:loadPlayerClothing(charPed, skinData)

                end)
            else
                print(5)
                DeleteEntity(charPed)
                CreateThread(function()
                    local ped = "mp_m_freemode_01"
                    if cData.sex == "female" then
                        ped = "mp_f_freemode_01"
                    end
                    local model = joaat(ped)
                    RequestModel(model)
                    while not HasModelLoaded(model) do
                        Wait(0)
                    end
                    charPed = CreatePed(2, model, Config.PedCoords.x, Config.PedCoords.y, Config.PedCoords.z - 0.98,
                            Config.PedCoords.w, false, true)
                    SetPedCanPlayAmbientAnims(charPed, true)
                    RequestAnimDict('anim@amb@business@bgen@bgen_no_work@')
                    while not HasAnimDictLoaded('anim@amb@business@bgen@bgen_no_work@') do
                        Wait(0)
                    end
                    TaskPlayAnim(charPed, 'anim@amb@business@bgen@bgen_no_work@', 'sit_phone_phoneputdown_idle_nowork',
                            8.0, 1.0, -1, 1, 0.0, false, false, true)
                    SetPedComponentVariation(charPed, 0, 0, 0, 2)
                    FreezeEntityPosition(charPed, false)
                    SetEntityInvincible(charPed, true)
                    PlaceObjectOnGroundProperly(charPed)
                    SetBlockingOfNonTemporaryEvents(charPed, true)
                end)
            end
            cb("ok")
        end, cData.cData)
    end
end)
