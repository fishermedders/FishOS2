-- FMPack

-- F.isher's
-- M.anager (of)
-- P.ackages
-- A.nd
-- C.ool
-- K.ode

-- Idunno seemed like a cool acronym

os.loadAPI("/lib/json.lua")
local basalt = require("/lib/basalt")

local main = basalt.createFrame()

local list = main:addList():setSize("parent.w-2", "parent.h-2"):setPosition(2,2)

local repoStr = http.get("https://api.github.com/search/repositories?q=topic:computercraft&sort=stars&order=desc").readAll()
local repos = json.decode(repoStr)

--print(textutils.serialize(repos))

for k,v in pairs(repos.items) do
    list:addItem(v.owner.login .. ": " .. v.name)
end

basalt.autoUpdate()