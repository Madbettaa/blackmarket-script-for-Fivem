local tabletModel = "prop_cs_tablet"
local tabletDict = "amb@world_human_seat_wall_tablet@female@base"
local tabletAnim = "base"

function attachObject()
	if tabletEntity == nil then
		Citizen.Wait(580)
		RequestModel(tabletModel)
		while not HasModelLoaded(tabletModel) do
			Citizen.Wait(100)
		end
		tabletEntity = CreateObject(GetHashKey(tabletModel), 1.0, 1.0, 1.0, 1, 1, 0)
		AttachEntityToEntity(tabletEntity, GetPlayerPed(-1), GetPedBoneIndex(GetPlayerPed(-1), 57005), 0.12, 0.10, -0.13, 25.0, 170.0, 160.0, true, true, false, true, 1, true)
	end
end

function Animation()
	Citizen.CreateThread(function()
	  RequestAnimDict(tabletDict)
	  while not HasAnimDictLoaded(tabletDict) do
	    Citizen.Wait(100)
	  end
		attachObject()
		TaskPlayAnim(GetPlayerPed(-1), tabletDict, tabletAnim, 4.0, -4.0, -1, 50, 0, false, false, false)
	end)
end

function stopAnimation()
	if tabletEntity ~= nil then
		StopAnimTask(GetPlayerPed(-1), tabletDict, tabletAnim ,4.0, -4.0, -1, 50, 0, false, false, false)
		DeleteEntity(tabletEntity)
		tabletEntity = nil
	end
end

function DrawText3D(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

function knockDoorAnim()
    local knockAnimLib = "timetable@jimmy@doorknock@"
    local knockAnim = "knockdoor_idle"
    local PlayerPed = GetPlayerPed(-1)
    TriggerServerEvent("InteractSound_SV:PlayOnSource", "knock_door", 0.2)
    Wait(100)
    while (not HasAnimDictLoaded(knockAnimLib)) do
        RequestAnimDict(knockAnimLib)
        Wait(100)
    end
    TaskPlayAnim(PlayerPed, knockAnimLib, knockAnim, 3.0, 3.0, -1, 1, 0, false, false, false )
    Wait(3500)
    TaskPlayAnim(PlayerPed, knockAnimLib, "exit", 3.0, 3.0, -1, 1, 0, false, false, false)
    Wait(1000)
    open(true)
end

function EndRuns()
    ClearBlips()
    SetVehicleHasBeenOwnedByPlayer(WeedVehicle,false)
    SetEntityAsNoLongerNeeded(WeedVehicle)

    BlackMarketItems = false
    waittime = 1000
    CurrentStep = 0
    DropOffCount = 0
    DropOffLocation =  { ['x'] = -10.81,['y'] = -1828.68,['z'] = 25.4,['h'] = 301.59, ['info'] = ' Grove shop' }
    Wait(1000)
    ClearBlips()
end

function ClearBlips()
    RemoveBlip(CurrentMarker)
    CurrentMarker = 0
    CurrentStep = 0
end

function BlipCreation()
    ClearBlips()
    CurrentMarker = AddBlipForCoord(pickthetingup["x"],pickthetingup["y"],pickthetingup["z"])
    SetBlipSprite(CurrentMarker, 586)
    SetBlipScale(CurrentMarker, 0.7)
    SetBlipAsShortRange(CurrentMarker, false)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Black Market Item")
    EndTextCommandSetBlipName(CurrentMarker)
end

function DrawText3Ds(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end