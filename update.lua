-- FishOS Updater

-- F.isher's
-- I.ncredible
-- S.andboxed
-- H.alfassed
-- O.perating
-- S.ystem

-- Don't bully my (probably) inefficient code,
-- please :]

-- Check if the lib folder exists, for storing
-- third party libraries
if not fs.exists("/lib") then
    fs.makeDir("/lib")
end

-- Basalt Library, we need this for UI things.
if not fs.exists("/lib/basalt.lua") then
    shell.run("pastebin run ESs1mg7P packed true /lib/basalt")
end

-- BigFont Library, we also need this for UI things.
if not fs.exists("/lib/bigfont.lua") then
    shell.run("pastebin get 3LfWxRWh /lib/bigfont.lua")
end

-- Json Library, we need this for package manager.
if not fs.exists("/lib/json.lua") then
    shell.run("pastebin get 4nRg9CHU /lib/json.lua")
end