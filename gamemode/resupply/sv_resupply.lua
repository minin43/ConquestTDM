--[[
    What is Conquest Resupply? I'll explain here:
    Conquest Resupply is supposed to be a slight-alternative approach to conquest tdm, where the map shifts at halftime depending on who's winning & losing. Nothing super
    exciting goes on in the backend besides changing the spawns & flags, respawning all players, and doing some effect that fades their sceen out. Maps utilizing this alternative
    game type need the "resupply" tag given in shared.lua in its MapTable table
    In order for maps to be resupply-ready, they need 3 sets of spawns & flags, with IDs being 1, 2, or 3. 2 is the starting set of spawns & flags. The game shifts to 1
    if red team (team 1) is doing poorly and needs help, or 3 if blue team/team 2 needs help.
]]

local color_red, color_green, color_blue = Color(244, 67, 54), Color(76, 175, 80), Color(33, 150, 243),

hook.Add( "PostGamemodeLoaded", "SetResupply", function()
    local isResupply = false
    for k, v in pairs( GAMEMODE.MapTable[ game.GetMap() ].tags ) do
        if v == "resupply" then isResupply = true end
    end
    
    if isResupply then
        SetGlobalInt( "ConquestResupply", 2 )
        GAMEMODE:SetupFlags()
        refreshspawns()
    else
        SetGlobalInt( "ConquestResupply", 0 )
    end
end )

hook.Add( "RountTimerInc", "ResupplyCheck", function( secPassed, redTix, blueTix ) 
    if GetGlobalInt( "ConquestResupply" ) == 0 or ResupplyChecked then return end
    
    if secPassed == GAMEMODE.GameTime / 2 or (redTix <= GAMEMODE.Tickets / 2) or (blueTix <= GAMEMODE.Tickets / 2) then
        ResupplyChecked = true

        if redTix - blueTix < -20 then
            SetGlobalInt( "ConquestResupply", 1 )
            GAMEMODE:SetupFlags()
            refreshspawns()
            GlobalChatPrintColor( color_green, "[Conquest Resupply]", Color(255, 255, 255), " Half time! ", color_blue, GAMEMODE.blueTeamName, Color(255, 255, 255), " have the lead and pushed into ", color_red, GAMEMODE.redTeamName, Color(255, 255, 255), "'s territory! Things are going to get tougher for them...")
        elseif redTix - blueTix > 20 then
            SetGlobalInt( "ConquestResupply", 3 )
            GAMEMODE:SetupFlags()
            refreshspawns()
            GlobalChatPrintColor( color_green, "[Conquest Resupply]", Color(255, 255, 255), " Half time! ", color_red, GAMEMODE.redTeamName, Color(255, 255, 255), " have the lead and pushed into ", color_blue, GAMEMODE.blueTeamName, Color(255, 255, 255), "'s territory! Things are going to get tougher for them...")
        else    --If both teams are neck-and-neck at the halfway point
            GlobalChatPrintColor( color_green, "[Conquest Resupply]", Color(255, 255, 255), " Half time! Both teams are neck-and-neck, no map shift will occur!" )
            return
        end

        for k, v in pairs( player.GetAll() ) do
            v:Lock()
            v:EmitSound( "ambient/alarms/warningbell1.wav" )
        end
        GAMEMODE.PreventTeamSwitching = true

        timer.Simple( 3, function()
            for k, v in pairs( player.GetAll() ) do
                if v:Team() == 1 or v:Team() == 2 then
                    v:ScreenFade( SCREENFADE.OUT, Color( 0, 0, 0 ), 1, 4 )
                end
            end
            timer.Simple( 1.5, function()
                for k, v in pairs( player.GetAll() ) do
                    if v:Team() == 1 or v:Team() == 2 then
                        v:Spawn()
                        v:UnLock()
                        net.Start( "DoStart" )
                        net.Send( v )
                    end
                end
                GAMEMODE.PreventTeamSwitching = false
            end)
        end )
    end
end )

hook.Add( "RountTimerInc", "ResupplyWarning", function( secPassed, redTix, blueTix )
    if GetGlobalInt( "ConquestResupply" ) == 0 or WarningChecked then return end

    if secPassed == GAMEMODE.GameTime / 10 * 6 or redTix == GAMEMODE.Tickets / 10 * 6 or blueTix == GAMEMODE.Tickets / 10 * 6 then
        WarningChecked = true
        if redTix > blueTix then
            GlobalChatPrintColor( color_green, "[Conquest Resupply]", color_red, GAMEMODE.redTeamName, Color(255, 255, 255), " are in the lead, the map may soon shift out of their favor!" )
        elseif redTix < blueTix then
            GlobalChatPrintColor( color_green, "[Conquest Resupply] ", color_blue, GAMEMODE.blueTeamName, Color(255, 255, 255), " are in the lead, the map may soon shift out of their favor!" )
        else
            GlobalChatPrintColor( color_green, "[Conquest Resupply] ", Color(255, 255, 255), "Both teams are neck-and-neck! Map shift will likely not occur." )
        end
    end
end )
