--//I'm going to use a table to set up the display for the help menu, type is used to distinguish what to do with display, types are:
GM.HelpMenuObjects = {
    { type = "header", display = "The Basics" },
    { type = "subheader", display = "First Things First" },
    { type = "text", display = "If you end up getting bored reading this menu (which it seems most people do) and scroll to the bottom to get passed it all (which I don't recommend), you can always come back to this page by opening the menu (F1 or F2) and selecting the \"Help Menu\" button." },
    { type = "image", display = "vgui/help/0.png" },
	{ type = "subheader", display = "How To Play" },
	{ type = "text", display = "There are 2 game types available: team deathmatch and conquest. In Team Deathmatch, your goal is to achieve more kills than your enemy before reaching the time limit. The time remaining can be seen in the top center of the screen, with each team's current kill count on each side." },
	--{ type = "image", display = "vgui/help/1.png" },
	{ type = "text", display = "In Conquest, your goal is to drain the enemy of their points (or tickets, if you played Battlefield) before they can drain all of your teams'. You drain points by holding the majority of flags placed around the map. The flags can be seen along the top of the screen underneath the timer and ticket counter." },
	{ type = "image", display = "vgui/help/2.png" },
	{ type = "spacer" },
	{ type = "subheader", display = "Spawning & How To Spawn" },
	--{ type = "text", display = "Spawning requires that you have selected both a PRIMARY and a SECONDARY weapon. EQUIPMENT and PERKS are optional additions which are not required to spawn, but are recommended regardless, as there is nothing detrimental to having either equipped. Once spawned, all players receive 3 seconds of spawn protection, which provides 90% damage reduction." },
	{ type = "text", display = "Spawning requires that you have a Primary weapon selected. Your option defaults to the AR-15. Secondary weapons, Equipment and Perks are optional loadout additions which are not required to spawn, but are recommended. From this menu, you can also select special playermodels, or individual weapon skins, to equip. Some playermodels may come with extra skins or bodygroups, which you may customize as you like. Once spawned, all players receive 3 seconds of spawn protection, which provides 90% damage reduction for the duration." },
    { type = "image", display = "vgui/help/3.png" },
	--{ type = "image", display = "vgui/help/4.png" },
	{ type = "spacer" },
	{ type = "subheader", display = "Cash & Experience Accumulation" },
	{ type = "text", display = "Cash and experience ($/exp) is accumulated by killing opponents, assisting in killing opponents, and capturing flags. Cash and experience is accumulated at the same rate (200 points earned equates to 200 in both cash and experience). Additional points can be earned by: killing opponenets in consecutive strings, getting headshots from far away, and more." },
	{ type = "image", display = "vgui/help/5.png" },
	{ type = "spacer" },
	{ type = "subheader", display = "Navigating The Menu" },
	{ type = "text", display = "The menu can be accessed at any moment by pressing F1 (unless you are already in it). From the menu, you can reselect your loadout, visit the shop, change your team, change your achievement tag, and re-open this help menu. The Loadout Menu can be accessed directly with F2, the Shop with F3, and the Team Selection menu with F4." },
	{ type = "image", display = "vgui/help/6.png" }, --//Need a new image
	{ type = "spacer" },
	{ type = "subheader", display = "Perks" },
	{ type = "text", display = "Perks are passive bonuses which are designed to positively affect your gameplay. Some offer a 1-time bonus on spawn, others introduces a new mechanic available only to you, and some quietly provide a buff to your character. Few perks offer any sort of negative drawbacks, and some perks are soft counters to others." },
	{ type = "spacer" },
	{ type = "subheader", display = "Unlocking New Weapons & Perks" },
	{ type = "text", display = "Weapons and perks have to be unlocked before they can be bought or used. Perks are simply unlocked by reaching the level required to unlock them, displayed in the loadout menu. Weapons are unlocked this way also, but must additionally be purchased in the Shop before the weapon becomes available. The price of weapons increases as their level requirement increases." },
	{ type = "image", display = "vgui/help/7.png" },
	--{ type = "image", display = "vgui/help/8.png" },
	{ type = "spacer" },
	{ type = "subheader", display = "Attachment Unlocks" },
	{ type = "text", display = "Attachments are unlocked by earning kills with any given gun. The rate at which attachments unlock may change (they have been lowered for some of the starting weapons), but most weapons unlock 1 attachment at every 10 kills. Your weapon's killcount can be found at the bottom left hand corner of the screen. Attachments are necessary for increasing the usability of your guns. Weapons are currently customized by pressing C (or whatever key of yours is bounded to +context_menu) while holding a weapon." },
	{ type = "image", display = "vgui/help/9.png" },
	{ type = "image", display = "vgui/help/10.png" },
    { type = "spacer" },
    --//
	{ type = "header", display = "Extra Topics" },
	{ type = "subheader", display = "Prestiging" },
	{ type = "text", display = "If you've ever played the multiplayer for a Call of Duty game after World at War, you are familiar with what prestiging is. Prestiging resets all progress earned towards achievements and attachments and resets all player progress (resetting the player back to level 1 with no weapons, perk unlocks, and money). This grants the player 1 prestige token, which can be used in the shop to buy special cosmetics. It only becomes available at level 100, the highest level you can achieve." },
	{ type = "image", display = "vgui/help/11.png" },
	{ type = "image", display = "vgui/help/12.png" },
	{ type = "spacer" },
	{ type = "subheader", display = "The Shop" },
	{ type = "text", display = "The shop is divided into 3 sections, each with an individual purpose. The weapons shop is used to buy guns you've unlocked. It relevant balancing stats, such as rate of fire, damage, and accuracy. This section of the shop uses in-game cash only." },
	{ type = "image", display = "vgui/help/13.png" },
	{ type = "text", display = "The skins shop is used to buy weapon skins which can be applied to any and all of your guns in the PRIMARY or SECONDARY slot (so no equipment). Skins are tiered by which I think look better vs. worse (in my opinion). Worse-looking skins can be purchased with in-game cash, prestige tokens, and donator credits. Better-looking skins CANNOT be purchased with cash, and the best-looking skins can ONLY be purchased with donator credits." },
	{ type = "image", display = "vgui/help/14.png" },
	{ type = "text", display = "The model shop is used to buy new player models. These are assumed to not have large hitbox differences, and skins that are determined to be unfair to play against will be removed. Similar to the aforementioned skins, the models operate in a tiered system, with worse-looking skins being cheaper, and better-looking skins being more expensive or only purchaseable with prestige tokens and/or donator credits." },
	{ type = "image", display = "vgui/help/15.png" },
	{ type = "spacer" },
	{ type = "subheader", display = "Vendetta" },
	{ type = "text", display = "Vendetta is an ever-changing mechanic designed to do 1 thing: help players not so great at the game perform better against those that play well. Vendetta is earned against a specific player who has killed you many times (this amount changes dynamically, based on the amount of people on their team). The current iteration of the mechanic is two-fold: it provides the losing player with damage resistance against their vendetta target, and when a kill is achieved, heals you back for a significant amount of damage they've done to you during your current life (none if none). Previous iterations of the mechanic gave the losing player wall-hacks against their vendetta target, but this was changed at the community's behest. This mechanic may change again in the future." },
	--{ type = "image", display = "vgui/help/16.png" },
	{ type = "spacer" },
	{ type = "subheader", display = "Achievement Titles" },
	{ type = "text", display = "Achievement titles (called so because I couldn't think of anything besides \"achievements/titles\") are tags you can earn for completing various in-game objectives, listed in the Achievement Titles subsection of the menu (found by pressing F2, or by backing out of this help menu). These objectives, currently low in amount, require you to earn an in-game achievement (such as getting a headshot) x amount of times, a la Call of Duty titles." },
	{ type = "image", display = "vgui/help/17.png" },
	{ type = "text", display = "These tags/titles are displayed both when you chat and when you kill a player in their death screen. Progress made toward these titles is lost on prestige, but any that are completed remain available (including gun mastery for guns that no longer exist on the server)." },
	{ type = "image", display = "vgui/help/18.png" },
	{ type = "spacer" },
	{ type = "subheader", display = "Killstreaks & Killsprees" },
	{ type = "text", display = "An important distinction needs to be made between killSTREAKs and killSPREEs. Killstreaks can be thought of like they are in Call of Duty multiplayer: how many kills you've achieved in 1 life. Rewards for getting high killstreaks start at 5 kills, and are announced in chat." },
	{ type = "image", display = "vgui/help/19.png" },
	{ type = "text", display = "Killsprees are kill combos, when you earn kills back-to-back, with a (currently) 7 second window between each kill. Rewards continue to accumulate if the combo is kept going, unlike killstreaks, but points are capped after a 6 combo. Killstreaks and Killsprees are the best way to earn points, with flag capturing being second best." },
    { type = "spacer" },
    { type = "subheader", display = "Events" },
	{ type = "text", display = "Events come in 2 forms: time-based, and single-game. Time based events, such as Happy Hour and Double XP Weekend, happen on a schedule, which is displayed in the F2 menu. These time-based events may provide bonus point accumulation, or may be a race to reach a specific goal. Single-game events add fun and unique mututators to the game which change or add to the game's mechanics. When they (rarely) occur, you'll see an option to vote for a map with a mutator in the mapvote." },
    { type = "spacer" }
}

GM.HelpImageWide = 480 --by 270

surface.CreateFont( "HelpHeader" , { font = "Exo 2", size = 24, weight = 600 } )
surface.CreateFont( "HelpSubheader" , { font = "Exo 2", size = 20, weight = 600 } )
surface.CreateFont( "HelpText" , { font = "Exo 2", size = 16, weight = 600 } )

function GM:OpenHelp( firstTime )
    if self.HelpMain and self.HelpMain:IsValid() then return end

    self.HelpMain = vgui.Create( "DFrame" )
    self.HelpMain:SetSize( 960, 540 )
	self.HelpMain:SetTitle( "" )
	self.HelpMain:SetVisible( true )
	self.HelpMain:SetDraggable( false )
	self.HelpMain:ShowCloseButton( false )
	self.HelpMain:Center()
	self.HelpMain:MakePopup()
	self.HelpMain.Think = function()
		self.HelpMain.x, self.HelpMain.y = self.HelpMain:GetPos()
    end
    self.HelpMainTitleBar = 56
    self.HelpMain.Paint = function()
        Derma_DrawBackgroundBlur( self.HelpMain, CurTime() )
		surface.SetDrawColor( self.TeamColor )
		surface.DrawRect( 0, 0, self.HelpMain:GetWide(), self.HelpMainTitleBar )

        surface.SetFont( "Exo 2" )
		surface.SetTextColor( Color( 255, 255, 255 ) )
		surface.SetTextPos( self.HelpMain:GetWide() / 2 - surface.GetTextSize("Help Menu") / 2, 16 )
		surface.DrawText( "Help Menu" )

		surface.SetDrawColor( Color( 255, 255, 255 ) )
		surface.DrawRect( 0, self.HelpMainTitleBar, self.HelpMain:GetWide(), self.HelpMain:GetTall() )

		surface.SetTexture( GAMEMODE.GradientTexture )
        surface.SetDrawColor( 0, 0, 0, 164 )
        surface.DrawTexturedRectRotated( self.HelpMain:GetWide() / 2, self.HelpMainTitleBar + 4, 8, self.HelpMain:GetWide(), 270 )
    end

	self.HelpScrollBar = vgui.Create( "DScrollPanel", self.HelpMain )
	self.HelpScrollBar:SetPos( 0, self.HelpMainTitleBar )
	self.HelpScrollBar:SetSize( self.HelpMain:GetWide() - 2, self.HelpMain:GetTall() - self.HelpMainTitleBar )

	local ScrollBar = self.HelpScrollBar:GetVBar()
	function ScrollBar:Paint( w, h )
        draw.RoundedBox( 4, 7, 16, w / 2, h - 32, Color( 66, 66, 66 ) )
        return 
    end
    function ScrollBar.btnGrip:Paint( w, h )
        draw.RoundedBox( 4, 7, 0, w / 2, h, GAMEMODE.TeamColor )
    end
    ScrollBar.btnUp.Paint = function() return end
    ScrollBar.btnDown.Paint = function() return end
	
	for k, v in pairs( self.HelpMenuObjects ) do
		local panel = vgui.Create( "DPanel", self.HelpScrollBar )
		panel:Dock( TOP )
		if v.type == "header" then
			panel:SetSize( self.HelpScrollBar:GetWide(), 24 + 8 )
			panel.Paint = function()
				surface.SetFont( "HelpHeader" )
				surface.SetTextColor( self.TeamColor )
				local wide, tall = surface.GetTextSize( v.display )
				surface.SetTextPos( panel:GetWide() / 2 - ( wide / 2 ), panel:GetTall() / 2 - ( tall / 2 ) )
				surface.DrawText( v.display )
			end
		elseif v.type == "subheader" then
			panel:SetSize( self.HelpScrollBar:GetWide(), 20 + 8 )
			panel.Paint = function()
				surface.SetFont( "HelpSubheader" )
				surface.SetTextColor( self.TeamColor )
				local wide, tall = surface.GetTextSize( v.display )
				surface.SetTextPos( 4, panel:GetTall() / 2 - ( tall / 2 ) )
				surface.DrawText( v.display )

				surface.SetDrawColor( self.TeamColor )
				surface.DrawLine( 2, panel:GetTall() / 2 + ( tall / 2 ) + 2, wide + 4, panel:GetTall() / 2 + ( tall / 2 ) + 2 )
			end
		elseif v.type == "text" then
			local markupobj = markup.Parse( "<font=HelpText><colour=0,0,0>" .. v.display .. "</colour></font>", self.HelpScrollBar:GetWide() - 12 )
			local markupheight = markupobj:GetHeight()
			panel:SetSize( self.HelpScrollBar:GetWide(), markupheight + 8 )
			panel.Paint = function()
				markupobj:Draw( 6, 4, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			end
		elseif v.type == "image" then
			local ratio = self.HelpMain:GetTall() / self.HelpMain:GetWide()
            local picture = Material( v.display )
            GAMEMODE.HelpImageWide = self.HelpMain:GetWide() / 2
            panel:SetSize( GAMEMODE.HelpImageWide, GAMEMODE.HelpImageWide * ratio )
            panel:DockMargin( GAMEMODE.HelpImageWide / 2, 0, GAMEMODE.HelpImageWide / 2, 0 )
            panel.Paint = function()
                surface.SetDrawColor( 255, 255, 255 )
				surface.SetMaterial( picture )
				surface.DrawTexturedRect( 4, 4, panel:GetWide() - 8, panel:GetTall() - 8 )
			end
		elseif v.type == "spacer" then
			panel:SetSize( self.HelpScrollBar:GetWide(), 8 )
			panel.Paint = function()
			end
		end
	end

	if firstTime then
			local close = vgui.Create( "DButton", self.HelpScrollBar )
			close:Dock( TOP )
			surface.SetFont( "HelpHeader" )
			local wide = surface.GetTextSize("UNDERSTOOD, LET'S PLAY")
			local remainingspace = ( self.HelpScrollBar:GetWide() - wide ) / 2
			close:DockMargin( remainingspace, 0, remainingspace, 0 )
			close:SetText( "" )
			close.Think = function()
				close:SetSize( wide + 8, 24 + 8 + 8 )
			end
			close.Paint = function()
				surface.SetTextColor( 0, 0, 0 )
				surface.SetFont( "HelpHeader" )
				surface.SetTextPos( 4, 2 )
				surface.DrawText( "UNDERSTOOD, LET'S PLAY" )

				if close.hover then
					draw.RoundedBox( 4, 0, 0, close:GetWide(), close:GetTall() - 8, Color( 0, 0, 0, 153 ) )
				end
			end
			close.DoClick = function()
				self.HelpMain:Close()
				LocalPlayer():ConCommand( "tdm_spawnmenu" )
				net.Start( "AcceptedHelp" )
				net.SendToServer()
			end
			close.OnCursorEntered = function()
				close.hover = true
			end
			close.OnCursorExited = function()
				close.hover = false
			end
		else
			local back = vgui.Create( "DButton", self.HelpMain )
			back:SetSize( 40, 40 )
			back:SetPos( 8, 8 )
			back:SetText( "" )
			back.DoClick = function()
				self.HelpMain:Close()
				GAMEMODE:MenuMain()
			end
			back.Paint = function()
				if back.hover then
					surface.SetDrawColor( colorScheme[ LocalPlayer():Team() ].ButtonIndicator )
				else
					surface.SetDrawColor( 0, 0, 0, 220 )
				end
				surface.SetMaterial( GAMEMODE.Icons.Menu.backIcon )
				surface.DrawTexturedRect( 0, 0, back:GetWide(), back:GetTall() )
			end
			back.OnCursorEntered = function()
				back.hover = true
			end
			back.OnCursorExited = function()
				back.hover = false
			end

			local close = vgui.Create( "DButton", self.HelpMain )
			close:SetSize( 40, 40 )
			close:SetPos( self.HelpMain:GetWide() - 8 - close:GetWide(), 8 )
			close:SetText( "" )
			close.DoClick = function()
				self.HelpMain:Close()
			end
			close.Paint = function()
				if close.hover then
					surface.SetDrawColor( colorScheme[ LocalPlayer():Team() ].ButtonIndicator )
				else
					surface.SetDrawColor( 0, 0, 0, 220 )
				end
				surface.SetMaterial( GAMEMODE.Icons.Menu.cancelIcon )
				surface.DrawTexturedRect( 0, 0, close:GetWide(), close:GetTall() )
			end
			close.OnCursorEntered = function()
				close.hover = true
			end
			close.OnCursorExited = function()
				close.hover = false
			end
		end
end

