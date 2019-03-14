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

wep_att = {}

--Set the number to 0 to give for free, a specific number for custom killcount, a negative number for custom killcount but adds the previous highest killcount requirement
--(so -50 would be 120 + 50, whereas 170 would just be 170), or nil to remove the attachment from being unlockable - done in order of appearance in this table
--so add the negative values (kill requirements adding on the previous) first and the 0's and absolutes after
-- [ "cw_ar15" ] = { [ "bg_foldsight" ] = -20, [ "md_microt1" ] = -30 }, [ "md_saker" ] = 200 }		-	 as an example
specialAttachmentRules = { --This didn't work like I wanted it to, so we'll just do these manually when necessary
	--[ "cw_ar15" ] = { [ "bg_foldsight" ] = 0 },
	--[ "cw_m14" ] = { [ "md_nightforce_nxs" ] = 0 }
}

--[[wep_att[ "cw_ar15" ] = {
SWEP.Attachments = {[1] = {header = "Sight", offset = {800, -500}, atts = {"bg_foldsight", "md_microt1", "md_eotech", "md_aimpoint", "md_schmidt_shortdot", "md_acog"}},
	[2] = {header = "Barrel", offset = {300, -500}, atts = {"md_saker"}},
	[3] = {header = "Receiver", offset = {-400, -500}, atts = {"bg_magpulhandguard", "bg_longbarrel", "bg_ris", "bg_longris"}},
	[4] = {header = "Handguard", offset = {-400, 0}, atts = {"md_foregrip", "md_m203"}},
	[5] = {header = "Magazine", offset = {-400, 400}, atts = {"bg_ar1560rndmag"}},
	[6] = {header = "Stock", offset = {1000, 400}, atts = {"bg_ar15sturdystock", "bg_ar15heavystock"}},
	[7] = {header = "Rail", offset = {250, 400}, atts = {"md_anpeq15"}, dependencies = {bg_ris = true, bg_longris = true}},
	["+reload"] = {header = "Ammo", offset = {800, 0}, atts = {"am_magnum", "am_matchgrade"}}}
}

wep_att[ "cw_m14" ] = {
SWEP.Attachments = {[1] = {header = "Sight", offset = {800, -300},  atts = {"md_microt1", "md_eotech", "md_aimpoint", "md_schmidt_shortdot", "md_acog", "md_nightforce_nxs"}},
	[2] = {header = "Barrel", offset = {-450, -300},  atts = {"md_saker"}},
	[3] = {header = "Rail", offset = {800, 100}, atts = {"md_anpeq15"}, dependencies = {md_microt1 = true, md_eotech = true, md_aimpoint = true, md_schmidt_shortdot = true, md_acog = true, md_nightforce_nxs = true}},
	["+reload"] = {header = "Ammo", offset = {-450, 100}, atts = {"am_magnum", "am_matchgrade"}}}
}

wep_att[ "cw_vss" ] = {
SWEP.Attachments = {[1] = {header = "Sight", offset = {800, -450},  atts = {"md_kobra", "md_eotech", "md_aimpoint", "md_schmidt_shortdot", "md_pso1"}},
	[2] = {header = "Magazine", offset = {0, 350},  atts = {"bg_asval_20rnd", "bg_asval_30rnd"}},
	[3] = {header = "Variant", offset = {0, -450},  atts = {"bg_asval", "bg_sr3m"}},
	[4] = {header = "Stock", offset = {1400, -50}, atts = {"bg_vss_foldable_stock"}},
	[5] = {header = "Barrel", offset = {0, -50}, atts = {"md_pbs1"}, dependencies = {bg_sr3m = true}},
	[6] = {header = "Front", offset = {800, -50}, atts = {"md_foregrip"}, dependencies = {bg_sr3m = true}},
	["+reload"] = {header = "Ammo", offset = {1400, 350}, atts = {"am_magnum", "am_matchgrade"}}}
}]]

--//Constructs a list of attachments for each CW2.0 gun, whether it's used or not. A lot less time consuming than manually adding each attachment to a table with a kill value
function ConstructAttachmentLists()
	print( "(Re)constructing attachment lists..." )
	
	for k, v in pairs( weapons.GetList() ) do
		if v.Base == "cw_base" and !wep_att[ v.ClassName ] then --If cw2.0 weapon and not pre-done
			if v.Attachments and #v.Attachments > 0 then --if it has attachments (looking at you, L115)
				wep_att[ v.ClassName ] = {}

				local fixedAttachmentTable = v.Attachments
				if specialAttachmentRules[ v.ClassName ] then --if the gun has an attachment we need to treat differently (free, perma-locked, or has a unique kill requirement )
					for attachmentName, _uniqueStatus in pairs( specialAttachmentRules[ v.ClassName ] ) do --for each attachment
						for attachmentTypeTableKey, attachmentTypeTable in pairs( v.Attachments ) do --find it in the atts table, ran through v.Attachments to change fixedAttTable
							for attachmentLocation, actualAttachment in pairs( attachmentTypeTable.atts ) do
								if attachmentName == actualAttachment then
									table.remove( fixedAttachmentTable[ attachmentTypeTableKey ].atts, attachmentLocation )
								end
							end
						end
					end
				end

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

				if specialAttachmentRules[ v.ClassName ] then
					for attachmentName, uniqueStatus in pairs( specialAttachmentRules[ v.ClassName ] ) do
						if uniqueStatus == 0 then
							table.insert( wep_att[ v.ClassName ], 1, { attachmentName, 0 } )							
						elseif uniqueStatus > 0 then
							wep_att[ v.ClassName ][ #wep_att[ v.ClassName ] + 1 ] = { attachmentName, uniqueStatus }
						elseif uniqueStatus < 0 then 
							wep_att[ v.ClassName ][ #wep_att[ v.ClassName ] + 1 ] = { attachmentName, math.abs(uniqueStatus) + ( #wep_att[ v.ClassName ] * 10 + 10 ) }
						end
					end
				end
				
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

		GAMEMODE:UpdateVendetta( ply, att )

		print("Sending client GetCurrentAttachments", ply )
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
	
		if not att:GetPData( wepclass ) then
			att:SetPData( wepclass, 1 )
		else
			local num = att:GetPData( wepclass )
			att:SetPData( wepclass, num + 1 )
		end
		
		net.Start( "UpdateStatTrak" )
			net.WriteString( wepclass )
			net.WriteString( tostring( att:GetPData( wepclass ) ) )
		net.Send( att )
			
		local num = GetStatTrak( att, wepclass )
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
		if next(togive) ~= nil then CustomizableWeaponry.giveAttachments( att, togive ) end
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