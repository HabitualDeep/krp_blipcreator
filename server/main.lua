ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- Command to create a blip
RegisterCommand('createblip', function(source, args, rawCommand)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    -- Check if the player has the required permission (optional)
    if xPlayer.hasPermission('admin') then
        -- Extract blip details from command arguments
        local blipName = args[1]
        local blipType = tonumber(args[2])
        local blipColor = tonumber(args[3])
        local blipX = tonumber(args[4])
        local blipY = tonumber(args[5])
        local blipZ = tonumber(args[6])

        -- Check if all required arguments are provided and are of correct types
        if blipName and blipType and blipColor and blipX and blipY and blipZ
           and type(blipName) == "string" and type(blipType) == "number"
           and type(blipColor) == "number" and type(blipX) == "number"
           and type(blipY) == "number" and type(blipZ) == "number" then
            -- Create blip in-game
            local blip = AddBlipForCoord(blipX, blipY, blipZ)
            SetBlipSprite(blip, blipType)
            SetBlipDisplay(blip, 4)
            SetBlipColour(blip, blipColor)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(blipName)
            EndTextCommandSetBlipName(blip)

            -- Save blip data to database
            MySQL.Async.execute('INSERT INTO blips (name, type, color, x, y, z) VALUES (?, ?, ?, ?, ?, ?)',
                {blipName, blipType, blipColor, blipX, blipY, blipZ})
            
            -- Notify player
            TriggerClientEvent('chat:addMessage', _source, { args = { '^*^7Blip created successfully.' } })
        else
            -- Notify player of error
            TriggerClientEvent('chat:addMessage', _source, { args = { '^*^1Error: Invalid arguments or types. Usage: /createblip [name] [type] [color] [x] [y] [z]' } })
        end
    else
        TriggerClientEvent('chat:addMessage', _source, { args = { '^*^1Error: You do not have permission to use this command.' } })
    end
end, false)

-- Command to delete a blip
RegisterCommand('deleteblip', function(source, args, rawCommand)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    -- Check if the player has the required permission (optional)
    if xPlayer.hasPermission('admin') then
        -- Ensure the blip ID is provided as an argument
        if args[1] then
            local blipId = tonumber(args[1])
            if blipId then
                -- Delete blip in-game
                RemoveBlip(blipId)

                -- Remove blip data from the database
                MySQL.Async.execute('DELETE FROM blips WHERE id = @id', {['@id'] = blipId}, function(rowsChanged)
                    if rowsChanged > 0 then
                        -- Notify player
                        TriggerClientEvent('chat:addMessage', _source, { args = { '^*^7Blip deleted successfully.' } })
                    else
                        -- Notify player if blip with specified ID doesn't exist
                        TriggerClientEvent('chat:addMessage', _source, { args = { '^*^1Error: Blip with specified ID does not exist.' } })
                    end
                end)
            else
                -- Notify player if blip ID is not a number
                TriggerClientEvent('chat:addMessage', _source, { args = { '^*^1Error: Blip ID must be a number.' } })
            end
        else
            -- Notify player if blip ID is missing
            TriggerClientEvent('chat:addMessage', _source, { args = { '^*^1Error: Missing blip ID. Usage: /deleteblip [blipId]' } })
        end
    else
        TriggerClientEvent('chat:addMessage', _source, { args = { '^*^1Error: You do not have permission to use this command.' } })
    end
end, false)

RegisterCommand('blipcreator', function(source, args, rawCommand)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local isAdmin = xPlayer.hasPermission('admin')

    if isAdmin then
        TriggerClientEvent('blipcreator:openMenu', _source)
    else
        TriggerClientEvent('chat:addMessage', _source, { args = { '^*^1Error: You do not have permission to use this command.' } })
    end
end, false)
