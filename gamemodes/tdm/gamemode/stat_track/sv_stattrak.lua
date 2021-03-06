util.AddNetworkString( "UpdateStatTrak" )
util.AddNetworkString( "SendInitialStatTrak" )
util.AddNetworkString( "GetCurrentAttachments" )
util.AddNetworkString( "GetCurrentAttachmentsCallback" )

GM.PyroChecks = { }

st = {}

st.attachments = {}

if ( CustomizableWeaponry.registeredAttachments ) then
	for k, v in ipairs( CustomizableWeaponry.registeredAttachments ) do
		table.insert( st.attachments, v.name )
	end
end

wep_att = { }

specialAttachmentRules = { } --This didn't work like I wanted it to, so we'll just do these manually when necessary

--//The AR-15, UMP .45, and M3 Super 90 get special attachment scaling as a way to more quickly introduce attachments to new players, the guns are also cheaper

wep_att[ "cw_ar15" ] = {
	{ "bg_foldsight", 0 },
	{ "md_microt1", 5 },
	{ "md_saker", 10 },
	{ "bg_magpulhandguard", 15 },
	{ "md_foregrip", 20 },
	{ "bg_ar1560rndmag", 30 },
	{ "bg_ar15sturdystock", 40 },
	{ "md_eotech", 50 },
	{ "bg_longbarrel", 60 },
	{ "bg_ar15heavystock", 70 },
	{ "md_aimpoint", 80 },
	{ "bg_ris", 90 },
	{ "md_anpeq15", 100 },
	{ "md_schmidt_shortdot", 110 },
	{ "bg_longris", 120 },
	{ "md_m203", 130 },
	{ "md_acog", 140 },
	{ "am_magnum", 160 },
	{ "am_matchgrade", 180 }
}

wep_att[ "cw_ump45" ] = {
	{ "md_microt1", 5 },
	{ "md_saker", 10 },
	{ "md_anpeq15", 15 },
	{ "md_eotech", 20 },
	{ "md_aimpoint", 30 },
	{ "md_schmidt_shortdot", 40 },
	{ "md_acog", 50 },
	{ "am_magnum", 70 },
	{ "am_matchgrade", 90 }
}

wep_att[ "cw_super90" ] = {
	{ "md_microt1", 5 },
	{ "md_eotech", 10 },
	{ "md_aimpoint", 15 },
	{ "md_acog", 20 },
	{ "am_slugrounds", 40 },
	{ "am_flechetterounds", 60 }
}

wep_att[ "cw_m14" ] = {
	{ "md_nightforce_nxs", 0 },
	{ "md_microt1", 10 },
	{ "md_saker", 20 },
	{ "md_anpeq15", 30 },
	{ "md_eotech", 40 },
	{ "md_aimpoint", 50 },
	{ "md_schmidt_shortdot", 60 },
	{ "md_acog", 70 },
	{ "am_magnum", 80 },
	{ "am_matchgrade", 90 }
}

wep_att[ "cw_vss" ] = {
	{ "md_kobra", 10 },
	{ "bg_asval_20rnd", 20 },
	{ "bg_asval", 30 },
	{ "bg_vss_foldable_stock", 40 },
	{ "md_eotech", 50 },
	{ "bg_asval_30rnd", 60 },
	{ "bg_sr3m", 70 },
	{ "md_pbs1", 80 },
	{ "md_foregrip", 90 },
	{ "md_aimpoint", 100 },
	{ "md_schmidt_shortdot", 110 },
	{ "md_pso1", 120 },
	{ "am_magnum", 130 },
	{ "am_matchgrade", 140 }
}

wep_att[ "cw_b196" ] = {
	{ "md_csgo_556", 0 },
	{ "md_microt1", 10 },
	{ "md_saker", 20 },
	{ "md_bipod", 30 },
	{ "md_anpeq15", 40 },
	{ "md_aimpoint", 50 },
	{ "md_csgo_silencer_ballistic", 60 },
	{ "md_elcan", 70 },
	{ "md_csgo_silencer_rifle", 80 },
	{ "md_acog_fixed", 90 },
	{ "md_uecw_csgo_scope_ssg", 100 },
	{ "am_magnum", 110 },
	{ "am_matchgrade", 120 }
}

wep_att[ "cw_tac338" ] = {
    { "md_nightforce_nxs", 0 },
	{ "md_rmr", 10 },
	{ "md_saker", 20 },
	{ "bg_tac338_short_barrel", 30 },
	{ "md_anpeq15", 40 },
	{ "md_bipod", 50 },
    { "md_microt1", 60 },
    { "bg_snip_tac338_8_mag", 70 },
    { "bg_snip_tac338_rest_cheeks_up", 80 },
	{ "md_improved_bolt", 90 },
	{ "md_aimpoint", 100 },
	{ "md_snip2_light_suppressor", 110 },
	{ "bg_snip2_special_bipod", 120 },
	{ "md_eotech", 130 },
	{ "md_heavy_muzzle_brake", 140 },
	{ "md_schmidt_shortdot", 150 },
	{ "md_acog", 160 },
	{ "am_magnum", 170 },
	{ "am_matchgrade", 180 }
}

wep_att[ "cw_wf_m200" ] = {
    { "md_nightforce_nxs", 0 },
	{ "md_rmr", 10 },
	{ "md_saker", 20 },
	{ "bg_cheytac_short_barrel", 30 },
	{ "bg_Cheytac_Bipod", 40 },
	{ "bg_snip_Cheytac_no_stock", 50 },
	{ "md_microt1", 60 },
	{ "md_aimpoint", 70 },
	{ "md_eotech", 80 },
	{ "md_schmidt_shortdot", 90 },
	{ "md_acog", 100 },
	{ "am_magnum", 110 },
	{ "am_matchgrade", 120 }
}

wep_att[ "cw_weapon_rfb" ] = {
    { "md_nightforce_nxs", 0 },
    { "bg_rfb_special_rail", 0 },
	{ "md_rmr", 10 },
    { "md_saker", 20 },
    { "bg_rfb_long_barrel", 30 },
    { "md_anpeq15", 40 },
    { "md_bipod", 50 },
    { "md_microt1", 60 },
    { "bg_rfb_short_barrel", 70 },
    { "md_aimpoint", 80 },
    { "md_eotech", 90 },
    { "md_schmidt_shortdot", 100 },
    { "md_acog", 110 },
}

wep_att[ "bo2r_svu" ] = {
    { "bo2_acog_sniper", 10 },
    { "md_tundra9mm", 20 },
    { "bo2_fmj", 30 }
}

wep_att[ "bo2r_m27" ] = {
    { "bo2_reddot", 10 },
	{ "md_tundra9mm", 20 },
	{ "bo2_mms", 30 },
	{ "bo2_grip", 40 },
	{ "bo2_eotech", 50 },
	{ "bo2_acog", 60 },
	{ "bo2_fmj", 70 }
}

wep_att[ "bo2r_peacekeeper" ] = {
    { "bo2_reddot", 10 },
	{ "md_tundra9mm", 20 },
	{ "bo2_mms", 30 },
	{ "bo2_grip_peace", 40 },
	{ "bo2_eotech", 50 },
	{ "bo2_fmj", 60 }
}

wep_att[ "bo2r_870mcs" ] = {
    { "bo2_reddot", 10 },
    { "md_tundra9mm", 20 },
    { "bo2_mms", 30 }
}

wep_att[ "bo2r_hamr" ] = {
	{ "bo2_reddot", 10 },
	{ "md_tundra9mm", 20 },
	{ "bo2_mms", 30 },
	{ "bo2_grip", 40 },
	{ "bo2_eotech", 50 },
	{ "bo2_acog", 60 },
	{ "bo2_fmj", 70 }
}

wep_att[ "bo2r_mp7" ] = {
    { "bo2_reddot", 10 },
	{ "md_tundra9mm", 20 },
	{ "bo2_mms", 30 },
	{ "bo2_grip", 40 },
	{ "bo2_eotech", 50 },
	{ "bo2_fmj", 60 }
}

wep_att[ "bo2r_b23r" ] = {
    { "md_tundra9mm", 10 },
    { "bo2_fmj", 20 }
}

wep_att[ "cw_kk_hk416" ] = {
    { "bg_hk416_foldsight", 0 },
	{ "md_fas2_eotech", 10 },
	{ "md_saker", 20 },
	{ "bg_hk416_longbarrel", 30 },
	{ "md_fas2_holo", 40 },
	{ "md_foregrip", 50 },
	{ "bg_hk416_34rndmag", 60 },
	{ "md_cod4_aimpoint_v2", 70 },
	{ "bg_hk416_heavystock", 80 },
	{ "md_anpeq15", 90 },
	{ "md_cod4_acog_v2", 100 },
	{ "md_backup_reflex", 110 },
    { "bg_hk416_silencer", 120 },
    { "md_hk416_bipod", 130 },
	{ "md_fas2_leupold", 140 },
	{ "bg_hk416_cmag", 150 },
	{ "bg_hk416_nostock", 160 },
	{ "md_magnifier_scope", 170 },
	{ "md_m203", 180 },
	{ "am_magnum", 190 },
	{ "am_matchgrade", 200 }
}

wep_att[ "cw_killdrix_acre" ] = {
	{ "md_microt1", 10 },
	{ "md_saker", 20 },
	{ "md_eotech", 30 },
	{ "md_anpeq15", 40 },
	{ "md_aimpoint", 50 },
	{ "am_magnum", 60 },
	{ "am_matchgrade", 70 }
}

wep_att[ "cw_contender" ] = {
    { "bg_g2caccu", 0 },
	{ "md_microt1", 10 },
	{ "md_saker", 20 },
	{ "md_eotech", 30 },
    { "md_aimpoint", 50 },
    { "md_acog", 60 },
	{ "am_magnum", 70 },
	{ "am_matchgrade", 80 }
}

--//Constructs a list of attachments for each CW2.0 gun, whether it's used or not. A lot less time consuming than manually adding each attachment to a table with a kill value
function GM:ConstructAttachmentLists()
    if hook.Call( "PreConstructAttachmentLists", self, wep_att ) then return end

	print( "[CTDM] Auto-constructing attachment hierarchies..." )
	
	for k, v in pairs( weapons.GetList() ) do
		if v.Base == "cw_base" and !wep_att[ v.ClassName ] then --If cw2.0 weapon and not pre-done
			if v.Attachments and #v.Attachments > 0 then --if it has attachments (looking at you, L115)
				wep_att[ v.ClassName ] = {}

				local fixedAttachmentTable = v.Attachments
				--[[if specialAttachmentRules[ v.ClassName ] then --if the gun has an attachment we need to treat differently (free, perma-locked, or has a unique kill requirement )
					for attachmentName, _uniqueStatus in pairs( specialAttachmentRules[ v.ClassName ] ) do --for each attachment
						for attachmentTypeTableKey, attachmentTypeTable in pairs( v.Attachments ) do --find it in the atts table, ran through v.Attachments to change fixedAttTable
							for attachmentLocation, actualAttachment in pairs( attachmentTypeTable.atts ) do
								if attachmentName == actualAttachment then
									table.remove( fixedAttachmentTable[ attachmentTypeTableKey ].atts, attachmentLocation )
								end
							end
						end
					end
				end]]

				local maxAtt = 1
				for k2, v2 in ipairs( fixedAttachmentTable ) do
					if #v2.atts > maxAtt then maxAtt = #v2.atts end
				end

				for counter = 1, maxAtt, 1 do
					for k2, v2 in ipairs( fixedAttachmentTable ) do
						if v2.atts[ counter ] then
							wep_att[ v.ClassName ][ #wep_att[ v.ClassName ] + 1 ] = { v2.atts[ counter ], #wep_att[ v.ClassName ] * 10 + 10 }
						end
					end
				end

				if fixedAttachmentTable[ "+reload" ] then
					for k2, v2 in pairs( fixedAttachmentTable[ "+reload" ].atts ) do
						wep_att[ v.ClassName ][ #wep_att[ v.ClassName ] + 1 ] = { v2, #wep_att[ v.ClassName ] * 10 + 10 }
					end
				end

				--[[if specialAttachmentRules[ v.ClassName ] then
					for attachmentName, uniqueStatus in pairs( specialAttachmentRules[ v.ClassName ] ) do
						if uniqueStatus == 0 then
							table.insert( wep_att[ v.ClassName ], 1, { attachmentName, 0 } )							
						elseif uniqueStatus > 0 then
							wep_att[ v.ClassName ][ #wep_att[ v.ClassName ] + 1 ] = { attachmentName, uniqueStatus }
						elseif uniqueStatus < 0 then 
							wep_att[ v.ClassName ][ #wep_att[ v.ClassName ] + 1 ] = { attachmentName, math.abs(uniqueStatus) + ( #wep_att[ v.ClassName ] * 10 + 10 ) }
						end
					end
				end]]
				
			end
		end
	end
end

ConstructAttachmentLists = GM.ConstructAttachmentLists
hook.Add( "PostWeaponBalancing", "ConstructAttachmentLists", function()
    ConstructAttachmentLists()

    hook.Run( "PostAttachmentConstruction" )
end )

function GetStatTrak( ply, wep )
	if not ply:GetPData( wep ) then
		return 0
	end
	
	return tonumber( ply:GetPData( wep ) )
end

function UpdateAttKillTracking( ply, wepclass )
	if !ply or !wepclass then return end
	if not ply:GetPData( wepclass ) then
		ply:SetPData( wepclass, 1 )
	else
		local num = ply:GetPData( wepclass )
		ply:SetPData( wepclass, num + 1 )
	end
	
	net.Start( "UpdateStatTrak" )
		net.WriteString( wepclass )
		net.WriteString( tostring( ply:GetPData( wepclass ) ) )
	net.Send( ply )
		
	local totalKills = GetStatTrak( ply, wepclass )
	local togive = {}
	
	for k, v in pairs( GAMEMODE.WeaponsList ) do
		if wepclass == v[ 2 ] then
			local masteryamount = GAMEMODE.MasteryRequirements[ v.type ] or 1000
			if totalKills == masteryamount then
				hook.Run( "WeaponMasteryAchieved", ply, wepclass )
				return
			end
		end
	end

	--//If we have a new attachment to give the player
	if wep_att[ wepclass ] then
		for k, v in pairs( wep_att[ wepclass ] ) do
			if totalKills == v[ 2 ] then
				togive[ #togive + 1 ] = v[ 1 ]
				--//If it's the final attachment to unlock
				if k == #wep_att[ wepclass ] then
					hook.Run( "AllAttachmentsUnlocked", ply, wepclass )
				end
			end
		end
	end

	--[[for k, v in pairs( wep_att ) do
		if k == wepclass then
			for k2, v2 in pairs( v ) do
				--//If this kill has reached a new attachment unlock...
				if totalKills == v2[ 2 ] then
					togive[ #togive + 1 ] = v2[ 1 ]
				end
			end
		end
	end]]

	if next(togive) ~= nil then 
		CustomizableWeaponry.giveAttachments( ply, togive ) 
		local green = Color( 102, 255, 51 )
		local white = Color( 255, 255, 255 )
		ply:ChatPrintColor( white, "You have unlocked a new attachment for reaching ", green, ply:GetPData( wepclass ), white, " kills with the ", white, RetrieveWeaponName( wepclass ), "!" )
	end
end

hook.Add( "DoPlayerDeath", "ST_PlayerDeath", function( ply, att, dmginfo )
	print( att, "killed", ply, "with", dmginfo:GetInflictor() )
	if ply and ply:IsValid() and att and att:IsValid() and att:IsPlayer() and att ~= ply then

		local wepclass = dmginfo:GetInflictor():GetClass()
		if dmginfo:IsBulletDamage() then
			local wep = att:GetActiveWeapon() or dmginfo:GetInflictor()
			if !wep then return end
			wepclass = wep:GetClass()
		elseif dmginfo:IsExplosionDamage() then
			if dmginfo:GetInflictor():GetClass() == "cw_grenade_thrown" then
				wepclass = "cw_frag_grenade"
			elseif dmginfo:GetInflictor():GetClass() == "cw_40mm_explosive" then
				wepclass = att:GetActiveWeapon():GetClass()
			end
		elseif dmginfo:GetInflictor():GetClass() == "weapon_fists" then
			wepclass = dmginfo:GetInflictor():GetClass()
		elseif dmginfo:IsDamageType( DMG_BURN ) then --Necessary for Pyromancer perk
			GAMEMODE.PyroChecks[ id( ply ) ]:GetActiveWeapon():GetClass()
		elseif dmginfo:GetInflictor() == "env_explosion" or dmginfo:GetInflictor():GetClass() == "env_explosion" then --For Pyromancer Perk
			wepclass = att:GetActiveWeapon():GetClass()
		end

		--GAMEMODE:UpdateVendetta( ply, att )

		net.Start( "GetCurrentAttachments" )
		net.Send( ply )

		--What's the point to this? st seems like an extremely redundant table
		if st[ att ] then
			for k, v in next, st[ att ] do
				if wep == v:GetClass() then
					cantrack = true
				end
			end
		end
	
		UpdateAttKillTracking( att, wepclass )
	else
		net.Start( "GetCurrentAttachments" )
		net.Send( ply )
	end
end )

hook.Add( "PlayerSpawn", "ST_PlayerSpawn", function( ply )
	timer.Simple( 0.5, function()
        if !ply:IsValid() then return end
		local weps = ply:GetWeapons()
		st[ ply ] = weps
		
		local tab = {}
		
		for k, v in next, weps do
			local x = v:GetClass()
			
			if ply:GetPData( x ) then
				table.insert( tab, { x, ply:GetPData( x ) } )
			else
				table.insert( tab, { x, 0 } )
			end
		end

		net.Start( "SendInitialStatTrak" )
			net.WriteTable( tab )
			net.WriteTable( wep_att )
		net.Send( ply )
		
		local togive = {}
		
		for k, v in pairs( weps ) do
			local num = GetStatTrak( ply, v:GetClass() )
			
			for q, w in next, wep_att do
				if q == v:GetClass() then
					for a, s in next, w do
						if num >= s[ 2 ] then
							table.insert( togive, s[ 1 ] )
						end
					end
				end
			end
		end
		CustomizableWeaponry.giveAttachments( ply, togive, true )
	end )
end )

hook.Add( "Think", "UpdateSTWeps", function()
	for k, v in next, player.GetAll() do
		if st[ v ] ~= v:GetWeapons() then
			st[ v ] = v:GetWeapons()
		end
	end
end )

net.Receive( "GetCurrentAttachmentsCallback", function( len, ply )
	local tabel = net.ReadTable()
	GAMEMODE.SavedAttachmentLists[ id( ply:SteamID() ) ] = GAMEMODE.SavedAttachmentLists[ id( ply:SteamID() ) ] or { }
	for wepClass, attTable in pairs( tabel ) do
		GAMEMODE.SavedAttachmentLists[ id( ply:SteamID() ) ][ wepClass ] = attTable
	end
end )