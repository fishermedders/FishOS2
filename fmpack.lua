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

local list = main:addList():setSize("parent.w-2", "parent.h-6"):setPosition(2,2)
local install = main:addButton("install")
    :setSize("parent.w/4-2","3")
    :setPosition(2, "parent.h-3")
    :setText("Install")

local text = main:addTextarea():setSize()

local repoStr = http.get("https://api.github.com/search/repositories?q=topic:computercraft&sort=stars&order=desc").readAll()
local repos = json.decode(repoStr)

--print(textutils.serialize(repos))

for k,v in pairs(repos.items) do
    list:addItem(v.owner.login .. ": " .. v.name)
end

basalt.autoUpdate()