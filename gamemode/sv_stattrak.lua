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

wep_att[ "cw_ar15" ] = {
	{ "bg_foldsight", 0 },
	{ "md_microt1", 10 },
	{ "md_saker", 20 },
	{ "bg_magpulhandguard", 30 },
	{ "md_foregrip", 40 },
	{ "bg_ar1560rndmag", 50 },
	{ "bg_ar15sturdystock", 60 },
	{ "md_eotech", 70 },
	{ "bg_longbarrel", 80 },
	{ "bg_ar15heavystock", 90 },
	{ "md_aimpoint", 100 },
	{ "bg_ris", 110 },
	{ "md_anpeq15", 120 },
	{ "md_schmidt_shortdot", 130 },
	{ "bg_longris", 140 },
	{ "md_m203", 150 },
	{ "md_acog", 160 },
	{ "am_magnum", 170 },
	{ "am_matchgrade", 180 }
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
	{ "bg_bl96_paint1", 0 },
	{ "bg_bl96_paint2", 0 },
	{ "bg_bl96_paint3", 0 },
	{ "bg_bl96_paint4", 0 },
	{ "bg_bl96_paint5", 0 },
	{ "bg_bl96_paint6", 0 },
	{ "bg_bl96_paint7", 0 },
	{ "bg_bl96_paint8", 0 },
	{ "bg_bl96_paint9", 0 },
	{ "bg_bl96_paint10", 0 },
	{ "bg_bl96_paint11", 0 },
	{ "bg_bl96_paint12", 0 },
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

--//Constructs a list of attachments for each CW2.0 gun, whether it's used or not. A lot less time consuming than manually adding each attachment to a table with a kill value
function ConstructAttachmentLists()
	print( "(Re)constructing attachment lists..." )
	
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
hook.Add( "InitPostEntity", "ST_ConstructAttachmentLists", ConstructAttachmentLists )

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
		
	local num = GetStatTrak( ply, wepclass )
	local togive = {}
	
	--for k, v in pairs( wep_att ) do
	for q, w in next, wep_att do
		if q == wepclass then
			for a, s in next, w do
				if num == s[ 2 ] then
					table.insert( togive, s[ 1 ] )
				end
			end
		end
	end
	if next(togive) ~= nil then CustomizableWeaponry.giveAttachments( ply, togive ) end
end

hook.Add( "DoPlayerDeath", "ST_PlayerDeath", function( ply, att, dmginfo )
	print( ply, att, dmginfo:GetInflictor() )
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
        if ply == nil then return end
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