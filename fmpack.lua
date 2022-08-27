-- FMPack

-- F.isher's
-- M.anager (of)
-- P.ackages
-- A.nd
-- C.ool
-- K.ode

-- Idunno seemed like a cool acronym

-- Json Library, we need this for package manager.
if not fs.exists("/lib/json.lua") then
    shell.run("pastebin get 4nRg9CHU /lib/json.lua")
end

-- Basalt Library, we need this for UI things.
if not fs.exists("/lib/basalt.lua") then
    shell.run("pastebin run ESs1mg7P packed true /lib/basalt")
end

os.loadAPI("/lib/json.lua")
local basalt = require("/lib/basalt")

local main = basalt.createFrame()

local topBar = main:addFrame()
:setSize("parent.w",3)
:setPosition(1, 1)
:setBackground(colors.gray)

local label = topBar:addLabel("top_label"):setText("FMPack - Fisher's Manager (of) Packages And Cool Kode \02"):setPosition(2,2)
local barString = ""
for i = 1,topBar:getWidth()-2 do
    barString = barString .. "\143"
end

local topBarBorder = topBar:addLabel("topBarBorder"):setText(barString):setPosition(2,3):setBackground(colors.black):setForeground(colors.gray)

local content = main:addFrame()
:setSize("parent.w-2","parent.h-3")
:setPosition(2, 4)
:setBackground(colors.lightGray)
:setScrollable(true)

local infoPanelBorder = main:addFrame("infoPanelBorder")
:setSize("parent.w-10", "parent.h-4")
--:setPosition("1","((parent.h/2)-(parent.h-4)/2)+1")
:setPosition("parent.w","((parent.h/2)-(parent.h-4)/2)")
--:setOffset(-main:getWidth()-10, 0)
:setBackground(colors.gray, "\127")
--:setMovable()
:hide()
local infoPanel = infoPanelBorder:addFrame()
:setSize("parent.w-2","parent.h-2")
:setPosition(2,2)
:setBackground(colors.lightGray)

local infoPanelHide = infoPanel:addButton("infoPanelHide"):setSize(1,1):setPosition("parent.w-1", 1):setText("\08")
:setBackground(colors.red)
:onClick(function()
    main:addAnimation():setObject(infoPanelBorder):setAutoDestroy():move(main:getWidth()+1, ((main:getHeight()/2)-(main:getHeight()-4)/2), 1):play()
end)
local infoPanelLabel = infoPanel:addLabel("infoPanelLabel"):setText("Package Name Here"):setPosition(2,2)

local infoPanelDescription = infoPanel:addLabel():setSize("parent.w-2","parent.h-6"):setPosition(2,6):setBackground(colors.gray):setText("blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah ")
--local list = content:addList():setSize("parent.w-2", "parent.h-6"):setPosition(2,2):setBackground(colors.red)
--[[:onChange(function(self)
    main:getDeepObject("desc"):setText(self:getValue().args[1])
end)
local install = main:addButton("install")
    :setSize("parent.w/4-2","3")
    :setPosition(2, "parent.h-3")
    :setText("Install")

local text = main:addLabel("desc"):setSize("parent.w*0.75-1", 3):setPosition("parent.w/4+1", "parent.h-3"):setBackground(colors.red)]]--

local repoStr = http.get("https://api.github.com/search/repositories?q=topic:fmpack&sort=stars&order=desc").readAll()
local repos = json.decode(repoStr)

local repoCards = {}

file = fs.open("logs","w")

--print(textutils.serialize(repos))

local count = 1
for k,v in pairs(repos.items) do
    local cols={colors.red;colors.orange;colors.yellow;colors.green;colors.blue;colors.purple}
    local cardsPerRow = 2
    local cardHeight = 11
    --list.addItem()
    --list:addItem(v.owner.login .. ": " .. v.name, nil, nil, v.description)
    local c = count-1
    table.insert(repoCards, content:addFrame()
        :setSize("parent.w/".. cardsPerRow .. "-1", cardHeight-1)
        :setPosition("1+(parent.w*"..((c/cardsPerRow)-math.floor(c/cardsPerRow)) .. ")",((math.ceil(count/cardsPerRow)*cardHeight)-cardHeight)+2)
        :setBackground(cols[math.random(1,#cols)])
        --:setPosition("parent.w*"..(((count/cardsPerRow)-(math.floor(count/cardsPerRow)))-1/cardsPerRow)+1,math.ceil(count/3))
    )
    repoCards[#repoCards]:addLabel("shorthand"):setFontSize(2):setText(string.sub(v.name, 1, 2)):setPosition(1, 3):setTextAlign("center", "center"):setBackground(colors.gray)
    repoCards[#repoCards]:addFrame("info_tray"):setSize("parent.w", "4"):setPosition(1, "parent.h-3")
    repoCards[#repoCards]:getDeepObject("info_tray"):addLabel():setPosition(2,2):setText(v.name)
    repoCards[#repoCards]:getDeepObject("info_tray"):addLabel():setPosition(2,3):setText("by " .. v.owner.login)
    repoCards[#repoCards]:onClick(function()
        local w, h = term.getSize()
        main:addAnimation():setObject(infoPanelBorder):setAutoDestroy():move((main:getWidth()/2)-(main:getWidth()-10)/2, (main:getHeight()/2)-(main:getHeight()-4)/2, 1):play()
        infoPanelLabel:setText(v.name)
        infoPanelDescription:setText(v.description)
        infoPanelBorder:show()
        --basalt.debug(v.name)
    end)
    file.writeLine(" " .. count .. ": " .. ((count-1/cardsPerRow)-math.floor(count-1/cardsPerRow)))
    count = count + 1
end

file.close()

function titlebar()
    local titlebar = "FMPack - Fisher's Manager (of) Packages And Cool Kode \02        "
    local w,_ = term.getSize()
    for i = 1,w-2-#titlebar do
        titlebar = titlebar .. " "
    end
    while true do
        titlebar = string.sub(titlebar,2,#titlebar) .. string.sub(titlebar, 1, 1)
        topBar:getDeepObject("top_label"):setText(string.sub(titlebar,1,w-2))
        sleep(0.1)
    end
end

parallel.waitForAll(basalt.autoUpdate,titlebar)