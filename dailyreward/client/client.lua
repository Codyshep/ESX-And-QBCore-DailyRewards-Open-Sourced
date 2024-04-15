local isNuiOpen = false

RegisterNetEvent('DailyNotify')
AddEventHandler('DailyNotify', function(text, ntype)
    local sourceId = sourceId
    print(text, ntype)
    exports['notifications']:sendnotify(text, ntype, 6000)
end)

RegisterCommand(config.command, function()
    isNuiOpen = not isNuiOpen
    SetNuiFocus(isNuiOpen, isNuiOpen)
    SendNUIMessage({
        type = "toggleNui",
        isOpen = isNuiOpen
    })
end, false)

RegisterNUICallback('SetUIFocus', function(data, cb)
    if isNuiOpen ~= false then
        isNuiOpen = false
    end
    SetNuiFocus(isNuiOpen, isNuiOpen)
    cb({})
end)

RegisterNUICallback('ClaimDaily', function(data, cb)
    local source = GetPlayerServerId(PlayerId())
    TriggerServerEvent('claimDaily', source)
    cb({})
end)
