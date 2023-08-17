Citizen.CreateThread(function()
	while ESX == nil do
		ESX = exports["es_extended"]:getSharedObject()
		Citizen.Wait(0)
	end
end)

local playerVehicleRentals = {}
local playerId = PlayerId()

function RecordPlayerRental(playerId)
    playerVehicleRentals[playerId] = true
end

-- Creation du Blips
Citizen.CreateThread(function()
    local blipCoords = Config.pedlocation

    local blip = AddBlipForCoord(blipCoords.x, blipCoords.y, blipCoords.z)

    SetBlipSprite(blip, 227)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.8)
    SetBlipColour(blip, 3)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(_U("blips_string"))
    EndTextCommandSetBlipName(blip)
end)

Citizen.CreateThread(function()
    local npcModel = Config.pedModel
    local npcCoords = Config.pedlocation

    -- Créer le NPC
    RequestModel(npcModel)
    while not HasModelLoaded(npcModel) do
        Citizen.Wait(0)
    end

    local ped = CreatePed(4, npcModel, npcCoords.x, npcCoords.y, npcCoords.z, npcCoords.w, false, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
    TaskStartScenarioInPlace(ped, "WORLD_HUMAN_CLIPBOARD", 0, 1)

    local npcOptions = {
        label = _U("npc_label", Config.prix),
        onSelect = function(data)

            if playerVehicleRentals[playerId] then
                lib.notify({
                    id = 'spawnimpossible',
                    title = _U("notification_titel"),
                    description = _U("notification_fail"),
                    position = 'top',
                    style = {
                        backgroundColor = '#141517',
                        color = '#C1C2C5',
                        ['.description'] = {
                          color = '#909296'
                        }
                    },
                    icon = 'ban',
                    iconColor = '#C53030'
                })
            else
                TriggerServerEvent('sl_loc:rent')
            end
        end
    }
    
    exports.ox_target:addLocalEntity(ped, npcOptions)
end)


RegisterNetEvent('sl_loc:spawncar')
AddEventHandler('sl_loc:spawncar', function()
    local car = GetHashKey("serv_electricscooter")
    RequestModel(car)

    while not HasModelLoaded(car) do 
        Citizen.Wait(100)
    end

    local voiturespawn = CreateVehicle(car, Config.spawnpoint, true, false)
    TaskWarpPedIntoVehicle(GetPlayerPed(-1), voiturespawn, -1)

    RecordPlayerRental(playerId)

    lib.notify({
        title = _U("notification_titel"),
        description = _U("notification_success", Config.prix),
        type = 'success',
        position = "top"
    })
end)

RegisterNetEvent("sl_loc:NotEnoughMoney")
AddEventHandler('sl_loc:NotEnoughMoney', function()
    lib.notify({
        id = 'spawnimpossible',
        title = _U("notification_titel"),
        description = _U("notification_notenoughmoney"),
        position = 'top',
        style = {
            backgroundColor = '#141517',
            color = '#C1C2C5',
            ['.description'] = {
              color = '#909296'
            }
        },
        icon = 'ban',
        iconColor = '#C53030'
    })

end)