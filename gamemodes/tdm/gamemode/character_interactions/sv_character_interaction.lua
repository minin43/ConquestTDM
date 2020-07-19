util.AddNetworkString( "SetInteractionGroup" )
util.AddNetworkString( "ResetInteractionGroup" )

GM.PlayedSounds = {} --//Since I use CSoundPatch for playing sounds, each sound per player has to be unique, so we need to set them all up here
GM.InteractionList = {} --//This table is used to store a player's voice series (hl2 rebebl, ins2 security, mw2 rangers, etc)
GM.ValidModels = { --//This table is used to check if a player's model is valid for the interaction voices, and which voice series it's from
    [ "models/player/group03/male_01.mdl" ] = "rebels",
	[ "models/player/group03/male_02.mdl" ] = "rebels",
	[ "models/player/group03/male_03.mdl" ] = "rebels",
	[ "models/player/group03/male_04.mdl" ] = "rebels",
    [ "models/player/group03/male_05.mdl" ] = "rebels",
    [ "models/player/group03/male_06.mdl" ] = "rebels",
	[ "models/player/group03/male_07.mdl" ] = "rebels",
	[ "models/player/group03/male_08.mdl" ] = "rebels",
	[ "models/player/group03/male_09.mdl" ] = "rebels",
    [ "models/player/combine_soldier.mdl" ] = "combine",
    [ "models/player/combine_soldier_prisonguard.mdl" ] = "combine",
    [ "models/player/combine_super_soldier.mdl" ] = "combine",
    [ "models/player/police.mdl" ] = "combine",
    [ "models/player/police_fem.mdl" ] = "combine",
    [ "models/player/ins_insurgent_heavy.mdl" ] = "insurgent",
    [ "models/player/ins_insurgent_light.mdl" ] = "insurgent",
    [ "models/player/ins_insurgent_standard.mdl" ] = "insurgent",
    [ "models/player/ins_security_heavy.mdl" ] = "security",
    [ "models/player/ins_security_light.mdl" ] = "security",
    [ "models/player/ins_security_standard.mdl" ] = "security",
    [ "models/mw2guy/rus/gassoldier.mdl" ] = "spetsnaz",
    [ "models/mw2guy/rus/soldier_a.mdl" ] = "spetsnaz",
    [ "models/mw2guy/rus/soldier_c.mdl" ] = "spetsnaz",
    [ "models/mw2guy/rus/soldier_d.mdl" ] = "spetsnaz",
    [ "models/mw2guy/rus/soldier_e.mdl" ] = "spetsnaz",
    [ "models/mw2guy/rus/soldier_f.mdl" ] = "spetsnaz",
    [ "models/cod players/opfor1.mdl" ] = "opfor",
    [ "models/cod players/opfor3.mdl" ] = "opfor",
    [ "models/cod players/opfor4.mdl" ] = "opfor",
    [ "models/cod players/opfor6.mdl" ] = "opfor",
    [ "models/codmw2/codmw2.mdl" ] = "rangers",
    [ "models/codmw2/codmw2h.mdl" ] = "rangers",
    [ "models/codmw2/codmw2he.mdl" ] = "rangers",
    [ "models/codmw2/codmw2m.mdl" ] = "rangers",
    [ "models/mw2guy/bz/bzgb01.mdl" ] = "tf141",
    [ "models/mw2guy/bz/bzghost.mdl" ] = "tf141",
    [ "models/mw2guy/bz/tfbz01.mdl" ] = "tf141",
    [ "models/mw2guy/bz/tfbz02.mdl" ] = "tf141",
    [ "models/mw2guy/bz/tfbz03.mdl" ] = "tf141",
    [ "models/mw2guy/bz/tfbzca01.mdl" ] = "tf141",
    [ "models/mw2guy/bz/tfbzca02.mdl" ] = "tf141",
    [ "models/mw2guy/bz/tfbzw01.mdl" ] = "tf141",
    [ "models/mw2guy/bz/tfbzw02.mdl" ] = "tf141"
    --[[,
    [ "" ] = "",
    [ "" ] = "",
    [ "" ] = "",
    [ "" ] = "",
    [ "" ] = ""]]
}
GM.AvailableTypes = { --Available types: "selfDeath, selfDamage, teamDeath, enemyDeath, selfReload, selfSpawn, selfGrenade, selfStep"
    --//HL2 sounds
    [ "rebels" ] = {
        [ "selfDeath" ] = 4,
        [ "selfDamage" ] = 8,
        [ "teamDeath" ] = false,
        [ "enemyDeath" ] = 4,
        [ "selfReload" ] = 3,
        [ "selfSpawn" ] = 4,
        [ "selfGrenade" ] = false,
        [ "selfStep" ] = false,
        [ "path" ] = "hl2/rebels/"
    },
    [ "combine" ] = {
        [ "selfDeath" ] = 4,
        [ "selfDamage" ] = 7,
        [ "teamDeath" ] = 7,
        [ "enemyDeath" ] = 11,
        [ "selfReload" ] = 3,
        [ "selfSpawn" ] = 7,
        [ "selfGrenade" ] = 1,
        [ "selfStep" ] = 12,
        [ "path" ] = "hl2/combine/"
    },
    --//Insurgency sounds
    [ "insurgent" ] = {
        [ "selfDeath" ] = 19,
        [ "selfDamage" ] = 21,
        [ "teamDeath" ] = false,
        [ "enemyDeath" ] = 10,
        [ "selfReload" ] = 28,
        [ "selfSpawn" ] = 15,
        [ "selfGrenade" ] = false,
        [ "selfStep" ] = false,
        [ "path" ] = "ins2/insurgent/"
    },
    [ "security" ] = {
        [ "selfDeath" ] = 19,
        [ "selfDamage" ] = 18,
        [ "teamDeath" ] = false,
        [ "enemyDeath" ] = 16,
        [ "selfReload" ] = 27,
        [ "selfSpawn" ] = 15,
        [ "selfGrenade" ] = false,
        [ "selfStep" ] = false,
        [ "path" ] = "ins2/security/"
    },
    --//MW2 Sounds
    [ "opfor" ] = {
        [ "selfDeath" ] = 5,
        [ "selfDamage" ] = 4,
        [ "teamDeath" ] = 4,
        [ "enemyDeath" ] = 10,
        [ "selfReload" ] = 6,
        [ "selfSpawn" ] = false,
        [ "selfGrenade" ] = 6,
        [ "selfStep" ] = false,
        [ "path" ] = "mw2/opfor/"
    },
    [ "spetsnaz" ] = {
        [ "selfDeath" ] = 3,
        [ "selfDamage" ] = 3,
        [ "teamDeath" ] = 4,
        [ "enemyDeath" ] = 10,
        [ "selfReload" ] = 6,
        [ "selfSpawn" ] = false,
        [ "selfGrenade" ] = 6,
        [ "selfStep" ] = false,
        [ "path" ] = "mw2/spetsnaz/"
    },
    --[[[ "milita" ] = { --Currently unsorted & w/out any model
        [ "selfDeath" ] = 4,
        [ "selfDamage" ] = 7,
        [ "teamDeath" ] = false,
        [ "enemyDeath" ] = 1,
        [ "selfReload" ] = 1,
        [ "selfSpawn" ] = 3,
        [ "selfGrenade" ] = false,
        [ "selfStep" ] = false,
        [ "path" ] = "hl2/rebels/"
    },]]
    [ "rangers" ] = {
        [ "selfDeath" ] = 5,
        [ "selfDamage" ] = 4,
        [ "teamDeath" ] = 3,
        [ "enemyDeath" ] = 10,
        [ "selfReload" ] = 6,
        [ "selfSpawn" ] = false,
        [ "selfGrenade" ] = 5,
        [ "selfStep" ] = false,
        [ "path" ] = "mw2/rangers/"
    },
    --[[[ "seals" ] = {
        [ "selfDeath" ] = 4,
        [ "selfDamage" ] = 3,
        [ "teamDeath" ] = 4,
        [ "enemyDeath" ] = 10,
        [ "selfReload" ] = 6,
        [ "selfSpawn" ] = false,
        [ "selfGrenade" ] = 3,
        [ "selfStep" ] = false,
        [ "path" ] = "mw2/seals/"
    },]]
    [ "tf141" ] = {
        [ "selfDeath" ] = 5,
        [ "selfDamage" ] = 4,
        [ "teamDeath" ] = 4,
        [ "enemyDeath" ] = 10,
        [ "selfReload" ] = 6,
        [ "selfSpawn" ] = false,
        [ "selfGrenade" ] = 6,
        [ "selfStep" ] = false,
        [ "path" ] = "mw2/tf141/"
    }
}

GM.CombineCallsigns = {
    "one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "zero",
    "interlock", "jury", "king", "roller", "union", "upi", "vice", "victor", "xray", "yellow"
}

--//Strictly for Combine deaths, plays some Overwatch radio chatter like the metropolice sometimes do
--//This is fucking messy.
--/Unused since the sounds don't like auto-playing, and since players aren't dead for long enough for the string to play 
function GM:DoPostDeathRadio( ply )
    if !self.PlayedSounds[ id( ply:SteamID() ) ][ "combine" ].DeathSounds then
        self.PlayedSounds[ id( ply:SteamID() ) ][ "combine" ].DeathSounds = {}
        self.PlayedSounds[ id( ply:SteamID() ) ][ "combine" ].DeathSounds.FirstIdent = self.CombineCallsigns[ math.random( #self.CombineCallsigns ) ]
        self.PlayedSounds[ id( ply:SteamID() ) ][ "combine" ].DeathSounds.SecondIdent = self.CombineCallsigns[ math.random( #self.CombineCallsigns ) ]
    end
    local filter = RecipientFilter()
    filter:AddAllPlayers()
    self.PlayedSounds[ id( ply:SteamID() ) ][ "combine" ].DeathSounds.TableToPlay = {
        [0] = CreateSound( ply, "hl2/combine/deathradio/on" .. math.random( 2 ) .. ".ogg", filter ),
        [1] = CreateSound( ply, "hl2/combine/deathradio/lostbiosignalforunit.ogg", filter ),
        [2] = CreateSound( ply, "hl2/combine/deathradio/" .. self.PlayedSounds[ id( ply:SteamID() ) ][ "combine" ].DeathSounds.FirstIdent .. ".ogg", filter ),
        [3] = CreateSound( ply, "hl2/combine/deathradio/" .. self.PlayedSounds[ id( ply:SteamID() ) ][ "combine" ].DeathSounds.SecondIdent .. ".ogg", filter ),
        [4] = CreateSound( ply, "hl2/combine/deathradio/_comma.ogg", filter ),
        [5] = CreateSound( ply, "hl2/combine/deathradio/allteamsrespond.ogg", filter ),
        [6] = CreateSound( ply, "hl2/combine/deathradio/off" .. math.random( 4 ) .. ".ogg", filter )
    }
    --PrintTable( self.PlayedSounds[ id( ply:SteamID() ) ][ "combine" ].DeathSounds.TableToPlay  )
    self.PlayedSounds[ id( ply:SteamID() ) ][ "combine" ].DeathSounds.TimerName = "DeathSounds" .. id( ply:SteamID() )
    self.PlayedSounds[ id( ply:SteamID() ) ][ "combine" ].DeathSounds.Current = self.PlayedSounds[ id( ply:SteamID() ) ][ "combine" ].DeathSounds.TableToPlay[1]
    self.PlayedSounds[ id( ply:SteamID() ) ][ "combine" ].DeathSounds.Current:SetSoundLevel( 40 )
    self.PlayedSounds[ id( ply:SteamID() ) ][ "combine" ].DeathSounds.Current:Play()
    self.PlayedSounds[ id( ply:SteamID() ) ][ "combine" ].DeathSounds.Counter = 1

    timer.Create( self.PlayedSounds[ id( ply:SteamID() ) ][ "combine" ].DeathSounds.TimerName, 0, 0, function()
        --print( "timer test", ply:IsValid(), self.PlayedSounds[ id( ply:SteamID() ) ][ "combine" ].DeathSounds.Current:IsPlaying() )
        if !ply:IsValid() then timer.Remove( self.PlayedSounds[ id( ply:SteamID() ) ][ "combine" ].DeathSounds.TimerName ) return end

        if !self.PlayedSounds[ id( ply:SteamID() ) ][ "combine" ].DeathSounds.Current:IsPlaying() then
            self.PlayedSounds[ id( ply:SteamID() ) ][ "combine" ].DeathSounds.Current = self.PlayedSounds[ id( ply:SteamID() ) ][ "combine" ].DeathSounds.TableToPlay[ self.PlayedSounds[ id( ply:SteamID() ) ][ "combine" ].DeathSounds.Counter + 1 ]
            if self.PlayedSounds[ id( ply:SteamID() ) ][ "combine" ].DeathSounds.Current then
                self.PlayedSounds[ id( ply:SteamID() ) ][ "combine" ].DeathSounds.Current:SetSoundLevel( 40 )
                self.PlayedSounds[ id( ply:SteamID() ) ][ "combine" ].DeathSounds.Current:Play()
            else
                timer.Remove( self.PlayedSounds[ id( ply:SteamID() ) ][ "combine" ].DeathSounds.TimerName ) return
            end
        end
    end )
end

--//We're assuming this function gets good values every time
function GM:DoPlayerSound( ply, sound )
    --//Since DoPlayerSounds is called in the PlayerDeath hook, where ply is still counted as alive, this should prevent any sounds from playing post-death
    if not ply:Alive() or hook.Call( "OnPlayerSound", self, ply, sound ) then return end

    local mandatoryPlays = { selfDamage = true, selfDeath = true, selfStep = true }
    --//Included randomness, better for the sounds to be used sparingly, but always allow damage & death sounds
    --//There will probably be double-ups with this timer, preventing sound playing when it otherwise would, but I'm okay with that
    if ( timer.Exists( id( ply:SteamID() ) .. "_VoiceTimer" ) or math.random( 3 ) != 1 ) and !mandatoryPlays[ sound ] then return end

    local series = self.InteractionList[ id( ply:SteamID() ) ] --//"seals", "insurgent", etc
    if !series then return end
    local path = self.AvailableTypes[ series ].path
    local numberOfSounds = self.AvailableTypes[ series ][ sound ] --//Gets the number of sounds we have to play, or is false if there's no sounds to play
    if !numberOfSounds then return end
    local randomNumberFromSounds = math.random( numberOfSounds ) --//A random number, between 1 and the number of sounds available

    self.PlayedSounds[ id( ply:SteamID() ) ] = self.PlayedSounds[ id( ply:SteamID() ) ] or {}
    self.PlayedSounds[ id( ply:SteamID() ) ][ series ] = self.PlayedSounds[ id( ply:SteamID() ) ][ series ] or {}

    local filter = RecipientFilter()
    filter:AddAllPlayers()
    self.PlayedSounds[ id( ply:SteamID() ) ][ series ][ randomNumberFromSounds ] = CreateSound( ply, path .. sound .. randomNumberFromSounds .. ".ogg", filter )

    if sound != "selfStep" then
        if self.PlayedSounds[ id( ply:SteamID() ) ].ActiveSound and self.PlayedSounds[ id( ply:SteamID() ) ].ActiveSound:IsPlaying() then
            self.PlayedSounds[ id( ply:SteamID() ) ].ActiveSound:Stop()
        end

        timer.Create( id( ply:SteamID() ) .. "_VoiceTimer", 5, 1, function() --[[preventing more calls]] end )
        self.PlayedSounds[ id( ply:SteamID() ) ][ series ][ randomNumberFromSounds ]:SetSoundLevel( 75 )
    else
        self.PlayedSounds[ id( ply:SteamID() ) ][ series ][ randomNumberFromSounds ]:SetSoundLevel( 30 )
    end

    self.PlayedSounds[ id( ply:SteamID() ) ][ series ][ randomNumberFromSounds ]:Play()
    self.PlayedSounds[ id( ply:SteamID() ) ].ActiveSound = self.PlayedSounds[ id( ply:SteamID() ) ][ series ][ randomNumberFromSounds ]

    --/Disabled since the sounds don't like auto-playing, and since players aren't dead for long enough for the string to play 
    --[[if series == "combine" and sound == "selfDeath" then
        timer.Simple( 1.5, function()
            self:DoPostDeathRadio( ply )
        end )
    end]]
end

hook.Add( "PlayerSpawn", "SetInteractionAvailability", function( ply )
    --//Setting server-side var for InteractionList is done in init.lua in hook PostGiveLoadout
    timer.Simple( 0.5, function()
        if ply:Team() != 1 and ply:Team() != 2 then return end
        timer.Simple( math.random(), function()
            GAMEMODE:DoPlayerSound( ply, "selfSpawn" )
        end )
    end )
end )

hook.Add( "DoPlayerDeath", "DoDeathSounds", function( ply, att, dmginfo )
    --//selfDeath
    if ply:IsValid() and ply:IsPlayer() and GAMEMODE.InteractionList[ id( ply:SteamID() ) ] then
        if ply:LastHitGroup() != HITGROUP_HEAD then --//Headshots mean no sound plays
            GAMEMODE:DoPlayerSound( ply, "selfDeath" )
        end
    end

    --//teamDeath
    local closestPlayer, closestDistance
    for k, v in pairs( team.GetPlayers( ply:Team() ) ) do
        if v != ply then
            if v:GetAimVector():Dot( ( ply:GetPos() - v:EyePos() ):GetNormalized() ) > 0 and v:Visible( ply ) then
                if !closestDistance or !closestPlayer then 
                    closestDistance = v:GetPos():Distance( ply:GetPos() )
                    closestPlayer = v
                else
                    if v:GetPos():Distance( ply:GetPos() ) < closestDistance then
                        closestDistance = v:GetPos():Distance( ply:GetPos() )
                        closestPlayer = v
                    end
                end
            end
        end
    end
    if closestPlayer then
        timer.Simple( math.random(), function()
            GAMEMODE:DoPlayerSound( closestPlayer, "teamDeath" )
        end )
    end

    --//enemyDeath
    if ply == att or att:IsWorld() or !att:IsPlayer() then return end
    if !timer.Exists( id( att:SteamID() ) .. "_KillTimer" ) then
        timer.Simple( math.random(), function()
            timer.Create( id( att:SteamID() ) .. "_KillTimer", 4, 1, function() --[[preventing more calls]] end )

            GAMEMODE:DoPlayerSound( att, "enemyDeath" )
        end )
    end
end )

--//selfDamage
hook.Add( "EntityTakeDamage", "DoSelfDamageSound", function( ent, dmginfo )
    if ent:IsValid() and ent:IsPlayer() and GAMEMODE.InteractionList[ id( ent:SteamID() ) ] then
        if timer.Exists( id( ent:SteamID() ) .. "_DamageTimer" ) or ( dmginfo:GetAttacker():IsPlayer() and ent:Team() == dmginfo:GetAttacker():Team() ) then return end

        GAMEMODE:DoPlayerSound( ent, "selfDamage" )
        timer.Create( id( ent:SteamID() ) .. "_DamageTimer", 3, 1, function() --[[preventing more calls]] end )
    end
end )

--//selfReload
hook.Add( "KeyPress", "DoSelfReloadSound", function( ply, key )
    if !ply:Alive() then return end

    local wep = ply:GetActiveWeapon()    
	if key == IN_RELOAD and wep.Clip1 and wep:Clip1() < wep:GetMaxClip1() then
		GAMEMODE:DoPlayerSound( ply, "selfReload" )
	end
end )

--//selfSpawn
--[[hook.Add( "PlayerSpawn", "DoSelfSpawnSound", function( ply )
    if ply:Team() != 1 or ply:Team() != 2 then return end
    timer.Simple( math.random(), function()
        GAMEMODE:DoPlayerSound( ply, "selfSpawn" )
    end )
end )]]

--//selfStep
hook.Add( "PlayerFootstep", "DoSelfStepSound", function( ply, pos, foot, sound, volume, rf )
    GAMEMODE:DoPlayerSound( ply, "selfStep" )
    return true
end )

--//selfGrenade
--Was originally going to utilize CW's own callback feature, but since it doesn't seem any of the callbacks provide user info, just have to overwrite instead
if CustomizableWeaponry then
    local pinPullAnims = {"pullpin", "pullpin2", "pullpin3", "pullpin4"}
    local SP = game.SinglePlayer()

    function CustomizableWeaponry.quickGrenade:throw()
        local CT = CurTime()
        
        self:setGlobalDelay(1.9)
        self:SetNextPrimaryFire(CT + 1.9)
        
        if SERVER and SP then
            SendUserMessage("CW20_THROWGRENADE", self.Owner)
        end
        
        self.dt.State = CW_ACTION
        
        if (not SP and IsFirstTimePredicted()) or SP then
            if self:filterPrediction() then
                self:EmitSound("CW_HOLSTER")
            end
            
            CustomizableWeaponry.callbacks.processCategory(self, "beginThrowGrenade")
            
            if CLIENT then
                CustomizableWeaponry.actionSequence.new(self, 0.45, nil, function()
                    self.GrenadePos.z = -10
                    self.grenadeTime = CurTime() + 1.5
                    self:playAnim(table.Random(pinPullAnims), 1, 0, self.CW_GREN)
                end)
                
                CustomizableWeaponry.actionSequence.new(self, 0.5, nil, function()
                    surface.PlaySound("weapons/pinpull.wav")
                end)
                
                CustomizableWeaponry.actionSequence.new(self, 1.1, nil, function()
                    self:playAnim("throw", 1.1, 0, self.CW_GREN)
                end)
            end
            
            if SERVER then
                CustomizableWeaponry.actionSequence.new(self, 0.3, nil, function()
                    self.canDropGrenade = true
                end)
            
                CustomizableWeaponry.actionSequence.new(self, 0.5, nil, function()
                    self.liveGrenade = true
                end)
            
                CustomizableWeaponry.actionSequence.new(self, 1.15, nil, function()
                    local nade = CustomizableWeaponry.quickGrenade:createThrownGrenade(self.Owner)
                    CustomizableWeaponry.quickGrenade:applyThrowVelocity(self.Owner, nade, throwVelocity, addVelocity)
                    
                    self.liveGrenade = false
                    self.canDropGrenade = false
                    self.Owner:RemoveAmmo(1, "Frag Grenades")
                    
                    CustomizableWeaponry.callbacks.processCategory(self, "finishThrowGrenade")

                    GAMEMODE:DoPlayerSound( self.Owner, "selfGrenade" ) --My only inclusion
                end)
            end
            
            CustomizableWeaponry.actionSequence.new(self, 1.8, nil, function()
                local delay = CustomizableWeaponry.quickGrenade.postGrenadeWeaponDelay
                self:SetNextPrimaryFire(CT + delay)
                self:SetNextSecondaryFire(CT + delay)
            end)
        end
    end
end