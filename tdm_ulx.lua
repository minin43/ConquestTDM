--setting
--set level
function ulx.setlevel( calling_ply, target_ply, level )
	lvl.SetLevel( target_ply, level )
	target_ply:ConCommand( "lvl_refresh" )
	ulx.fancyLogAdmin( calling_ply, "#A set the level of #T to #i", target_ply, level )
end
local sl = ulx.command( "TDM", "ulx setlevel", ulx.setlevel, "!setlevel" )
sl:addParam{ type=ULib.cmds.PlayerArg }
sl:addParam{ type=ULib.cmds.NumArg, min=1, hint="Level" }
sl:defaultAccess( ULib.ACCESS_SUPERADMIN )
sl:help( "Set a player's level" )

--set exp
function ulx.setexp( calling_ply, target_ply, level )
	lvl.SetEXP( target_ply, level )
	target_ply:ConCommand( "lvl_refresh" )
	ulx.fancyLogAdmin( calling_ply, "#A set the exp of #T to #i", target_ply, level )
end
local se = ulx.command( "TDM", "ulx setexp", ulx.setexp, "!setexp" )
se:addParam{ type=ULib.cmds.PlayerArg }
se:addParam{ type=ULib.cmds.NumArg, hint="EXP" }
se:defaultAccess( ULib.ACCESS_SUPERADMIN )
se:help( "Set a player's exp" )

--set money
function ulx.setmoney( calling_ply, target_ply, dosh )
	SetMoney( target_ply, dosh )
	ulx.fancyLogAdmin( calling_ply, "#A set the money of #T to #i", target_ply, dosh )
end
local d = ulx.command( "TDM", "ulx setmoney", ulx.setmoney, "!setmoney" )
d:addParam{ type=ULib.cmds.PlayerArg }
d:addParam{ type=ULib.cmds.NumArg, hint="Money" }
d:defaultAccess( ULib.ACCESS_SUPERADMIN )
d:help( "Set a player's money" )

--adding
--add level
function ulx.addlevel( calling_ply, target_ply, level )
	local curLevel = lvl.GetLevel( target_ply )
	curLevel = curLevel + level
	if curLevel > lvl.maxlevel then
		curLevel = lvl.maxlevel
	end
	lvl.SetLevel( target_ply, curLevel )
	target_ply:ConCommand( "lvl_refresh" )
	ulx.fancyLogAdmin( calling_ply, "#A gave #T #i levels", target_ply, level )
end
local asl = ulx.command( "TDM", "ulx addlevel", ulx.addlevel, "!addlevel" )
asl:addParam{ type=ULib.cmds.PlayerArg }
asl:addParam{ type=ULib.cmds.NumArg, hint="Level" }
asl:defaultAccess( ULib.ACCESS_SUPERADMIN )
asl:help( "Add levels to a player" )

--add exp
function ulx.addexp( calling_ply, target_ply, level )
	lvl.AddEXP( target_ply, level )
	target_ply:ConCommand( "lvl_refresh" )
	ulx.fancyLogAdmin( calling_ply, "#A gave #t #i exp", target_ply, level )
end
local ase = ulx.command( "TDM", "ulx addexp", ulx.addexp, "!addexp" )
ase:addParam{ type=ULib.cmds.PlayerArg }
ase:addParam{ type=ULib.cmds.NumArg, hint="EXP" }
ase:defaultAccess( ULib.ACCESS_SUPERADMIN )
ase:help( "Add exp to a player" )

--add money
function ulx.addmoney( calling_ply, target_ply, dosh )
	AddMoney( target_ply, dosh )
	ulx.fancyLogAdmin( calling_ply, "#A gave #T #i money", target_ply, dosh )
end
local ad = ulx.command( "TDM", "ulx addmoney", ulx.addmoney, "!addmoney" )
ad:addParam{ type=ULib.cmds.PlayerArg }
ad:addParam{ type=ULib.cmds.NumArg, hint="Money" }
ad:defaultAccess( ULib.ACCESS_SUPERADMIN )
ad:help( "Add money to a player" )

--checking
--check exp
function ulx.checkexp( calling_ply, target_ply )
	local xp = lvl.GetEXP( target_ply )
	ulx.fancyLogAdmin( calling_ply, "#A checked the EXP of #T", target_ply )
	
	ULib.tsay( calling_ply, target_ply:Nick() .. " has " .. xp .. " EXP.", true )
end
local ce = ulx.command( "TDM", "ulx checkexp", ulx.checkexp, "!checkexp" )
ce:addParam{ type=ULib.cmds.PlayerArg, target="*" }
ce:defaultAccess( ULib.ACCESS_ADMIN )
ce:help( "Checks a player's EXP" )

--check money
function ulx.checkmoney( calling_ply, target_ply )
	local money = GetMoney( target_ply )
	ulx.fancyLogAdmin( calling_ply, "#A checked the money of #T", target_ply )
	
	ULib.tsay( calling_ply, target_ply:Nick() .. " has $" .. money .. " money.", true )
end
local cm = ulx.command( "TDM", "ulx checkmoney", ulx.checkmoney, "!checkmoney" )
cm:addParam{ type=ULib.cmds.PlayerArg, target="*" }
cm:defaultAccess( ULib.ACCESS_ADMIN )
cm:help( "Checks a player's money" )

--silent check exp
function ulx.checkexpsilent( calling_ply, target_ply )
	local xp = lvl.GetEXP( target_ply )
	ulx.fancyLogAdmin( calling_ply, true, "#A checked the EXP of #T", target_ply )
	
	ULib.tsay( calling_ply, target_ply:Nick() .. " has " .. xp .. " EXP.", true )
end
local sce = ulx.command( "TDM", "ulx checkexpsilent", ulx.checkexpsilent, "!checkexpsilent" )
sce:addParam{ type=ULib.cmds.PlayerArg, target="*" }
sce:defaultAccess( ULib.ACCESS_ADMIN )
sce:help( "Silently checks a player's EXP" )

--silent check money
function ulx.checkmoneysilent( calling_ply, target_ply )
	local money = GetMoney( target_ply )
	ulx.fancyLogAdmin( calling_ply, true, "#A checked the money of #T", target_ply )
	
	ULib.tsay( calling_ply, target_ply:Nick() .. " has $" .. money .. " money.", true )
end
local scm = ulx.command( "TDM", "ulx checkmoneysilent", ulx.checkmoneysilent, "!checkmoneysilent" )
scm:addParam{ type=ULib.cmds.PlayerArg, target="*" }
scm:defaultAccess( ULib.ACCESS_ADMIN )
scm:help( "Silently checks a player's money" )

--giving
--give money
function ulx.givemoney( calling_ply, target_ply, amount )
	local money = GetMoney( calling_ply )

	--can't give to yourself
	if calling_ply == target_ply then
		ULib.tsayError( calling_ply, "You can't give to yourself!", true )
		return
	--can't give nothing
	elseif amount == 0 then
		ULib.tsayError( calling_ply, "You can't give nothing.", true )
		return
	--can't give negative money
	elseif amount < 0 then
		ULib.tsayError( calling_ply, "You can't give negative money!", true )
		return
	--insufficient funds
	elseif money < amount then
		ULib.tsayError( calling_ply, "You have insufficient funds!", true )
		return
	end

	SetMoney( calling_ply, money - amount )
	AddMoney( target_ply, amount )
	
	ulx.fancyLogAdmin( calling_ply, "#A gave #i of their own money to #T", amount, target_ply )
end
local gm = ulx.command( "TDM", "ulx givemoney", ulx.givemoney, "!givemoney" )
gm:addParam{ type=ULib.cmds.PlayerArg, target="*" }
gm:addParam{ type=ULib.cmds.NumArg, hint="Money", min=1, default=1 }
gm:defaultAccess( ULib.ACCESS_ADMIN )
gm:help( "Give a player money" )

--get loadout
function ulx.getloadout( calling_ply, target_ply )
	ulx.fancyLogAdmin( calling_ply, "#A checked the loadout of #T", target_ply )

	local l = preload[target_ply]
	local pl = load[target_ply]
	local cur_l = target_ply:GetWeapons()
	local cur_w = target_ply:GetActiveWeapon()

	if cur_w.CW20Weapon then
		ULib.tsay( calling_ply, target_ply:Nick() .. " is currently using the " .. cur_w:GetClass() .. " with:", true )
		--for k, v in pairs( cur_w.Attachments ) do
		--	ULib.tsay( calling_ply, v, true )
		--end
	elseif cur_w then
		ULib.tsay( calling_ply, target_ply:Nick() .. " is currently using the " .. cur_w:GetClass() .. " with no attachments.", true )
	else
		ULib.tsayError( calling_ply, target_ply:Nick() .. " is not using any weapon.", true )
	end

	if target_ply:Alive() then
		ULib.tsay( calling_ply, target_ply:Nick() .. " currently has these weapons:", true )
		for k, v in pairs( cur_l ) do
			ULib.tsay( calling_ply, " - " .. v:GetClass(), true )
		end
	else
		ULib.tsayError( calling_ply, target_ply:Nick() .. " is dead, thus carrying no weapons.", true )
	end
	
	if l then
		ULib.tsay( calling_ply, target_ply:Nick() .. " will spawn with these weapons:", true )
		ULib.tsay( calling_ply, " - " .. l.primary, true )
		ULib.tsay( calling_ply, " - " .. l.secondary, true )
		ULib.tsay( calling_ply, " - " .. l.extra, true )
		ULib.tsay( calling_ply, target_ply:Nick() .. "'s current Perk is " .. pl.perk, true )
		if pl.perk ~= l.perk then
			ULib.tsay( calling_ply, target_ply:Nick() .. "'s next Perk is " .. l.perk, true )
		end
	else
		ULib.tsayError( calling_ply, target_ply:Nick() .. " does not have a spawning loadout.", true )
	end

end
local getld = ulx.command( "TDM", "ulx getloadout", ulx.getloadout, "!getloadout" )
getld:addParam{ type=ULib.cmds.PlayerArg, target="*" }
getld:defaultAccess( ULib.ACCESS_ADMIN )
getld:help( "Print the player's current loadout" )

--silent get loadout
function ulx.getloadoutsilent( calling_ply, target_ply )
	ulx.fancyLogAdmin( calling_ply, true, "#A checked the loadout of #T", target_ply )

	local l = preload[target_ply]
	local pl = load[target_ply]
	local cur_l = target_ply:GetWeapons()
	local cur_w = target_ply:GetActiveWeapon()

	if cur_w.CW20Weapon then
		ULib.tsay( calling_ply, target_ply:Nick() .. " is currently using the " .. cur_w:GetClass() .. " with:", true )
		--for k, v in pairs( cur_w.Attachments ) do
		--	ULib.tsay( calling_ply, v, true )
		--end
	elseif cur_w then
		ULib.tsay( calling_ply, target_ply:Nick() .. " is currently using the " .. cur_w:GetClass() .. " with no attachments.", true )
	else
		ULib.tsayError( calling_ply, target_ply:Nick() .. " is not using any weapon.", true )
	end

	if target_ply:Alive() then
		ULib.tsay( calling_ply, target_ply:Nick() .. " currently has these weapons:", true )
		for k, v in pairs( cur_l ) do
			ULib.tsay( calling_ply, " - " .. v:GetClass(), true )
		end
	else
		ULib.tsayError( calling_ply, target_ply:Nick() .. " is dead, thus carrying no weapons.", true )
	end
	
	if l then
		ULib.tsay( calling_ply, target_ply:Nick() .. " will spawn with these weapons:", true )
		ULib.tsay( calling_ply, " - " .. l.primary, true )
		ULib.tsay( calling_ply, " - " .. l.secondary, true )
		ULib.tsay( calling_ply, " - " .. l.extra, true )
		ULib.tsay( calling_ply, target_ply:Nick() .. "'s current Perk is " .. pl.perk, true )
		if pl.perk ~= l.perk then
			ULib.tsay( calling_ply, target_ply:Nick() .. "'s next Perk is " .. l.perk, true )
		end
	else
		ULib.tsayError( calling_ply, target_ply:Nick() .. " does not have a spawning loadout.", true )
	end

end
local getlds = ulx.command( "TDM", "ulx getloadoutsilent", ulx.getloadoutsilent, "!getloadoutsilent" )
getlds:addParam{ type=ULib.cmds.PlayerArg, target="*" }
getlds:defaultAccess( ULib.ACCESS_ADMIN )
getlds:help( "Print the player's current loadout silently" )

--change voice chat
function ulx.changevoice( calling_ply, bool )
	if bool == true then
		game.ConsoleCommand( "sv_alltalk 1\n" )
		ulx.fancyLogAdmin( calling_ply, "#A changed the voice chat to Global. " )
	elseif bool == false then
		game.ConsoleCommand( "sv_alltalk 0\n" )
		ulx.fancyLogAdmin( calling_ply, "#A changed the voice chat to Team-Only. " )
	else
		ULib.tsayError( calling_ply, "Unable change the voice chat.", true )
	end
end
local changechat = ulx.command( "TDM", "ulx changevoice", ulx.changevoice, "!worldchat" )
changechat:addParam{ type=ULib.cmds.BoolArg, hint="Global Chat" }
changechat:defaultAccess( ULib.ACCESS_SUPERADMIN )
changechat:help( "Change if the voice chat should be global or team-only" )

-- faq
-- Define Colors
local color_green = Color( 102, 255, 51 )
local color_white = Color( 255, 255, 255 )
local color_random = Color( math.random( 255 ), math.random( 255 ), math.random( 255 ) )

-- Define Tables
-- Completes Table (for the command)
local faqcomplete = { "list", "help" }

-- FAQ Table (for the message, add new FAQs here!)
-- { "name", "message1", "message2", ... , "messageN" }
local faqanswers = {
	{ "test_faq", "test message" },
	{ "test_multi", "test message", "test message 2", "test message 3" },
	{ "Grenade", "To use Grenades, Hold E + your fire button" }
}

-- Fill table for the completes
for k, v in next, faqanswers do
	table.insert( faqcomplete, v[ 1 ] )
end

-- Cooldown timer in seconds
local faqcooldown = 3

-- Print FAQ Function
function ulx.faqcommand( calling_ply, faq )
	-- Check if FAQ is not on cooldown, let admins bypass
	if not calling_ply:IsAdmin() then
		if timer.Exists( "faq_cooldown" ) then
			-- On cooldown, send error to calling_ply, return function
			ULib.tsayError( calling_ply, "FAQ is on cooldown for " .. timer.RepsLeft( "faq_cooldown" ) .. " seconds.", true )
			return
		else
			-- Not on cooldown, create cooldown, continue
			timer.Create( "faq_cooldown", 1, faqcooldown, function() end )
		end
	end

	-- Convert string to all lowercase (because case sensitivity ;~;)
	local _faq = faq:lower()

	-- Special Case checks
	-- Check if user entered "list" or "help" or nothing at all (default is "help")
	if _faq == "list" or _faq == "help" then
		ULib.tsayColor( calling_ply, true, color_green, "Available FAQs: ", color_white, table.concat( faqcomplete, ", " ) )
		return
	end

	-- Do normal printing if all special checks are false
	for k, v in next, faqanswers do
		if _faq == v[ 1 ] then
			for i = 2, table.Count( v ), 1 do
				ULib.tsayColor( nil, true, color_green, "FAQ: ", color_white, v[ i ] )
			end
			return
		end
	end
end

local faqcommand = ulx.command( "TDM", "ulx faq", ulx.faqcommand, "!faq" )
faqcommand:addParam{
	type=ULib.cmds.StringArg, 
	completes=faqcomplete, 
	default="help", 
	hint="FAQ", 
	error="Invalid FAQ \"%s\" specified", 
	ULib.cmds.restrictToCompletes
}
faqcommand:help( "Display a FAQ answer" )