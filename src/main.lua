local app     = require("milua")
local json    = require("json")

local version = "dev-1.0"
local status  = "NotStarted" -- NotStarted InGame
local map     = { 1, 2, 3, 4 }
local turn    = 0
local users   = {}


-- info page
app.add_handler(
    "GET",
    "/",
    function()
        -- TODO update server - mabey corotine
        return '{"version":"' ..
            version .. '","status":"' .. status .. '","players":' .. #users .. ',"turn":' .. turn .. '}',
            { ["Content-Type"] = "json" }
    end
)
-- get map
app.add_handler(
    "GET",
    "/map",
    function()
        return "Under Construction"
    end
)
-- get user info
app.add_handler(
    "GET",
    "/userinfo",
    function()
        return "Under Construction"
    end
)
-- move
app.add_handler(
    "PUT",
    "/move",
    function()
        return "Under Construction"
    end
)

-- join
app.add_handler(
    "POST",
    "/user",
    function(captures, query, headers, body)
        if (status == "NotStarted") then
            -- create new user
            -- print(headers, body)
            -- print(headers["content-type"]) --application/json
            if (headers["content-type"] == "application/json") then
                local values = json.decode(body)
                -- TODO unique user identifier
                --user checking
                for i = 1, #users, 1 do
                    -- color check
                    if (users[i].color == values["color"]) then
                        return '{"err":"color taken"}', { ["Content-Type"] = "json" }
                    end
                end

                -- create id/user
                local id = "wasd"
                users[#users + 1] = {
                    id = id,
                    color = values["color"]
                }
                return '{"user":' .. id .. '"}', { ["Content-Type"] = "json" }
            else
                return '{"err":"bad"}', { ["Content-Type"] = "json" }
            end
        end
    end
)
-- leave/quit
-- TODO
app.add_handler(
    "DELETE",
    "/user/quit",
    function()
        return nil, { [":status"] = "204" }
    end
)
-- admin
-- TODO admin password - mabey otp code
-- TODO force start
-- TODO kick
-- TODO get all users info


local config = {
    HOST = "0.0.0.0",
    PORT = "8080",
}

app.start(config)
