
local display = false
local ped = PlayerPedId()
local BlackMarketItems = false
local CurrentStep = 0
local waittime = 1000
DropOffsClose = {
    [1] =  { ['x'] = 508.90548706055,['y'] = 3099.7451171875,['z'] = 41.293823242188,['h'] = 218.2677154541, ['info'] = 'Pickup Location', ['apt'] = 1 },
}

RegisterNUICallback("order", function(data)
    print(data.item..  ": $ " ..data.price)
    TriggerServerEvent('blackmarket:makeorder', data)
end)

RegisterNUICallback("exit", function(data)
    stopAnimation()
    open(false)
end)

function open(bool)
    display = bool
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        type = "ui",
        status = bool,
    })
end


RegisterNetEvent("blackmarket:open")
AddEventHandler("blackmarket:open",function()
    Animation()
    open(true)
end)

CreateThread(function()
    while display do
        Wait(0)
        DisableControlAction(0, 1, display) -- LookLeftRight
        DisableControlAction(0, 2, display) -- LookUpDown
        DisableControlAction(0, 142, display) -- MeleeAttackAlternate
        DisableControlAction(0, 18, display) -- Enter
        DisableControlAction(0, 322, display) -- ESC
        DisableControlAction(0, 106, display) -- VehicleMouseControlOverride
    end
end)

RegisterNetEvent("stufmanidk")
AddEventHandler("stufmanidk", function(data)
    local toolong = 0
    BlackMarketItems = true
    while BlackMarketItems do
        Wait(1)
        if CurrentStep == 0 then
            pickthetingup = DropOffsClose[math.random(#DropOffsClose)]
            BlipCreation()
            CurrentStep = 1
        end
        local plyCoords = GetEntityCoords(PlayerPedId())
        local inVehicle = IsPedInAnyVehicle(PlayerPedId(), false)
        local distance = Vdist(pickthetingup["x"],pickthetingup["y"],pickthetingup["z"],plyCoords)
        if distance < 5.0 and not inVehicle then
            waittime = 1
            DrawText3Ds(pickthetingup["x"],pickthetingup["y"],pickthetingup["z"],"[E] To pickup Package")
            if IsControlJustReleased(1,38) and distance < 1.5 then
                ClearBlips()  
                TriggerEvent("player:receiveItem",data.item, data.amount)
                TriggerEvent("susdropoof")
                EndRuns()
                end
            end
            toolong = toolong + 1
            if toolong > 180000 then
            TriggerEvent("DoLongHudText","Too Long Pick up cancelled !")
            EndRuns()
            DeleteCreatedPed()
        end
    end
end)
