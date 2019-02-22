util.AddNetworkString( "UpdateStatTrak" )
util.AddNetworkString( "SendInitialStatTrak" )

--[[st = {}

st.attachments = {}

if ( CustomizableWeaponry.registeredAttachments ) then
	for k, v in ipairs( CustomizableWeaponry.registeredAttachments ) do
		table.insert( st.attachments, v.name )
	end
end]]

wep_att = {}

--Set the number to 0 to give for free, a specific number for custom killcount, a negative number for custom killcount but adds the previous highest killcount requirement
--(so -50 would be 120 + 50, whereas 170 would just be 170), or nil to remove the attachment from being unlockable - done in order of appearance in this table
--so add the negative values (kill requirements adding on the previous) first and the 0's and absolutes after
-- [ "cw_ar15" ] = { [ "bg_foldsight" ] = -20, [ "md_microt1" ] = -30 }, [ "md_saker" ] = 200 }		-	 as an example
specialAttachmentRules = { 
	[ "cw_ar15" ] = { [ "bg_foldsight" ] = 0 },
	[ "cw_m14" ] = { [ "md_nightforce_nxs" ] = 0 }
}

--//Constructs a list of attachments for each CW2.0 gun, whether it's used or not. A lot less time consuming than manually adding each attachment to a table with a kill value
function ConstructAttachmentLists()
	print( "(Re)constructing attachment lists..." )
	
	for k, v in pairs( weapons.GetList() ) do
		if v.Base == "cw_base" then --If cw2.0 weapon
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
	if ply and ply:IsValid() and att and att:IsValid() and att ~= ply then

		local wep
		if dmginfo:IsBulletDamage() then
			wep = att:GetActiveWeapon() or dmginfo:GetInflictor()
			if !wep then return end
		end
		
		wep = wep:GetClass()
		
		--What's the point to this? st seems like an extremely redundant table
		--[[if st[ att ] then
			for k, v in next, st[ att ] do
				if wep == v:GetClass() then
					cantrack = true
				end
			end
		end]]
	
		if not att:GetPData( wep ) then
			att:SetPData( wep, 1 )
		else
			local num = att:GetPData( wep )
			att:SetPData( wep, num + 1 )
		end
		
		net.Start( "UpdateStatTrak" )
			net.WriteString( wep )
			net.WriteString( tostring( att:GetPData( wep ) ) )
		net.Send( att )
			
		local num = GetStatTrak( att, wep )
		local togive = {}
		
		--for k, v in pairs( wep_att ) do
		for q, w in next, wep_att do
			if q == wep then
				for a, s in next, w do
					if num == s[ 2 ] then
						table.insert( togive, s[ 1 ] )
					end
				end
			end
		end
		if next(togive) ~= nil then CustomizableWeaponry.giveAttachments( att, togive ) end

	end
end )

hook.Add( "PlayerSpawn", "ST_PlayerSpawn", function( ply )
	timer.Simple( 0.5, function()
        if ply == nil then return end
		local weps = ply:GetWeapons()
		--st[ ply ] = weps
		
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

--[[hook.Add( "Think", "UpdateSTWeps", function()
	for k, v in next, player.GetAll() do
		if st[ v ] ~= v:GetWeapons() then
			st[ v ] = v:GetWeapons()
		end
	end
end )]]