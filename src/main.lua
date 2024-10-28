local app     = require("milua")
local json    = require("json")

local version = "dev-1.0"
local status  = "NotStarted" -- NotStarted InGame
local map     = json.decode(
    '{"version":1.0,"name":"testing","width":5,"turns":3,"turnTime":60,"author":"DynomiteWaffle","map":[2,2,0,4,4,2,2,0,4,4,0,0,0,0,0,5,5,0,3,3,5,5,0,3,3]}')
local turn    = 0
local users   = {}
local colors  = {} --map numbers to colors

-- info page
app.add_handler(
    "GET",
    "/",
    function()
        -- TODO update server - mabey corotine
        local R = {
            version = version,
            status = status,
            users = #users,
            turn = turn
        }
        return json.encode(R), { ["Content-Type"] = "json" }
    end
)
-- get map
app.add_handler(
    "GET",
    "/map",
    function()
        return "Under Construction", { ["Content-Type"] = "json" }
    end
)
-- get map info/settings
app.add_handler(
    "GET",
    "/map/info",
    function()
        local R = {
            version = map.version,
            name = map.name,
            author = map.author,
            turns = map.turns,
            turnTime = map.turnTime,
            width = map.width
        }
        return json.encode(R), { ["Content-Type"] = "json" }
    end
)
-- get map colors/players
app.add_handler(
    "GET",
    "/map/players",
    function()
        return json.encode(colors), { ["Content-Type"] = "json" }
    end
)
-- get user info - give id in json - {"id":"example id"}
app.add_handler(
    "GET",
    "/userinfo",
    function()
        return "Under Construction", { ["Content-Type"] = "json" }
    end
)
-- move - move piece - end turn
app.add_handler(
    "PUT",
    "/move",
    function()
        return "Under Construction", { ["Content-Type"] = "json" }
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
-- TODO change map
-- TODO end match


local config = {
    HOST = "0.0.0.0",
    PORT = "8080",
}

app.start(config)
