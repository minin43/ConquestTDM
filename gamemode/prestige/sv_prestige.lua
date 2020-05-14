util.AddNetworkString( "GetPrestigeTokens" )
util.AddNetworkString( "GetPrestigeTokensCallback" )
util.AddNetworkString( "PlayerAttemptPrestige" )
util.AddNetworkString( "AttemptPrestigeCallback" )

prestige = {}

function prestige.GetTokens( ply )
    return tonumber( ply:GetPData( "prestigetokens" ) )
end

function prestige.AddTokens( ply, amt )
    ply:SetPData( "prestigetokens", prestige.GetTokens( ply ) + amt )
end

--//Should only be called by admins if we start selling these or there's a fuckup
function prestige.SetTokens( ply, amt )
    ply:SetPData( "prestigetokens", amt )
end

function prestige.SubtractTokens( ply, amt )
    ply:SetPData( "prestigetokens", prestige.GetTokens( ply ) - math.abs( amt ) )
end

--//This resets ALL weapon information, attachments & purchases - call with care
function prestige.ResetPlayer( ply )
    local playerfile = util.JSONToTable( file.Read( "tdm/users/" .. id( ply:SteamID() ) .. ".txt", "DATA" ) )
    local boughtguns = playerfile[ 2 ]
    local searchedguns = {}
    
    for k, v in pairs( boughtguns ) do
        ply:SetPData( v, 0 )
        searchedguns[ v ] = true
    end
    for k, v in pairs( GAMEMODE.WeaponsList ) do
        if !searchedguns[ v[ 2 ] ] then
            ply:SetPData( v[ 2 ], 0 )
            searchedguns[ v[ 2 ] ] = true
        end
    end

    GAMEMODE.RecacheUnlockedTable[ ply ].wep = true

	file.Write( "tdm/users/" .. id( ply:SteamID() ) .. ".txt", util.TableToJSON( { playerfile[ 1 ], { } } ) )
end

--//Granted 1 token per regular prestige, more if desired
function prestige.AttemptPrestige( ply )
    if lvl.GetLevel( ply ) < lvl.maxlevel then return false end
    --[[local tally = 1

    if _ then
        tally = tally + 1
    end]]
    
    prestige.ActuallyPrestige( ply, 1 )
    return true
end

--//Does the actual prestiging, money/weapon resetting, runs assuming it was ran through AttemptPrestige
function prestige.ActuallyPrestige( ply, amt )
    lvl.ResetPlayer( ply )
    ResetMoney( ply )
    prestige.ResetPlayer( ply )

    prestige.AddTokens( ply, amt )
end

--//Sends GetPrestigeTokensCallback to a player
function prestige.UpdateTokens( ply )
    net.Start( "GetPrestigeTokensCallback" )
        net.WriteInt( prestige.GetTokens( ply ), 16 ) --//16 is probably overkill, but there's technically no cap, so better safe than sorry
    net.Send( ply )
end

net.Receive( "GetPrestigeTokens", function( len, ply )
    prestige.UpdateTokens( ply )
end )

net.Receive( "PlayerAttemptPrestige", function( len, ply )
    if prestige.AttemptPrestige( ply ) then
        net.Start( "AttemptPrestigeCallback" )
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