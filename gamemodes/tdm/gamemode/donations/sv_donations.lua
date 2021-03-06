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

--//Should only be called by admins
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

vip = {}
vip.Players = {}

vip.Groups = { --Multiplier %
	vip = 0.10,
	["vip+"] = 0.15,
	ultravip = 0.20,
    staff = 0.05, --base staff bonus
    vipmod = 0.15, --vip + staff
    ["vip+mod"] = 0.20, --vip+ + staff
    ultravipmod = 0.25 --ultravip + staff
}

vip.ULiBStaffRoles = {
    dev = true,
    superadmin = true,
    admin = true,
    operator = true,
    trialmod = true
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

--DOES NOT save to a file, only sets the player's "usergroup" (we don't actually touch ply:SetUserGroup, since it's used by ULX/ULiB)
function vip.SetVip( ply, group )
    vip.Players[ id(ply:SteamID()) ] = group
end

function vip.GetVip( ply )
    return vip.Players[ id(ply:SteamID()) ] or false
end

function vip.IsVip( ply )
    local role = vip.GetVip( ply )
    return vip.Groups[ role ] or vip.ULiBStaffRoles[ string.lower(ply:GetUserGroup()) ]
end

--Saves the provided group name to a file
function vip.SaveVip( ply, group )
    if vip.Groups[ group ] then
        file.Write( "tdm/users/vip/" .. id(ply:SteamID()) .. ".txt", group )
        vip.SetVip( ply, group )
    end
end

hook.Add( "PlayerInitialSpawn", "SetUserGroup", function( ply )
	if not file.Exists( "tdm/users/vip", "DATA" ) then
        file.CreateDir( "tdm/users/vip" )
    end

    if file.Exists( "tdm/users/vip/" .. id( ply:SteamID() ) .. ".txt", "DATA" ) then
        local vipgroup = file.Read( "tdm/users/vip/" .. id( ply:SteamID() ) .. ".txt" )
        vip.SetVip( ply, vipgroup )
    else
        print("[CTDM] Checking for ULiB usergroup on " .. ply:Nick() .. " - ", ply:GetUserGroup())

        local role = string.lower(ply:GetUserGroup())
        if vip.Groups[ role ] then
            vip.SaveVip( ply, role )
        elseif vip.ULiBStaffRoles[ role ] then
            vip.SaveVip( ply, "staff" )
        else
            --print("Does not exist")
        end
	end
end )

net.Receive( "GetDonatorCredits", function( len, ply )
    donations.UpdateCredits( ply )
end )