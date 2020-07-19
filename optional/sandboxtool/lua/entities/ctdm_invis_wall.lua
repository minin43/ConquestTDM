AddCSLuaFile( )

ENT.Type = "anim"
 
ENT.PrintName		= "ctdm_invis_wall"
ENT.Author			= "Logan/Zet0r"
ENT.Contact			= "conquesttdm@gmail.com"
ENT.Purpose			= "Invisible Wall that spawns in CTDM servers"


function ENT:SetupDataTables()
	self:NetworkVar("Vector", 0, "MaxBound")
end

function ENT:Initialize()
	self:DrawShadow( false )
	self:SetRenderMode( RENDERMODE_TRANSCOLOR )
	if self.SetRenderBounds then
        --self:SetRenderBounds(Vector(0,0,0), self:GetMaxBound()) --This is relative to the ent origin
        self:SetRenderBoundsWS(self:GetPos(), self:GetMaxBound())
	end
	self:SetCustomCollisionCheck(true)
end

local mat = Material("color")
local white = Color(255,150,0,30)

if CLIENT then
	function ENT:Draw()
		--if ConVarExists("nz_creative_preview") and !GetConVar("nz_creative_preview"):GetBool() and nzRound:InState( ROUND_CREATE ) then
			cam.Start3D()
				render.SetMaterial(mat)
				render.DrawBox(self:GetPos(), self:GetAngles(), Vector(0,0,0), self:GetMaxBound() - self:GetPos(), white, true)
			cam.End3D()
		--end
	end
end

hook.Add("PhysgunPickup", "nzInvisWallNotPickup", function(ply, wall)
	if wall:GetClass() == "ctdm_invis_wall" then return false end
end)

print("ctdm_invis_wall debug")