GM.Name = "Team Deathmatch"
GM.Author = "Cobalt"
GM.Email = "N/A"
GM.Website = "N/A"

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
	
end

function GM:Initialize()
	self.BaseClass.Initialize( self )
end

local _PLY = FindMetaTable( "Player" )
function _PLY:Score()
	return self:GetNWInt( "tdm_score" )
end