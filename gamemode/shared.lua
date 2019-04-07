GM.Name = "Conquest Team Deathmatch"
GM.Author = "Cobalt, Whuppo, Logan"
GM.Email = "lobsterlogan43@yahoo.com"
GM.Website = "N/A"
GM.Version = "Conquest Team Deathmatch V. 1.4.7"

--hardcoded colors. once fully implemented we could change from red v. blue to any two colors.


team.SetUp( 0, "Spectators", Color( 0, 0, 0 ) )
team.SetUp( 1, "Red", Color( 255, 0, 0 ) )
team.SetUp( 2, "Blue", Color( 0, 0, 255 ) )
team.SetUp( 3, "deathSelf", Color( 158, 253, 56 ) ) --colors defined here will be deprecated soon

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

function alterColorRGB( col, rDelta, gDelta, bDelta, aDelta ) --takes a Color as input, and returns it altered by the specified RGB amount. improves code readability without sacrificing constant colors
	return Color(math.Clamp(col.r + rDelta, 0, 255),
				 math.Clamp(col.g + gDelta, 0, 255),
				 math.Clamp(col.b + bDelta, 0, 255),
				 math.Clamp(col.a + aDelta, 0, 255))
end

function alterColorHSV( col, hDelta, sDelta, vDelta, aDelta ) --takes a Color as input, and returns it altered by the given HSV values. can be a lot more useful than simple RGB alterations for making decent procedural color changes
	--warning, colors returned by this function will fail IsColor checks!
	--this can be fixed if needed but it probably doesn't matter
	local h,s,v = ColorToHSV(col)
	return HSVToColor((h + hDelta) % 360,
					 math.Clamp(s, 0, 1),
					 math.Clamp(v, 0, 1))
end

function id( steamid )
	return string.gsub( steamid, ":", "x" )
end