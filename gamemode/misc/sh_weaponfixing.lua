hook.Add( "InitPostEntity", "FixWeapons", function()
    print( "[CTDM] Overwriting any necessary weapon and weapon base functions...")

    local wepbase = weapons.GetStored( "cw_base" )
    function wepbase:unloadWeapon()
        return
    end

    --Fixes the error when spectating someone first-person and they open their attachments
    function CustomizableWeaponry:hasAttachment(ply, att, lookIn)
        if not self.useAttachmentPossessionSystem then
            return true
        end
        
        lookIn = lookIn or ply.CWAttachments
        
        local has = hook.Call("CW20HasAttachment", nil, ply, att, lookIn)
        
        if (lookIn and lookIn[att]) or has then
            return true
        end
        
        return false
    end

    if weapons.Get( "sg_adrenaline" ) then
        local wep = weapons.GetStored( "sg_adrenaline" )
        local function SG_IsActive(self)
            local ply = self.Owner
            if not IsValid(self) then return false end
            if not ply or not IsValid(ply) then return false end
            if not IsValid(ply:GetActiveWeapon()) then return false end
            if ply:GetActiveWeapon() != self then return false end
            return true
        end
        function wep:PrimaryAttack()
            --if CLIENT then return end

            local ply = self.Owner
            self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
            self:SetNextPrimaryFire(CurTime()+3.4)
            self.CanHolster = false
        
            timer.Simple(1.6, function()
                if CLIENT then return end
                if not SG_IsActive(self) then return end

                ply.IsAdrenalized = true
                ply:SetHealth( math.min(ply:Health() + 20, ply:GetMaxHealth() ) )
                ply:AlterFOV( 20, 30, 0.5 )
                ply:SetWalkSpeed( ply:GetWalkSpeed() + 30 )
                ply:SetRunSpeed( ply:GetRunSpeed() + 30 )
                ply:SetJumpPower( ply:GetJumpPower() + 20 )
                if GAMEMODE.ChilledPlayers and GAMEMODE.ChilledPlayers[ ply ] then
                    GAMEMODE.MovementBackups[ id( ply:SteamID() ) ].walk = GAMEMODE.MovementBackups[ id( ply:SteamID() ) ].walk + 30
                    GAMEMODE.MovementBackups[ id( ply:SteamID() ) ].run = GAMEMODE.MovementBackups[ id( ply:SteamID() ) ].run + 30
                    GAMEMODE.MovementBackups[ id( ply:SteamID() ) ].jump = GAMEMODE.MovementBackups[ id( ply:SteamID() ) ].jump + 20
                end

                timer.Create( id(ply:SteamID()) .. "adrenaltimer", 30, 1, function()
                    if ply.IsAdrenalized then
                        ply:SetFOV( 0, 1.5 )
                        ply:SetWalkSpeed( ply:GetWalkSpeed() - 30 )
                        ply:SetRunSpeed( ply:GetRunSpeed() - 30 )
                        ply:SetJumpPower( ply:GetJumpPower() - 20 )

                        if GAMEMODE.ChilledPlayers and GAMEMODE.ChilledPlayers[ ply ] then
                            GAMEMODE.MovementBackups[ id( ply:SteamID() ) ].walk = GAMEMODE.MovementBackups[ id( ply:SteamID() ) ].walk - 30
                            GAMEMODE.MovementBackups[ id( ply:SteamID() ) ].run = GAMEMODE.MovementBackups[ id( ply:SteamID() ) ].run - 30
                            GAMEMODE.MovementBackups[ id( ply:SteamID() ) ].jump = GAMEMODE.MovementBackups[ id( ply:SteamID() ) ].jump - 20
                        end
                    end
                end )
            end)
        
            timer.Simple(0.6, function()
                if not SG_IsActive(self) then return end
                if SERVER then
                    self:EmitSound("weapons/ak47/ak47_clipout.wav", 40, 170)
                end
            end)
        
            timer.Simple(1.5, function()
                if not SG_IsActive(self) then return end
                if SERVER then
                    self:EmitSound("weapons/slam/mine_mode.wav", 100, 100)
                end
            end)
        
            timer.Simple(ply:GetViewModel():SequenceDuration(), function()
                if not SG_IsActive(self) then return end
                ply:ConCommand("lastinv")
                if SERVER then 
                    ply:StripWeapon(self:GetClass())
                end
            end)
        end

        if SERVER then
            hook.Add( "PlayerDeath", "FixAdrenalProperties", function( ply, dmginfo )
                if ply.IsAdrenalized then
                    timer.Remove( id(ply:SteamID()) .. "adrenaltimer" )
                    ply:SetFOV( 0, 0 )
                    if GAMEMODE.ChilledPlayers and GAMEMODE.ChilledPlayers[ ply ] then
                        GAMEMODE.MovementBackups[ id( ply:SteamID() ) ].walk = GAMEMODE.MovementBackups[ id( ply:SteamID() ) ].walk - 30
                        GAMEMODE.MovementBackups[ id( ply:SteamID() ) ].run = GAMEMODE.MovementBackups[ id( ply:SteamID() ) ].run - 30
                        GAMEMODE.MovementBackups[ id( ply:SteamID() ) ].jump = GAMEMODE.MovementBackups[ id( ply:SteamID() ) ].jump - 20
                    end
                    ply.IsAdrenalized = false
                end
            end )
        end
    end

    if weapons.Get( "weapon_cbox" ) then
        local wep = weapons.GetStored( "weapon_cbox" )

        function wep:Initialize()
            self:SetWeaponHoldType( "normal" )
            self:DrawShadow( false )
            
            if SERVER then
                if GetConVarNumber( "cbox_stealth" ) == 2 then
                    self:SetStealth( true )
                end
            end

            self:SetRenderMode( RENDERMODE_TRANSCOLOR )
            --self.Owner:SetRenderMode( RENDERMODE_TRANSCOLOR )
        end

        function wep:IsHiding()
            return self:GetStealth() and self:IsUnderBox() and self.LerpMul < 0.1 --and PlayerIsntMoving( self.Owner )    --PlayerIsntMoving function can be found in entrench.lua
        end

        function wep:DrawWorldModel()
            if not IsValid( self.Owner ) then self:DrawModel() return end
            if not self:IsUnderBox() and self.LerpMul > 0.8 then return end
        
            local pos = self.Owner:GetPos()
            local ang = Angle( 0, self.Owner:EyeAngles().y, 0 )
            
            pos = pos + ( ang:Forward() * 10 )
            
            local bone_pos, bone_ang = self.Owner:GetBonePosition( self.Owner:LookupBone( "ValveBiped.Bip01_Spine1" ) )
            
            bone_pos = bone_pos + ( ang:Forward() * 10 )
            bone_pos.z = bone_pos.z - 15
            
            bone_ang:RotateAroundAxis( bone_ang:Forward(), 90 )
            bone_ang:RotateAroundAxis( bone_ang:Right(), -40 )
            bone_ang.y = ang.y -- box will spin around really fast in certain angles unless we make it the same in both
            
            if self:IsUnderBox() then
                local vel = self.Owner:GetVelocity():Length2D()
                local mul = math.Clamp( vel / 40, 0, 1 )
                self.LerpMul = Lerp( FrameTime() * 10, self.LerpMul, mul )
            else
                self.LerpMul = Lerp( FrameTime() * 10, self.LerpMul, 1 )
            end
            
            self:SetRenderOrigin( pos * ( 1 - self.LerpMul ) + bone_pos * self.LerpMul )
            self:SetRenderAngles( ang * ( 1 - self.LerpMul ) + bone_ang * self.LerpMul )
            self:SetModelScale( 1.2, 0 )
            
            self:DrawModel()
            self:SetColor( 255, 255, 255, 255 )
            if self:IsHiding() then
                self:SetColor( 255, 255, 255, 100 )
            end
        end
    end

    if weapons.Get( "impulse_grenade" ) then
        local wep = weapons.GetStored( "impulse_grenade" )
        wep.WorldModel = "models/impulse_grenade/impulse_grenade.mdl"
        --wep.ExplosionRadius = 192
        wep.Primary.ClipSize = 2
        wep.Primary.DefaultClip	= 2

        function wep:PrimaryAttack()
            if self:Clip1() <= 0 then return end

            self.Weapon:SetNextPrimaryFire( CurTime() + 1.0 )
            self.Weapon:SetNextSecondaryFire( CurTime() + 1.0 )
            self:ThrowGrenade( "models/impulse_grenade/impulse_grenade.mdl" )
            self:TakePrimaryAmmo( 1 )
        end
        
        function wep:SecondaryAttack()
            if self:Clip1() <= 0 then return end

            self.Weapon:SetNextPrimaryFire( CurTime() + 1.0 )
            self.Weapon:SetNextSecondaryFire( CurTime() + 1.0 )
            self:ThrowGrenade( "models/impulse_grenade/impulse_grenade.mdl", true )
            self:TakePrimaryAmmo( 1 )
        end

        local ShootSound = Sound( "Metal.SawbladeStick" )
        function wep:ThrowGrenade( model_file, alt )
            self:EmitSound( ShootSound )
            if ( CLIENT ) then return end
        
            local ent = ents.Create( "prop_physics" )
            if ( !IsValid( ent ) ) then return end
        
            ent:SetModel( model_file )
            ent:SetPos( self.Owner:EyePos() + ( self.Owner:GetAimVector() * 16 ) )
            ent:SetAngles( self.Owner:EyeAngles() )
            ent:Spawn()
            --ent:PhysicsInit(SOLID_VPHYSICS)
            --ent:SetMoveType(MOVETYPE_VPHYSICS)
            --ent:SetSolid(SOLID_VPHYSICS)
            ent:SetCollisionGroup(COLLISION_GROUP_WEAPON)
        
            local phys = ent:GetPhysicsObject()
            if ( !IsValid( phys ) ) then ent:Remove() return end
        
            if CustomizableWeaponry and !alt then
                CustomizableWeaponry.quickGrenade:applyThrowVelocity(self.Owner, ent, 800, Vector(0, 0, 150))
            else
                local velocity = self.Owner:GetAimVector()
                velocity = velocity * 10000
                velocity = velocity + ( VectorRand() * 100 ) 
                phys:ApplyForceCenter( velocity )
            end
        
            explodeGrenade(ent, self.Owner)
        end

        function explodeGrenade(ent, player) 
            timer.Simple(2,function()
                local explode = ents.Create( "env_explosion" ) 
                explode:SetPos( ent:GetPos() ) 
                explode:SetOwner(player)
                explode:SetKeyValue( "iMagnitude", 0 )
                explode:SetKeyValue( "iRadiusOverride", 256 )
                explode:SetKeyValue( "spawnflags", 2 + 16 )
                explode:Spawn()
                explode:Fire( "Explode", "", 0 )	
                explode:EmitSound( "weapon_AWP.Single", 400, 400 )
                for k, v in pairs( ents.FindInSphere(ent:GetPos(), 192) ) do
                    if v:IsPlayer() and (v:Team() != player:Team() or v == player) then
                          v:SetVelocity(v:GetUp() * 400 + Vector(0,0,100))
                    end
                end
                ent:Remove()
            end)
        end
        
    end

    if weapons.Get( "weapon_hexshield" ) then
        local wep = weapons.GetStored( "weapon_hexshield" )

        function wep:Event_Throw()
            if ( self:OutOfAmmo() ) then
    
                self:On_OutOfAmmo()
                self.Owner:StripWeapon( self:GetClass() )
                return
            end
    
            if ( CurTime() < self.ThrowTime ) then return end
    
            self:Throw()
            self.Owner:RemoveAmmo( 1, self:GetPrimaryAmmoType() )
            self.Owner:DrawWorldModel( false )
            self.Owner:StripWeapon( self:GetClass() )
    
            self.Events[ 1 ] = self.Event_Draw
        end
    end
    --This is written so goddamn poorly
    --[[if weapons.Get( "cwc_fate" ) then
        local wep = weapons.GetStored( "cwc_fate" )

        function wep:IndividualThink()
            self.ForegripOverride = true
                
            if self.FireMode == "cqc" then
                if self.Owner:KeyPressed(IN_ATTACK) then
                    self.MuzzleEffect = "muzzleflash_pistol_deagle"
                else
                    self.MuzzleEffect = "muzzleflash_smg"	
                end
                self.Damage = 24
                self.Recoil = 0.76
                self.HipSpread = 0.045
                self.AimSpread = 0.025
                self.VelocitySensitivity = 1.2
                self.MaxSpreadInc = 0.03
                self.SpreadPerShot = 0.003
                self.Shots = 1
                self.Primary.ClipSize = 35
                self.Primary.DefaultClip = self.Primary.ClipSize
                self.SpreadCooldown = 0.13
                self.SpeedDec = 50

                self.ZoomAmount = 15
                self.AimViewModelFOV = 60
                self.ForegripParent = "cqc"
                self.CrosshairParts = {left = true, right = true, upper = true, lower = true}
                self.Trivia = {text = "Currently in SMG mode, change fire modes to swap between SMG mode and AR mode.", x = -900, y = -600}
            elseif self.FireMode == "ranged" then
                self.MuzzleEffect = "muzzleflash_ak74"
                self.Damage = 30
                self.Recoil = 1.05
                self.HipSpread = 0.12
                self.AimSpread = 0.01
                self.VelocitySensitivity = 1.8
                self.MaxSpreadInc = 0.05
                self.SpreadPerShot = 0.001
                self.Shots = 1
                self.Primary.ClipSize = 35
                self.Primary.DefaultClip = self.Primary.ClipSize
                self.SpreadCooldown = 0.16
                self.SpeedDec = 50

                self.ZoomAmount = 50
                self.AimViewModelFOV = 75
                self.ForegripParent = "ranged"
                self.CrosshairParts = {left = true, right = true, upper = false, lower = false}
                self.Trivia = {text = "Currently in AR mode, change fire modes to swap between SMG mode and AR mode.", x = -900, y = -600}
            end

            if self.FireMode == "ranged" then
                self.Animations = {fire1 = {"shoot1_unsil"},
                fire1_aim = {"shoot_unsil_aim"},
                changetosmg = "detach_silencer",
                changetorifle = "add_silencer",
                reload = "reload_unsil",
                idle = "idle_unsil",
                draw = "draw_unsil"}
            elseif self.FireMode == "cqc" then
                self.Animations = {fire1 = {"shoot_aim"},
                fire1_aim = {"shoot_aim"},
                changetosmg = "detach_silencer",
                changetorifle = "add_silencer",
                reload = "reload",
                idle = "idle",
                draw = "draw"}
            end
        
        
            if self.FireMode == "ranged" then 
                if self.Owner:KeyPressed(IN_ATTACK) then
                    self.FireSound = "CWC_FATE_FIRE_START"
                else
                    self.FireSound = "CWC_FATE_FIRE"
                end
            else
                if self.Owner:KeyPressed(IN_ATTACK) then
                    self.FireSound = "CWC_FATE_FIRE_CQC_START"
                else
                    self.FireSound = "CWC_FATE_FIRE_CQC"
                end
            end
        
            if self:isAiming() then
                if self.FireMode == "cqc" then 
                    --self.Recoil = 0.7
                    self.LuaVMRecoilAxisMod = {vert = 0, hor = 0.1, roll = 0, forward = -.5, pitch = 0.2}
        
                else
                    --self.Recoil = 0.4
                    self.LuaVMRecoilAxisMod = {vert = 0, hor = 0.1, roll = 0.0, forward = -1, pitch = 0.5}
        
                end		
            else
                if self.FireMode == "cqc" then 
                    --self.Recoil = 0.5
                    self.LuaVMRecoilAxisMod = {vert = 0, hor = 0.5, roll = 0, forward = -0.3, pitch = -0.2}
                else
                    --self.Recoil = 1
                    self.LuaVMRecoilAxisMod = {vert = 0, hor = 0.5, roll = 0, forward = 1.0, pitch = -0.2}
                end
            end
        end

        function wep:CycleFiremodes()
            t = self.FireModes
            
            if not t.last then
                t.last = 2
            else
                if not t[t.last + 1] then
                    t.last = 1
                else
                    t.last = t.last + 1
                end
            end
            
            if self.dt.State == CW_AIMING or self:isBipodDeployed() then
                if self.FireModes[t.last] == "safe" then
                    t.last = 1
                end
            end
            
            if self.FireMode != self.FireModes[t.last] and self.FireModes[t.last] then
                CT = CurTime()
                
                if IsFirstTimePredicted() then
                    self:SelectFiremode(self.FireModes[t.last])
                end
                
                self:SetNextPrimaryFire(CT + 1.2)
                self:SetNextSecondaryFire(CT + 1.2)
                self.ReloadWait = CT + 1.2
            end
            
            if self.FireMode == "ranged" then
                self.ForegripParent = "ranged"
            
                clip = self:Clip1()
                cycle = 0.0
                rate = 1.8
                anim = ""
                prefix = ""
                suffix = ""
                if (SP and SERVER) or (not SP and CLIENT and IFTP) then
                    self:sendWeaponAnim(prefix .. "changetorifle" .. suffix, rate, cycle)
                else
                    self:sendWeaponAnim(prefix .. "changetosmg" .. suffix, rate, cycle)
                end
                self.FireDelay = 0.092
            elseif self.FireMode == "cqc" then
                self.ForegripParent = "cqc"
                
                clip = self:Clip1()
                cycle = 0.0
                rate = 1.8
                anim = ""
                prefix = ""
                suffix = ""
                if (SP and SERVER) or (not SP and CLIENT and IFTP) then
                    self:sendWeaponAnim(prefix .. "changetosmg" .. suffix, rate, cycle)
                else
                    self:sendWeaponAnim(prefix .. "changetorifle" .. suffix, rate, cycle)
                end
                self.FireDelay = 0.07
            end
        end
    end]]

end )

--FOV altering necessary for the adrenaline shot changes
if SERVER then
    GM.ActiveFOVChanges = {}
    local PlayerClass = FindMetaTable( "Player" )

    util.AddNetworkString( "AlterFOV" )
    function PlayerClass:AlterFOV( amount, duration, rate )
        self:SetFOV( self:GetFOV() + amount, rate or 1.0 )
        net.Start( "AlterFOV" )
            net.WriteInt( amount, 8 )
        net.Send( self )

        GAMEMODE.ActiveFOVChanges[ self ] = amount

        timer.Create( id(self:SteamID()) .. "FovAlter", duration or 30, 1, function()
            self:SetFOV( 0, rate or 1.0 )
            net.Start( "AlterFOV" )
                net.WriteInt( -amount, 8 )
            net.Send( self )
            GAMEMODE.ActiveFOVChanges[ self ] = nil
        end )
    end

    hook.Add( "WeaponEquip", "AlterFOVNewGun", function( wep, ply )
        if GAMEMODE.ActiveFOVChanges[ ply ] then
            net.Start( "AlterFOV" )
                net.WriteInt( GAMEMODE.ActiveFOVChanges[ ply ], 8 )
            net.Send( ply )
        end
    end )

    hook.Add( "PlayerDeath", "ResetFOV", function( ply, wep, att )
        if timer.Exists( id(ply:SteamID()) .. "FovAlter" ) then
            ply:SetFOV( 0, 0 )
            timer.Remove( id(ply:SteamID()) .. "FovAlter" )
            net.Start( "AlterFOV" )
                net.WriteInt( 0, 8 )
            net.Send( ply )
            GAMEMODE.ActiveFOVChanges[ ply ] = nil
        end
    end )
else
    net.Receive( "AlterFOV", function()
        local amount = net.ReadInt( 8 )
        if amount == 0 then GAMEMODE.WeaponsAlteredFOV = {} return end
        
        GAMEMODE.WeaponsAlteredFOV = GAMEMODE.WeaponsAlteredFOV or {}
        for k, v in pairs( LocalPlayer():GetWeapons() ) do
            if !GAMEMODE.WeaponsAlteredFOV[ v ] then
                GAMEMODE.WeaponsAlteredFOV[ v ] = true
                v.ViewModelFOV = v.ViewModelFOV + amount
                if v.Base == "cw_base" then
                    v.ViewModelFOV_Orig = v.ViewModelFOV_Orig + amount
                    v.AimViewModelFOV = v.AimViewModelFOV + amount
                    v.AimViewModelFOV_Orig = v.AimViewModelFOV_Orig + amount
                end
            elseif amount < 0 then
                GAMEMODE.WeaponsAlteredFOV[ v ] = false
                v.ViewModelFOV = v.ViewModelFOV + amount
                if v.Base == "cw_base" then
                    v.ViewModelFOV_Orig = v.ViewModelFOV_Orig + amount
                    v.AimViewModelFOV = v.AimViewModelFOV + amount
                    v.AimViewModelFOV_Orig = v.AimViewModelFOV_Orig + amount
                end
            end
        end
    end )
end