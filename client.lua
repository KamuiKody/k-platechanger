local QBCore = exports['qb-core']:GetCoreObject()
local attached = nil
local sleep = 0
local listen = false


--- QB-Input ----
RegisterNetEvent('k-platechange:plate', function(plate,owned)
    local dialog = exports['qb-input']:ShowInput({
        header = "New Plate",
        submitText = "submit",
        inputs = {
            {
                text = "7 Digits",
                name = "plate",
                type = "text",
                isRequired = true
            },
        },
    })    
    if dialog ~= nil then
        local entry = (dialog['plate'])
        local digits = Config.Length
        if #entry ~= digits then 
            detatchVeh()
            QBCore.Functions.Notify('You\'re Plate Text Must Be ['..digits..'] Digits')
        else
            local triggerword = false
            for _,v in pairs(Config.RestrictedWords) do
                if string.upper(v) == string.upper(entry) then
                    QBCore.Functions.Notify('Seriously now...')
                    triggerword = true
                    break
                end
            end
            if not triggerword then
                local veh = GetVehiclePedIsIn(PlayerPedId(), false)
                local props = QBCore.Functions.GetVehicleProperties(veh)      
                TriggerServerEvent('k-platechange:server:platetext', entry, plate, props, owned)
                Wait(100)
                detatchVeh()
            end
        end    
    end
end)

---EVENTS ----

RegisterNetEvent('k-platechange:endgame', function(entry)
    local veh = GetVehiclePedIsIn(PlayerPedId(), false)
    SetVehicleNumberPlateText(veh, entry)
    TriggerEvent("vehiclekeys:client:SetOwner",  QBCore.Functions.GetPlate(veh))
end)

RegisterNetEvent("k-platechange:change", function()
    local ped = PlayerPedId()
    local coords = Config.Location
    local distance = #(GetEntityCoords(ped) - coords)
    if distance <= Config.Radius then
        if IsPedInAnyVehicle(ped) then
            local veh = GetVehiclePedIsIn(ped, false)
            attachVeh(veh)
        end
    end
end)

---THREADS---
CreateThread(function()
    if not Config.UseTarget then
        while true do    
            sleep = 2500
            local ped = PlayerPedId()
            local coords = Config.Location
            local distance = #(GetEntityCoords(ped) - coords)
            if distance <= Config.Radius then
                if IsPedInAnyVehicle(ped) then
                    local veh = GetVehiclePedIsIn(ped, false)
                    sleep = 5
                    if not listen then
                        listen = true
                        if Config.UseItem then
                            exports['qb-core']:DrawText('[E] - Change Plate ['..Config.Item..']','left')
                        else
                            exports['qb-core']:DrawText('[E] - Change Plate ['..Config.Cash..']','left')
                        end
                    end
                    if IsControlJustPressed(1, 38)   then
                        attachVeh(veh)
                        listen = false
                        exports['qb-core']:HideText()	
                    end
                else
                    listen = false		
                    exports['qb-core']:HideText()		  
                end
            else  
                listen = false		              
                exports['qb-core']:HideText()
            end
            Wait(sleep)    
        end
    else
        exports['qb-target']:AddCircleZone("pc1", Config.Location, Config.Radius, {
            name="pc1",
            heading=266,
            --debugPoly=true
              }, {
            options = {
                {
                    type = "client",
                    action = "k-platechange:change",
                    icon = "fas fa-desktop",
                    label = 'Change Plate',
                },
            },
            distance = 1.5
        })
    end  
end)

function attachVeh(veh)
    QBCore.Functions.TriggerCallback('k-platechange:checkowned', function(data)
        if data then 
            local plate = GetVehicleNumberPlateText(veh)
            TriggerEvent('k-platechange:plate', plate, data, 'owned')
            local pos = Config.CarPos
            DoScreenFadeOut(150)
            Wait(150)
            SetEntityCoords(veh, pos.x, pos.y, pos.z)
            SetEntityHeading(veh, pos.w)
            FreezeEntityPosition(veh, true)
            Wait(500)
            DoScreenFadeIn(250)
            attached = veh
        else
            if not Config.Owned then
                local plate = GetVehicleNumberPlateText(veh)
                TriggerEvent('k-platechange:plate', plate, data, 'unreg')
                local pos = Config.CarPos
                DoScreenFadeOut(150)
                Wait(150)
                SetEntityCoords(veh, pos.x, pos.y, pos.z)
                SetEntityHeading(veh, pos.w)
                FreezeEntityPosition(veh, true)
                Wait(500)
                DoScreenFadeIn(250)
                attached = veh
            end
        end
    end, GetVehicleNumberPlateText(veh))
end

function detatchVeh()
    local pos = Config.CarPos
    DoScreenFadeOut(150)
    Wait(150)
    FreezeEntityPosition(attached, false)
    SetEntityCoords(attached, pos.x, pos.y, pos.z)
    SetEntityHeading(attached, pos.w)
    TaskWarpPedIntoVehicle(PlayerPedId(), attached, -1)
    Wait(500)
    DoScreenFadeIn(250)
    attached = nil
end