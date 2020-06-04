--Any chat command hooks should be found here
--The one exception is for the treasure hunt, which is found in teasure_hunt/sv_treasure_hunt.lua

local color_red, color_green, color_blue = Color(244, 67, 54), Color(76, 175, 80), Color(33, 150, 243)

hook.Add( "PlayerSay", "DontRockTheVoteBaby", function( ply, msg, teamOnly )
    if #player.GetAll() == 1 then return end
    local stringCheck = string.lower( msg )
    if GAMEMODE.EquippedTitles[ id( ply:SteamID() ) ] then
        local len = string.len( "[" .. GAMEMODE.EquippedTitles[ id( ply:SteamID() ) ] .. "]" )
        stringCheck = string.Right( string.lower( msg ), len )
    end
    if string.StartWith( stringCheck, "rtv" ) or string.StartWith( stringCheck, "/rtv" ) or string.StartWith( stringCheck, "!rtv" ) then
        if not timer.Exists( "RTVCooldownTimer" ) then --If the RTV isn't on cooldown (because it didn't pass)
            if not timer.Exists( "RTVTimer" ) then --If an RTV hasn't been started yet
                if GAMEMODE.GameTime - GetGlobalInt( "RoundTime" ) < 60 then 
                    GlobalChatPrintColor( "[RTV] Too early into the round before a Rock The Vote can be started!" )
                    return
                end
                GAMEMODE.NecessaryRTVVotes = math.Round( #player.GetAll() / 2 ) or 1
                GAMEMODE.RTVVotes = { [ id( ply:SteamID() ) ] = true }
                GAMEMODE.TotalRTVVotes = 1

                timer.Create( "RTVTimer", GAMEMODE.RTVTime, 1, function()
                    GlobalChatPrintColor( "[RTV] Not enough votes placed to Rock The Vote" )
                    timer.Create( "RTVCooldownTimer", GAMEMODE.RTVCooldown, 1, function() end )
                    GAMEMODE.TotalRTVVotes = 0
                end )

                GlobalChatPrintColor( "[RTV] Rock The Vote has been called, total votes necessary: " .. GAMEMODE.NecessaryRTVVotes )
                GlobalChatPrintColor( "[RTV] Type \"rtv\" in chat to cast your vote" )
                timer.Simple( 0.25, function()
                    GlobalChatPrintColor( "[RTV] Time to cast your vote: " .. GAMEMODE.RTVTime .. " seconds" )
                end )
                timer.Simple( 0.5, function()
                    GlobalChatPrintColor( "[RTV] " .. ply:Nick() .. " has voted, " .. GAMEMODE.NecessaryRTVVotes - GAMEMODE.TotalRTVVotes .. " more vote(s) necessary" )
                end )
            else
                if !GAMEMODE.RTVVotes[ id( ply:SteamID() ) ] then
                    GAMEMODE.RTVVotes[ id( ply:SteamID() ) ] = true
                    GAMEMODE.TotalRTVVotes = GAMEMODE.TotalRTVVotes + 1
                    
                    GlobalChatPrintColor( "[RTV] " .. ply:Nick() .. " has voted, " .. GAMEMODE.NecessaryRTVVotes - GAMEMODE.TotalRTVVotes .. " more vote(s) necessary" )

                    if GAMEMODE.TotalRTVVotes >= GAMEMODE.NecessaryRTVVotes then
                        GlobalChatPrintColor( "[RTV] Enough votes have been cast, rocking the vote..." )
                        timer.Simple( 3, function()
                            hook.Run( "StartMapvote" )
                        end )
                        timer.Remove( "RTVTimer" )
                        timer.Create( "RTVCooldownTimer", GAMEMODE.RTVCooldown, 1, function() end ) --Just so we don't get a second RTV called while in mapvote
                    end
                end
            end
        else
            GlobalChatPrintColor( "[RTV] RockTheVote is on cooldown for " .. math.Round( timer.TimeLeft( "RTVCooldownTimer" ) ) .. " more second(s)" )
        end
        return ""
    end
end )

hook.Add( "PlayerSay", "TimePlayedCheck", function( ply, msg, teamOnly )
    if string.StartWith( msg, "/time" ) or string.StartWith( msg, "!time" ) then
        local timespent = tonumber( ply:GetPData( "g_time", "1" ) )
        ply:ChatPrintColor( color_green, ply:Nick(), Color(255, 255, 255), ", you've spent ", color_green, timespent .. " minutes", Color(255, 255, 255), " playing on the server,",
            " which amounts to ", color_green, math.round(timespent / 60, 1), " hours", Color(255, 255, 255), "." )
        return
    end
end )

hook.Add( "PlayerSay", "HelpCheck", function( ply, msg, teamOnly )
    if string.StartWith( msg, "/help" ) or string.StartWith( msg, "!help" ) then
        ply:ChatPrintColor( Color(255, 255, 255), "Press F1 to open the menu\nUse +context_menu (defaults to c) to customize your gun\nThe community exists on discord, join with the textbox button!" )
        return
    end
end )