--//Much of this structured copied from Zaratusa's TTT SLAM weapon, profile: http://steamcommunity.com/profiles/76561198032479768
--//Generally like doing things on my own, but I'm pretty clueless when it comes to SWEP-making
--[[SWEP.Contact = "https://www.steamcommunity.com/profiles/LoganChristianson"

SWEP.Primary.Ammo = "none"
SWEP.Primary.Delay = 1.25
SWEP.Primary.Automatic = false
SWEP.Primary.ClipSize = 1
SWEP.Primary.DefaultClip = 1
SWEP.FiresUnderwater = false

SWEP.HoldType = "slam"
SWEP.ViewModel = Model( "models/weapons/v_slam.mdl" )
SWEP.WorldModel	= Model( "models/weapons/w_slam.mdl" )

if CLIENT then
    SWEP.PrintName = "S.L.A.M. Tripwire Mine"
    SWEP.Slot = 2
    SWEP.ViewModelFlip = false
    SWEP.ViewModelFOV = 64
end

--//The 3 states the weapon may be in (used mostly for animation control, since these SLAMs only work as tripmines)
local IDLE, SATCHEL, TRIPMINE = 0, 1, 2

function SWEP:Initialize()
	self.State = IDLE
	self:SetHoldType( self.HoldType )
end

function SWEP:CanAttachSLAM()
	if IsValid( self ) then
		local owner = self.Owner

		if IsValid( owner ) then
			local ignore = { owner, self.Weapon }
			local startpos = owner:GetShootPos()
			local endpos = spos + owner:GetAimVector() * 42
			local trace = util.TraceLine( {start = startpos, endpos = endpos, filter = ignore, mask = MASK_SOLID } )

			result = trace.HitWorld
		end
	end

	return ( result or false )
end

function SWEP:CheckAnimation()
    if IsValid( self.Owner ) and self.Owner:GetActiveWeapon() == self.Weapon then
        --//If we can attach a SLAM to the wall
		if self:CanAttachSLAM() then
            if self.State != TRIPMINE then
				self.Weapon:SendWeaponAnim( ACT_SLAM_TRIPMINE_DRAW )
				self.State = TRIPMINE
			end
		elseif self.Weapon:Clip1() > 0 then
			if (self.State == TRIPMINE) then
				self.Weapon:SendWeaponAnim( ACT_SLAM_STICKWALL_TO_THROW_ND )
			elseif (self.State == IDLE) then
				self.Weapon:SendWeaponAnim( ACT_SLAM_THROW_ND_DRAW )
			end
			self.State = SATCHEL
		else
			self.Weapon:SendWeaponAnim( ACT_SLAM_DETONATOR_DRAW )
		end
	end
end

function SWEP:AnimateAttack( animation1, animation2, sound )
	self.Weapon:SendWeaponAnim( animation1 )
	local holdup = self.Owner:GetViewModel():SequenceDuration()

	timer.Simple( holdup * 0.6, function()
		if IsValid( self ) then
			self:EmitSound( sound )
		end
	end )
	timer.Simple( holdup, function()
		if IsValid( self ) then
			self.Weapon:SendWeaponAnim( animation2 )
		end
	end )
	timer.Simple( holdup + 0.1, function()
		if IsValid( self ) then
			self:TakePrimaryAmmo( 1 )
			self:Deploy()
		end
	end)
end

function SWEP:PrimaryAttack()
	if CLIENT then return end

    local owner = self.Owner
	if self:CanPrimaryAttack() and self:GetNextPrimaryFire() <= CurTime() and IsValid( owner ) and self.State == TRIPMINE then
		self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
        local ignore = { owner, self.Weapon }
		local startpos = owner:GetShootPos()
		local endpos = startpos + owner:GetAimVector() * 42

		local trace = util.TraceLine( { start = startpos, endpos = endpos, filter = ignore, mask = MASK_SOLID } )
		if trace.HitWorld then
			local mine = ents.Create( "" ) --//To create
			if IsValid( mine ) then
				local traceEnt = util.TraceEntity( { start = startpos, endpos = endpos, filter = ignore, mask = MASK_SOLID }, mine )
				if traceEnt.HitWorld then
					self:AnimateAttack( ACT_SLAM_TRIPMINE_ATTACH, ACT_SLAM_TRIPMINE_ATTACH2, "weapons/slam/mine_mode.wav" )

					local ang = traceEnt.HitNormal:Angle()
					ang.p = ang.p + 90

					mine:SetPos( traceEnt.HitPos + ( traceEnt.HitNormal * 3 ) )
					mine:SetAngles( ang )
					mine:SetPlacer( owner )
					mine:Spawn()
				end
			end
		end
		owner:SetAnimation( PLAYER_ATTACK1 )
	end
end

function SWEP:Deploy()
	if self.Weapon:Clip1() == 0 then
		self:Remove()
	else
		self.State = IDLE
		self:CheckAnimation()
	end
	return true
end

function SWEP:Reload()
end

function SecondaryAttack()
end

if SERVER then
    function SWEP:Think()
        self:CheckAnimation()

        self:NextThink(CurTime() + 0.25)
        return true
    end
end

if CLIENT then
    function SWEP:OnRemove()
        --Run some function that draws last held weapon
    end
end