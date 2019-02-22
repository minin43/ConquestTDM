include( "shared.lua" )
include( "hud.lua" )
include( "spawnmenu.lua" )
include( "cl_scoreboard.lua" )
include( "cl_lvl.lua" )
include( "cl_loadout.lua" )
include( "cl_money.lua" )
include( "cl_flags.lua" )
include( "cl_feed.lua" )
include( "cl_deathscreen.lua" )
include( "cl_customspawns.lua" )
include( "cl_leaderboards.lua" )
include( "cl_playercards.lua" )
include( "sh_weaponbalancing.lua" )

local groups = {
	{ "vip", Color( 0, 200, 0 ), "VIP" },
	{ "operator", Color( 180, 180, 180 ), "Operator" },
	{ "vip+", Color( 0, 255, 0 ), "VIP+" },
	{ "owner", Color( 255, 0, 0 ), "Owner" },
	{ "creator", Color( 200, 0, 0 ), "Creator" },
	{ "coowner", Color( 255, 0, 0 ), "Co-Owner" },
	{ "Developer", Color( 179, 225, 0 ), "Developer" },
	{ "superadmin", Color( 255, 0, 0 ), "Superadmin" },
	{ "admin", Color( 220, 180, 0 ), "Admin" }
}

local ccolors = {
	{ "red", Color( 255, 0, 0 ) },
	{ "blue", Color( 0, 0, 255 ) },
	{ "yellow", Color( 255, 255, 0 ) },
	{ "black", Color( 0, 0, 0 ) },
	{ "white", Color( 255, 255, 255 ) },
	{ "green", Color( 0, 255, 0 ) },
	{ "orange", Color( 255, 120, 0 ) },
	{ "pink", Color( 255, 0, 255 ) },
	{ "purple", Color( 270, 0, 255 ) }
}

local ti = table.insert
local IsValid = IsValid
local Color = Color
local unpack = unpack
local white = color_white
/*


function GM:OnPlayerChat( ply, text, teamonly, dead )
	local tab = {}
	if IsValid( ply ) then
		if dead then
			ti( tab, Color( 255, 30, 40 ) )		
			ti( tab, "*At a beter place* " )
		end
		if teamonly then
			ti( tab, Color( 30, 160, 40 ) )		
			ti( tab, "(TEAM) " )		
		end	
		
		local strcol = white
		local customfound = false
		for k, v in next, ccolors do
			if string.StartWith( text, "`" .. v[ 1 ] .. "`" ) then
				local pos = string.find( text, "`" .. v[ 1 ] .. "`" ) + v[ 1 ]:len()
				text = string.sub( text, pos + 3 )
				strcol = v[ 2 ]
				customfound = true
			end
		end
		
		if customfound == false and string.StartWith( text, "`" ) then
			local exp = string.Explode( "`", text:sub( 2 ) )
			local str = exp[ 1 ]
			local str2 = string.Explode( " ", str )
			if #str2 == 3 then
				str2[ 4 ] = "255"
			end
			local col = string.ToColor( table.concat( str2, " " ) )
			strcol = col or color_white
			local pos = string.find( string.sub( text, 2 ), "`" )
			text = string.sub( text, pos + 3 )
		end
		
		if ply:GetNWString( "usergroup" ) == "user" then
			ti( tab, ply )
			ti( tab, white )
			ti( tab, ": " )
			ti( tab, strcol )
			ti( tab, text )
		else
			for k, v in next, groups do
				if ply:GetNWString( "usergroup" ) == v[ 1 ] then
					ti( tab, v[ 2 ] )
					ti( tab, "[" .. v[ 3 ] .. "] " )
					ti( tab, ply )
					ti( tab, white )
					ti( tab, ": " )
					ti( tab, strcol )
					ti( tab, text )
				end
			end
		end
		chat.AddText( unpack( tab ) )
		return true
	end
end*/

net.Receive( "SetMagician", function()
	local bool = net.ReadBool()
	local wep = net.ReadEntity()
	local num = net.ReadInt( 32 )
	local tbl = {}
	
	if bool and tbl[num] == nil then
		wep["ReloadSpeed"] = ( wep["ReloadSpeed"] * 1.5 )
		--wep["DelpoyTime"] = ( wep["DelpoyTime"] / 2 )
		tbl[num] = wep
	elseif !bool and tbl[num] == wep then
		savedwep["ReloadSpeed"] = ( savedwep["ReloadSpeed"] / 1.5 )
		--savedwep["DelpoyTime"] = ( savedwep["DelpoyTime"] * 2 )
	end
end)