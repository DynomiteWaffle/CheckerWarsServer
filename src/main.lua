local app       = require("milua")
local json      = require("json")

local version   = "dev-1.0"
local status    = "NotStarted" -- NotStarted InGame
local map       = json.decode(
    '{"version":1.0,"players":4,"name":"testing","width":5,"turns":3,"turnTime":60,"author":"DynomiteWaffle","map":[2,2,0,4,4,2,2,0,4,4,0,0,0,0,0,5,5,0,3,3,5,5,0,3,3]}')
local turn      = 0
local users     = {}
local colors    = {} --map numbers to colors - 0 1 not players

-- ingame vars
local usedTurns = 0


-- update server


-- info page
app.add_handler(
    "GET",
    "/",
    function()
        -- TODO update server - time based events - auto start when full
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
        return json.encode(map.map), { ["Content-Type"] = "json" }
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
local function validateUser(id)
    local valid = false
    for i = 1, #users, 1 do
        if (users[i].id == id) then
            valid = true
        end
    end
    if (not valid) then
        return false
    end
    return true
end
-- get user info - give id in json - {"id":"example id"}
-- NOTE - may not work
app.add_handler(
    "GET",
    "/userinfo",
    function(captures, query, headers, body)
        if query.id == nil then
            return '{"err":"no input"}', { ["Content-Type"] = "json" }
        end
        -- validateUser
        if (not validateUser(query.id)) then
            return '{"err":"bad input"}', { ["Content-Type"] = "json" }
        end
        -- calculate your next turn
        local turnsUntill = turn
        local turnsOffest = turnsUntill % map.turns -- now just players turns
        turnsUntill = turnsUntill % #users          -- now just turn order
        -- get user number
        local userNumber = 0
        for i = 1, #users, 1 do
            if (users[i] == query.id) then
                userNumber = i
            end
        end

        turnsUntill = userNumber - turnsUntill              -- now your turn position
        turnsUntill = turnsUntill * map.turns + turnsOffest -- now turns untill your turn

        local R = {
            turnsUntill = turnsUntill,
            turn = turn
        }
        return json.encode(R), { ["Content-Type"] = "json" }
    end
)
-- move - move piece - end turn
app.add_handler(
    "PUT",
    "/move",
    function(captures, query, headers, body)
        -- input validation
        if query.id == nil then
            return '{"err":"no input"}', { ["Content-Type"] = "json" }
        end
        -- validateUser
        if (not validateUser(query.id)) then
            return '{"err":"bad input"}', { ["Content-Type"] = "json" }
        end

        return "Under Construction", { ["Content-Type"] = "json" }
    end
)
-- from - https://uuidgenerator.dev/uuid-in-lua
local function generateCustomUUID()
    local template = 'xxxxx-xxxxx'
    return string.gsub(template, '[x]', function(c)
        local v = math.random(0, 0xf)
        return string.format('%x', v)
    end)
end

-- join
app.add_handler(
    "GET", -- should be POST - TODO set to POST - TEMP
    "/user",
    function(captures, query, headers, body)
        if (status == "NotStarted") then
            -- create new user
            -- input validation
            if (query.color == nil) then
                return '{"err":"no input"}', { ["Content-Type"] = "json" }
            end
            --TODO check if color is right format - 6 hex nums

            --user checking
            for i = 1, #users, 1 do
                -- simple color check
                if (users[i].color == query.color) then
                    return '{"err":"color taken"}', { ["Content-Type"] = "json" }
                end
                -- deep color check - checks if color is too close
            end

            -- create id/user
            local id = generateCustomUUID()
            users[#users + 1] = {
                id = id,
                color = query.color
            }
            return '{"user":"' .. id .. '"}', { ["Content-Type"] = "json" }
        end
    end
)
-- leave/quit
-- TODO
app.add_handler(
    "DELETE",
    "/user/quit",
    function(captures, query, headers, body)
        -- input validation
        if query.id == nil then
            return '{"err":"no input"}', { ["Content-Type"] = "json" }
        end
        -- validateUser
        if (not validateUser(query.id)) then
            return '{"err":"bad input"}', { ["Content-Type"] = "json" }
        end
        -- TODO delete users pieces
        return "Under Construction", { [":status"] = "204" }
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
