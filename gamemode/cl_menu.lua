surface.CreateFont( "MenuInfo", { font = "Exo 2", size = 24, weight = 400 } )

GM.FirstLoadout = true
function GM:MenuMain()
	if (self.ChooseMain and self.ChooseMain:IsValid()) or (main and main:IsValid()) or (self.LoadoutMain and self.LoadoutMain:IsValid()) or (self.ShopMain and self.ShopMain:IsValid()) or (self.HelpMain and self.HelpMain:IsValid()) or (self.TitleMain and self.TitleMain:IsValid()) or (GAMEMODE.MapvoteMain and GAMEMODE.MapvoteMain:IsValid()) then
		return
	end

	self.ChooseMain = vgui.Create( "DFrame" )
	self.ChooseMain:SetSize( 600, 500 )
	self.ChooseMain:SetTitle( "" )
	self.ChooseMain:SetVisible( true )
	self.ChooseMain:SetDraggable( false )
	self.ChooseMain:ShowCloseButton( false )
	self.ChooseMain:MakePopup()
	self.ChooseMain:Center()
	self.ChooseMainTitleBar = 56 --The originally-sized title bar height - to be kept consistent as an homage to the old menu
    self.ChooseMain.Paint = function()
        Derma_DrawBackgroundBlur( self.ChooseMain, CurTime() )
		surface.SetDrawColor( GAMEMODE.TeamColor )
		surface.DrawRect( 0, 0, self.ChooseMain:GetWide(), self.ChooseMainTitleBar )

		draw.SimpleText( "Select An Option", "ExoTitleFont", self.ChooseMain:GetWide() / 2, self.ChooseMainTitleBar / 2, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

		surface.SetDrawColor( Color( 255, 255, 255 ) )
		surface.DrawRect( 0, self.ChooseMainTitleBar, self.ChooseMain:GetWide(), self.ChooseMain:GetTall() )
	end

	self.ChooseLoadout = vgui.Create( "ChooseMainButton", self.ChooseMain )
	self.ChooseLoadout:SetSize( self.ChooseMain:GetWide() / 3, ( self.ChooseMain:GetTall() - self.ChooseMainTitleBar ) / 2 )
	self.ChooseLoadout:SetPos( 0, self.ChooseMainTitleBar )
	self.ChooseLoadout:SetText( "Loadout" )
	self.ChooseLoadout:SetFont( "MenuInfo" )
	self.ChooseLoadout:SetIcon( GAMEMODE.Icons.Menu.loadoutIcon )
	if LocalPlayer():Team() == 0 then self.ChooseLoadout:Disable( true ) end
	self.ChooseLoadout.DoClick = function()
		if self.ChooseLoadout.Disabled then return end
		surface.PlaySound( self.ChooseLoadout.SoundTable[ math.random( #self.ChooseLoadout.SoundTable ) ] )
		self.ChooseMain:Close() --Remove?
		--self:SetLoadout()
		LoadoutMenu()
	end

	self.ChooseShop = vgui.Create( "ChooseMainButton", self.ChooseMain )
	self.ChooseShop:SetSize( self.ChooseMain:GetWide() / 3, ( self.ChooseMain:GetTall() - self.ChooseMainTitleBar ) / 2 )
	self.ChooseShop:SetPos( self.ChooseMain:GetWide() / 3, self.ChooseMainTitleBar )
	self.ChooseShop:SetText( "Shop" )
	self.ChooseShop:SetFont( "MenuInfo" )
	self.ChooseShop:SetIcon( GAMEMODE.Icons.Menu.shopIcon )
	self.ChooseShop.DoClick = function()
		if self.ChooseShop.Disabled then return end --Always returns true, to be removed when shop is finished
		surface.PlaySound( self.ChooseLoadout.SoundTable[ math.random( #self.ChooseLoadout.SoundTable ) ] )
		self.ChooseMain:Close() --Remove?
		GAMEMODE:OpenShop()
	end

	self.ChooseTeam = vgui.Create( "ChooseMainButton", self.ChooseMain )
	self.ChooseTeam:SetSize( self.ChooseMain:GetWide() / 3, ( self.ChooseMain:GetTall() - self.ChooseMainTitleBar ) / 2 )
	self.ChooseTeam:SetPos( self.ChooseMain:GetWide() / 3 * 2, self.ChooseMainTitleBar )
	self.ChooseTeam:SetText( "Change\n Teams" )
	self.ChooseTeam:SetFont( "MenuInfo" )
	self.ChooseTeam:SetIcon( GAMEMODE.Icons.Menu.teamChangeIcon )
	self.ChooseTeam.DoClick = function()
		surface.PlaySound( self.ChooseLoadout.SoundTable[ math.random( #self.ChooseLoadout.SoundTable ) ] )
		self.ChooseMain:Close() --Remove?
		LocalPlayer():ConCommand( "tdm_spawnmenu" )
	end

	self.ChooseTag = vgui.Create( "ChooseMainButton", self.ChooseMain )
	self.ChooseTag:SetSize( self.ChooseMain:GetWide() / 3, ( self.ChooseMain:GetTall() - self.ChooseMainTitleBar ) / 2 )
	self.ChooseTag:SetPos( 0, self.ChooseMainTitleBar + self.ChooseTag:GetTall() )
	self.ChooseTag:SetText( "Achievement\n        Titles" )
	self.ChooseTag:SetFont( "MenuInfo" )
	self.ChooseTag:SetIcon( GAMEMODE.Icons.Menu.titleIcon )
	self.ChooseTag.DoClick = function()
		surface.PlaySound( self.ChooseLoadout.SoundTable[ math.random( #self.ChooseLoadout.SoundTable ) ] )
		self.ChooseMain:Close() --Remove?
		GAMEMODE:OpenTitles()
	end

	self.ChooseHelp = vgui.Create( "ChooseMainButton", self.ChooseMain )
	self.ChooseHelp:SetSize( self.ChooseMain:GetWide() / 3, ( self.ChooseMain:GetTall() - self.ChooseMainTitleBar ) / 2 )
	self.ChooseHelp:SetPos( self.ChooseMain:GetWide() / 3, self.ChooseMainTitleBar + self.ChooseTag:GetTall() )
	self.ChooseHelp:SetText( "Help" )
	self.ChooseHelp:SetFont( "MenuInfo" )
	self.ChooseHelp:SetIcon( GAMEMODE.Icons.Menu.helpIcon )
	--self.ChooseHelp:Disable( true )
	self.ChooseHelp.DoClick = function()
		surface.PlaySound( self.ChooseLoadout.SoundTable[ math.random( #self.ChooseLoadout.SoundTable ) ] )
		self.ChooseMain:Close() --Remove?
		GAMEMODE:OpenHelp()
	end

	self.ChooseCancel = vgui.Create( "ChooseMainButton", self.ChooseMain )
	self.ChooseCancel:SetSize( self.ChooseMain:GetWide() / 3, ( self.ChooseMain:GetTall() - self.ChooseMainTitleBar ) / 2 )
	self.ChooseCancel:SetPos( self.ChooseMain:GetWide() / 3 * 2, self.ChooseMainTitleBar + self.ChooseTag:GetTall() )
	self.ChooseCancel:SetText( "Cancel" )
	self.ChooseCancel:SetFont( "MenuInfo" )
	self.ChooseCancel:SetIcon( GAMEMODE.Icons.Menu.cancelIcon )
	self.ChooseCancel.DoClick = function()
		surface.PlaySound( self.ChooseLoadout.SoundTable[ math.random( #self.ChooseLoadout.SoundTable ) ] )
		self.ChooseMain:Close() --Remove?
    end
    
    GAMEMODE:DrawEventStatuses( self.ChooseMain )
end

concommand.Add( "tdm_loadout", GM.MenuMain ) --GAMEMODE.NewLoadout( GAMEMODE ) ?