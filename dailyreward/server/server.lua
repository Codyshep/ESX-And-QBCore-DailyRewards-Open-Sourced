ESX = exports['es_extended']:getSharedObject()

-- Function to give items to a player in ESX
local function giveItemsToPlayer(sourceId, item, count)
    local xPlayer = ESX.GetPlayerFromId(sourceId)
    if xPlayer then
        -- Check if the player has enough space in their inventory
        if xPlayer.canCarryItem(item, count) then
            -- Try to add the item to the player's inventory
            if xPlayer.addInventoryItem(item, count) then
                TriggerClientEvent('DailyNotify', sourceId, 'Successfully Claimed Reward!', 1)
                return true  -- Return true if item was successfully added
            else
                TriggerClientEvent('DailyNotify', sourceId, 'Claim Failed: Inventory Full!', 2)
                return false  -- Return false if item could not be added
            end
        else
            TriggerClientEvent('DailyNotify', sourceId, 'Claim Failed: Inventory Full!', 2)
            return false  -- Return false if player does not have enough space
        end
    else
        print("Player not found in ESX database!")
        TriggerClientEvent('DailyNotify', sourceId, 'Claim Failed: Player Not Found!', 2)
        return false  -- Return false if player is not found
    end
end

-- Function to handle claiming of daily rewards
local function claimDailyReward(sourceId, identifier)
    local currentTime = os.time()  -- Get current time in seconds

    -- Check if player has claimed within the last 24 hours
    local query = "SELECT claimtime FROM daily_reward WHERE claimed = @identifier"
    MySQL.Async.fetchScalar(query, {['@identifier'] = identifier}, function(lastClaimTime)
        if lastClaimTime == nil or (currentTime - lastClaimTime) >= 86400 then
            -- Player is eligible to claim the reward
            local totalItems = #config.possibleitems
            local randomIndex = math.random(1, totalItems)
            local randomItemData = config.possibleitems[randomIndex]
            local item = randomItemData.item
            local count = randomItemData.quantity

            -- Give the item to the player
            if giveItemsToPlayer(sourceId, item, count) then
                -- Item successfully added to inventory, insert/update claimtime
                local insertQuery = "INSERT INTO daily_reward (claimed, claimtime) VALUES (@identifier, @currentTime) ON DUPLICATE KEY UPDATE claimtime = @currentTime"
                MySQL.Async.execute(insertQuery, {['@identifier'] = identifier, ['@currentTime'] = currentTime}, function(rowsChanged)
                    if rowsChanged > 0 then
                        print("Claim time updated in daily_reward table.")
                    else
                        print("Failed to update claim time in daily_reward table.")
                        TriggerClientEvent('DailyNotify', sourceId, 'Claim Failed: Database Error!', 2)
                    end
                end)
            end
        else
            -- Player has already claimed within the last 24 hours
            print("Player has already claimed within the last 24 hours.")
            TriggerClientEvent('DailyNotify', sourceId, 'Wait 24 Hours Before Trying Again!', 3)
        end
    end)
end


-- Event handler for claimDaily event
RegisterServerEvent('claimDaily')
AddEventHandler('claimDaily', function()
    local sourceId = source
    local identifier = GetPlayerIdentifierByType(sourceId, 'license')
    if identifier then
        claimDailyReward(sourceId, identifier)
    else
        print("Failed to get player identifier.")
        TriggerClientEvent('DailyNotify', sourceId, 'Claim Failed: Player Identifier Error!', 2)
    end
end)
