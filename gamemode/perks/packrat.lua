local dontgive = {
	"fas2_ammobox",
	"fast2_ifak",
	"fas2_m67",
	"seal6-claymore"
}

hook.Add( "PlayerSpawn", "Packrat", function( ply )
	timer.Simple( 1.5, function()
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
end )

RegisterPerk( "Packrat", "packrat", 17, "Spawn with 3 times as much ammo as usual." )