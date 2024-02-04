local Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
    ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local menuOpen = false

local savedColor = {
    r = 255,
    g = 0,
    b = 0,
}

local listenForKeybind = false

RegisterNUICallback('NUIReady', function(data, cb)
    if not Config.AllowHeadlights then
        SendNUIMessage({
            event = "disallowHeadlights",
        })
    end
    cb(true)
end)

if Config.Debug then
    RegisterCommand('neon', function(source, args)
        local ped = PlayerPedId()
        local veh = GetVehiclePedIsIn(ped)
        SetVehicleNeonLightEnabled(veh, 0, true)
        SetVehicleNeonLightEnabled(veh, 1, true)
        SetVehicleNeonLightEnabled(veh, 2, true)
        SetVehicleNeonLightEnabled(veh, 3, true)
    end)

    RegisterCommand('xenon', function(source, args)
        local ped = PlayerPedId()
        local veh = GetVehiclePedIsIn(ped)
        ToggleVehicleMod(veh, 22, true)
    end)
end

if Config.Keybind.Enabled then
    Citizen.CreateThread(function()
        while true do
            local sleep = 2000
            if listenForKeybind then
                sleep = 0
                if IsControlPressed(0, Keys[Config.Keybind.SpecialKey]) and IsControlJustReleased(0, Keys[Config.Keybind.Key]) then
                    menuOpen = not menuOpen
                    ToggleMenu()
                end
            end
            Citizen.Wait(sleep)
        end
    end)

    Citizen.CreateThread(function()
        while true do
            local sleep = 2000
            listenForKeybind = IsPedInAnyVehicle(PlayerPedId())
            Citizen.Wait(sleep)
        end
    end)
end

if Config.Command.Enabled then
    RegisterCommand(Config.Command.Command, function()
        if IsPedInAnyVehicle(PlayerPedId()) then
            menuOpen = not menuOpen
            ToggleMenu()
        end
    end)
end

RegisterNUICallback('CloseMenu', function(data, cb)
    CloseMenu()
    cb(true)
end)

function CloseMenu()
    menuOpen = false
    ToggleMenu()
end

function ToggleMenu()
    SendNUIMessage({
        event = "show",
        state = menuOpen
    })
    SetNuiFocus(menuOpen, menuOpen)
    SetNuiFocusKeepInput(true)
end

RegisterNUICallback('SetRGB', function(data, cb)
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped)

    animStep = 1
    anim = nil
    animVehicle = nil

    savedColor = {
        r = data.r,
        g = data.g,
        b = data.b,
    }

    RGB(veh, data.r, data.g, data.b)
    cb(true)
end)

function RGB(veh, r, g, b)
    SetVehicleNeonLightsColour(veh, tonumber(r), tonumber(g), tonumber(b))
end

RegisterNUICallback('SetXenon', function(data, cb)
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped)
    if IsToggleModOn(veh, 22) then
        Xenon(veh, data.color)
    else
        ShowTooltip('Vehicle requires Xenon headlights to change the color')
    end

    cb(true)
end)

function Xenon(veh, color)
    SetVehicleXenonLightsColor(veh, tonumber(color))
end

Citizen.CreateThread(function()
    while true do
        local sleep = 100
        if menuOpen then
            sleep = 0
            DisableControlAction(0, 1, menuOpen)
            DisableControlAction(0, 2, menuOpen)
            DisableControlAction(0, 14, menuOpen)
            DisableControlAction(0, 15, menuOpen)
            DisableControlAction(0, 16, menuOpen)
            DisableControlAction(0, 17, menuOpen)
            DisableControlAction(0, 50, menuOpen)
            DisableControlAction(0, 81, menuOpen)
            DisableControlAction(0, 82, menuOpen)
            DisableControlAction(0, 96, menuOpen)
            DisableControlAction(0, 97, menuOpen)
            DisableControlAction(0, 99, menuOpen)
            DisableControlAction(0, 198, menuOpen)
            DisableControlAction(0, 142, menuOpen)
            DisableControlAction(0, 263, menuOpen)
            DisableControlAction(0, 262, menuOpen)
            DisableControlAction(0, 264, menuOpen)
            DisableControlAction(0, 257, menuOpen)
            DisableControlAction(0, 332, menuOpen)
            DisableControlAction(0, 333, menuOpen)
            DisableControlAction(0, 336, menuOpen)
        end

        Citizen.Wait(sleep)
    end
end)

function ShowTooltip(message)
    SetTextComponentFormat("STRING")
    AddTextComponentString(message)
    EndTextCommandDisplayHelp(0, 0, 1, -1)
end
