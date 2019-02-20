GM.Name = "Team Deathmatch"
GM.Author = "Cobalt"
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
	--[[resource.AddWorkshop( "627716476" ) --AMR CTDM Pack 1
	resource.AddWorkshop( "627718636" ) --AMR CTDM Pack 2
	resource.AddWorkshop( "627720669" ) --AMR CTDM Pack 3
	resource.AddWorkshop( "627723217" ) --AMR CTDM Pack 4
	resource.AddWorkshop( "621821594" ) --AMR CTDM Pack 5
	resource.AddWorkshop( "621796838" ) --AMR CTDM Cam's Shit
	resource.AddWorkshop( "616256862" ) --AMR Galil-Chan
	resource.AddWorkshop( "617144172" ) --AMR P.F.D.C HAMR
	resource.AddWorkshop( "400665331" ) --Rage's cw2.0 attachment pack
	resource.AddWorkshop( "579360189" ) --UnluckyWolf's cw2.0 attachment pack
	resource.AddWorkshop( "606458021" ) --Cam's M16
	resource.AddWorkshop( "317267606" ) --cardboard box
	resource.AddWorkshop( "180842642" ) --stargate medkit & adrenaline
	resource.AddWorkshop( "105463332" ) --spraymon
	resource.AddWorkshop( "112806637" ) --gmod legs
  	resource.AddWorkshop( "247181062" ) --old snake
	resource.AddWorkshop( "319094282" ) --Neptune
	resource.AddWorkshop( "366438805" ) --Husky
	resource.AddWorkshop( "549723093" ) --Flash, Reverse Flash, and Zoom
	resource.AddWorkshop( "616973356" ) --Deathclaw
	resource.AddWorkshop( "413438609" ) --Batman
	resource.AddWorkshop( "216408135" ) --GTA V Crew
	resource.AddWorkshop( "616470108" ) --Nathan Drake
	resource.AddWorkshop( "316178708" ) --Bear
	resource.AddWorkshop( "465761506" ) --Ruby
	resource.AddWorkshop( "527188346" ) --Weiss
	resource.AddWorkshop( "503472222" ) --Blake
	resource.AddWorkshop( "515139583" ) --Yang
	resource.AddWorkshop( "440189569" ) --DeadPool
	resource.AddWorkshop( "169817394" ) --DeadPool/required
	resource.AddWorkshop( "351508041" ) --Snipar]]
end

function GM:Initialize()
	self.BaseClass.Initialize( self )
end

local _PLY = FindMetaTable( "Player" )
function _PLY:Score()
	return self:GetNWInt( "tdm_score" )
end
