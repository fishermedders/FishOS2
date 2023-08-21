-- FMPack

-- F.isher's
-- M.anager (of)
-- P.ackages
-- A.nd
-- C.ool
-- K.ode

-- Idunno seemed like a cool acronym

-- Package Manager internal settings
local bVerboseLog = true

verboseLog = function(sLog)
    if not bVerboseLog then return end
    print(" VERBOSE \26 " .. sLog)
end

verboseKeep = function(sIdentifier, sMessage)
    if not tVerboseKeep then
        tVerboseKeep = {}
    end
    if tVerboseKeep[sIdentifier] then
        local tPos = { term.getCursorPos() }
        term.setCursorPos(1, tPos[2]-1)
    end
    verboseLog(sMessage)
    tVerboseKeep[sIdentifier] = true
end


verboseLog("Making sure we have our libraries")

-- Json Library, we need this for package manager.
if not fs.exists("/lib/json.lua") then
    verboseLog("Getting JSON Library")
    shell.run("pastebin get 4nRg9CHU /lib/json.lua")
end

local expect = dofile("rom/modules/main/cc/expect.lua").expect

_G.paintutils.loadImage = function(path)
    expect(1, path, "string")
    
    if fs.exists(path) then
        local file = io.open(path, "r")
        local sContent = file:read("*a")
        file:close()
        return paintutils.parseImage(sContent)
    else
        return paintutils.parseImage(path)
    end
    return nil
end


--[[if not fs.exists("/lib/basalt.lua") then
    shell.run("pastebin run ESs1mg7P packed true /lib/basalt")
end]]--

-- Basalt Library, we need this for UI things.
if not fs.exists("/lib/basalt.lua") then
    verboseLog("Getting Latest Basalt Library")
    shell.run("wget run https://basalt.madefor.cc/install.lua release latest.lua /lib/basalt.lua")
end

verboseLog("Loading Libraries")
os.loadAPI("/lib/json.lua")
local basalt = require("/lib/basalt")

-- UI Layout
verboseLog("Setting up UI Components")
local main = basalt.createFrame()
local isPackageCardUp = false

local topBar = main:addFrame()
    :setSize("{parent.w}",3)
    :setPosition(1, 1)
    :setBackground(colors.gray)

local label = topBar:addLabel("top_label")
    :setText("FMPack - Fisher's Manager (of) Packages And Cool Kode \02")
    :setPosition(2,2)

local barString = ""
for i = 1,1000 do
    barString = barString .. "\143"
end

local topBarBorder = topBar:addLabel("topBarBorder")
    :setText(barString)
    :setPosition(2,3)
    :setSize("{parent.w-3}", 1)
    :setBackground(colors.black)
    :setForeground(colors.gray)

local content = main:addScrollableFrame()
    :setSize("{parent.w-2}","{parent.h-3}")
    :setPosition(2, 4)
    :setBackground(colors.lightGray)

local infoPanelBorder = main:addFrame("infoPanelBorder")
    :setSize("{parent.w-10}", "{parent.h-4}")
    :setPosition("{parent.w+1}","{((parent.h/2)-(parent.h-4)/2)-1}")
    :setBackground(colors.gray, "\127")
local infoPanel = infoPanelBorder:addFrame()
    :setSize("{parent.w-3}","{parent.h-3}")
    :setPosition(2,2)
    :setBackground(colors.lightGray)

local infoPanelHide = infoPanel:addButton("infoPanelHide"):setSize(1,1):setPosition("{parent.w-1}", 1):setText("\08")
    :setBackground(colors.red)
    :onClick(function()
        infoPanelBorder:animatePosition(main:getWidth()+1, (main:getHeight()/2)-(main:getHeight()-4)/2, 0.5, 0, "linear")
        --main:addAnimation():setObject(infoPanelBorder):setAutoDestroy():move(main:getWidth()+1, ((main:getHeight()/2)-(main:getHeight()-4)/2), 1):play()
        isPackageCardUp = false
    end)
local infoPanelLabel = infoPanel:addLabel("infoPanelLabel"):setText("Package Name Here"):setPosition(2,2)
local infoPanelAuthor = infoPanel:addLabel("infoPanelAuthor"):setText("A Package by Author"):setPosition(2,3)
local infoPanelDescription = infoPanel:addLabel():setSize("{parent.w-3}","{parent.h-7}"):setPosition(2,6):setBackground(colors.gray):setText("blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah ")

-- Fetch Repositories
verboseLog("Fetching Globally indexed Github Packages with topic 'fmpack'")
local repoStr = http.get("https://api.github.com/search/repositories?q=topic:fmpack&sort=stars&order=desc").readAll()
local repos = json.decode(repoStr)

verboseLog("Fetching FMPack Central Repo")
local fmPackCentralStr = http.get("https://raw.githubusercontent.com/fishermedders/fmpack-central/main/package_info.json").readAll()
local fmPackCentral = json.decode(fmPackCentralStr)

local repoCards = {}

verboseLog("Setting up Repository UI")
local count = 1
for k,v in pairs(repos.items) do
    verboseKeep("repo_load", "Loaded package " .. v.name .. " by " .. v.owner.login .. "(#" .. count .. ")")
    local cols={colors.red;colors.orange;colors.yellow;colors.green;colors.blue;colors.purple}
    local cardsPerRow = 2
    local cardHeight = 12
    local c = count-1
    table.insert(repoCards, content:addFrame()
        :setSize("{parent.w/".. cardsPerRow .. "-2}", cardHeight-1)
        :setPosition("{(parent.w*"..((c/cardsPerRow)-math.floor(c/cardsPerRow)) .. ")}",((math.ceil(count/cardsPerRow)*cardHeight)-cardHeight)+2)
        :setBackground(cols[math.random(1,#cols)])
        --:setPosition("parent.w*"..(((count/cardsPerRow)-(math.floor(count/cardsPerRow)))-1/cardsPerRow)+1,math.ceil(count/3))
    )
    repoCards[#repoCards]:addFrame("info_tray"):setSize("{parent.w}", 5):setPosition(1, "{parent.h-4}")
    repoCards[#repoCards]:getChild("info_tray"):addLabel():setPosition(2,2):setText(v.name)
    repoCards[#repoCards]:getChild("info_tray"):addLabel():setPosition(2,3):setText("by " .. v.owner.login)
    repoCards[#repoCards]:onClick(function()
        if not isPackageCardUp then
            isPackageCardUp = true
            local w, h = term.getSize()
            infoPanelBorder:animatePosition((main:getWidth()/2)-(main:getWidth()-10)/2, (main:getHeight()/2)-(main:getHeight()-4)/2, 0.5, 0, "linear")
            --main:addAnimation():setObject(infoPanelBorder):setAutoDestroy():move((main:getWidth()/2)-(main:getWidth()-10)/2, (main:getHeight()/2)-(main:getHeight()-4)/2, 1):play()
            infoPanelLabel:setText(v.name)
            infoPanelDescription:setText(v.description)
            infoPanelAuthor:setText("A package by " .. v.owner.login)
            infoPanelBorder:show()
        end
    end)
    
    -- TODO: Load an optional thumbnail
    local thumbnail = http.get("https://raw.githubusercontent.com/" .. v.owner.login .. "/" .. v.name .. "/" .. v.default_branch .. "/fmpack/thumbnail.nfp")
    if thumbnail then
        --repoCards[#repoCards]:addImage():setImage(thumbnail.readAll(), "nfp"):setPosition(1,1):shrink()
    else
        
    end
    repoCards[#repoCards]:addLabel("shorthand"):setText(string.sub(v.name, 1, 4)):setPosition(1, 3):setTextAlign("center", "center"):setBackground(colors.gray):setFontSize(2)
    
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
        repoCards[#repoCards]:getChild("info_tray"):addLabel("version")
            :setText(infoString)
            :setPosition(2, 4)
    end
    for e = 1,#fmPackCentral.verified do
        if fmPackCentral.verified[e] == v.full_name then
            repoCards[#repoCards]:getChild("info_tray"):addLabel("verified")
            :setText("Verified")
            :setBackground(colors.lime)
            :setPosition("{(parent.w/2)-3}",1)
            repoCards[#repoCards]:getChild("info_tray"):addLabel("vright")
            :setText("\157")
            :setForeground(colors.lime)
            :setBackground(colors.gray)
            :setPosition("{(parent.w/2)+5}",1)
            repoCards[#repoCards]:getChild("info_tray"):addLabel("vleft")
            :setText("\145")
            :setForeground(colors.gray)
            :setBackground(colors.lime)
            :setPosition("{(parent.w/2)-4}",1)
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
        topBar:getChild("top_label"):setText(string.sub(titlebar,1,w-2))
        sleep(0.1)
    end
end

parallel.waitForAll(basalt.autoUpdate,titlebar)
