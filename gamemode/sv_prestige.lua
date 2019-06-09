util.AddNetworkString( "GetPrestigeTokens" )
util.AddNetworkString( "GetPrestigeTokensCallback" )
util.AddNetworkString( "PlayerAttemptPrestige" )

prestige = {}

function prestige.GetTokens( ply )
    return math.round( tonumber( ply:GetPData( "prestigetokens" ) ) )
end

function prestige.AddTokens( ply, amt )
    ply:SetPData( "prestigetokens", prestige.GetTokens( ply ) + amt )
end

--//Should only be called by admins if we start selling these or there's a fuckup
function prestige.SetTokens( ply, amt )
    ply:SetPData( "prestigetokens", amt )
end

--//Granted 1 token per regular prestige, more if specific criteria are met
function prestige.AttemptPrestige( ply )
    if lvl.GetLevel( ply ) < lvl.maxlevel then return false end
    local tally = 1

    if _ then
        tally = tally + 1
    end
    
    self:ActuallyPrestige( ply, tally )
end

--//Does the actual prestiging, money/weapon resetting, runs assuming it was ran through AttemptPrestige
function prestige.ActuallyPrestige( ply, amt )
    lvl.ResetPlayer( ply )
    ResetMoney( ply )
    --Need a way to reset all weapon information, probably need to run a SQL script
    prestige.AddTokens( amt )
end

net.Receive( "GetPrestigeTokens", function( len, ply )
    net.Start( "GetPrestigeTokensCallback" )
        net.WriteInt( prestige.GetTokens( ply ), 16 ) --//16 is probably overkill, but there's technically no cap, so better safe than sorry
    net.Send( ply )
end )

net.Receive( "PlayerAttemptPrestige", function( len, ply )
    if prestige.AttemptPrestige( ply ) then
        net.Start( "GetPrestigeTokensCallback" )
            net.WriteInt( prestige.GetTokens( ply ), 16 ) --//16 is probably overkill, but there's technically no cap, so better safe than sorry
        net.Send( ply )
    end

end )

hook.Add( "PlayerInitialSpawn", "SetupPrestigePData", function( ply )
	timer.Simple( 5, function()
		if not ply:GetPData( "prestigetokens" ) then
			prestige.SetTokens( ply, 0 )
		end
	end )
end )