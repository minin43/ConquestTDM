--//Logan Christianson © 2018 (lul copyright)
--//Adds ambient gunfire to the background of the games to immerse the players. By default, maps get the full ambient treatment, edit those that don't here.

local restartThink1, restartThink2, restartThink3, restartThink4, restartThink5 = true, true, true, true, true
local preventThink1, preventThink2, preventThink3, preventThink4, preventThink5 = false, false, false, false, false

--If certain maps don't need all of the ambient sounds, add it's representative number to a table down below
local CustomMapSounds = {
    --["map_name"] = {1 = a10, 2 = aa, 3 = explosions, 4 = long gunfire sequences, 5 = short gunfire sequences}
    ["gm_flatgrass"] = {1, 2, 5}
}

--If you don't want ANY sounds, add it to this table here (for underground maps I guess)
local NoMapSounds = {
    ["gm_construct"] = true
}

--//Needs to be ran after the gamemode is loaded, else game.GetMap() won't return properly (I think after gamemode load).
hook.Add( "PostGamemodeLoaded", "Ambienceeee", function()
    if CustomMapSounds[ game.GetMap() ] then
        for k, v in pairs(CustomMapSounds[ game.GetMap() ]) do
            if v == 1 then
                preventThink1 = true
            elseif v == 2 then
                preventThink2 = true
            elseif v == 3 then
                preventThink3 = true
            elseif v == 4 then
                preventThink4 = true
            elseif v == 5 then
                preventThink5 = true
            end
        end
    end

    if NoMapSounds[ game.GetMap() ] then return end

    --//The think function loops continually until the round is over
    --[[hook.Add( "Think", "LoopCheck", function()
        return
        if restartThink1 and not preventThink1 then
            restartThink1 = false
            timer.Simple( math.random( 90, 200 ), function()
                for k, v in pairs( player.GetAll() ) do
                    v:SendLua( "surface.PlaySound(\"ambient/looped sounds/a10/a10\" .. math.random( 1, 10 ) .. \".ogg\" )" ) --Shouldn't use SendLua but I can't be fucked to use net messages
                end
                timer.Simple( 15, function() restartThink1 = true end)
            end )
        end
        if restartThink2 and not preventThink2 then
            restartThink2 = false
            timer.Simple( math.random( 20, 80 ), function()
                for k, v in pairs( player.GetAll() ) do
                    v:SendLua( "surface.PlaySound(\"ambient/looped sounds/aa/aa\" .. math.random( 1, 6 ) .. \".ogg\" )" )
                end
                timer.Simple( 15, function() restartThink2 = true end)
            end )
        end
        if restartThink3 and not preventThink3 then
            restartThink3 = false
            timer.Simple( math.random( 10, 50 ), function()
                for k, v in pairs( player.GetAll() ) do
                    v:SendLua( "surface.PlaySound(\"ambient/looped sounds/explosions/explosion\" .. math.random( 1, 18 ) .. \".ogg\" )" )
                end
                timer.Simple( 4, function() restartThink3 = true end)
            end )
        end
        if restartThink4 and not preventThink4 then
            restartThink4 = false
            timer.Simple( math.random( 100, 200 ), function()
                for k, v in pairs( player.GetAll() ) do
                    v:SendLua( "surface.PlaySound(\"ambient/looped sounds/long gunfire/gunfire\" .. math.random( 1, 2 ) .. \".ogg\" )" )
                end
                timer.Simple( 25, function() restartThink4 = true end)
            end )
        end
        if restartThink5 and not preventThink5 then
            restartThink5 = false
            timer.Simple( math.random( 10, 50 ), function()
                for k, v in pairs( player.GetAll() ) do
                    v:SendLua( "surface.PlaySound(\"ambient/looped sounds/short gunfire/gunfire\" .. math.random( 1, 39 ) .. \".ogg\" )" )
                end
                timer.Simple( 4, function() restartThink5 = true end)
            end )
        end
    end )]]
end )