surface.CreateFont( "Exo 2 Tab", {
	font = "Exo 2",
	size = 14,
	weight = 400
} )

surface.CreateFont( "Exo 2 Hint" , {
	font = "Exo 2",
	size = 18,
	weight = 400
} )

surface.CreateFont( "Exo 2 Hint Empty", {
	font = "Exo 2",
	size = 16,
	weight = 400,
	italic = true
} )

local bought = Material( "tdm/ic_done_white_24dp.png", "noclamp smooth" )
local locked = Material( "tdm/ic_lock_white_24dp.png", "noclamp smooth" )
local unlock = Material( "tdm/ic_lock_open_white_24dp.png", "noclamp smooth" )
local buyicon = Material( "tdm/ic_add_shopping_cart_white_48dp.png", "noclamp smooth" )
local gradient = surface.GetTextureID( "gui/gradient" )

local FontColor = colorScheme[0]["DefaultFontColor"]

function GetTeamColor() --this implementation is only needed here, because everywhere else we already know what team the player is on and can use colorScheme[LocalPlayer():Team()]["TeamColor"]
	if LocalPlayer().red then
		return colorScheme[1]["TeamColor"]
	elseif LocalPlayer().blue then
		return colorScheme[2]["TeamColor"]
	else
		return colorScheme[0]["TeamColor"]
	end
end

function LoadoutMenu()
	if main then
		return
	end

	local CurrentMoneyAmt = "Fetching..."
	local CurrentLevel = 0
	
	main = vgui.Create( "DFrame" )
	main:SetSize( 750, 430 )
	main:SetTitle( "" )
	main:SetVisible( true )
	main:SetDraggable( false )
	main:ShowCloseButton( true )
	main:MakePopup()
	main:Center()
	main.btnMaxim:Hide()
	main.btnMinim:Hide() 
	main.btnClose:Hide()
	
	main.Paint = function()
		Derma_DrawBackgroundBlur( main, CurTime() )
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.DrawRect( 0, 0, main:GetWide(), main:GetTall() )
		surface.SetDrawColor( GetTeamColor() )
		surface.DrawRect( 0, 0, main:GetWide(), 56 + 48 )
		surface.SetFont( "Exo 2" )
		surface.SetTextColor( FontColor )
		surface.SetTextPos( main:GetWide() / 2 - surface.GetTextSize("Loadout") / 2, 16 )
		surface.DrawText( "Loadout" )
		surface.SetTexture( gradient )
		surface.SetDrawColor( 0, 0, 0, 164 )
		surface.DrawTexturedRectRotated( main:GetWide() / 3, 56 + 48 + 4, 8, main:GetWide() / 3 * 2, 270 )
		surface.DrawTexturedRectRotated( main:GetWide() / 3 * 2 - 4, main:GetTall() - 56 - 48 - 48 - 7, 8, main:GetTall(), 180 )
	end

	main.PaintOver = function()
		surface.SetTexture( gradient )
		surface.SetDrawColor( 0, 0, 0, 164 )
		surface.DrawTexturedRectRotated( main:GetWide() / 2, 56 + 4, 8, main:GetWide(), 270 )
	end
	
	local choose = vgui.Create( "DPropertySheet", main )
	choose:SetPos( 0, 56 + 20 )
	choose:SetSize( main:GetWide() / 3 * 2, main:GetTall() - 56 - 12 )
	choose.Paint = function() end

	local info = vgui.Create( "DPanel", main )
	info:SetPos( main:GetWide() / 3 * 2, 56 )
	info:SetSize( main:GetWide() / 3, main:GetTall() - 56 )
	info.Paint = function()
		surface.SetDrawColor( 0, 0, 0, 64 )
		surface.DrawRect( 0, info:GetWide() / 2 + 8 + 36 + 8, info:GetWide(), 1 )
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.DrawRect( 0, 0, info:GetWide(), 48 )
		surface.SetDrawColor( 0, 0, 0, 128 )
		surface.DrawRect( 0, 0, 1, info:GetTall() )
	end

	info.PaintOver = function()
		surface.SetTexture( gradient )
		surface.SetDrawColor( 0, 0, 0, 164 )
		surface.DrawTexturedRectRotated( info:GetWide() / 2, info:GetWide() / 2 + 8 + 36 + 8 + 4, 8, info:GetWide(), 270 )
	end

	local model = vgui.Create( "DModelPanel", info )
	model.restricted = false
	model.name = ""
	model:SetSize( info:GetWide(), info:GetWide() / 2 )
	model:SetCamPos( Vector( -45, 0, 0 ) )
	model:SetLookAt( Vector( 0, 0, 5 ) )
	model._Paint = model.Paint
	model.Paint = function( self, ... )
		self._Paint( self, ... )
		surface.SetDrawColor( 0, 0, 0, 64 )
		surface.DrawRect( 0, model:GetTall() - 1, model:GetWide(), 1 )
	end
	model.PaintOver = function()
		if model.restricted == true then
			surface.SetDrawColor( 0, 0, 0, 164 )
			surface.DrawRect( 0, 0, model:GetWide(), model:GetTall() )
			draw.SimpleText( "LOCKED", "Exo 2", model:GetWide() / 2 + 1, model:GetTall() / 2 + 2 + 1, Color( 0, 0, 0 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
			draw.SimpleText( "LOCKED", "Exo 2", model:GetWide() / 2, model:GetTall() / 2 + 2, GetTeamColor(), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
		end
		draw.SimpleText( model.name, "Exo 2 Button", model:GetWide() / 2 + 1, model:GetTall() / 2 + 2 + 1, Color( 0, 0, 0 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM )
		draw.SimpleText( model.name, "Exo 2 Button", model:GetWide() / 2, model:GetTall() / 2 + 2, GetTeamColor(), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM )
	end
	function model:LayoutEntity( ent )
		ent:SetAngles( Angle( 0, 90, 0 ) )
	end

	net.Start( "RequestWeapons" ) --logan
	net.SendToServer()
	local received = false

	local function DoNothing() end
	local primaries = vgui.Create( "DScrollPanel", choose )
	local secondaries = vgui.Create( "DScrollPanel", choose )
	local equipment = vgui.Create( "DScrollPanel", choose )
	local perks = vgui.Create( "DScrollPanel", choose )

	local sBar = primaries:GetVBar()
	sBar.Paint = DoNothing()
	sBar.btnUp.Paint = DoNothing()
	sBar.btnDown.Paint = DoNothing()
	function sBar.btnGrip:Paint( w, h )
		draw.RoundedBox( 4, 7, 0, w / 2, h, Color( 0, 0, 0, 128 ) )
	end

	sBar = secondaries:GetVBar()
	sBar.Paint = DoNothing()
	sBar.btnUp.Paint = DoNothing()
	sBar.btnDown.Paint = DoNothing()
	function sBar.btnGrip:Paint( w, h )
		draw.RoundedBox( 4, 7, 0, w / 2, h, Color( 0, 0, 0, 128 ) )
	end

	sBar = equipment:GetVBar()
	sBar.Paint = DoNothing()
	sBar.btnUp.Paint = DoNothing()
	sBar.btnDown.Paint = DoNothing()
	function sBar.btnGrip:Paint( w, h )
		draw.RoundedBox( 4, 7, 0, w / 2, h, Color( 0, 0, 0, 128 ) )
	end

	sBar = perks:GetVBar()
	sBar.Paint = DoNothing()
	sBar.btnUp.Paint = DoNothing()
	sBar.btnDown.Paint = DoNothing()
	function sBar.btnGrip:Paint( w, h )
		draw.RoundedBox( 4, 7, 0, w / 2, h, Color( 0, 0, 0, 128 ) )
	end

	local pri = choose:AddSheet( "Primaries", primaries )
	pri.ID = 0
	local sec = choose:AddSheet( "Secondaries", secondaries )
	sec.ID = 1
	local equ = choose:AddSheet( "Equipment", equipment )
	equ.ID = 2
	local per = choose:AddSheet( "Perks", perks ) --Change here?
	per.ID = 3

	for k, v in pairs( choose.Items ) do
		if ( !v.Tab ) then continue end

		v.Tab.Paint = function() return true end
	end

	local primaryequip, secondaryequip, equipmentequip, perkequip = NULL, NULL, NULL, { NULL, NULL }
	local primaryselect, secondaryselect = {}, {}
	local selectsound = {
		"ambient/machines/keyboard2_clicks.wav",
		"ambient/machines/keyboard3_clicks.wav",
		"ambient/machines/keyboard1_clicks.wav",
		"ambient/machines/keyboard4_clicks.wav",
		"ambient/machines/keyboard5_clicks.wav",
		"ambient/machines/keyboard6_clicks.wav",
		"ambient/machines/keyboard7_clicks_enter.wav"
	}
	local button, weps = {}, {}

	local buy = vgui.Create( "DButton", info )
	buy.Hover = false
	buy.Click = false
	buy.restricted = 1
	buy.selected = ""
	buy.price = 0
	buy:SetSize( 88, 36 )
	buy:SetPos( info:GetWide() - buy:GetWide() - 8, model:GetTall() + 8 )
	buy.Paint = function()
		if buy.restricted == 2 then
			if buy.Hover == false then
				draw.RoundedBox( 2, 4, 4, buy:GetWide() - 8, buy:GetTall() - 8, Color( 0, 0, 0, 255 / 10 ) )
			elseif buy.Click == true then
				draw.RoundedBox( 2, 4, 4, buy:GetWide() - 8, buy:GetTall() - 8, Color( 0, 0, 0, 255 / 2.5 ) )
			else
				draw.RoundedBox( 2, 4, 4, buy:GetWide() - 8, buy:GetTall() - 8, Color( 0, 0, 0, 255 / 4 ) )
			end
			draw.SimpleText( "DONATE", "Exo 2 Button", buy:GetWide() / 2, buy:GetTall() / 2, GetTeamColor(), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		else
			if buy.restricted ~= 1 then
				if buy.Hover == false then
					draw.RoundedBox( 2, 4, 4, buy:GetWide() - 8, buy:GetTall() - 8, Color( 0, 0, 0, 255 / 10 ) )
				elseif buy.Click == true then
					draw.RoundedBox( 2, 4, 4, buy:GetWide() - 8, buy:GetTall() - 8, Color( 0, 0, 0, 255 / 2.5 ) )
				else
					draw.RoundedBox( 2, 4, 4, buy:GetWide() - 8, buy:GetTall() - 8, Color( 0, 0, 0, 255 / 4 ) )
				end
				draw.SimpleText( "BUY", "Exo 2 Button", buy:GetWide() / 2, buy:GetTall() / 2, GetTeamColor(), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			else
				draw.RoundedBox( 2, 4, 4, buy:GetWide() - 8, buy:GetTall() - 8, Color( 0, 0, 0, 255 * 0.12 * 2.75 ) )
				draw.SimpleText( "BUY", "Exo 2 Button", buy:GetWide() / 2, buy:GetTall() / 2, Color( 0, 0, 0, 255 * 0.26 * 2.75 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			end
		end
		return true
	end

	buy.OnCursorEntered = function()
		buy.Hover = true
	end
	buy.OnCursorExited = function()
		buy.Hover = false
	end
	buy.OnMousePressed = function()
		LocalPlayer():EmitSound( "buttons/button22.wav" )
		buy.Click = true
	end
	buy.OnMouseReleased = function()
		buy.Click = false
		if buy.restricted == 2 then
			gui.OpenURL( "http://amrcommunity.com/donate" )
			return
		end
		if buy.restricted == 1 then
			return
		end
		if buy.selected == "" then
			return
		end
		if ( not table.HasValue( weps, buy.selected ) ) and buy.price ~= "0" and CurrentMoneyAmt >= tonumber( buy.price ) then
			if button[ buy.selected ].haventbought ~= true then
				return
			end					
			if CurrentMoneyAmt >= tonumber( buy.price ) then
				buying = true
				net.Start( "BuyShit" ) --logan
					net.WriteString( tostring( buy.selected ) )
					net.WriteString( tostring( buy.price ) )
				net.SendToServer()
				net.Receive( "BuyShitCallback", function()
					local num = tonumber( net.ReadString() )
					CurrentMoneyAmt = num
					net.Start( "GetCurWeapons" )
					net.SendToServer()
					net.Receive( "GetCurWeaponsCallback", function()
						weps = net.ReadTable()
					end )
				end )
				surface.PlaySound( "ambient/levels/labs/coinslot1.wav" )
				button[ buy.selected ].Purchased = true
				buy.restricted = 1
				model.restricted = false
			else
				LocalPlayer():EmitSound( "buttons/combine_button_locked.wav" )
			end
		end
	end

	local money = vgui.Create( "DShape", info )
	local x, y = buy:GetPos()
	money:SetPos( 0, info:GetWide() / 2 + 8 )
	money:SetSize( info:GetWide(), 36 )
	money.Paint = function()
		if !isnumber( CurrentMoneyAmt ) then
			draw.SimpleText( CurrentMoneyAmt, "Exo 2", x - 8, money:GetTall() / 2 - 2, GetTeamColor(), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
		else
			draw.SimpleText( "$" .. comma_value( CurrentMoneyAmt ), "Exo 2", x - 8, money:GetTall() / 2 - 8, GetTeamColor(), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
			draw.SimpleText( "Level " .. CurrentLevel, "Exo 2 Tab", x - 8, money:GetTall() / 2 + 16, GetTeamColor(), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP )
		end
		return true
	end

	local damagelabel = vgui.Create( "DLabel", info )
	damagelabel:SetPos( 8, model:GetTall() + buy:GetTall() + 18 )
	damagelabel:SetColor( Color( 0, 0, 0, 255 ) )
	damagelabel:SetFont( "Exo 2" )
	damagelabel:SetText( "Damage" )
	damagelabel:SizeToContents()

	local damageunder = vgui.Create( "DShape", info )
	local x, y = damagelabel:GetPos()
	damageunder:SetType( "Rect" )
	damageunder:SetPos( 8, y + 24 + 4 )
	damageunder:SetSize( info:GetWide() - 16, 12 )
	damageunder:SetColor( Color( GetTeamColor().r, GetTeamColor().g, GetTeamColor().b, 64 ) )

	local damage = vgui.Create( "DShape", info )
	damage.value = {}
	damage.value.display = 0
	damage.value.real = 0
	damage.width = {}
	damage.width.min = info:GetWide() - 16
	damage.width.max = info:GetWide() - 16
	damage:SetType( "Rect" )
	damage:SetPos( 8, y + 24 + 4 )
	damage:SetSize( damage.width.min, 12 )
	damage:SetColor( GetTeamColor() )
	damage.Think = function()
		damage.value.display = Lerp( FrameTime() * 16, damage.value.display, math.Clamp( damage.value.real, 1, 100 ) )
		damage.width.min = Lerp( FrameTime() * 16, damage.width.min, damage.width.max * ( damage.value.display / 100 ) )

		damage:SetSize( damage.width.min, 12 )
	end

	local accuracylabel = vgui.Create( "DLabel", info )
	local x, y = damage:GetPos()
	accuracylabel:SetPos( 8, y + damage:GetTall() + 8 )
	accuracylabel:SetColor( Color( 0, 0, 0, 255 ) )
	accuracylabel:SetFont( "Exo 2" )
	accuracylabel:SetText( "Accuracy" )
	accuracylabel:SizeToContents()

	local accuracyunder = vgui.Create( "DShape", info )
	local x, y = accuracylabel:GetPos()
	accuracyunder:SetType( "Rect" )
	accuracyunder:SetPos( 8, y + 24 + 4 )
	accuracyunder:SetSize( info:GetWide() - 16, 12 )
	accuracyunder:SetColor( Color( GetTeamColor().r, GetTeamColor().g, GetTeamColor().b, 64 ) )

	local accuracy = vgui.Create( "DShape", info )
	accuracy.value = {}
	accuracy.value.display = 0
	accuracy.value.real = 0
	accuracy.width = {}
	accuracy.width.min = info:GetWide() - 16
	accuracy.width.max = info:GetWide() - 16
	accuracy:SetType( "Rect" )
	accuracy:SetPos( 8, y + 24 + 4 )
	accuracy:SetSize( accuracy.width.min, 12 )
	accuracy:SetColor( GetTeamColor() )
	accuracy.Think = function()
		accuracy.value.display = Lerp( FrameTime() * 16, accuracy.value.display, math.Clamp( accuracy.value.real, 1, 100 ) )
		accuracy.width.min = Lerp( FrameTime() * 16, accuracy.width.min, accuracy.width.max * ( accuracy.value.display / 100 ) )

		accuracy:SetSize( accuracy.width.min, 12 )
	end

	local roflabel = vgui.Create( "DLabel", info )
	local x, y = accuracy:GetPos()
	roflabel:SetPos( 8, y + accuracy:GetTall() + 8 )
	roflabel:SetColor( Color( 0, 0, 0, 255 ) )
	roflabel:SetFont( "Exo 2" )
	roflabel:SetText( "Rate of Fire" )
	roflabel:SizeToContents()

	local rofunder = vgui.Create( "DShape", info )
	local x, y = roflabel:GetPos()
	rofunder:SetType( "Rect" )
	rofunder:SetPos( 8, y + 24 + 4 )
	rofunder:SetSize( info:GetWide() - 16, 12 )
	rofunder:SetColor( Color( GetTeamColor().r, GetTeamColor().g, GetTeamColor().b, 64 ) )

	local rof = vgui.Create( "DShape", info )
	rof.value = {}
	rof.value.display = 0
	rof.value.real = 0
	rof.width = {}
	rof.width.min = info:GetWide() - 16
	rof.width.max = info:GetWide() - 16
	rof:SetType( "Rect" )
	rof:SetPos( 8, y + 24 + 4 )
	rof:SetSize( rof.width.min, 12 )
	rof:SetColor( GetTeamColor() )
	rof.Think = function()
		rof.value.display = Lerp( FrameTime() * 16, rof.value.display, math.Clamp( rof.value.real, 1, 100 ) )
		rof.width.min = Lerp( FrameTime() * 16, rof.width.min, rof.width.max * ( rof.value.display / 100 ) )

		rof:SetSize( rof.width.min, 12 )
	end

	local hint = vgui.Create( "DTextEntry", info )
	hint:SetPos( 8, info:GetWide() / 2 + 8 + 36 + 8 + 8 )
	hint:SetSize( info:GetWide() - 16, info:GetWide() / 2 + 14 )
	hint:SetFont( "Exo 2 Hint" )
	hint:SetText( "" )
	hint:SetEditable( false )
	hint:SetMultiline( true )
	hint:SetVisible( false )
	hint.Paint = function( self )
		surface.SetDrawColor( 255, 255, 255 )
		surface.DrawRect( 0, 0, hint:GetWide(), hint:GetTall() )
		if hint:GetText() ~= "" then
			self:DrawTextEntryText( GetTeamColor(), Color( 255, 255, 255 ), Color( 255, 255, 255 ) )
		else
			draw.SimpleText( "No Description", "Exo 2 Hint Empty", hint:GetWide() / 2, hint:GetTall() / 2, Color( 0, 0, 0, 164 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
	end

	local function ClearInfo()
		model:SetModel( "" )
		model.restricted = false
		model.name = ""
		damage.value.real = 0
		accuracy.value.real = 0
		rof.value.real = 0
		buy.restricted = 1
		hint:SetText( "" )
	end

	local primariesbutton = vgui.Create( "DButton", main )
	primariesbutton:SetSize( choose:GetWide() / 4, 48 )
	primariesbutton:SetPos( choose:GetWide() / 4 * 0, 56 )
	primariesbutton.Paint = function()
		draw.SimpleText( "PRIMARIES", "Exo 2 Tab", primariesbutton:GetWide() / 2, primariesbutton:GetTall() / 2, FontColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		return true
	end
	primariesbutton.DoClick = function()
		choose:SetActiveTab( pri.Tab )
		LocalPlayer():EmitSound( "buttons/button22.wav" )
		ClearInfo()
		hint:SetVisible( false )
	end

	local secondariesbutton = vgui.Create( "DButton", main )
	secondariesbutton:SetSize( choose:GetWide() / 4, 48 )
	secondariesbutton:SetPos( choose:GetWide() / 4 * 1, 56 )
	secondariesbutton.Paint = function()
		draw.SimpleText( "SECONDARIES", "Exo 2 Tab", secondariesbutton:GetWide() / 2, secondariesbutton:GetTall() / 2, FontColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		return true
	end
	secondariesbutton.DoClick = function()
		choose:SetActiveTab( sec.Tab )
		LocalPlayer():EmitSound( "buttons/button22.wav" )
		ClearInfo()
		hint:SetVisible( false )
	end

	local equipmentbutton = vgui.Create( "DButton", main )
	equipmentbutton:SetSize( choose:GetWide() / 4, 48 )
	equipmentbutton:SetPos( choose:GetWide() / 4 * 2, 56 )
	equipmentbutton.Paint = function()
		draw.SimpleText( "EQUIPMENT", "Exo 2 Tab", equipmentbutton:GetWide() / 2, equipmentbutton:GetTall() / 2, FontColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		return true
	end
	equipmentbutton.DoClick = function()
		choose:SetActiveTab( equ.Tab )
		LocalPlayer():EmitSound( "buttons/button22.wav" )
		ClearInfo()
		hint:SetVisible( true )
	end

	local perksbutton = vgui.Create( "DButton", main )
	perksbutton:SetSize( choose:GetWide() / 4, 48 )
	perksbutton:SetPos( choose:GetWide() / 4 * 3, 56 )
	perksbutton.Paint = function()
		draw.SimpleText( "PERKS", "Exo 2 Tab", perksbutton:GetWide() / 2, perksbutton:GetTall() / 2, FontColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		return true
	end
	perksbutton.DoClick = function()
		choose:SetActiveTab( per.Tab )
		LocalPlayer():EmitSound( "buttons/button22.wav" )
		ClearInfo()
		hint:SetVisible( true )
	end

	local buttonindicator = vgui.Create( "DShape", main )
	local x = 0
	buttonindicator:SetType( "Rect" )
	buttonindicator:SetPos( 0, 46 + 56 )
	buttonindicator:SetSize( choose:GetWide() / 4, 2 )
	buttonindicator:SetColor( colorScheme[LocalPlayer():Team()]["ButtonIndicator"] )
	buttonindicator.Think = function()
		for k, v in pairs( choose.Items ) do
			if ( !v.Tab ) then continue end

			if v.Tab == choose:GetActiveTab() then
				x = Lerp( FrameTime() * 12, x, choose:GetWide() / 4 * v.ID )
				break
			end
		end
		buttonindicator:SetPos( x, 46 + 56 )
	end

	net.Receive( "RequestWeaponsCallback", function() --logan
		local p = net.ReadTable()
		local s = net.ReadTable()
		local e = net.ReadTable()
		local per = net.ReadTable()
		primariestable = p
		secondariestable = s
		extrastable = e
		perkstable = per
		net.Start( "GetRank" )
		net.SendToServer()
		net.Receive( "GetRankCallback", function()
		local num = tonumber( net.ReadString() )
		CurrentLevel = num
		net.Start( "GetCurWeapons" )
		net.SendToServer()
		net.Receive( "GetCurWeaponsCallback", function()
		weps = net.ReadTable()
		net.Start( "GetMoney" )
		net.SendToServer()
		net.Receive( "GetMoneyCallback", function()
		CurrentMoneyAmt = tonumber( net.ReadString() )
		net.Start( "GetUserGroupRank" )
		net.SendToServer()
		net.Receive( "GetUserGroupRankCallback", function()
		local vip = 0 --tonumber( net.ReadString() )
        received = true
        -- PRIMARIES --
        for i, v in next, primariestable do
            --    Name,     _name,  Level,                           Model,   Cost
            -- "AK-74", "cw_ak74",      0, "models/weapons/w_rif_ak47.mdl",      0
            --  v[ 1 ],    v[ 2 ], v[ 3 ],                          v[ 4 ], v[ 5 ]
            button[ v[ 2 ] ] = vgui.Create( "DButton", primaries )
            button[ v[ 2 ] ].isVIP = false
            local blv        = v[ 3 ]
            button[ v[ 2 ] ].alpha = 0
            button[ v[ 2 ] ].CursorHover = false
            button[ v[ 2 ] ]:SetPos( 0, 72 * ( i - 1 ) )
            button[ v[ 2 ] ]:SetSize( choose:GetWide() - 30, 72 )
            button[ v[ 2 ] ].Think = function()
                if not button[ v[ 2 ] ].CursorHover then
                    button[ v[ 2 ] ].alpha = Lerp( FrameTime() * 20, button[ v[ 2 ] ].alpha, 0 )
                else
                    button[ v[ 2 ] ].alpha = Lerp( FrameTime() * 20, button[ v[ 2 ] ].alpha, 164 )
                end
            end
            button[ v[ 2 ] ].Paint = function()
                if i ~= #primariestable then
                    surface.SetDrawColor( 0, 0, 0, 64 )
                    surface.DrawRect( 72, 71, button[ v[ 2 ] ]:GetWide(), 1 )
                end
                surface.SetFont( "Exo 2" )
                surface.SetTextColor( 0, 0, 0, 255 )
                surface.SetTextPos( 72, 16 )
                surface.DrawText( v[ 1 ] )
                if blv > num and blv <= 200 and vip < 203 then
                    surface.SetDrawColor( 213, 0, 0, 255 )
                    surface.SetMaterial( locked )
                    surface.DrawTexturedRect( 16, 16, 40, 40 )
                    surface.SetFont( "Exo 2 Subhead" )
                    surface.SetTextColor( 213, 0, 0, 255 )
                    surface.SetTextPos( 72, 40 )
                    surface.DrawText( "Level " .. v[ 3 ] .. " is required." )
                    button[ v[ 2 ] ].restricted = true
                    button[ v[ 2 ] ].haventbought = false
                elseif primaryequip == v[ 2 ] then
                    surface.SetDrawColor( 56, 142, 60, 255 )
                    surface.SetMaterial( bought )
                    surface.DrawTexturedRect( 16, 16, 40, 40 )
                    button[ v[ 2 ] ].restricted = false
                    button[ v[ 2 ] ].haventbought = false
                else
                    if ( not table.HasValue( weps, v[ 2 ] ) ) and v[ 5 ] ~= 0 then
                        if button[ v[ 2 ] ].Purchased ~= true then
                            if CurrentMoneyAmt >= tonumber( v[ 5 ] ) then
                                surface.SetDrawColor( 56, 142, 60, 255 )
                                surface.SetMaterial( unlock )
                                surface.DrawTexturedRect( 16, 16, 40, 40 )
                                surface.SetFont( "Exo 2 Subhead" )
                                surface.SetTextColor( 56, 142, 60, 255 )
                                surface.SetTextPos( 72, 40 )
                                surface.DrawText( "$" .. comma_value( v[ 5 ]) )
                            else
                                surface.SetDrawColor( 213, 0, 0, 255 )
                                surface.SetMaterial( unlock )
                                surface.DrawTexturedRect( 16, 16, 40, 40 )
                                surface.SetFont( "Exo 2 Subhead" )
                                surface.SetTextColor( 213, 0, 0, 255 )
                                surface.SetTextPos( 72, 40 )
                                surface.DrawText( "$" .. comma_value( v[ 5 ]) )
                            end
                        end
                        button[ v[ 2 ] ].restricted = true
                        button[ v[ 2 ] ].haventbought = true
                    else
                        if blv > 200 then
                            button[ v[ 2 ] ].isVIP = true
                            if blv == 201 and vip < 201 then
                                surface.SetDrawColor( 213, 0, 0, 255 )
                                surface.SetMaterial( locked )
                                surface.DrawTexturedRect( 16, 16, 40, 40 )
                                surface.SetFont( "Exo 2 Subhead" )
                                surface.SetTextColor( 213, 0, 0, 255 )
                                surface.SetTextPos( 72, 40 )
                                surface.DrawText( "VIP Rank is required." )
                                button[ v[ 2 ] ].restricted = true
                                button[ v[ 2 ] ].haventbought = false
                            elseif blv == 202 and vip < 202 then
                                surface.SetDrawColor( 213, 0, 0, 255 )
                                surface.SetMaterial( locked )
                                surface.DrawTexturedRect( 16, 16, 40, 40 )
                                surface.SetFont( "Exo 2 Subhead" )
                                surface.SetTextColor( 213, 0, 0, 255 )
                                surface.SetTextPos( 72, 40 )
                                surface.DrawText( "VIP+ Rank is required." )
                                button[ v[ 2 ] ].restricted = true
                                button[ v[ 2 ] ].haventbought = false
                            elseif blv == 203 and vip < 203 then
                                surface.SetDrawColor( 213, 0, 0, 255 )
                                surface.SetMaterial( locked )
                                surface.DrawTexturedRect( 16, 16, 40, 40 )
                                surface.SetFont( "Exo 2 Subhead" )
                                surface.SetTextColor( 213, 0, 0, 255 )
                                surface.SetTextPos( 72, 40 )
                                surface.DrawText( "Ultra VIP Rank is required." )
                                button[ v[ 2 ] ].restricted = true
                                button[ v[ 2 ] ].haventbought = false
                            elseif blv == 204 and vip < 204 then
                                surface.SetDrawColor( 213, 0, 0, 255 )
                                surface.SetMaterial( locked )
                                surface.DrawTexturedRect( 16, 16, 40, 40 )
                                surface.SetFont( "Exo 2 Subhead" )
                                surface.SetTextColor( 213, 0, 0, 255 )
                                surface.SetTextPos( 72, 40 )
                                surface.DrawText( "Staff Rank is required." )
                                button[ v[ 2 ] ].restricted = true
                                button[ v[ 2 ] ].haventbought = false
                            elseif blv == 205 then
                                surface.SetDrawColor( 213, 0, 0, 255 )
                                surface.SetMaterial( locked )
                                surface.DrawTexturedRect( 16, 16, 40, 40 )
                                surface.SetFont( "Exo 2 Subhead" )
                                surface.SetTextColor( 213, 0, 0, 255 )
                                surface.SetTextPos( 72, 40 )
                                surface.DrawText( "Head Admin Rank is required" )
                                button[ v[ 2 ] ].restricted = true
                                button[ v[ 2 ] ].haventbought = false
                            elseif blv >= 206 then
                                surface.SetDrawColor( 255, 215, 64, 255 )
                                surface.SetMaterial( unlock )
                                surface.DrawTexturedRect( 16, 16, 40, 40 )
                                surface.SetFont( "Exo 2 Subhead" )
                                surface.SetTextColor( 255, 215, 64, 255 )
                                surface.SetTextPos( 72, 40 )
                                surface.DrawText( "Unlocked due to an event." )
                                button[ v[ 2 ] ].isVIP = false
                                button[ v[ 2 ] ].restricted = false
                                button[ v[ 2 ] ].haventbought = false
                            else
                                button[ v[ 2 ] ].restricted = false						
                                button[ v[ 2 ] ].haventbought = false
                            end
                        else
                            button[ v[ 2 ] ].restricted = false						
                            button[ v[ 2 ] ].haventbought = false
                        end
                    end
                end
                return true
            end
            button[ v[ 2 ] ].DoClick = function()
                if not ( button[ v[ 2 ] ].restricted ) then
                    LocalPlayer():EmitSound( selectsound[ math.random( 1, #selectsound ) ] )
                    primaryequip = v[ 2 ]
                    primaryselect = v[ 6 ] and v[ 6 ] or { 0, 0, 0 }
                    damage.value.real   = primaryselect[ 1 ]
                    accuracy.value.real = primaryselect[ 2 ]
                    rof.value.real      = primaryselect[ 3 ]
                    model:SetModel( v[ 4 ] )
                    model.restricted = false
                    model.name = v[ 1 ]
                    buy.restricted = 1
                else
                    LocalPlayer():EmitSound( "buttons/combine_button_locked.wav" )
                    model:SetModel( v[ 4 ] )
                    model.restricted = true
                    model.name = v[ 1 ]
                    primaryselect = v[ 6 ] and v[ 6 ] or { 0, 0, 0 }
                    damage.value.real   = primaryselect[ 1 ]
                    accuracy.value.real = primaryselect[ 2 ]
                    rof.value.real      = primaryselect[ 3 ]
                    if button[ v[ 2 ] ].isVIP == true then
                        buy.restricted = 2
                        return
                    end
                    if button[ v[ 2 ] ].Purchased ~= true then
                        if CurrentMoneyAmt < tonumber( v[ 5 ] ) then
                            buy.restricted = 1
                            return
                        end
                        if blv > num and blv <= 200 and vip < 203 then
                            buy.restricted = 1
                            return
                        end
                        buy.restricted = 0
                        buy.selected = v[ 2 ]
                        buy.price = v[ 5 ]
                    end
                end			
            end
            button[ v[ 2 ] ].OnCursorEntered = function()
                button[ v[ 2 ] ].CursorHover = true
            end
            button[ v[ 2 ] ].OnCursorExited = function()
                button[ v[ 2 ] ].CursorHover = false
            end

            local buttonhovertop = vgui.Create( "DShape", primaries )
            buttonhovertop:SetType( "Rect" )
            buttonhovertop:SetPos( 0, 72 * ( i - 1 ) - 8 )
            buttonhovertop:SetSize( choose:GetWide() - 30, 8 )

            buttonhovertop.Paint = function()
                surface.SetTexture( gradient )
                surface.SetDrawColor( 0, 0, 0, button[ v[ 2 ] ].alpha )
                surface.DrawTexturedRectRotated( buttonhovertop:GetWide() / 2, 4, 8, buttonhovertop:GetWide(), 90 )
            end

            if i ~= #primariestable then
                local buttonhoverbottom = vgui.Create( "DShape", primaries )
                buttonhoverbottom:SetType( "Rect" )
                buttonhoverbottom:SetPos( 0, 72 * ( i ) - 1 )
                buttonhoverbottom:SetSize( choose:GetWide() - 30, 8 )

                buttonhoverbottom.Paint = function()
                    surface.SetTexture( gradient )
                    surface.SetDrawColor( 0, 0, 0, button[ v[ 2 ] ].alpha )
                    surface.DrawTexturedRectRotated( buttonhoverbottom:GetWide() / 2, 4, 8, buttonhoverbottom:GetWide(), 270 )
                end
            end
            
            primariestable[i]["Button"] = button[v[2]];
            
            hook.Add("PrimaryForceSelect", "pforceselect_" .. v[2], function(class)
                if v[2] != class then return end
                button[v[2]]:DoClick();
            end)
        end 

        -- SECONDARIES --
        for i, v in next, secondariestable do
            button[ v[ 2 ] ] = vgui.Create( "DButton", secondaries )
            button[ v[ 2 ] ].isVIP = false
            local blv        = v[ 3 ]
            button[ v[ 2 ] ].alpha = 0
            button[ v[ 2 ] ].CursorHover = false
            button[ v[ 2 ] ]:SetPos( 0, 72 * ( i - 1 ) )
            button[ v[ 2 ] ]:SetSize( choose:GetWide() - 30, 72 )
            button[ v[ 2 ] ].Think = function()
                if not button[ v[ 2 ] ].CursorHover then
                    button[ v[ 2 ] ].alpha = Lerp( FrameTime() * 20, button[ v[ 2 ] ].alpha, 0 )
                else
                    button[ v[ 2 ] ].alpha = Lerp( FrameTime() * 20, button[ v[ 2 ] ].alpha, 164 )
                end
            end
            button[ v[ 2 ] ].Paint = function()
                if i ~= #secondariestable then
                    surface.SetDrawColor( 0, 0, 0, 64 )
                    surface.DrawRect( 72, 71, button[ v[ 2 ] ]:GetWide(), 1 )
                end
                surface.SetFont( "Exo 2" )
                surface.SetTextColor( 0, 0, 0, 255 )
                surface.SetTextPos( 72, 16 )
                surface.DrawText( v[ 1 ] )
                if blv > num and blv <= 100 and vip < 203 then
                    surface.SetDrawColor( 213, 0, 0, 255 )
                    surface.SetMaterial( locked )
                    surface.DrawTexturedRect( 16, 16, 40, 40 )
                    surface.SetFont( "Exo 2 Subhead" )
                    surface.SetTextColor( 213, 0, 0, 255 )
                    surface.SetTextPos( 72, 40 )
                    surface.DrawText( "Level " .. v[ 3 ] .. " is required." )
                    button[ v[ 2 ] ].restricted = true
                    button[ v[ 2 ] ].haventbought = false
                elseif secondaryequip == v[ 2 ] then
                    surface.SetDrawColor( 56, 142, 60, 255 )
                    surface.SetMaterial( bought )
                    surface.DrawTexturedRect( 16, 16, 40, 40 )
                    button[ v[ 2 ] ].restricted = false
                    button[ v[ 2 ] ].haventbought = false
                else
                    if ( not table.HasValue( weps, v[ 2 ] ) ) and v[ 5 ] ~= 0 then
                        if button[ v[ 2 ] ].Purchased ~= true then
                            if CurrentMoneyAmt >= tonumber( v[ 5 ] ) then
                                surface.SetDrawColor( 56, 142, 60, 255 )
                                surface.SetMaterial( unlock )
                                surface.DrawTexturedRect( 16, 16, 40, 40 )
                                surface.SetFont( "Exo 2 Subhead" )
                                surface.SetTextColor( 56, 142, 60, 255 )
                                surface.SetTextPos( 72, 40 )
                                surface.DrawText( "$" .. comma_value( v[ 5 ]) )
                            else
                                surface.SetDrawColor( 213, 0, 0, 255 )
                                surface.SetMaterial( unlock )
                                surface.DrawTexturedRect( 16, 16, 40, 40 )
                                surface.SetFont( "Exo 2 Subhead" )
                                surface.SetTextColor( 213, 0, 0, 255 )
                                surface.SetTextPos( 72, 40 )
                                surface.DrawText( "$" .. comma_value( v[ 5 ]) )
                            end
                        end
                        button[ v[ 2 ] ].restricted = true
                        button[ v[ 2 ] ].haventbought = true
                    else
                        if blv > 200 then
                            button[ v[ 2 ] ].isVIP = true
                            if blv == 201 and vip < 201 then
                                surface.SetDrawColor( 213, 0, 0, 255 )
                                surface.SetMaterial( locked )
                                surface.DrawTexturedRect( 16, 16, 40, 40 )
                                surface.SetFont( "Exo 2 Subhead" )
                                surface.SetTextColor( 213, 0, 0, 255 )
                                surface.SetTextPos( 72, 40 )
                                surface.DrawText( "VIP Rank is required." )
                                button[ v[ 2 ] ].restricted = true
                                button[ v[ 2 ] ].haventbought = false
                            elseif blv == 202 and vip < 202 then
                                surface.SetDrawColor( 213, 0, 0, 255 )
                                surface.SetMaterial( locked )
                                surface.DrawTexturedRect( 16, 16, 40, 40 )
                                surface.SetFont( "Exo 2 Subhead" )
                                surface.SetTextColor( 213, 0, 0, 255 )
                                surface.SetTextPos( 72, 40 )
                                surface.DrawText( "VIP+ Rank is required." )
                                button[ v[ 2 ] ].restricted = true
                                button[ v[ 2 ] ].haventbought = false
                            elseif blv == 203 and vip < 203 then
                                surface.SetDrawColor( 213, 0, 0, 255 )
                                surface.SetMaterial( locked )
                                surface.DrawTexturedRect( 16, 16, 40, 40 )
                                surface.SetFont( "Exo 2 Subhead" )
                                surface.SetTextColor( 213, 0, 0, 255 )
                                surface.SetTextPos( 72, 40 )
                                surface.DrawText( "Ultra VIP Rank is required." )
                                button[ v[ 2 ] ].restricted = true
                                button[ v[ 2 ] ].haventbought = false
                            elseif blv == 204 and vip < 204 then
                                surface.SetDrawColor( 213, 0, 0, 255 )
                                surface.SetMaterial( locked )
                                surface.DrawTexturedRect( 16, 16, 40, 40 )
                                surface.SetFont( "Exo 2 Subhead" )
                                surface.SetTextColor( 213, 0, 0, 255 )
                                surface.SetTextPos( 72, 40 )
                                surface.DrawText( "Staff Rank is required." )
                                button[ v[ 2 ] ].restricted = true
                                button[ v[ 2 ] ].haventbought = false
                            elseif blv == 205 then
                                surface.SetDrawColor( 213, 0, 0, 255 )
                                surface.SetMaterial( locked )
                                surface.DrawTexturedRect( 16, 16, 40, 40 )
                                surface.SetFont( "Exo 2 Subhead" )
                                surface.SetTextColor( 213, 0, 0, 255 )
                                surface.SetTextPos( 72, 40 )
                                surface.DrawText( "Unavailable." )
                                button[ v[ 2 ] ].isVIP = false
                                button[ v[ 2 ] ].restricted = true
                                button[ v[ 2 ] ].haventbought = false
                            elseif blv >= 206 then
                                surface.SetDrawColor( 255, 215, 64, 255 )
                                surface.SetMaterial( unlock )
                                surface.DrawTexturedRect( 16, 16, 40, 40 )
                                surface.SetFont( "Exo 2 Subhead" )
                                surface.SetTextColor( 255, 215, 64, 255 )
                                surface.SetTextPos( 72, 40 )
                                surface.DrawText( "Unlocked due to an event." )
                                button[ v[ 2 ] ].isVIP = false
                                button[ v[ 2 ] ].restricted = false
                                button[ v[ 2 ] ].haventbought = false
                            else
                                button[ v[ 2 ] ].restricted = false						
                                button[ v[ 2 ] ].haventbought = false
                            end
                        else
                            button[ v[ 2 ] ].restricted = false						
                            button[ v[ 2 ] ].haventbought = false
                        end
                    end
                end
                return true
            end
            button[ v[ 2 ] ].DoClick = function()
                if not ( button[ v[ 2 ] ].restricted ) then
                    LocalPlayer():EmitSound( selectsound[ math.random( 1, #selectsound ) ] )
                    secondaryequip = v[ 2 ]
                    secondaryselect = v[ 6 ] and v[ 6 ] or { 0, 0, 0 }
                    damage.value.real   = secondaryselect[ 1 ]
                    accuracy.value.real = secondaryselect[ 2 ]
                    rof.value.real      = secondaryselect[ 3 ]
                    model:SetModel( v[ 4 ] )
                    model.restricted = false
                    model.name = v[ 1 ]
                    buy.restricted = 1
                else
                    LocalPlayer():EmitSound( "buttons/combine_button_locked.wav" )
                    model:SetModel( v[ 4 ] )
                    model.restricted = true
                    model.name = v[ 1 ]
                    secondaryselect = v[ 6 ] and v[ 6 ] or { 0, 0, 0 }
                    damage.value.real   = secondaryselect[ 1 ]
                    accuracy.value.real = secondaryselect[ 2 ]
                    rof.value.real      = secondaryselect[ 3 ]
                    if button[ v[ 2 ] ].isVIP == true then
                        buy.restricted = 2
                        return
                    end
                    if button[ v[ 2 ] ].Purchased ~= true then
                        if CurrentMoneyAmt < tonumber( v[ 5 ] ) then
                            buy.restricted = 1
                            return
                        end
                        if blv > num and blv <= 100 and vip < 203 then
                            buy.restricted = 1
                            return
                        end
                        buy.restricted = 0
                        buy.selected = v[ 2 ]
                        buy.price = v[ 5 ]
                    end
                end			
            end
            button[ v[ 2 ] ].OnCursorEntered = function()
                button[ v[ 2 ] ].CursorHover = true
            end
            button[ v[ 2 ] ].OnCursorExited = function()
                button[ v[ 2 ] ].CursorHover = false
            end
            
            
            secondariestable[i]["Button"] = button[v[2]];
        
            hook.Add("SecondaryForceSelect", "sforceselect_" .. v[2], function(class)
                if class != v[2] then return end
                button[v[2]]:DoClick();
            end)

            local buttonhovertop = vgui.Create( "DShape", secondaries )
            buttonhovertop:SetType( "Rect" )
            buttonhovertop:SetPos( 0, 72 * ( i - 1 ) - 8 )
            buttonhovertop:SetSize( choose:GetWide() - 30, 8 )

            buttonhovertop.Paint = function()
                surface.SetTexture( gradient )
                surface.SetDrawColor( 0, 0, 0, button[ v[ 2 ] ].alpha )
                surface.DrawTexturedRectRotated( buttonhovertop:GetWide() / 2, 4, 8, buttonhovertop:GetWide(), 90 )
            end

            if i ~= #secondariestable then
                local buttonhoverbottom = vgui.Create( "DShape", secondaries )
                buttonhoverbottom:SetType( "Rect" )
                buttonhoverbottom:SetPos( 0, 72 * ( i ) - 1 )
                buttonhoverbottom:SetSize( choose:GetWide() - 30, 8 )

                buttonhoverbottom.Paint = function()
                    surface.SetTexture( gradient )
                    surface.SetDrawColor( 0, 0, 0, button[ v[ 2 ] ].alpha )
                    surface.DrawTexturedRectRotated( buttonhoverbottom:GetWide() / 2, 4, 8, buttonhoverbottom:GetWide(), 270 )
                end
            end
        end

			-- EQUIPMENT --
			for i, v in next, extrastable do
				button[ v[ 2 ] ] = vgui.Create( "DButton", equipment )
				button[ v[ 2 ] ].isVIP = false
				local blv        = v[ 3 ]
				button[ v[ 2 ] ].alpha = 0
				button[ v[ 2 ] ].CursorHover = false
				button[ v[ 2 ] ]:SetPos( 0, 72 * ( i - 1 ) )
				button[ v[ 2 ] ]:SetSize( choose:GetWide() - 30, 72 )
				button[ v[ 2 ] ].Think = function()
					if not button[ v[ 2 ] ].CursorHover then
						button[ v[ 2 ] ].alpha = Lerp( FrameTime() * 20, button[ v[ 2 ] ].alpha, 0 )
					else
						button[ v[ 2 ] ].alpha = Lerp( FrameTime() * 20, button[ v[ 2 ] ].alpha, 164 )
					end
				end
				button[ v[ 2 ] ].Paint = function()
					if i ~= #extrastable then
						surface.SetDrawColor( 0, 0, 0, 64 )
						surface.DrawRect( 72, 71, button[ v[ 2 ] ]:GetWide(), 1 )
					end
					surface.SetFont( "Exo 2" )
					surface.SetTextColor( 0, 0, 0, 255 )
					surface.SetTextPos( 72, 16 )
					surface.DrawText( v[ 1 ] )
					if blv > num and blv <= 100 and vip < 203 then
						surface.SetDrawColor( 213, 0, 0, 255 )
						surface.SetMaterial( locked )
						surface.DrawTexturedRect( 16, 16, 40, 40 )
						surface.SetFont( "Exo 2 Subhead" )
						surface.SetTextColor( 213, 0, 0, 255 )
						surface.SetTextPos( 72, 40 )
						surface.DrawText( "Level " .. v[ 3 ] .. " is required." )
						button[ v[ 2 ] ].restricted = true
						button[ v[ 2 ] ].haventbought = false
					elseif equipmentequip == v[ 2 ] then
						surface.SetDrawColor( 56, 142, 60, 255 )
						surface.SetMaterial( bought )
						surface.DrawTexturedRect( 16, 16, 40, 40 )
						button[ v[ 2 ] ].restricted = false
						button[ v[ 2 ] ].haventbought = false
					else
						if ( not table.HasValue( weps, v[ 2 ] ) ) and v[ 5 ] ~= 0 then
							if button[ v[ 2 ] ].Purchased ~= true then
								if CurrentMoneyAmt >= tonumber( v[ 5 ] ) then
									surface.SetDrawColor( 56, 142, 60, 255 )
									surface.SetMaterial( unlock )
									surface.DrawTexturedRect( 16, 16, 40, 40 )
									surface.SetFont( "Exo 2 Subhead" )
									surface.SetTextColor( 56, 142, 60, 255 )
									surface.SetTextPos( 72, 40 )
									surface.DrawText( "$" .. comma_value( v[ 5 ]) )
								else
									surface.SetDrawColor( 213, 0, 0, 255 )
									surface.SetMaterial( unlock )
									surface.DrawTexturedRect( 16, 16, 40, 40 )
									surface.SetFont( "Exo 2 Subhead" )
									surface.SetTextColor( 213, 0, 0, 255 )
									surface.SetTextPos( 72, 40 )
									surface.DrawText( "$" .. comma_value( v[ 5 ]) )
								end
							end
							button[ v[ 2 ] ].restricted = true
							button[ v[ 2 ] ].haventbought = true
						else
							if blv > 200 then
								button[ v[ 2 ] ].isVIP = true
								if blv == 201 and vip < 201 then
									surface.SetDrawColor( 213, 0, 0, 255 )
									surface.SetMaterial( locked )
									surface.DrawTexturedRect( 16, 16, 40, 40 )
									surface.SetFont( "Exo 2 Subhead" )
									surface.SetTextColor( 213, 0, 0, 255 )
									surface.SetTextPos( 72, 40 )
									surface.DrawText( "VIP Rank is required." )
									button[ v[ 2 ] ].restricted = true
									button[ v[ 2 ] ].haventbought = false
								elseif blv == 202 and vip < 202 then
									surface.SetDrawColor( 213, 0, 0, 255 )
									surface.SetMaterial( locked )
									surface.DrawTexturedRect( 16, 16, 40, 40 )
									surface.SetFont( "Exo 2 Subhead" )
									surface.SetTextColor( 213, 0, 0, 255 )
									surface.SetTextPos( 72, 40 )
									surface.DrawText( "VIP+ Rank is required." )
									button[ v[ 2 ] ].restricted = true
									button[ v[ 2 ] ].haventbought = false
								elseif blv == 203 and vip < 203 then
									surface.SetDrawColor( 213, 0, 0, 255 )
									surface.SetMaterial( locked )
									surface.DrawTexturedRect( 16, 16, 40, 40 )
									surface.SetFont( "Exo 2 Subhead" )
									surface.SetTextColor( 213, 0, 0, 255 )
									surface.SetTextPos( 72, 40 )
									surface.DrawText( "Ultra VIP Rank is required." )
									button[ v[ 2 ] ].restricted = true
									button[ v[ 2 ] ].haventbought = false
								elseif blv == 204 and vip < 204 then
									surface.SetDrawColor( 213, 0, 0, 255 )
									surface.SetMaterial( locked )
									surface.DrawTexturedRect( 16, 16, 40, 40 )
									surface.SetFont( "Exo 2 Subhead" )
									surface.SetTextColor( 213, 0, 0, 255 )
									surface.SetTextPos( 72, 40 )
									surface.DrawText( "Staff Rank is required." )
									button[ v[ 2 ] ].restricted = true
									button[ v[ 2 ] ].haventbought = false
								elseif blv == 205 then
									surface.SetDrawColor( 213, 0, 0, 255 )
									surface.SetMaterial( locked )
									surface.DrawTexturedRect( 16, 16, 40, 40 )
									surface.SetFont( "Exo 2 Subhead" )
									surface.SetTextColor( 213, 0, 0, 255 )
									surface.SetTextPos( 72, 40 )
									surface.DrawText( "Unavailable." )
									button[ v[ 2 ] ].isVIP = false
									button[ v[ 2 ] ].restricted = true
									button[ v[ 2 ] ].haventbought = false
								elseif blv >= 206 then
									surface.SetDrawColor( 255, 215, 64, 255 )
									surface.SetMaterial( unlock )
									surface.DrawTexturedRect( 16, 16, 40, 40 )
									surface.SetFont( "Exo 2 Subhead" )
									surface.SetTextColor( 255, 215, 64, 255 )
									surface.SetTextPos( 72, 40 )
									surface.DrawText( "Unlocked due to an event." )
									button[ v[ 2 ] ].isVIP = false
									button[ v[ 2 ] ].restricted = false
									button[ v[ 2 ] ].haventbought = false
								else
									button[ v[ 2 ] ].restricted = false						
									button[ v[ 2 ] ].haventbought = false
								end
							else
								button[ v[ 2 ] ].restricted = false						
								button[ v[ 2 ] ].haventbought = false
							end
						end
					end
                    return true
                end
                button[ v[ 2 ] ].DoClick = function()
                    if not ( button[ v[ 2 ] ].restricted ) then
                        LocalPlayer():EmitSound( selectsound[ math.random( 1, #selectsound ) ] )
                        equipmentequip = v[ 2 ]
                        model:SetModel( v[ 4 ] )
                        model.restricted = false
                        model.name = v[ 1 ]
                        buy.restricted = 1
                        local description = v[ 6 ] or ""
                        hint:SetText( description )
                    else
                        LocalPlayer():EmitSound( "buttons/combine_button_locked.wav" )
                        model:SetModel( v[ 4 ] )
                        model.restricted = true
                        model.name = v[ 1 ]
                        local description = v[ 6 ] or ""
                        hint:SetText( description )
                        if button[ v[ 2 ] ].isVIP == true then
                            buy.restricted = 2
                            return
                        end
                        if button[ v[ 2 ] ].Purchased ~= true then
                            if CurrentMoneyAmt < tonumber( v[ 5 ] ) then
                                buy.restricted = 1
                                return
                            end
                            if blv > num and blv <= 100 and vip < 203 then
                                buy.restricted = 1
                                return
                            end
                            buy.restricted = 0
                            buy.selected = v[ 2 ]
                            buy.price = v[ 5 ]
                        end
                    end			
                end
                button[ v[ 2 ] ].OnCursorEntered = function()
                    button[ v[ 2 ] ].CursorHover = true
                end
                button[ v[ 2 ] ].OnCursorExited = function()
                    button[ v[ 2 ] ].CursorHover = false
                end
                
                hook.Add("EquipmentForceSelect", "eforceselect_" .. v[2], function(class)
                    if v[2] != class then return end
                    button[v[2]]:DoClick();
                end)

				local buttonhovertop = vgui.Create( "DShape", equipment )
				buttonhovertop:SetType( "Rect" )
				buttonhovertop:SetPos( 0, 72 * ( i - 1 ) - 8 )
				buttonhovertop:SetSize( choose:GetWide() - 30, 8 )

				buttonhovertop.Paint = function()
					surface.SetTexture( gradient )
					surface.SetDrawColor( 0, 0, 0, button[ v[ 2 ] ].alpha )
					surface.DrawTexturedRectRotated( buttonhovertop:GetWide() / 2, 4, 8, buttonhovertop:GetWide(), 90 )
				end

				if i ~= #extrastable then
					local buttonhoverbottom = vgui.Create( "DShape", equipment )
					buttonhoverbottom:SetType( "Rect" )
					buttonhoverbottom:SetPos( 0, 72 * ( i ) - 1 )
					buttonhoverbottom:SetSize( choose:GetWide() - 30, 8 )

					buttonhoverbottom.Paint = function()
						surface.SetTexture( gradient )
						surface.SetDrawColor( 0, 0, 0, button[ v[ 2 ] ].alpha )
						surface.DrawTexturedRectRotated( buttonhoverbottom:GetWide() / 2, 4, 8, buttonhoverbottom:GetWide(), 270 )
					end
				end
			end

			-- PERKS --
			for i, v in next, perkstable do
				local button = vgui.Create( "DButton", perks )
				local blv    = v[ 3 ]
				button.alpha = 0
				button.CursorHover = false
				button:SetPos( 0, 72 * ( i - 1 ) )
				button:SetSize( choose:GetWide() - 30, 72 )
				button.Think = function()
					if !button.CursorHover then
						button.alpha = Lerp( FrameTime() * 20, button.alpha, 0 )
					else
						button.alpha = Lerp( FrameTime() * 20, button.alpha, 164 )
					end
				end
				button.Paint = function()
					if i ~= #perkstable then
						surface.SetDrawColor( 0, 0, 0, 64 )
						surface.DrawRect( 72, 71, button:GetWide(), 1 )
					end
					surface.SetFont( "Exo 2" )
					surface.SetTextColor( 0, 0, 0, 255 )
					surface.SetTextPos( 72, 16 )
					surface.DrawText( v[ 1 ] )
					if blv > num and blv <= 100 and vip < 203 then
						surface.SetDrawColor( 213, 0, 0, 255 )
						surface.SetMaterial( locked )
						surface.DrawTexturedRect( 16, 16, 40, 40 )
						surface.SetFont( "Exo 2 Subhead" )
						surface.SetTextColor( 213, 0, 0, 255 )
						surface.SetTextPos( 72, 40 )
						surface.DrawText( "Level " .. v[ 3 ] .. " is required." )
						button.restricted = true
						button.haventbought = false
					elseif perkequip[ 1 ] == v[ 2 ] then
						surface.SetDrawColor( 56, 142, 60, 255 )
						surface.SetMaterial( bought )
						surface.DrawTexturedRect( 16, 16, 40, 40 )
						button.restricted = false
						button.haventbought = false
					else
						if blv > 200 then
							if blv == 201 and vip < 201 then
								surface.SetDrawColor( 213, 0, 0, 255 )
								surface.SetMaterial( locked )
								surface.DrawTexturedRect( 16, 16, 40, 40 )
								surface.SetFont( "Exo 2 Subhead" )
								surface.SetTextColor( 213, 0, 0, 255 )
								surface.SetTextPos( 72, 40 )
								surface.DrawText( "VIP Rank is required." )
								button.restricted = true
								button.haventbought = false
							elseif blv == 202 and vip < 202 then
								surface.SetDrawColor( 213, 0, 0, 255 )
								surface.SetMaterial( locked )
								surface.DrawTexturedRect( 16, 16, 40, 40 )
								surface.SetFont( "Exo 2 Subhead" )
								surface.SetTextColor( 213, 0, 0, 255 )
								surface.SetTextPos( 72, 40 )
								surface.DrawText( "VIP+ Rank is required." )
								button.restricted = true
								button.haventbought = false
							elseif blv == 203 and vip < 203 then
								surface.SetDrawColor( 213, 0, 0, 255 )
								surface.SetMaterial( locked )
								surface.DrawTexturedRect( 16, 16, 40, 40 )
								surface.SetFont( "Exo 2 Subhead" )
								surface.SetTextColor( 213, 0, 0, 255 )
								surface.SetTextPos( 72, 40 )
								surface.DrawText( "Ultra VIP Rank is required." )
								button.restricted = true
								button.haventbought = false
							elseif blv == 204 and vip < 204 then
								surface.SetDrawColor( 213, 0, 0, 255 )
								surface.SetMaterial( locked )
								surface.DrawTexturedRect( 16, 16, 40, 40 )
								surface.SetFont( "Exo 2 Subhead" )
								surface.SetTextColor( 213, 0, 0, 255 )
								surface.SetTextPos( 72, 40 )
								surface.DrawText( "Co-Owner Rank is required." )
								button.restricted = true
								button.haventbought = false
							elseif blv == 205 then
								surface.SetDrawColor( 213, 0, 0, 255 )
								surface.SetMaterial( locked )
								surface.DrawTexturedRect( 16, 16, 40, 40 )
								surface.SetFont( "Exo 2 Subhead" )
								surface.SetTextColor( 213, 0, 0, 255 )
								surface.SetTextPos( 72, 40 )
								surface.DrawText( "Unavailable." )
								button.restricted = true
								button.haventbought = false
							elseif blv >= 206 then
								surface.SetDrawColor( 255, 215, 64, 255 )
								surface.SetMaterial( unlock )
								surface.DrawTexturedRect( 16, 16, 40, 40 )
								surface.SetFont( "Exo 2 Subhead" )
								surface.SetTextColor( 255, 215, 64, 255 )
								surface.SetTextPos( 72, 40 )
								surface.DrawText( "Unlocked due to an event." )
								button.restricted = false
								button.haventbought = false
							else
								button.restricted = false						
								button.haventbought = false
							end
						else
							button.restricted = false						
							button.haventbought = false
						end
					end
                    return true
                end
                button.DoClick = function()
                    if not ( button.restricted ) then
                        LocalPlayer():EmitSound( selectsound[ math.random( 1, #selectsound ) ] )
                        perkequip = { v[ 2 ], v[ 1 ] }
                        perkselect = { v[ 2 ], v[ 1 ] }
                        model.restricted = false
                        model.name = v[ 1 ]
                        local description = v[ 4 ] or ""
                        hint:SetText( description )
                    else
                        LocalPlayer():EmitSound( "buttons/combine_button_locked.wav" )
                        perkselect = { v[ 2 ], v[ 1 ] }
                        model.restricted = true
                        model.name = v[ 1 ]
                        local description = v[ 6 ] or ""
                        hint:SetText( description )
                    end			
                end
                button.OnCursorEntered = function()
                    button.CursorHover = true
                end
                button.OnCursorExited = function()
                    button.CursorHover = false
                end


				local buttonhovertop = vgui.Create( "DShape", perks )
				buttonhovertop:SetType( "Rect" )
				buttonhovertop:SetPos( 0, 72 * ( i - 1 ) - 8 )
				buttonhovertop:SetSize( choose:GetWide() - 30, 8 )

				buttonhovertop.Paint = function()
					surface.SetTexture( gradient )
					surface.SetDrawColor( 0, 0, 0, button.alpha )
					surface.DrawTexturedRectRotated( buttonhovertop:GetWide() / 2, 4, 8, buttonhovertop:GetWide(), 90 )
				end

				if i ~= #perkstable then
					local buttonhoverbottom = vgui.Create( "DShape", perks )
					buttonhoverbottom:SetType( "Rect" )
					buttonhoverbottom:SetPos( 0, 72 * ( i ) - 1 )
					buttonhoverbottom:SetSize( choose:GetWide() - 30, 8 )

					buttonhoverbottom.Paint = function()
						surface.SetTexture( gradient )
						surface.SetDrawColor( 0, 0, 0, button.alpha )
						surface.DrawTexturedRectRotated( buttonhoverbottom:GetWide() / 2, 4, 8, buttonhoverbottom:GetWide(), 270 )
					end
				end
                perkstable[i]["Button"] = button[v[2]];
                
                hook.Add("PerksForceSelect", "pkforceselect_" .. v[2], function(class)
                    if v[2] != class then return end
                    button:DoClick();
                end)
			end
		end )
		end )
		end )
		end )
	end )

	local close = vgui.Create( "DButton", main )
	close.Hover = false
	close.Click = false
	close:SetSize( 64, 36 )
	close:SetPos( main:GetWide() - close:GetWide() - 16, main:GetTall() - close:GetTall() - 8 )
	
	function PaintClose()
		if not main then return end
		if close.Hover then
			draw.RoundedBox( 4, 0, 0, close:GetWide(), close:GetTall(), Color( 0, 0, 0, 255 * 0.2 ) )
		end
		if close.Click then
			draw.RoundedBox( 4, 0, 0, close:GetWide(), close:GetTall(), Color( 0, 0, 0, 255 * 0.2 ) )
		end
		draw.SimpleText( "CLOSE", "Exo 2 Button", close:GetWide() / 2, close:GetTall() / 2, GetTeamColor(), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		return true
	end
	close.Paint = PaintClose

	close.OnCursorEntered = function()
		close.Hover = true
	end
	close.OnCursorExited = function()
		close.Hover = false
	end

	close.OnMousePressed = function()
		LocalPlayer():EmitSound( "buttons/button22.wav" )
		close.Click = true
	end
	close.OnMouseReleased = function()
		close.Click = false
		main:Close()
	end
	
	main.OnClose = function()
		main:Remove()
		if main then
			main = nil
		end
	end

	local spawn = vgui.Create( "DButton", main )
	local spawncolor = Vector( 200, 200, 200 )
	spawn.Hover = false
	spawn.Click = false
	spawn:SetFont( "Exo 2 Button" )
	spawn:SetText( "Spawn" )
	spawn:SetSize( 64, 36 )
	spawn:SetPos( main:GetWide() - close:GetWide() - spawn:GetWide() - 26, main:GetTall() - spawn:GetTall() - 8 )
	spawn.Paint = function()
		if not main then return end
		if spawn:GetDisabled() ~= true then
			if spawn.Hover then
				draw.RoundedBox( 4, 0, 0, spawn:GetWide(), spawn:GetTall(), Color( 0, 0, 0, 255 * 0.2 ) )
			end
			if spawn.Click then
				draw.RoundedBox( 4, 0, 0, spawn:GetWide(), spawn:GetTall(), Color( 0, 0, 0, 255 * 0.2 ) )
			end
		end
		draw.SimpleText( "SPAWN", "Exo 2 Button", spawn:GetWide() / 2, spawn:GetTall() / 2, spawncolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		return true
	end
	
	spawn.Think = function()
		local p = primaryequip
		local s = secondaryequip

		if p ~= NULL and s ~= NULL then
			spawncolor = LerpVector( FrameTime() * 12, spawncolor, Vector( GetTeamColor().r, GetTeamColor().g, GetTeamColor().b ) )
			spawn:SetDisabled( false )
		else
			spawncolor = LerpVector( FrameTime() * 12, spawncolor, Vector( 200, 200, 200 ) )
			spawn:SetDisabled( true )
		end
	end

	spawn.OnCursorEntered = function()
		spawn.Hover = true
	end
	spawn.OnCursorExited = function()
		spawn.Hover = false
	end

	spawn.OnMousePressed = function()
		spawn.Click = true
		if spawn:GetDisabled() == true then
			return
		end
		LocalPlayer():EmitSound( "buttons/button22.wav" )
	end
	spawn.OnMouseReleased = function()
		spawn.Click = false
		if spawn:GetDisabled() == true then
			return
		end
		local p = primaryequip and tostring( primaryequip ) or nil
		local s = secondaryequip and tostring( secondaryequip ) or nil
		local e = equipmentequip and tostring( equipmentequip ) or nil
		local pe = perkequip and tostring( perkequip[ 1 ] ) or nil
		net.Start( "tdm_loadout" ) --logan
			net.WriteString( p )
			net.WriteString( s )
			if e then
				net.WriteString( e )
			else
				net.WriteString( "" )
			end
			if pe then
				net.WriteString( pe )
				LocalPlayer():SetNWString( "tdm_perk", perkequip[ 2 ] ) // XX
			else
				net.WriteString( "" )
				LocalPlayer():SetNWString( "tdm_perk", "" )
			end
		net.SendToServer()
		if LocalPlayer().red ~= nil and LocalPlayer().blue ~= nil then
			if LocalPlayer().blue == true and LocalPlayer().red == false then
				RunConsoleCommand( "tdm_setteam", "2" )
			elseif LocalPlayer().blue == false and LocalPlayer().red == true then
				RunConsoleCommand( "tdm_setteam", "1" )
			end
		else
			chat.AddText( "Your loadout will be given on your next spawn" )
		end
		main:Close()
	end
    
    --//Inserting temporary prestige button...

    local canPrestige = false
    if currentlvl >= 100 then canPrestige = true end

	local prestige = vgui.Create( "DButton", main )
	prestige.Hover = false
	prestige.Click = false
	prestige:SetSize( 64, 36 )
	prestige:SetPos( main:GetWide() - 230, main:GetTall() - prestige:GetTall() - 8 )
	prestige.Paint = function()
		if not main then return end
		if prestige.Hover and canPrestige then
			draw.RoundedBox( 4, 0, 0, prestige:GetWide(), prestige:GetTall(), Color( 0, 0, 0, 255 * 0.2 ) )
		end
		if prestige.Click and canPrestige then
			draw.RoundedBox( 4, 0, 0, prestige:GetWide(), prestige:GetTall(), Color( 0, 0, 0, 255 * 0.2 ) )
        end
        if canPrestige then
            draw.SimpleText( "PRESTIGE", "Exo 2 Button", prestige:GetWide() / 2, prestige:GetTall() / 2, GetTeamColor(), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        else
            draw.SimpleText( "PRESTIGE", "Exo 2 Button", prestige:GetWide() / 2, prestige:GetTall() / 2, Color( 200, 200, 200 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        end
		return true
	end
	prestige.OnCursorEntered = function()
		prestige.Hover = true
	end
	prestige.OnCursorExited = function()
		prestige.Hover = false
	end
	prestige.OnMousePressed = function()
		LocalPlayer():EmitSound( "buttons/button22.wav" )
		prestige.Click = true
	end
    
    local confirmationpanel;
	prestige.OnMouseReleased = function()
		prestige.Click = false
		-- Presets UI
        if confirmationpanel or !canPrestige then 
            return 
        end
        OpenConfirmationPanel()
        main:Close()
	end
    
    function OpenConfirmationPanel()
        confirmationpanel = vgui.Create( "DFrame" )
        confirmationpanel:SetSize( 450, 180 )
        confirmationpanel:SetTitle( "" )
        confirmationpanel:SetVisible( true )
        confirmationpanel:SetDraggable( false )
        confirmationpanel:ShowCloseButton( false )
        confirmationpanel:Center()
        confirmationpanel.Think = function()
            confirmationpanel:MakePopup()
        end
        confirmationpanel.Paint = function()
            Derma_DrawBackgroundBlur( confirmationpanel, CurTime() )
            surface.SetDrawColor( 255, 255, 255, 255 )
            surface.DrawRect( 0, 0, confirmationpanel:GetWide(), confirmationpanel:GetTall() )
            surface.SetDrawColor( GetTeamColor() )
            surface.DrawRect( 0, 0, confirmationpanel:GetWide(), 56 )
            surface.SetFont( "Exo 2" )
            surface.SetTextColor( Color( 255, 255, 255 ) )
            surface.SetTextPos( confirmationpanel:GetWide() / 2 - surface.GetTextSize("Prestige") / 2, 16 )
            surface.DrawText( "Prestige" )
            surface.SetTexture( gradient )

            draw.SimpleText( "Are you sure you wish to prestige?", "Exo 2", confirmationpanel:GetWide() / 2, confirmationpanel:GetTall() / 2 - 5, GetTeamColor(), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
            draw.SimpleText( "This cannot be undone!", "Exo 2", confirmationpanel:GetWide() / 2, confirmationpanel:GetTall() / 2 + 20, GetTeamColor(), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        end
        confirmationpanel.PaintOver = function()
            surface.SetTexture( gradient )
            surface.SetDrawColor( 0, 0, 0, 164 )
            surface.DrawTexturedRectRotated( confirmationpanel:GetWide() / 2, 56 + 4, 8, confirmationpanel:GetWide(), 270 )
        end
        confirmationpanel.OnClose = function()
            confirmationpanel:Remove()
            confirmationpanel = nil
        end

        local acceptbutton = vgui.Create( "DButton", confirmationpanel )
        acceptbutton:SetSize( 64, 36 )
        acceptbutton:SetPos( 32, confirmationpanel:GetTall() - acceptbutton:GetTall() - 8 )
        acceptbutton:SetText( "" )
        acceptbutton.Paint = function()
            if acceptbutton.Hover then
                draw.RoundedBox( 4, 0, 0, acceptbutton:GetWide(), acceptbutton:GetTall(), Color( 0, 0, 0, 255 * 0.2 ) )
            end
            if acceptbutton.Click then
                draw.RoundedBox( 4, 0, 0, acceptbutton:GetWide(), acceptbutton:GetTall(), Color( 0, 0, 0, 255 * 0.2 ) )
            end
            draw.SimpleText( "CONFIRM", "Exo 2 Button", acceptbutton:GetWide() / 2, acceptbutton:GetTall() / 2, GetTeamColor(), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
            return true
        end
        acceptbutton.OnCursorEntered = function()
            acceptbutton.Hover = true
        end
        acceptbutton.OnCursorExited = function()
            acceptbutton.Hover = false
        end
        acceptbutton.OnMousePressed = function()
            --LocalPlayer():EmitSound( "buttons/button22.wav" )
            acceptbutton.Click = true
        end
        acceptbutton.OnMouseReleased = function()
            acceptbutton.Click = false

            if acceptbutton.once then return end
            acceptbutton.once = true
            net.Start( "PlayerAttemptPrestige" )
            net.SendToServer()
            
            net.Receive( "GetPrestigeTokensCallback", function()
                local tokens = net.ReadInt( 16 )
                DoClientPrestige( tokens )
            end )
        end
        
        local cancelbutton = vgui.Create( "DButton", confirmationpanel )
        cancelbutton:SetSize( 64, 36 )
        cancelbutton:SetPos( confirmationpanel:GetWide() - cancelbutton:GetWide() - 32, confirmationpanel:GetTall() - cancelbutton:GetTall() - 8 )
        cancelbutton:SetText( "" )
        cancelbutton.Paint = function()
            if cancelbutton.Hover then
                draw.RoundedBox( 4, 0, 0, cancelbutton:GetWide(), cancelbutton:GetTall(), Color( 0, 0, 0, 255 * 0.2 ) )
            end
            if cancelbutton.Click then
                draw.RoundedBox( 4, 0, 0, cancelbutton:GetWide(), cancelbutton:GetTall(), Color( 0, 0, 0, 255 * 0.2 ) )
            end
            draw.SimpleText( "CANCEL", "Exo 2 Button", cancelbutton:GetWide() / 2, cancelbutton:GetTall() / 2, GetTeamColor(), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
            return true
        end
        cancelbutton.OnCursorEntered = function()
            cancelbutton.Hover = true
        end
        cancelbutton.OnCursorExited = function()
            cancelbutton.Hover = false
        end
        cancelbutton.OnMousePressed = function()
            LocalPlayer():EmitSound( "buttons/button22.wav" )
            cancelbutton.Click = true
        end
        cancelbutton.OnMouseReleased = function()
            cancelbutton.Click = false
            confirmationpanel:Close()
            confirmationpanel = nil
        end

        function DoClientPrestige( Tokens )
            acceptbutton:Remove()
            cancelbutton:Remove()
            --timer.Simple( 1, function()
                confirmationpanel.Paint = function()
                    Derma_DrawBackgroundBlur( confirmationpanel, CurTime() )
                    surface.SetDrawColor( 255, 255, 255, 255 )
                    surface.DrawRect( 0, 0, confirmationpanel:GetWide(), confirmationpanel:GetTall() )
                    surface.SetDrawColor( GetTeamColor() )
                    surface.DrawRect( 0, 0, confirmationpanel:GetWide(), 56 )
                    surface.SetFont( "Exo 2" )
                    surface.SetTextColor( Color( 255, 255, 255 ) )
                    surface.SetTextPos( confirmationpanel:GetWide() / 2 - surface.GetTextSize("Prestige") / 2, 16 )
                    surface.DrawText( "Prestige" )
                    surface.SetTexture( gradient )

                    draw.SimpleText( "Prestige Succesful!", "Exo 2", confirmationpanel:GetWide() / 2, confirmationpanel:GetTall() / 2 - 5, GetTeamColor(), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
                    draw.SimpleText( "You have: " .. Tokens .. " prestige token(s)!", "Exo 2", confirmationpanel:GetWide() / 2, confirmationpanel:GetTall() / 2 + 35, GetTeamColor(), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
                end

                surface.PlaySound( "ui/challengecomplete.wav" )
            --end )

            timer.Simple( 2, function()
                ply:ConCommand( "tdm_setteam 0" )
            end )
            timer.Simple( 3, function()
                confirmationpanel:Remove()
            end )
        end
        
        --[[local function DoNothing() end
        local pcontainer = vgui.Create( "DScrollPanel", confirmationpanel )
        pcontainer:SetPos(0, 56);
        pcontainer:SetSize(confirmationpanel:GetWide(), confirmationpanel:GetTall() - 56)
        local sBar = pcontainer:GetVBar()
        sBar.Paint = DoNothing()
        sBar.btnUp.Paint = DoNothing()
        sBar.btnDown.Paint = DoNothing()
        function sBar.btnGrip:Paint( w, h )
            draw.RoundedBox( 4, 7, 0, w / 2, h, Color( 0, 0, 0, 128 ) )
        end
        
        local presetstable = {}
        
        local function LoadPresets()
            if !file.Exists("conquest_tdm_presets.txt", "DATA") then 
                file.Write("conquest_tdm_presets.txt", table.ToString({}, "prestige", false));
            end
            local tab = util.JSONToTable(file.Read("conquest_tdm_presets.txt")) or {};
            for k, v in next, tab do
                table.insert(presetstable, v)
            end
            table.insert(presetstable, {"Save Current"});
        end
        
        local function SavePreset(name, p, s, e, pk)
            table.insert(presetstable, #presetstable - 1, {name, p, s, e, pk[1]}) -- pk[2] is the display name
            local tab = presetstable;
            table.remove(tab, #tab);
            local str = util.TableToJSON(tab, "prestige", false)
            file.Write("conquest_tdm_presets.txt", str);
            hook.Run("PresetAdded");
        end
        
        local function refresh()
            table.Empty(presetstable)
            LoadPresets()
            pcontainer:Clear()
            for i, v in next, presetstable do
                local button = vgui.Create( "DButton", pcontainer )
                button:SetText("");
                button.alpha = 0
                button.CursorHover = false
                button:SetPos( 0, 72 * ( i - 1 ) )
                button:SetSize( pcontainer:GetWide() - 30, 72 )
                button.Think = function()
                    if not button.CursorHover then
                        button.alpha = Lerp( FrameTime() * 20, button.alpha, 0 )
                    else
                        button.alpha = Lerp( FrameTime() * 20, button.alpha, 164 )
                    end
                end
                button.Paint = function()
                    if i ~= #presetstable then
                        surface.SetDrawColor( 0, 0, 0, 64 )
                        surface.DrawRect( 0, 71, button:GetWide(), 1 )
                    end
                    surface.SetFont( "Exo 2" )
                    surface.SetTextColor( 0, 0, 0, 255 )
                    surface.SetTextPos( button:GetWide() / 2 - surface.GetTextSize(v[1]) / 2, 22 )
                    surface.DrawText( v[1] )
                end
                button.DoClick = function()
                    if #v == 1 then
                        if primaryequip != NULL and secondaryequip != NULL and equipmentequip != NULL and perkequip[1] != NULL and perkequip[2] != NULL then
                            Derma_StringRequest("New Preset", "Choose Name", "New Preset", function(text)
                                SavePreset(text, tostring(primaryequip), tostring(secondaryequip), tostring(equipmentequip), perkequip);
                            end)
                        end
                    else
                        local p = v[2];
                        local s = v[3];
                        local e = v[4];
                        local pk = v[5];
                        hook.Run("PrimaryForceSelect", p);
                        hook.Run("SecondaryForceSelect", s);
                        hook.Run("EquipmentForceSelect", e);
                        hook.Run("PerksForceSelect", pk);
                    end
                end
                button.OnCursorEntered = function()
                    button.CursorHover = true
                end
                button.OnCursorExited = function()
                    button.CursorHover = false
                end
                
                
            local buttonhovertop = vgui.Create( "DShape", pcontainer )
                buttonhovertop:SetType( "Rect" )
                buttonhovertop:SetPos( 0, 72 * ( i - 1 ) - 8 )
                buttonhovertop:SetSize( pcontainer:GetWide() - 30, 8 )

                buttonhovertop.Paint = function()
                    surface.SetTexture( gradient )
                    surface.SetDrawColor( 0, 0, 0, button.alpha )
                    surface.DrawTexturedRectRotated( buttonhovertop:GetWide() / 2, 4, 8, buttonhovertop:GetWide(), 90 )
                end

                if i ~= #presetstable then
                    local buttonhoverbottom = vgui.Create( "DShape", pcontainer )
                    buttonhoverbottom:SetType( "Rect" )
                    buttonhoverbottom:SetPos( 0, 72 * ( i ) - 1 )
                    buttonhoverbottom:SetSize( pcontainer:GetWide() - 30, 8 )

                    buttonhoverbottom.Paint = function()
                        surface.SetTexture( gradient )
                        surface.SetDrawColor( 0, 0, 0, button.alpha )
                        surface.DrawTexturedRectRotated( buttonhoverbottom:GetWide() / 2, 4, 8, buttonhoverbottom:GetWide(), 270 )
                    end
                end 
            end
        end
        refresh();
        hook.Add("PresetAdded", "addPreset", refresh)]]
    end


	local loading = vgui.Create( "DShape", main )
	local a = 200
	loading:SetType( "Rect" )
	loading:SetPos( 0, 0 )
	loading:SetSize( main:GetWide(), main:GetTall() )
	loading:SetColor( Color( 0, 0, 0, a ) )
	loading.Think = function()
		if received == true && a ~= 0 then
			a = Lerp( FrameTime() * 8, a, 0 )
			loading:SetColor( Color( 0, 0, 0, a ) )
			if a <= 0 then
				loading:Remove()
			end
		end
    end
    
    --GAMEMODE:DrawEventStatuses( main )
end

surface.CreateFont( "ExoTitleFont" , { font = "Exo 2", size = 20, weight = 400 } )
surface.CreateFont( "ExoInfoFont", { font = "Exo 2", size = 24, weight = 400 } )

GM.playerLevel = 1
GM.playerMoney = 0
GM.playerRank = 0

--//Loadout Menu - Set your primary/secondary weapon, equipment, and perk
function GM:SetLoadout()
	if self.LoadoutMain and self.LoadoutMain:IsValid() then return end

	--Not needed in the loadout menu, should be in the shop menu
	--[[net.Start( "GetRank" )
	net.SendToServer()
	net.Start( "GetMoney" )
	net.SendToServer()
	net.Start( "GetUserGroupRank" )
	net.SendToServer()

	net.Receive( "GetLevelCallback", function() --Net messages doesn't yet exist
		GAMEMODE.playerLevel = net.ReadInt() --Need total byte count
	end )
	net.Receive( "GetMoneyCallback", function()
		GAMEMODE.playerMoney = net.ReadInt( 64 )
	end )
	net.Receive( "GetUserGroupRank", function()
		GAMEMODE.playerRank = net.ReadInt() --Need total byte count
	end )]]

	net.Start( "RequestUnlocked" )
	net.SendToServer()

	net.Receive( "RequestUnlockedCallback", function()
		local unlocks = net.ReadTable()
		GAMEMODE.UnlockTable = { primaries = {}, secondaries = {}, equipment = {}, perks = {} }

		for k, v in pairs( unlocks[ 1 ] ) do
			GAMEMODE.UnlockTable.primaries[ #GAMEMODE.UnlockTable.primaries + 1 ] = GAMEMODE.PrimariesList[ k ]
			GAMEMODE.UnlockTable.primaries[ #GAMEMODE.UnlockTable.primaries ].attachments = v
		end
		for k, v in pairs( unlocks[ 2 ] ) do
			GAMEMODE.UnlockTable.secondaries[ #GAMEMODE.UnlockTable.secondaries + 1 ] = GAMEMODE.SecondariesList[ k ]
			GAMEMODE.UnlockTable.secondaries[ #GAMEMODE.UnlockTable.secondaries ].attachments = v
		end
		for k, v in pairs( unlocks[ 3 ] ) do
			GAMEMODE.UnlockTable.equipment[ #GAMEMODE.UnlockTable.equipment + 1 ] = GAMEMODE.EquipmentList[ k ]
		end
		for k, v in pairs( unlocks[ 4 ] ) do
			GAMEMODE.UnlockTable.perks[ #GAMEMODE.UnlockTable.perks + 1 ] = v
		end
		
		if not GAMEMODE.LoadoutMain then
			timer.Simple( 0.5, function()
				if not GAMEMODE.LoadoutMain then
					Error(  ) --dunno what the params are
				else
					ExtendLoadout()
				end
			end )
		else
			ExtendLoadout()
		end
	end )

	self.LoadoutMain = vgui.Create( "DFrame" )
	self.LoadoutMain:SetSize( 750, 430 ) --Gonna need a new window size, 
	self.LoadoutMain:SetTitle( "" )
	self.LoadoutMain:SetVisible( true )
	self.LoadoutMain:SetDraggable( false )
	self.LoadoutMain:ShowCloseButton( false )
	self.LoadoutMain:MakePopup()
	self.LoadoutMain:Center()
	self.LoadoutMain.Think = function()
		self.LoadoutMain.x, self.LoadoutMain.y = self.LoadoutMain:GetPos()
	end

	self.LoadoutMainTitleBar = vgui.Create( "DPanel", self.LoadoutMain )
	self.LoadoutMainTitleBar:SetPos( 0, 0 )
	self.LoadoutMainTitleBar:SetSize( self.LoadoutMain:GetWide(), 56 )
	self.LoadoutMainTitleBar.Paint = function()
		draw.SimpleText( "Set Your Loadout", "ExoTitleFont", self.LoadoutMainTitleBar:GetWide() / 2, self.LoadoutMainTitleBar:GetTall() / 2, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end

	local defaultTable = {
		primary = { class = "cw_ar15", attachments = {} },
		secondary = { class = "cw_p99", attachments = {} },
		equipment = { class = "weapon_fists" },
		perk = { class = "packrat" }
	}
	self.SelectedLoadout = self.SelectedLoadout or defaultTable

	local panelWide, panelTall = self.LoadoutMain:GetWide() / 4, self.LoadoutMain:GetTall() - self.LoadoutMainTitleBar:GetTall()
	self.LoadoutMainPrimaryPanel = vgui.Create( "SelectionPanel", self.LoadoutMain )
	self.LoadoutMainPrimaryPanel:SetPos( 0, self.LoadoutMainTitleBar:GetTall() )
	self.LoadoutMainPrimaryPanel:SetSize( panelWide, panelTall )
	self.LoadoutMainPrimaryPanel:SetType( self.LoadoutMainPrimaryPanel.EnumerationTypes.TYPE_WEAPON )

	self.LoadoutMainSecondaryPanel = vgui.Create( "SelectionPanel", self.LoadoutMain )
	self.LoadoutMainSecondaryPanel:SetPos( panelWide, self.LoadoutMainTitleBar:GetTall() )
	self.LoadoutMainSecondaryPanel:SetSize( panelWide, panelTall )
	self.LoadoutMainSecondaryPanel:SetType( self.LoadoutMainSecondaryPanel.EnumerationTypes.TYPE_WEAPON )

	self.LoadoutMainEquipmentPanel = vgui.Create( "SelectionPanel", self.LoadoutMain )
	self.LoadoutMainEquipmentPanel:SetPos( panelWide * 2, self.LoadoutMainTitleBar:GetTall() )
	self.LoadoutMainEquipmentPanel:SetSize( panelWide, panelTall )
	self.LoadoutMainEquipmentPanel:SetType( self.LoadoutMainEquipmentPanel.EnumerationTypes.TYPE_NONWEAPON )

	self.LoadoutMainPerkPanel = vgui.Create( "SelectionPanel", self.LoadoutMain )
	self.LoadoutMainPerkPanel:SetPos( panelWide * 3, self.LoadoutMainTitleBar:GetTall() )
	self.LoadoutMainPerkPanel:SetSize( panelWide, panelTall )
	self.LoadoutMainPerkPanel:SetType( self.LoadoutMainPerkPanel.EnumerationTypes.TYPE_NONWEAPON )

	function self:RefreshMenu()
		self.LoadoutMainPrimaryPanel:SetObject( self.SelectedLoadout.primary.class, self.SelectedLoadout.primary.attachments )
		self.LoadoutMainSecondaryPanel:SetObject( self.SelectedLoadout.secondary.class, self.SelectedLoadout.secondary.attachments )
		self.LoadoutMainEquipmentPanel:SetObject( self.SelectedLoadout.equipment.class, nil, true )
		self.LoadoutMainPerkPanel:SetObject( self.SelectedLoadout.perk.class )
	end
	self:RefreshMenu()

	--//Starts the drawing for the bottom half of the loadout menu
	local function ExtendLoadout()
		if not self.LoadoutMain then return end
		self.LoadoutMenuBuffer = 6

		self.LoadoutUnlocks = vgui.Create( "DFrame" )
		self.LoadoutUnlocks:SetSize( self.LoadoutMain:GetWide(), 430 )
		self.LoadoutUnlocks:SetPos( self.LoadoutMain.x, self.LoadoutMain.y + self.LoadoutMain:GetTall() + self.LoadoutMenuBuffer )
		self.LoadoutUnlocks:SetTitle( "" )
		self.LoadoutUnlocks:SetVisible( true )
		self.LoadoutUnlocks:SetDraggable( false )
		self.LoadoutUnlocks:ShowCloseButton( false )
		self.LoadoutUnlocks:MakePopup()
		self.LoadoutUnlocks.Think = function()
			self.LoadoutUnlocks.x, self.LoadoutUnlocks.y = self.LoadoutUnlocks:GetPos()
		end

		self.LoadoutUnlocksTitleBar = vgui.Create( "DPanel", self.LoadoutUnlocks )
		self.LoadoutUnlocksTitleBar:SetPos( 0, 0 )
		self.LoadoutUnlocksTitleBar:SetSize( self.LoadoutUnlocks:GetWide(), 56 )
		self.LoadoutUnlocksTitleBar.Paint = function()
			draw.SimpleText( "Unlocked Weapons, Equipment, & Perks", "ExoTitleFont", self.LoadoutUnlocksTitleBar:GetWide() / 2, self.LoadoutUnlocksTitleBar:GetTall() / 2, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end

		--Create 4 custom list-button parent/child vgui elements, don't do any unnecessary calling here
		--Send each the their respective list, do formating in the custom thinking
	end
end

usermessage.Hook( "ClearTable", function( um )
	LocalPlayer().blue = nil
	LocalPlayer().red = nil
end )