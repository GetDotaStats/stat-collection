modifier_statcollection_network = class({})

function modifier_statcollection_network:OnCreated(keys)
    if not IsServer() then
        local playerID = self:GetCaster():GetPlayerOwnerID()
        local printPrefix = 'Stat Collection: '
        print(printPrefix .. " Client Network Created for Player "..playerID)

        -- Build the payload
        local payload = {
            modIdentifier = '0a545b9a80b2c06512e7bf3d8a9bbae6',
            steamID32 = tostring('322'),
            matchID = '420',
            schemaVersion = 2
        }

        -- Create the request
        local req = CreateHTTPRequest('POST', 'http://getdotastats.com/s2/api/s2_check_in.php')
        print(json.encode(payload))

        -- Add the data
        req:SetHTTPRequestGetOrPostParameter('payload', json.encode(payload))

        -- Send the request
        req:Send(function(res)
            if res.StatusCode ~= 200 or not res.Body then
                print(printPrefix .. 'Failed to contact the master server! Bad status code, or no body!')
                return
            end

            print(res.Body)

            -- Try to decode the result
            local obj, pos, err = json.decode(res.Body, 1, nil)
                
            -- Check if we got an error
            if err then
                print(printPrefix .. 'There was an issue decoding the JSON returned from the server, see below:')
                print(printPrefix .. err)
            end

            -- Check for an error
            if res.error then
                print(printPrefix .. 'The server said something went wrong, see below:')
                print(res.error)
            end

            self:Destroy()
        end)
    end
end

function modifier_statcollection_network:IsHidden()
    return true
end