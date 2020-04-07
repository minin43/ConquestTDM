--//This file to be used for handling donator credits and VIP status
util.AddNetworkString( "GetDonatorCredits" )
util.AddNetworkString( "GetDonatorCreditsCallback" )

donations = {}

function donations.GetCredits( ply )
    return tonumber( ply:GetPData( "donatorcredits" ) )
end

function donations.AddCredits( ply, amt )
    ply:SetPData( "donatorcredits", donations.GetCredits( ply ) + amt )
end

--//Should only be called by admins if we start selling these or there's a fuckup
function donations.SetCredits( ply, amt )
    ply:SetPData( "donatorcredits", amt )
end

function donations.SubtractCredits( ply, amt )
    ply:SetPData( "donatorcredits", donations.GetCredits( ply ) - math.abs( amt ) )
end

function donations.UpdateCredits( ply )
    net.Start( "GetDonatorCreditsCallback" )
        net.WriteInt( donations.GetCredits( ply ), 16 )
    net.Send( ply )
end

hook.Add( "PlayerInitialSpawn", "SetupDonatorPData", function( ply )
	timer.Simple( 5, function()
		if not ply:GetPData( "donatorcredits" ) then
			donations.SetCredits( ply, 0 )
		end
	end )
end )

vip = { }

vip.Groups = { --Multiplier %
	vip = 0.10,
	vipplus = 0.15,
	ultravip = 0.20,
	staff = 0.05
}

if not file.Exists( "tdm/usergroups.txt", "DATA" ) then
	local throwaway = {}
	for k, v in pairs( vip.Groups ) do 
		throwaway[ k ] = {}
	end

	file.Write( "tdm/usergroups.txt", util.TableToJSON( throwaway ) )
else
	fil = util.JSONToTable( file.Read( "tdm/usergroups.txt" ) )
	for k, v in pairs( vip.Groups ) do
		if not fil[ k ] then
			fil[ k ] = { }
		end
	end
end

function vip.SetVip( ply, group )

end

hook.Add( "PlayerInitialSpawn", "SetUserGroup", function( ply )
	--fil = 
end )

net.Receive( "GetDonatorCredits", function( len, ply )
    donations.UpdateCredits( ply )
end )