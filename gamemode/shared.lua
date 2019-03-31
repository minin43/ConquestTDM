GM.Name = "Conquest Team Deathmatch"
GM.Author = "Cobalt, Whuppo, Logan"
GM.Email = "lobsterlogan43@yahoo.com"
GM.Website = "N/A"
GM.Version = "Conquest Team Deathmatch V. 1.4.7"

team.SetUp( 0, "Spectators", Color( 0, 0, 0 ) )
team.SetUp( 1, "Red", Color( 255, 0, 0 ) )
team.SetUp( 2, "Blue", Color( 0, 0, 255 ) )
team.SetUp( 3, "deathSelf", Color( 158, 253, 56 ) )

if SERVER then
    
	resource.AddWorkshop( "349050451" ) --CW2.0 Base
	resource.AddWorkshop( "358608166" ) --CW2.0 Extra Weapons
	resource.AddWorkshop( "1386774614" ) --CTDM Files
	resource.AddWorkshop( "805601312" ) --INS2 Ambient Noises
	resource.AddWorkshop( "512986704" ) --Knife Kitty's Hitmarker
	resource.AddWorkshop( "1698026320" ) --The 6 new guns
	resource.AddWorkshop( "934839887" ) --The L96
	resource.AddWorkshop( "526188110" ) --Scorpion EVO
	--resource.AddWorkshop( "595631935" ) --BER's Kings of Austria pack (AUG and Scout)
	--resource.AddWorkshop( "438373352" ) --BER's SMG pack (also includes base shit needed for his other addons)
	
end

function GM:Initialize()
	self.BaseClass.Initialize( self )
end

local _PLY = FindMetaTable( "Player" )

function _PLY:Score()
	return self:GetNWInt( "tdm_score" )
end

-- http://lua-users.org/wiki/FormattingNumbers
function comma_value( amount )
	local formatted = amount
	while true do  
		formatted, k = string.gsub( formatted, "^(-?%d+)(%d%d%d)", '%1,%2' )
		if ( k == 0 ) then
			break
		end
	end
	return formatted
end