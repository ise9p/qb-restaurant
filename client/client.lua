local QBCore = exports['qb-core']:GetCoreObject()
local PlayerData = {}
local PlayerLoaded = false

AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    PlayerData = QBCore.Functions.GetPlayerData()
    PlayerLoaded = true
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    PlayerData = {}
    PlayerLoaded = false
end)

RegisterNetEvent('QBCore:Player:SetPlayerData', function(val)
    local invokingResource = GetInvokingResource()
    if invokingResource and invokingResource ~= 'qb-core' then return end
    PlayerData = val
end)

local function IsBoss()
    return PlayerData.job and PlayerData.job.isboss
end

local function OpenBossMenu()
    TriggerEvent('qb-bossmenu:client:OpenMenu')
end

AddEventHandler('onResourceStart', function(resource)
    if GetCurrentResourceName() == resource then
        if QBCore.Functions.GetPlayerData() then
            PlayerData = QBCore.Functions.GetPlayerData()
            PlayerLoaded = true
        end
    end
end)

RegisterNetEvent('qb-restaurant :setProductPrice', function(shop, slot)
    local input = lib.inputDialog(Strings.sell_price, {Strings.amount_input})
    local price = not input and 0 or tonumber(input[1]) --[[@as number]]
    price = price < 0 and 0 or price

    TriggerEvent('ox_inventory:closeInventory')
    TriggerServerEvent('qb-restaurant :setData', shop, slot, math.floor(price))
    lib.notify({
        title = Strings.success,
        description = (Strings.item_stocked_desc):format(price),
        type = 'success'
    })
end)

local function createBlip(coords, sprite, color, text, scale)
    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip, sprite)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, scale)
    SetBlipColour(blip, color)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandSetBlipName(blip)
    return blip
end

CreateThread(function()
    for _, v in pairs(Config.Shops) do
        if v.blip.enabled then
            createBlip(v.blip.coords, v.blip.sprite, v.blip.color, v.blip.string, v.blip.scale)
        end
    end
end)

local function OpenStash(shop)
    if Config.Inventory == 'ox' then
        exports.ox_inventory:openInventory('stash', shop)
    else
        TriggerServerEvent("inventory:server:OpenInventory", "stash", shop, {
            maxweight = 100000,
            slots = 50,
        })
        TriggerEvent("inventory:client:SetCurrentStash", shop)
    end
end

local function OpenShop(shop)
    if Config.Inventory == 'ox' then
        exports.ox_inventory:openInventory('shop', { type = shop, id = 1 })
    else
        lib.notify({
            title = 'Info',
            description = 'Shop system requires ox_inventory for metadata pricing.',
            type = 'inform'
        })
    end
end

CreateThread(function()
    while not PlayerLoaded do Wait(500) end
    
    if Config.Target then
        for k, v in pairs(Config.Shops) do
            -- Stash Target
            local stashTarget = {
                {
                    label = Strings.target_inventory,
                    icon = "fas fa-inventory",
                    action = function() OpenStash(k) end,
                    job = k
                }
            }
            if Config.Target == 'ox' then
                exports.ox_target:addSphereZone({
                    coords = v.locations.stash.coords,
                    radius = v.locations.stash.range,
                    debug = false,
                    options = stashTarget
                })
            elseif Config.Target == 'qb' then
                exports['qb-target']:AddCircleZone(k.."_stash", v.locations.stash.coords, v.locations.stash.range, {
                    name = k.."_stash",
                    debugPoly = false,
                    useZ = true,
                }, {
                    options = stashTarget,
                    distance = 2.0
                })
            end

            -- Shop Target
            local shopTarget = {
                {
                    label = Strings.target_shop,
                    icon = "fas fa-shopping-basket",
                    action = function() OpenShop(k) end
                }
            }
            if Config.Target == 'ox' then
                exports.ox_target:addSphereZone({
                    coords = v.locations.shop.coords,
                    radius = v.locations.shop.range,
                    debug = false,
                    options = shopTarget
                })
            elseif Config.Target == 'qb' then
                exports['qb-target']:AddCircleZone(k.."_shop", v.locations.shop.coords, v.locations.shop.range, {
                    name = k.."_shop",
                    debugPoly = false,
                    useZ = true,
                }, {
                    options = shopTarget,
                    distance = 2.0
                })
            end

            -- Boss Menu Target
            if v.bossMenu.enabled then
                local bossTarget = {
                    {
                        label = Strings.target_boss,
                        icon = "fas fa-user-tie",
                        action = function() OpenBossMenu() end,
                        job = k,
                        canInteract = function() return IsBoss() end
                    }
                }
                if Config.Target == 'ox' then
                    exports.ox_target:addSphereZone({
                        coords = v.bossMenu.coords,
                        radius = v.bossMenu.range,
                        debug = false,
                        options = bossTarget
                    })
                elseif Config.Target == 'qb' then
                    exports['qb-target']:AddCircleZone(k.."_boss", v.bossMenu.coords, v.bossMenu.range, {
                        name = k.."_boss",
                        debugPoly = false,
                        useZ = true,
                    }, {
                        options = bossTarget,
                        distance = 2.0
                    })
                end
            end
        end
    else
        local textUI, points = nil, {}
        for k, v in pairs(Config.Shops) do
            if not points[k] then points[k] = {} end
            points[k].stash = lib.points.new({
                coords = v.locations.stash.coords,
                distance = v.locations.stash.range,
                shop = k
            })
            points[k].shop = lib.points.new({
                coords = v.locations.shop.coords,
                distance = v.locations.shop.range,
                shop = k
            })
            if v.bossMenu.enabled then
                points[k].bossMenu = lib.points.new({
                    coords = v.bossMenu.coords,
                    distance = v.bossMenu.range,
                    shop = k
                })
            end
        end

        for _, v in pairs(points) do
            function v.stash:nearby()
                if not self.isClosest or PlayerData.job.name ~= self.shop then return end
                if Config.DrawMarkers then
                    DrawMarker(2, self.coords.x, self.coords.y, self.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 30, 150, 30, 222, false, false, 0, true, false, false, false)
                end
                if self.currentDistance < self.distance then
                    if not textUI then
                        lib.showTextUI(Config.Shops[self.shop].locations.stash.string)
                        textUI = true
                    end
                    if IsControlJustReleased(0, 38) then
                        OpenStash(self.shop)
                    end
                end
            end

            function v.stash:onExit()
                if not self.isClosest then return end
                if textUI then
                    lib.hideTextUI()
                    textUI = nil
                end
            end

            function v.shop:nearby()
                if not self.isClosest then return end
                if Config.DrawMarkers then
                    DrawMarker(2, self.coords.x, self.coords.y, self.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 30, 150, 30, 222, false, false, 0, true, false, false, false)
                end
                if self.currentDistance < self.distance then
                    if not textUI then
                        lib.showTextUI(Config.Shops[self.shop].locations.shop.string)
                        textUI = true
                    end
                    if IsControlJustReleased(0, 38) then
                        OpenShop(self.shop)
                    end
                end
            end

            function v.shop:onExit()
                if not self.isClosest then return end
                if textUI then
                    lib.hideTextUI()
                    textUI = nil
                end
            end

            if v?.bossMenu then
                function v.bossMenu:nearby()
                    if not self.isClosest then return end
                    if IsBoss() then
                        if self.currentDistance < self.distance then
                            if Config.DrawMarkers then
                                DrawMarker(2, self.coords.x, self.coords.y, self.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 30, 150, 30, 222, false, false, 0, true, false, false, false)
                            end
                            if not textUI then
                                lib.showTextUI(Config.Shops[self.shop].bossMenu.string)
                                textUI = true
                            end
                            if IsControlJustReleased(0, 38) then
                                OpenBossMenu(PlayerData.job.name)
                            end
                        end
                    end
                end

                function v.bossMenu:onExit()
                    if textUI then
                        lib.hideTextUI()
                        textUI = nil
                    end
                end
            end
        end
    end
end)
