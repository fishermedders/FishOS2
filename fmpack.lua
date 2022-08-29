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
--if not fs.exists("/lib/basalt.lua") then
--    shell.run("pastebin run ESs1mg7P packed true /lib/basalt")
--end

os.loadAPI("/lib/json.lua")
local basalt = require("/Basalt")

local main = basalt.createFrame()
local isPackageCardUp = false

local topBar = main:addFrame()
    :setSize("parent.w",3)
    :setPosition(1, 1)
    :setBackground(colors.gray)

local label = topBar:addLabel("top_label")
    :setText("FMPack - Fisher's Manager (of) Packages And Cool Kode \02")
    :setPosition(2,2)

local barString = ""
for i = 1,topBar:getWidth()-2 do
    barString = barString .. "\143"
end

local topBarBorder = topBar:addLabel("topBarBorder")
    :setText(barString)
    :setPosition(2,3)
    :setBackground(colors.black)
    :setForeground(colors.gray)

local content = main:addFrame()
    :setSize("parent.w-2","parent.h-3")
    :setPosition(2, 4)
    :setBackground(colors.lightGray)
    :setScrollable(true)

local infoPanelBorder = main:addFrame("infoPanelBorder")
    :setSize("parent.w-10", "parent.h-4")
    :setPosition("parent.w+1","((parent.h/2)-(parent.h-4)/2)")
    :setBackground(colors.gray, "\127")
local infoPanel = infoPanelBorder:addFrame()
    :setSize("parent.w-2","parent.h-2")
    :setPosition(2,2)
    :setBackground(colors.lightGray)

local infoPanelHide = infoPanel:addButton("infoPanelHide"):setSize(1,1):setPosition("parent.w-1", 1):setText("\08")
    :setBackground(colors.red)
    :onClick(function()
        main:addAnimation():setObject(infoPanelBorder):setAutoDestroy():move(main:getWidth()+1, ((main:getHeight()/2)-(main:getHeight()-4)/2), 1):play()
        isPackageCardUp = false
    end)
local infoPanelLabel = infoPanel:addLabel("infoPanelLabel"):setText("Package Name Here"):setPosition(2,2)
local infoPanelAuthor = infoPanel:addLabel("infoPanelAuthor"):setText("A Package by Author"):setPosition(2,3)

local infoPanelDescription = infoPanel:addLabel():setSize("parent.w-2","parent.h-6"):setPosition(2,6):setBackground(colors.gray):setText("blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah ")

-- Fetch Repositories

local repoStr = http.get("https://api.github.com/search/repositories?q=topic:fmpack&sort=stars&order=desc").readAll()
local repos = json.decode(repoStr)

local fmPackCentralStr = http.get("https://raw.githubusercontent.com/fishermedders/fmpack-central/main/package_info.json").readAll()
local fmPackCentral = json.decode(fmPackCentralStr)

local repoCards = {}

local count = 1
for k,v in pairs(repos.items) do
    local cols={colors.red;colors.orange;colors.yellow;colors.green;colors.blue;colors.purple}
    local cardsPerRow = 2
    local cardHeight = 12
    local c = count-1
    table.insert(repoCards, content:addFrame()
        :setSize("parent.w/".. cardsPerRow .. "-1", cardHeight-1)
        :setPosition("1+(parent.w*"..((c/cardsPerRow)-math.floor(c/cardsPerRow)) .. ")",((math.ceil(count/cardsPerRow)*cardHeight)-cardHeight)+2)
        :setBackground(cols[math.random(1,#cols)])
        --:setPosition("parent.w*"..(((count/cardsPerRow)-(math.floor(count/cardsPerRow)))-1/cardsPerRow)+1,math.ceil(count/3))
    )
    repoCards[#repoCards]:addFrame("info_tray"):setSize("parent.w", "5"):setPosition(1, "parent.h-4")
    repoCards[#repoCards]:getDeepObject("info_tray"):addLabel():setPosition(2,2):setText(v.name)
    repoCards[#repoCards]:getDeepObject("info_tray"):addLabel():setPosition(2,3):setText("by " .. v.owner.login)
    repoCards[#repoCards]:onClick(function()
        if not isPackageCardUp then
            isPackageCardUp = true
            local w, h = term.getSize()
            main:addAnimation():setObject(infoPanelBorder):setAutoDestroy():move((main:getWidth()/2)-(main:getWidth()-10)/2, (main:getHeight()/2)-(main:getHeight()-4)/2, 1):play()
            infoPanelLabel:setText(v.name)
            infoPanelDescription:setText(v.description)
            infoPanelAuthor:setText("A package by " .. v.owner.login)
            infoPanelBorder:show()
        end
    end)
    local thumbnail = http.get("https://raw.githubusercontent.com/" .. v.owner.login .. "/" .. v.name .. "/" .. v.default_branch .. "/fmpack/thumbnail.nfp")
    if thumbnail then
        repoCards[#repoCards]:addImage():loadImageFromString(thumbnail.readAll()):setPosition(1,1):shrink()
    else
        repoCards[#repoCards]:addLabel("shorthand"):setFontSize(2):setText(string.sub(v.name, 1, 2)):setPosition(1, 3):setTextAlign("center", "center"):setBackground(colors.gray)
    end

    local fmPack = http.get("https://raw.githubusercontent.com/" .. v.owner.login .. "/" .. v.name .. "/" .. v.default_branch .. "/fmpack/fmpackage.json")
    if fmPack then
        local fmPackage = json.decode(fmPack.readAll())
        local infoString = ""
        if fmPackage.version then
            infoString = infoString .. fmPackage.version
        end
        if fmPackage.type then
            if infoString ~= "" then
                infoString = infoString .. " | "
            end
            infoString = infoString .. fmPackage.type
        end
        repoCards[#repoCards]:getDeepObject("info_tray"):addLabel("version")
            :setText(infoString)
            :setPosition(2, 4)
    end
    
    for e = 1,#fmPackCentral.verified do
        if fmPackCentral.verified[e] == v.full_name then
            repoCards[#repoCards]:getDeepObject("info_tray"):addLabel("verified")
            :setText("Verified")
            :setBackground(colors.lime)
            :setPosition("(parent.w/2)-3",1)
            repoCards[#repoCards]:getDeepObject("info_tray"):addLabel("vright")
            :setText("\157")
            :setForeground(colors.lime)
            :setBackground(colors.gray)
            :setPosition("(parent.w/2)+5",1)
            repoCards[#repoCards]:getDeepObject("info_tray"):addLabel("vleft")
            :setText("\145")
            :setForeground(colors.gray)
            :setBackground(colors.lime)
            :setPosition("(parent.w/2)-4",1)
        end
    end

    count = count + 1
end

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
