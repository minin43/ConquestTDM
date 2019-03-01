util.AddNetworkString( "FixReloadSpeeds" )
util.AddNetworkString( "UnFixReloadSpeeds" )
local dontgive = {
	"fas2_ammobox",
	"fast2_ifak",
	"fas2_m67",
	"seal6-claymore"
}

hook.Add( "PostGiveLoadout", "Packrat", function( ply )
	if CheckPerk( ply ) == "packrat" then
		for k, v in next, ply:GetWeapons() do
			local x = v:GetPrimaryAmmoType()
			local y = v:Clip1()
			local give = true
			
			for k2, v2 in next, dontgive do
				if v2 == v then
					give = false
					break
				end
			end
			if give == true then
				ply:GiveAmmo( ( y * 10 ), x, true )
			end
		end
		ply:GiveAmmo( 4, "40MM", true )
	end
end )

--//This is messy, but I don't see a way to make it not be - Client net message found in cl_init
--[[hook.Add( "WeaponEquip", "ReloadCheck", function( wep, ply )
	if CheckPerk( ply ) == "packrat" then --If the player has packrat
		if wep.Base == "cw_base" then --If the weapon we've picked up is a CW2.0 weapon
			if wep.Shots == 1 then --If it's not a shotgun
				if wep.ReloadSpeed == weapons.GetStored( wep:GetClass() ).ReloadSpeed then --If the value hasn't been edited yet
					wep.ReloadSpeed = wep.ReloadSpeed * 1.2 --Edit the value

					net.Start( "FixReloadSpeeds" ) --Tell the client to update these values
						net.WriteString( wep:GetClass() )
					net.Send( ply )
				end
			else --Is the weapon is a shotgun
				if wep.InsertShellTime == weapons.GetStored( wep:GetClass() ).InsertShellTime then --If the value hasn't been edited yet
					wep.InsertShellTime = wep.InsertShellTime * 0.8 --Edit the value
					wep.ReloadStartTime = wep.ReloadStartTime * 0.8

					net.Start( "FixReloadSpeeds" ) --Tell the client to update these values
						net.WriteString( wep:GetClass() )
					net.Send( ply )
				end
			end
		end
	else --If the player doesn't have packrat, we need to make sure they don't get the packrat reload bonus
		if wep.ReloadSpeed != weapons.GetStored( wep:GetClass() ).ReloadSpeed then
			wep.ReloadSpeed = weapons.GetStored( wep:GetClass() ).ReloadSpeed
		end
		if wep.Shots != 1 and wep.InsertShellTime != weapons.GetStored( wep:GetClass() ).InsertShellTime then
			wep.InsertShellTime = weapons.GetStored( wep:GetClass() ).InsertShellTime
			wep.ReloadStartTime = weapons.GetStored( wep:GetClass() ).ReloadStartTime
		end
	end
end )

hook.Add( "PlayerDeath", "UnFixAmmo", function( vic, ent, att )
	if CheckPerk( vic ) == "packrat" then
		net.Start( "UnFixReloadSpeeds" )
		net.Send( vic )
	end
end )]]

RegisterPerk( "Packrat", "packrat", 0, "Spawn with 3 times as much ammo as usual." )