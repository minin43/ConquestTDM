--We'll use this file to auto-load all files in the folder specified below

local toLoad = {
    character_interactions = true,
    chat = true,
    deathscreen = true,
    donations = true,
    events = true,
    feed = true,
    flags = true,
    help = true,
    hud = true,
    leaderboards = true,
    level = true,
    loadout = true,
    maps = true,
    mapvote = true,
    menu = true,
    misc = true,
    money = true,
    perks = true,
    prestige = true,
    resupply = true,
    scoreboard = true,
    shop = true,
    spawning = true,
    spectator = true,
    stat_track = true,
    teams = true,
    titles = true,
    treasure_hunt = true,
    vendetta = true
}

function IncludeNewFile( fileName, directory )
    local sepFileName = string.Explode( "_", fileName )
    local toUse = directory .. "/" .. fileName

    print("[CTDM] including new file: " .. fileName)

    if sepFileName[1] == "sv" then
        if SERVER then include( toUse ) end
    elseif sepFileName[1] == "sh" then
        if SERVER then 
            include( toUse )
            AddCSLuaFile( toUse )
        else
            include( toUse )
        end
    elseif sepFileName[1] == "cl" then
        if SERVER then
            AddCSLuaFile( toUse )
        else
            include( toUse )
        end
    end
end

local _, gamemodeDirectories = file.Find( "tdm/gamemode/*", "LUA" )
for k, v in pairs( gamemodeDirectories ) do
    if toLoad[ v ] then
        local files, _ = file.Find( "tdm/gamemode/" .. v .. "/*", "LUA" )
        for _, fileName in pairs( files ) do
            IncludeNewFile( fileName, v )
        end
    end
end