--//Y'know, after some inspection, I'm not sure what this code does, or why I have it included...

local ply = FindMetaTable( "Player" )

local teams = {}

teams[0] = { name = "Spectators", color = Vector( 0, 0, 0 ) }
teams[1] = { name = "Red", color = Vector( 1.0, .2, .2 ) }
teams[2] = { name = "Blue", color = Vector( .2, .2, 1.0 ) }

function ply:SetGamemodeTeam( n )
	if not teams[n] then return end
	
	self:SetTeam( n )
	
	self:SetPlayerColor( teams[n].color )
	
	return true
end