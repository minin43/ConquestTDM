--//This file is strictly for creating custom vgui elements for the shop
--//DAMN YE ALL WHO ENTER HERE

GM.slotmaterials = { Material( "vgui/prinary_icon.png" ), Material( "secondary_icon.png" ), Material( "equipment_icon.png" ) }
GM.typematerials = { Material( "vgui/ar_icon.png" ), Material( "vgui/smg_icon.png" ), Material( "vgui/shotgun_icon.png" ), Material( "vgui/sniper_icon.png" ),
    Material( "vgui/lmg_icon.png" ), Material( "vgui/pistol_icon.png" ), Material( "vgui/magnum_icon.png" ), Material( "vgui/equipment_icon.png" ), 
    ar = Material( "vgui/ar_icon.png" ), smg = Material( "vgui/smg_icon.png" ), sg = Material( "vgui/shotgun_icon.png" ), sr = Material( "vgui/sniper_icon.png" ),
    lmg = Material( "vgui/lmg_icon.png" ), pt = Material( "vgui/pistol_icon.png" ), mn = Material( "vgui/magnum_icon.png" ), eq = Material( "vgui/equipment_icon.png" ) }
GM.levelmaterials = { Material( "vgui/level_locked.png" ), Material( "vgui/level_unlocked.png" ) }
GM.moneymaterials = { Material( "vgui/money_locked.png" ), Material( "vgui/money_unlocked.png" ) }

surface.CreateFont( "WeaponsShopMain" , { font = "Exo 2", size = 20, weight = 600 } )
surface.CreateFont( "WeaponsShopButtonHeaderDisplay" , { font = "Exo 2", size = 36, weight = 600 } )
surface.CreateFont( "WeaponsShopButtonDisplay" , { font = "Exo 2", size = 32, weight = 600 } )
surface.CreateFont( "WeaponsShopButtonSubDisplay" , { font = "Exo 2", size = 16, weight = 500 } )
surface.CreateFont( "WeaponsShopInfo" , { font = "Exo 2", size = 16, weight = 600 } )
surface.CreateFont( "InsufficientFunds", { font = "Exo 2", size = 32 } )

surface.CreateFont( "SkinsShopButtonFont", { font = "Exo 2", size = 28, weight = 600 } )
surface.CreateFont( "SkinsShopTitleFont", { font = "Exo 2", size = 40, weight = 600 } )

--//This is the button that switches the PropertySheet panels - "Weapons", "Weapon Skins", and "Playermodels"
local psheetbutton = { }
psheetbutton.text = ""
psheetbutton.font = "DermaDefault"
psheetbutton.psheet = nil
psheetbutton.sheet = nil
psheetbutton.spacer = 4

function psheetbutton:SetText( txt )
    self.text = txt
end

function psheetbutton:SetFont( fnt )
    self.font = fnt
end

function psheetbutton:SetParentSheet( parent )
    self.psheet = parent
end

function psheetbutton:SetTab( tab )
    self.tab = tab
end

function psheetbutton:OnCursorEntered()
    self.hover = true
end

function psheetbutton:OnCursorExited()
    self.hover = false
end

function psheetbutton:DoClick()
    self.psheet:SetActiveTab( self.tab )
    self.selected = true
    surface.PlaySound( GAMEMODE.ButtonSounds.Accept[ math.random( #GAMEMODE.ButtonSounds.Accept ) ] )
end

function psheetbutton:Paint()
    surface.SetDrawColor( 66, 66, 66 )--GAMEMODE.TeamColor )
    surface.DrawRect( 0, 0, self:GetWide(), self:GetTall() )
    
    surface.SetTexture( GAMEMODE.GradientTexture )
    surface.SetDrawColor( 0, 0, 0, 164 )
    surface.DrawTexturedRectRotated( self:GetWide() / 2, 4, 8, self:GetWide(), 270 ) --self.TeamMain:GetWide() / 2, self.TeamMainTitleSize + 4, 8, self.TeamMain:GetWide(), 270
        
    surface.SetFont( self.font )
    local twide, ttall = surface.GetTextSize( self.text )
    surface.SetTextPos( self:GetWide() / 2 - ( twide / 2 ), self:GetTall() / 2 - ( ttall / 2) )
    surface.SetTextColor( 255, 255, 255 )
    surface.DrawText( self.text )
    --draw.SimpleText( self.text, self.font, self:GetWide() / 2, self:GetTall() / 2, Color( 255,255,255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

    self.lerp = self.lerp or 0
    if self.hover or self.selected then
        self.lerp = math.Clamp( self.lerp + 3, 0, self:GetWide() / 3 )
        if self.selected then
            surface.SetDrawColor( GAMEMODE.TeamColor )--colorScheme[LocalPlayer():Team()]["ButtonIndicator"] )
        else
            surface.SetDrawColor( 255, 255, 255 )
        end
    else
        surface.SetDrawColor( 255, 255, 255 )
        self.lerp = math.Clamp( self.lerp - 3, 0, self:GetWide() / 3 )
    end

    if self.lerp != 0 then
        surface.DrawLine( self:GetWide() / 2, self:GetTall() / 2 + ( ttall / 2 ) + 4, self:GetWide() / 2 + self.lerp, self:GetTall() / 2 + ( ttall / 2 ) + 4 )
        surface.DrawLine( self:GetWide() / 2, self:GetTall() / 2 + ( ttall / 2 ) + 4, self:GetWide() / 2 - self.lerp, self:GetTall() / 2 + ( ttall / 2 ) + 4 )
    end

    return true
end

function psheetbutton:Think()
    if self.psheet:GetActiveTab() == self.tab then --May be a bit expensive
        self.selected = true
    else
        self.selected = false
    end
end

vgui.Register( "PropertySheetButton", psheetbutton, "DButton" )

--//

local weaponsshopbutton = table.Copy( psheetbutton )
weaponsshopbutton.gradient = false
weaponsshopbutton.weaponclass = ""
weaponsshopbutton.order = 0
weaponsshopbutton.alpha = 0

function weaponsshopbutton:DoClick()
    if self.disabled then 
        surface.PlaySound( GAMEMODE.ButtonSounds.Deny[ math.random( #GAMEMODE.ButtonSounds.Deny ) ] )
        return 
    end
    self.trueparent:SelectWeapon( self.weaponclass, self.order )
    surface.PlaySound( GAMEMODE.ButtonSounds.Accept[ math.random( #GAMEMODE.ButtonSounds.Accept ) ] )
end

function weaponsshopbutton:SetWeapon( wep )
    self.weaponclass = wep
    self.weapontable = RetrieveWeaponTable( self.weaponclass )
    self.display = RetrieveWeaponName( self.weaponclass )
    self.canbuy = self.weapontable[ 5 ] < GAMEMODE.MyMoney
end

function weaponsshopbutton:Think()
    if self.trueparent.selectedweapon == self.weaponclass then
        self.selected = true
    else
        self.selected = false
    end

    if self.hover then
        self.alpha = Lerp( FrameTime() * 5, self.alpha, 0 )
    else
        self.alpha = Lerp( FrameTime() * 5, self.alpha, 164 )--Lerp
    end
end

function weaponsshopbutton:Disable()
    self.disabled = true
end

function weaponsshopbutton:SetTrueParent( panel, order )
    --//Since these buttons are actually parented to a scroll panel nested inside my custom panel, I need them to reference the custom panel and not the scroll panel
    self.trueparent = panel
    self.order = order
end

function weaponsshopbutton:Paint()
    surface.SetDrawColor( GAMEMODE.TeamColor )
    surface.SetMaterial( GAMEMODE.typematerials[ self.weapontable.type ] )
    surface.DrawTexturedRect( 8, 8, self:GetTall() - 16, self:GetTall() - 16 )

    if self.canbuy then
        --surface.SetDrawColor( colorScheme[ 0 ].TeamColor )
        --surface.SetMaterial( GAMEMODE.moneymaterials[ 2 ] )

        surface.SetTextColor( colorScheme[ 0 ].TeamColor )
        surface.SetFont( "WeaponsShopButtonSubDisplay" )
        surface.SetTextPos( self:GetTall() + 12, self:GetTall() / 2 + 8 )
        surface.DrawText( "Cost: " .. comma_value( self.weapontable[ 5 ] ) )
    else
        --surface.SetDrawColor( colorScheme[ 1 ].TeamColor )
        --surface.SetMaterial( GAMEMODE.moneymaterials[ 1 ] )

        surface.SetTextColor( colorScheme[ 1 ].TeamColor )
        surface.SetFont( "WeaponsShopButtonSubDisplay" )
        surface.SetTextPos( self:GetTall() + 12, self:GetTall() / 2 + 8 )
        surface.DrawText( "Cost: " .. comma_value( self.weapontable[ 5 ] ) )
    end
    --surface.DrawTexturedRect( self:GetWide() - ( self:GetTall() - 24 ) - 12, 12, self:GetTall() - 24, self:GetTall() - 24 )

    surface.SetTextColor( 0, 0, 0, 220 )
    if self.disabled then
        surface.SetDrawColor( colorScheme[ 1 ].TeamColor )
        surface.SetMaterial( GAMEMODE.levelmaterials[ 1 ] )
        --surface.DrawTexturedRect( self:GetWide() - ( ( self:GetTall() - 24 ) * 2 ) - ( 12 * 2 ), 12, self:GetTall() - 24, self:GetTall() - 24 )
        surface.DrawTexturedRect( self:GetWide() - ( self:GetTall() - 24 ) - 12, 12, self:GetTall() - 24, self:GetTall() - 24 )
    elseif ( self.hover or self.selected ) then
        surface.SetTextColor( GAMEMODE.TeamColor )
    end

    surface.SetFont( self.font )
    local w, h = surface.GetTextSize( self.display )
    surface.SetTextPos( self:GetTall(), self:GetTall() / 2 - ( h / 1.5 ) )
    surface.DrawText( self.display )

    if self.order != 1 and self.order != 0 then
        if self.trueparent.weaponbuttons[ self.order - 1 ].hover then
            surface.SetTexture( GAMEMODE.GradientTexture )
            surface.SetDrawColor( 0, 0, 0, self.alpha )
            surface.DrawTexturedRectRotated( self:GetWide() / 2, 4, 8, self:GetWide(), -90 )
        end
    end
    if self.order != #self.trueparent.weaponbuttons then
        if self.trueparent.weaponbuttons[ self.order + 1 ].hover then
            surface.SetTexture( GAMEMODE.GradientTexture )
            surface.SetDrawColor( 0, 0, 0, self.alpha )
            surface.DrawTexturedRectRotated( self:GetWide() / 2, self:GetTall() - 4, 8, self:GetWide(), 90 )
        end

        if !self.hover and !self.trueparent.weaponbuttons[ self.order + 1 ].hover then
            surface.SetTexture( GAMEMODE.GradientTexture )
            surface.SetDrawColor( 0, 0, 0, 164)
            surface.DrawLine( self:GetTall() - 12, self:GetTall() - 1, self:GetWide(), self:GetTall() - 1 )
        end
    end

    if self.disabled and self.hover then
        surface.SetDrawColor( 0, 0, 0, 220 )
        surface.DrawRect(0, 0, self:GetWide(), self:GetTall())
        draw.SimpleTextOutlined( "Unlocks at level " .. self.weapontable[ 3 ], self.font, self:GetWide() / 2, self:GetTall() / 2, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
        --draw.SimpleText( "Unlocks at level " .. self.weapontable[ 3 ], self.font, self:GetWide() / 2, self:GetTall() / 2, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    end

    return true
end

vgui.Register( "WeaponsShopButton", weaponsshopbutton, "DButton" )

--//

local weaponsshop = { }
weaponsshop.weaponname = "Nothing Selected"
weaponsshop.font = "WeaponsShopMain"
weaponsshop.tabs = { "ar", "smg", "sg", "sr", "lmg", "pt", "mn", "eq" }
weaponsshop.weaponbuttons = { }
weaponsshop.wepinfo = {
    { value = "Damage",     display = "Damage",     barfill = 0,    min = 0,        max = 120,  scale = "up" },
    { value = "FireDelay",  display = "Firerate",   barfill = 0,    min = 0.05,     max = 1.5,  scale = "up" },
    { value = "AimSpread",  display = "Accuracy",   barfill = 0,    min = 0.001,    max = 0.03, scale = "up" },
    { value = "Recoil",     display = "Recoil",     barfill = 0,    min = 0.1,      max = 2,    scale = "down" }
}
weaponsshop.modeloffsets = { --FOR MOST GUNS: pos = Vector( x coord (reversed), z coord (+ closer), y coord )
    --[ "cw_ar15" ] = { cam = Vector( 0, 35, 0 ), lookat = Vector( 0, 0, 0 ), pos = Vector( -6, 13.5, -1 ) },
    [ "cw_ak74" ] = { cam = Vector( 0, 35, 0 ), lookat = Vector( 0, 0, 0 ), pos = Vector( 2, 12, -4 ) },
    [ "cw_g3a3" ] = { cam = Vector( 0, 35, 0 ), lookat = Vector( 0, 0, 0 ), pos = Vector( 4, 12, -7 ) },
    [ "cw_scarh" ] = { cam = Vector( 0, 35, 0 ), lookat = Vector( 0, 0, 0 ), pos = Vector( -7, 11, -3 ) },
    [ "cw_g36c" ] = { cam = Vector( 0, 35, 0 ), lookat = Vector( 0, 0, 0 ), pos = Vector( -6, 13.5, -2 ) },
    [ "cw_mp5" ] = { cam = Vector( 0, 35, 0 ), lookat = Vector( 0, 0, 0 ), pos = Vector( -2, 12, -6 ) },
    [ "cw_deagle" ] = { cam = Vector( 0, 35, 0 ), lookat = Vector( 0, 0, 0 ), pos = Vector( -3.5, 13.5, -4 ) },
    [ "cw_l85a2" ] = { cam = Vector( 0, 35, 0 ), lookat = Vector( 0, 0, 0 ), pos = Vector( -22, 13, -9 ) },
    [ "cw_m14" ] = { cam = Vector( 0, 35, 0 ), lookat = Vector( 0, 0, 0 ), pos = Vector( -11, 13.5, -1.5 ) },
    [ "cw_m1911" ] = { cam = Vector( 0, 35, 0 ), lookat = Vector( 0, 0, 0 ), pos = Vector( -6, 13.5, -1 ) },
    [ "cw_m249_official" ] = { cam = Vector( 0, 35, 0 ), lookat = Vector( 0, 0, 0 ), pos = Vector( -8, 8, -2 ) },
    [ "cw_m3super90" ] = { cam = Vector( 0, 35, 0 ), lookat = Vector( 0, 0, 0 ), pos = Vector( -9, 11, -1.5 ) },
    [ "cw_mac11" ] = { cam = Vector( 0, 35, 0 ), lookat = Vector( 0, 0, 0 ), pos = Vector( -7, 13.5, -2 ) },
    [ "cw_mr96" ] = { cam = Vector( 0, 35, 0 ), lookat = Vector( 0, 0, 0 ), pos = Vector( -6, 13.5, -1 ) },
    [ "cw_ump45" ] = { cam = Vector( 0, 35, 0 ), lookat = Vector( 0, 0, 0 ), pos = Vector( 2, 12, -4 ) },
    [ "cw_makarov" ] = { cam = Vector( -20, 20, 0 ), lookat = Vector( 20, 5, 0 ), pos = Vector( -6, 13.5, -3 ) },
    [ "cw_shorty" ] = { cam = Vector( 0, 35, 0 ), lookat = Vector( 0, 0, 0 ), pos = Vector( -9, 13.5, -2 ) },
    [ "cw_vss" ] = { cam = Vector( 30, -60, 0 ), lookat = Vector( 30, 0, 0 ), pos = Vector( 30, -30, -1 ) },
    [ "cw_b196" ] = { cam = Vector( 0, 35, 0 ), lookat = Vector( 0, 0, 0 ), pos = Vector( -6, 13.5, -1 ) },
    [ "cw_scorpin_evo3" ] = { cam = Vector( 0, 35, 0 ), lookat = Vector( 0, 0, 0 ), pos = Vector( -6, 13.5, -1 ) },
    [ "cw_tac338" ] = { cam = Vector( 0, 35, 0 ), lookat = Vector( 0, 0, 0 ), pos = Vector( -6, 13.5, -1 ) },
    [ "cw_ber_p90" ] = { cam = Vector( 0, 35, 0 ), lookat = Vector( 0, 0, 0 ), pos = Vector( -3, 10, -3 ) },
    [ "cw_ber_famas_felin" ] = { cam = Vector( 0, 35, 0 ), lookat = Vector( 0, 0, 0 ), pos = Vector( -6, 13.5, -1 ) },
    [ "cw_ber_spas12" ] = { cam = Vector( 0, 35, 0 ), lookat = Vector( 0, 0, 0 ), pos = Vector( -13, 13.5, -1 ) },
    [ "cw_amr2_rpk74" ] = { cam = Vector( 0, 35, 0 ), lookat = Vector( 0, 0, 0 ), pos = Vector( -6, 13.5, -1 ) },
    [ "cw_wf_m200" ] = { cam = Vector( 0, 35, 0 ), lookat = Vector( 0, 0, 0 ), pos = Vector( -6, 13.5, -1 ) },
    [ "cw_ber_hkmp7" ] = { cam = Vector( 0, 35, 0 ), lookat = Vector( 0, 0, 0 ), pos = Vector( -4, 13.5, 1 ) },
    [ "cw_amr2_mk46" ] = { cam = Vector( 0, 35, 0 ), lookat = Vector( 0, 0, 0 ), pos = Vector( -6, 13.5, -1 ) },
    [ "cw_fiveseven" ] = { cam = Vector( 0, 35, 0 ), lookat = Vector( 0, 0, 0 ), pos = Vector( -2.5, 13.5, -3.5 ) },
    [ "r5" ] = { cam = Vector( 0, 35, 0 ), lookat = Vector( 0, 0, 0 ), pos = Vector( -10.5, 10, -1.5 ) },
    [ "cw_tr09_auga3" ] = { cam = Vector( 0, 35, 0 ), lookat = Vector( 0, 0, 0 ), pos = Vector( -8.5, 13.5, -3 ) },
    [ "cw_m1014" ] = { cam = Vector( 0, 35, 0 ), lookat = Vector( 0, 0, 0 ), pos = Vector( -6, 9, -1 ) }--[[,
    [ "cw_flash_grenade" ] = { cam = Vector( 0, 35, 0 ), lookat = Vector( 0, 0, 0 ), pos = Vector( -6, 13.5, -1 ) },
    { cam = Vector( 0, 35, 0 ), lookat = Vector( 0, 0, 0 ), pos = Vector( -6, 13.5, -1 ) },
    { cam = Vector( 0, 35, 0 ), lookat = Vector( 0, 0, 0 ), pos = Vector( -6, 13.5, -1 ) },
    { cam = Vector( 0, 35, 0 ), lookat = Vector( 0, 0, 0 ), pos = Vector( -6, 13.5, -1 ) },]]
}

function weaponsshop:DoSetup()
    net.Start( "RequestLockedWeapons" )
    net.SendToServer()

    net.Receive( "RequestLockedWeaponsCallback", function()
        --//Table received with ordered numeric keys and and values as the keys to the locked guns in GAMEMODE.WeaponsList
        GAMEMODE.lockedweapons = net.ReadTable()

        --[[ I'd like for the menu to notify players of new unlocks
        if file.Exists( "tdm/saves/lockedweps.txt", "DATA" ) then
            fil = util.JSONToTable( file.Read( "tdm/saves/lockedweps.txt", "DATA" ) )
            local  = {}
            for k, v in pairs( fil ) do
                if 
            end
        end]]

        if #GAMEMODE.lockedweapons == 0 then
            function self:Paint()
                draw.DrawText( "All weapons purchased!", self.font, self:GetWide() / 2, self:GetTall() / 2, GAMEMODE.TeamColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
            end
            return
        end

        --if self.scrollpanel and self.scrollpanel:IsValid() then self.scrollpanel:Remove() end
        self.scrollpanel = self.scrollpanel or vgui.Create( "DScrollPanel", self )
        self.scrollpanel:SetPos( 0, 0 )
        self.scrollpanel:SetSize( self:GetWide() / 2 - 8, self:GetTall() )
        local sBar = self.scrollpanel:GetVBar()
        function sBar:Paint( w, h )
            draw.RoundedBox( 4, 7, 16, w / 2, h - 32, Color( 66, 66, 66 ) )
            return 
        end
        function sBar.btnGrip:Paint( w, h )
            draw.RoundedBox( 4, 7, 0, w / 2, h, GAMEMODE.TeamColor )
        end
        sBar.btnUp.Paint = function() return end
        sBar.btnDown.Paint = function() return end

        self:RepopulateList()
    end )
end

function weaponsshop:RepopulateList()
    self.listOrder = { {}, {}, {} }

    local typetoint = { ar = 1, smg = 2, sg = 3, sr = 4, lmg = 5, pt = 6, mn = 7, eq = 8 }
    for k, v in pairs( GAMEMODE.lockedweapons ) do
        local slot = GAMEMODE.WeaponsList[ v ].slot
        local typeint = typetoint[ GAMEMODE.WeaponsList[ v ].type ]
        self.listOrder[ slot ][ typeint ] = self.listOrder[ slot ][ typeint ] or { }
        table.insert( self.listOrder[ slot ][ typeint ], GAMEMODE.WeaponsList[ v ] )
    end

    for k, v in pairs( self.weaponbuttons ) do
        if v and v:IsValid() then
            v:Remove()
        end
    end

    local headers = { "Primaries", "Secondaries", "Equipment" }
    for num, slot in pairs( self.listOrder ) do
        if table.Count( slot ) == 0 then continue end

        local header = vgui.Create( "DPanel", self.scrollpanel )
        header:SetSize( self.scrollpanel:GetWide(), 34 )
        header:Dock( TOP )
        header.Paint = function()
            surface.SetFont( "WeaponsShopButtonHeaderDisplay" )
            local textw, textt = surface.GetTextSize( headers[ num ] )
            surface.SetTextColor( 66, 66, 66 )
            surface.SetTextPos( header:GetWide() / 2 - ( textw / 2 ), header:GetTall() / 2 - ( textt / 2 ) )
            surface.DrawText( headers[ num ] )

            surface.SetDrawColor( 0, 0, 0 )
            surface.DrawLine( header:GetWide() / 2 - ( textw / 2 ), header:GetTall() - 1, header:GetWide() / 2 + ( textw / 2 ), header:GetTall() - 1 )
        end
        self.weaponbuttons[ #self.weaponbuttons + 1 ] = header 

        for _, type in pairs( slot ) do
            for _, weptable in pairs( type ) do
                local button = vgui.Create( "WeaponsShopButton", self.scrollpanel )
                button:SetSize( self.scrollpanel:GetWide(), 56 )
                button:Dock( TOP )
                button:SetWeapon( weptable[ 2 ] )
                button:SetFont( "WeaponsShopButtonDisplay" )
                button:SetTrueParent( self, #self.weaponbuttons + 1 )
                if GAMEMODE.MyLevel < weptable[ 3 ] then
                    button:Disable()
                end
                self.weaponbuttons[ #self.weaponbuttons + 1 ] = button
            end
        end
    end

    self:SelectWeapon()
end

function weaponsshop:SelectWeapon( wep, butID )
    if wep == nil then 
        self.selectedweapon = nil
        if self.modelpanel then self.modelpanel:Remove() end
        self.modelpanel = nil
        if self.infopanel then self.infopanel:Remove() end
        self.infopanel = nil
        self.DisplayStats = false
        self.weaponname = "Nothing Selected"
        self.weaponprice = 0
        return
    end

    self.selectedweapon = wep
    local wep = weapons.GetStored( wep )
    if !wep then return end

    self.modelpanel = self.modelpanel or vgui.Create( "DModelPanel", self )
    self.modelpanel:SetSize( self:GetWide() / 2, self:GetTall() / 2 )
    self.modelpanel:SetPos( self:GetWide() / 2, 0 )
    self.modelpanel:SetModel( wep.WorldModel )
    if self.modeloffsets[ self.selectedweapon ] then
        self.modelpanel:SetCamPos( self.modeloffsets[ self.selectedweapon ].cam )
        self.modelpanel:SetLookAt( self.modeloffsets[ self.selectedweapon ].lookat )
        self.modelpanel:GetEntity():SetPos( self.modeloffsets[ self.selectedweapon ].pos )
    else
        self.modelpanel:SetCamPos( Vector( 0, 35, 0 ) ) --Courtesy of Spy
        self.modelpanel:SetLookAt( Vector( 0, 0, 0 ) ) --Courtesy of Spy    
        self.modelpanel:GetEntity():SetPos( Vector( -6, 13.5, -1 ) )
    end
    self.modelpanel:SetFOV( 90 ) --Courtesy of Spy
    --self.modelpanel:GetEntity():SetAngles
    self.modelpanel:SetAmbientLight( Color( 255, 255, 255 ) )
    self.modelpanel.LayoutEntity = function() return true end --Disables rotation
    self.modelpanel.PaintOver = function( _, w, h )
        if self.selectedweapon == nil or !IsValid( self.modelpanel ) then return end
        if !self.weaponbuttons[ butID ].canbuy then
            local diff = 6
            surface.SetDrawColor( 0, 0, 0, 190 )
            surface.DrawRect( diff, diff, w - ( diff * 2 ), h - ( diff * 2 ) )
            --surface.DrawRect( 0, 0, w, h)
            surface.SetTextColor( 255, 255, 255 )
            surface.SetFont( "InsufficientFunds" )
            local textw, textt = surface.GetTextSize("Insufficient")
            surface.SetTextPos( w / 2 - ( textw / 2 ), h / 2 - textt - 2 )
            surface.DrawText( "Insufficient" )
            local textw, textt = surface.GetTextSize("Funds")
            surface.SetTextPos( w / 2 - ( textw / 2 ), h / 2 + 2 )
            surface.DrawText( "Funds" )
        end
    end

    self.weaponname = wep.PrintName or "Nothing Selected"
    self.weaponprice = RetrieveWeaponTable( self.selectedweapon )[ 5 ] or 0

    if wep.Base == "cw_base" then
        self.DisplayStats = true
        for k, v in pairs( self.wepinfo ) do
            if v.value == "Damage" and wep.Shots > 1 then --If it's a shotgun, scale with clumpspread
                v.barfill = ( math.Clamp( wep.Damage * wep.Shots, v.min, v.max + 50 ) - v.min) / ( v.max + 50 - v.min)
            elseif v.value == "AimSpread" then
                v.barfill = 1 - ( math.Clamp( wep.AimSpread - v.min, 0, v.max ) / v.max )

                if wep.Shots > 1 then --If it's a shotgun, scale with clumpspread
                    local clumpspread = 1 - ( ( wep.ClumpSpread - 0.02 ) / ( 0.06 - 0.02 ) )
                    v.barfill = ( v.barfill + clumpspread ) / 2
                    --v.barfill = 1 - ( ( wep.ClumpSpread - 0.02 ) / ( 0.06 - 0.02 ) )
                else --Otherwise scale with hipspread
                    local hipspread = 1 - ( ( wep.HipSpread - 0.03 ) / ( 0.35 - 0.03 ) )
                    v.barfill = ( v.barfill + hipspread ) / 2
                end
            elseif v.value == "FireDelay" then
                v.barfill = 1 - ( ( math.Clamp( wep.FireDelay - v.min, 0, v.max - v.min ) ) / ( v.max - v.min ) )
            elseif v.value == "Recoil" then
                if wep.Shots > 1 then
                    v.barfill = ( math.Clamp( wep.Recoil, 0, 4 ) ) / 4
                else
                    v.barfill = ( ( math.Clamp( wep.Recoil - v.min, 0, v.max - v.min ) ) / ( v.max - v.min ) )
                end
            else
                --//Default information displaying
                v.barfill = math.Clamp( wep[ v.value ], v.min, v.max ) / v.max
            end
        end
    else
        self.DisplayStats = false
    end

    local bar = Material( "vgui/ryg_gradient.png", "noclamp" )
    if self.infopanel and self.infopanel:IsValid() then self.infopanel:Remove() end
    self.infopanel = vgui.Create( "DPanel", self )
    self.infopanel:SetPos( self:GetWide() / 2, self:GetTall() / 2 )
    self.infopanel:SetSize( self:GetWide() / 2, self:GetTall() / 2 )
    self.infopanel.Paint = function()
        if !self.infopanel then return end
        surface.SetFont( "WeaponsShopButtonHeaderDisplay" )
        local headerw, headert = surface.GetTextSize( self.weaponname )
        surface.SetTextColor( GAMEMODE.TeamColor )
        surface.SetTextPos( self.infopanel:GetWide() / 2 - ( headerw / 2 ), 0 )
        surface.DrawText( self.weaponname )

        local infobox = self.infopanel:GetTall() - headert - 4 --//The height wepinfo has room to play with
        local individualt = infobox / ( #self.wepinfo + 1 )

        if self.DisplayStats then
            for k, v in pairs( self.wepinfo ) do
                draw.SimpleText( v.display, "WeaponsShopInfo", self.infopanel:GetWide() / 4, headert + (k - 1) * individualt + ( individualt / 2 ), Color( 0, 0, 0 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
                
                --//Box drawing
                local boxwide = self.infopanel:GetWide() / 3 * 2 - 8
                if v.barfill then
                    surface.SetDrawColor( 0, 0, 0, 80 )
                    surface.DrawRect( self.infopanel:GetWide() / 4 + 4, headert + (k - 1) * individualt + 2, boxwide, individualt - 4 )
                    
                    surface.SetDrawColor( 255, 255, 255 )
                    surface.SetMaterial( bar )
                    if v.scale == "up" then
                        surface.DrawTexturedRectUV( self.infopanel:GetWide() / 4 + 4, headert + (k - 1) * individualt + 2, boxwide * v.barfill, individualt - 4, 0, 0, 1 * v.barfill, 1 )
                    else
                        surface.DrawTexturedRectUV( self.infopanel:GetWide() / 4 + 4, headert + (k - 1) * individualt + 2, boxwide * v.barfill, individualt - 4, 1, 1, 1 - v.barfill, 0 )
                    end
                    --draw.SimpleTextOutlined( v.barfill, "WeaponsShopInfo", self.infopanel:GetWide() / 4 + 8, headert + (k - 1) * individualt + 10, GAMEMODE.TeamColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 255, 255, 255 ) )
                end
            end
        else
            --Pretty much only for equipment, should display some description
        end
    end

    if self.buybutton then self.buybutton:Remove() end
    self.buybutton = vgui.Create( "DButton", self.infopanel )
    self.buybutton:SetSize( 144, 24 )
    self.buybutton:SetPos( self.infopanel:GetWide() / 2 - ( self.buybutton:GetWide() / 2 ), self.infopanel:GetTall() - self.buybutton:GetTall() - 12 )
    self.buybutton:SetText( "" )
    self.buybutton.DoClick = function()
        if self.buybutton.canbuy and self.weaponprice != 0 then
            local success = GAMEMODE:AttemptBuyWeapon( self.selectedweapon )
            if success then
                net.Start( "RequestLockedWeapons" )
                net.SendToServer()

                surface.PlaySound( "ambient/levels/labs/coinslot1.wav" )
            end
        else
            surface.PlaySound( "buttons/combine_button_locked.wav" )
        end
    end
    self.buybutton.Paint = function()
        if self.buybutton.hover and self.buybutton.canbuy then
            surface.SetTextColor( GAMEMODE.TeamColor )
            surface.SetDrawColor( 0, 0, 0, 80 )
            --draw.RoundedBox( 8, 0, 0, self.buybutton:GetWide(), self.buybutton:GetTall(), Color( 0, 0, 0, 80 ) )
            surface.DrawRect(0, 0, self.buybutton:GetWide(), self.buybutton:GetTall() )
        else
            surface.SetTextColor( 66, 66, 66 )
        end

        surface.SetFont( "WeaponsShopMain" )
        local textw, textt = surface.GetTextSize( "Buy for $" .. comma_value( self.weaponprice ) )
        surface.SetTextPos( self.buybutton:GetWide() / 2 - ( textw / 2 ), self.buybutton:GetTall() / 2 - ( textt / 2 ) - 1 )
        surface.DrawText( "Buy for $" .. comma_value( self.weaponprice ) )
    end
    self.buybutton.Think = function()
        if self.weaponprice < GAMEMODE.MyMoney then
            self.buybutton.canbuy = true
        else
            self.buybutton.canbuy = false
        end
    end
    self.buybutton.OnCursorEntered = function()
        self.buybutton.hover = true
    end
    self.buybutton.OnCursorExited = function()
        self.buybutton.hover = false
    end
end

function weaponsshop:Paint()
    surface.SetTexture( GAMEMODE.GradientTexture )
    surface.SetDrawColor( 0, 0, 0, 164 )

    surface.DrawLine( self:GetWide() / 2, 0, self:GetWide() / 2, self:GetTall() )
    surface.DrawTexturedRectRotated( self:GetWide() / 2, 4, 8, self:GetWide(), 270 )

    surface.DrawLine( self:GetWide() / 2, self:GetTall() / 2, self:GetWide(), self:GetTall() / 2 )
    surface.DrawTexturedRectRotated( self:GetWide() / 4 * 3, self:GetTall() / 2 + 4, 8, self:GetWide() / 2, -90 )

    surface.DrawLine(self:GetWide() / 2, 0, self:GetWide() / 2, self:GetTall())
    surface.DrawTexturedRectRotated( self:GetWide() / 2 - 4, self:GetTall() / 2, 8, self:GetTall(), 180 )
end

vgui.Register( "WeaponsShopPanel", weaponsshop, "DPanel" )

--//

local skinsshopbutton = {}
skinsshopbutton.material = Material( "" )
skinsshopbutton.option = ""
skinsshopbutton.rarity = 0
skinsshopbutton.display = ""
skinsshopbutton.font = "DermaDefault"

function skinsshopbutton:SetFont( fnt )
    self.font = fnt
end

function skinsshopbutton:SetSkin( dir )
    local skinTable = GetSkinTableByDirectory( dir )
    self.option = dir
    --self.material = Material( dir )
    self.texture = surface.GetTextureID( dir )
    self.rarity = skinTable.rarity
    self.display = skinTable.name
end

function skinsshopbutton:SetTrueParent( panel )
    --//Since these buttons are actually parented to a scroll panel nested inside my custom panel, I need them to reference the custom panel and not the scroll panel
    self.trueparent = panel
end

function skinsshopbutton:DoClick()
    --Play a sound?
    self.trueparent:SelectOption( self.option )
end

function skinsshopbutton:Paint()
    --//The button should display the texture along the right-hand side of the button
    surface.SetDrawColor( GAMEMODE.ColorRarities[ self.rarity ] )
    surface.SetTexture( GAMEMODE.GradientTexture )
    --surface.DrawTexturedRect( 0, 0, self:GetWide(), self:GetTall() )
    surface.DrawTexturedRectRotated( self:GetWide() / 4, self:GetTall() / 2, self:GetWide() / 2, self:GetTall(), 0 )
    --surface.DrawTexturedRectRotated(x, y, width, height, rotation)

    surface.SetTexture( self.texture )
    surface.DrawTexturedRect( self:GetWide() * 0.85, 4, self:GetTall() - 8, self:GetTall() - 8 )

    surface.SetFont( self.font )
    surface.SetTextColor( 66, 66, 66 )
    local w, h = surface.GetTextSize( self.display )
    surface.SetTextPos( 16, self:GetTall() / 2 - ( h / 2 ) )
    surface.DrawText( self.display )

    --surface.SetDrawColor(0, 0, 0)
    --surface.DrawOutlinedRect(0, 0, self:GetWide(), self:GetTall())

    return true
end

function skinsshopbutton:OnCursorEntered()
    self.hover = true
end

function skinsshopbutton:OnCursorExited()
    self.hover = false
end

function skinsshopbutton:Think()
    if self:GetParent().selected == self.option then
        self.selected = true
    else
        self.selected = false
    end
end

vgui.Register( "SkinsShopButton", skinsshopbutton, "DButton" )

--//

local skinsshop = { }
skinsshop.skins = { }
skinsshop.skinbuttons = { }

function skinsshop:DoSetup()
    net.Start( "RequestLockedSkins" )
    net.SendToServer()

    net.Receive( "RequestLockedSkinsCallback", function()
        GAMEMODE.lockedskins = net.ReadTable()

        if #GAMEMODE.lockedskins == 0 then
            function self:Paint()
                draw.DrawText( "All skins purchased!", self.font, self:GetWide() / 2, self:GetTall() / 2, GAMEMODE.TeamColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
            end
            return
        end

        self.scrollpanel = self.scrollpanel or vgui.Create( "DScrollPanel", self )
        self.scrollpanel:SetPos( 0, 0 )
        self.scrollpanel:SetSize( self:GetWide() / 2 - 16, self:GetTall() ) --I have no idea why this is 8 pixels wider than weaponsshop
        local sBar = self.scrollpanel:GetVBar()
        function sBar:Paint( w, h )
            draw.RoundedBox( 4, 7, 16, w / 2, h - 32, Color( 66, 66, 66 ) )
            return 
        end
        function sBar.btnGrip:Paint( w, h )
            draw.RoundedBox( 4, 7, 0, w / 2, h, GAMEMODE.TeamColor )
        end
        sBar.btnUp.Paint = function() return end
        sBar.btnDown.Paint = function() return end

        self:RepopulateList()
    end )

    self:ApplySkin()
end

function skinsshop:ApplySkin( skin ) --//This function should only be called by skinsshop functions, skinsshopbuttons should call SelectionOption()
    if not self.displayModel then
        self.displayModel = vgui.Create( "DModelPanel", self )
        self.displayModel:SetSize( self:GetWide() / 2, self:GetTall() / 2 )
        self.displayModel:SetPos( self:GetWide() / 2, 0 )
        self.displayModel:SetModel( "models/weapons/w_rif_m4a1.mdl" )
        self.displayModel:SetCamPos( Vector( 0, 35, 0 ) ) --Courtesy of Spy
        self.displayModel:SetLookAt( Vector( 0, 0, 0 ) ) --Courtesy of Spy    
        self.displayModel:GetEntity():SetPos( Vector( 4, 13.5, -1 ) )
        self.displayModel:SetFOV( 90 ) --Courtesy of Spy
        self.displayModel:SetAmbientLight( Color( 255, 255, 255 ) )
        self.displayModel.LayoutEntity = function() return true end --Disables rotation
    end
    
    self.displayModel.Entity:SetMaterial( skin )
end

function skinsshop:SelectOption( dir )
    self.selected = dir
    self:ApplySkin( dir )

    local function genericOnCursorEntered( self )
        self.hover = true
    end

    local function genericOnCursorExited( self )
        self.hover = false
    end

    --//Standard in-game cash. Only the shitty skins can be purchased with this currency
    local tab = GetSkinTableByDirectory( dir )
    local cashdisabled, cashlocked = false
    if tab.cash > 0 then
        if GAMEMODE.MyMoney < tab.cash then
            cashlocked = true
        else
            cashlocked = false
        end
    else
        cashdisabled = true
    end
    self.cashbutton = vgui.Create( "DButton", self )
    self.cashbutton:SetSize( self:GetWide() / 6, self:GetTall() / 2 )
    self.cashbutton:SetPos( self:GetWide() / 2, self:GetTall() - self.cashbutton:GetTall() )
    self.cashbutton:SetText( "" )
    local cashTexture = Material( "vgui/money_icon.png" )
    self.cashbutton.Paint = function()
        --surface.SetDrawColor( 0, 0, 0 )
        --surface.SetMaterial( cashTexture )
        --surface.DrawTexturedRect(x, y, width, height)
        surface.SetDrawColor(0, 0, 0)
        surface.DrawOutlinedRect(0, 0, self.cashbutton:GetWide(), self.cashbutton:GetTall())
    end
    self.cashbutton.DoClick = function()

    end
    self.cashbutton.OnCursorEntered = genericOnCursorEntered( self.cashbutton )
    self.cashbutton.OnCursorExited = genericOnCursorExited( self.cashbutton )

    --//Prestige tokens. All weapon skins except rarity 5 (the most rare) can be purchased with this currency
    local tokensdisabled, tokenslocked = false
    if tab.tokens > 0 then
        if GAMEMODE.MyPrestigeTokens < tab.tokens then
            tokenslocked = true
        else
            tokenslocked = false
        end
    else
        tokensdisabled = true
    end
    self.tokensbutton = vgui.Create( "DButton", self )
    self.tokensbutton:SetSize( self:GetWide() / 6, self:GetTall() / 2 )
    self.tokensbutton:SetPos( self:GetWide() / 2 + self.tokensbutton:GetWide(), self:GetTall() - self.tokensbutton:GetTall() )
    self.tokensbutton:SetText( "" )
    self.tokensbutton.Paint = function()
        surface.SetDrawColor(0, 0, 0)
        surface.DrawOutlinedRect(0, 0, self:GetWide(), self:GetTall())
    end
    self.tokensbutton.DoClick = function()

    end
    self.tokensbutton.OnCursorEntered = genericOnCursorEntered( self.tokensbutton )
    self.tokensbutton.OnCursorExited = genericOnCursorExited( self.tokensbutton )

    --//Donator credits. All weapons can be purchased with this currency. Pricing barely changes across rarity levels
    local creditsdisabled, creditslocked = false
    if tab.tokens > 0 then
        if GAMEMODE.MyPrestigeTokens < tab.tokens then
            creditslocked = true
        else
            creditslocked = false
        end
    else
        creditsdisabled = true
    end
    self.creditsbutton = vgui.Create( "DButton", self )
    self.creditsbutton:SetSize( self:GetWide() / 6, self:GetTall() / 2 )
    self.creditsbutton:SetPos( self:GetWide() / 2 + ( self.creditsbutton:GetWide() * 2 ), self:GetTall() - self.creditsbutton:GetTall() )
    self.creditsbutton:SetText( "" )
    self.creditsbutton.Paint = function()
        surface.SetDrawColor(0, 0, 0)
        surface.DrawOutlinedRect(0, 0, self:GetWide(), self:GetTall())
    end
    self.creditsbutton.DoClick = function()

    end
    self.creditsbutton.OnCursorEntered = genericOnCursorEntered( self.creditsbutton )
    self.creditsbutton.OnCursorExited = genericOnCursorExited( self.creditsbutton )
end

function skinsshop:RepopulateList()
    self.listOrder = { [ 0 ] = {}, {}, {}, {}, {}, {} }
    for k, v in pairs( GAMEMODE.lockedskins ) do
        if self.listOrder[ GAMEMODE.WeaponSkins[ v ].rarity ] then
            table.insert( self.listOrder[ GAMEMODE.WeaponSkins[ v ].rarity ], GAMEMODE.WeaponSkins[ v ] )
        end
    end

    for k, v in pairs( self.listOrder ) do
        if #v == 0 then continue end

        local header = vgui.Create( "DPanel", self.scrollpanel )
        header:SetSize( self.scrollpanel:GetWide(), 34 )
        header:Dock( TOP )
        header.Paint = function()
            surface.SetFont( "SkinsShopTitleFont" )
            local textw, textt = surface.GetTextSize( "Tier " .. k + 1 )
            surface.SetTextColor( GAMEMODE.ColorRarities[ k ] )
            surface.SetTextPos( header:GetWide() / 2 - ( textw / 2 ), header:GetTall() / 2 - ( textt / 2 ) )
            surface.DrawText( "Tier " .. k + 1 )

            --draw.SimpleText( "Tier " .. k + 1, "SkinsShopTitleFont", header:GetWide() / 2, header:GetTall() / 2, GAMEMODE.ColorRarities[ k ], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
            surface.SetDrawColor( GAMEMODE.ColorRarities[ k ] )
            surface.DrawLine( header:GetWide() / 2 - ( textw / 2 ), header:GetTall() - 1, header:GetWide() / 2 + ( textw / 2 ), header:GetTall() - 1 )
        end

        for k2, v2 in pairs( v ) do
            local button = vgui.Create( "SkinsShopButton", self.scrollpanel )
            button:SetSkin( v2.directory )
            button:SetFont( "SkinsShopButtonFont" )
            button:SetSize( self.scrollpanel:GetWide(), 56 )
            button:Dock( TOP )
            button:SetTrueParent( self )
            self.skinbuttons[ v2.directory ] = button
        end
    end
end

function skinsshop:Paint()
    if self.selected then
        surface.SetDrawColor( GAMEMODE.ColorRarities[ self.skinbuttons[ self.selected ].rarity ] )
        surface.SetFont( "SkinsShopTitleFont" )
        local w, t = surface.GetTextSize( self.skinbuttons[ self.selected ].display )
        surface.SetTextPos( self:GetWide() / 4 * 3 - ( w / 2 ), self:GetWide() / 4 * 3 - t - 2 )
        surface.DrawText( self.skinbuttons[ self.selected ].display )

        surface.SetDrawColor( 0, 0, 0 )
        local w, t = surface.GetTextSize( "Price: " .. self.skinbuttons[ self.selected ].rarity .. " prestige tokens" )
        surface.SetTextPos( self:GetWide() / 4 * 3 - ( w / 2 ), self:GetWide() / 4 * 3 + 2 )
        surface.DrawText( "Price: " .. self.skinbuttons[ self.selected ].rarity .. " prestige tokens" )
    end
    --surface.SetDrawColor(0, 0, 0)
    --surface.DrawOutlinedRect(0, 0, self:GetWide(), self:GetTall() )
    --surface.DrawLine( self:GetWide() / 2, 0, self:GetWide() / 2, self:GetTall())
    surface.SetTexture( GAMEMODE.GradientTexture )
    surface.SetDrawColor( 0, 0, 0, 164 )

    surface.DrawLine( self:GetWide() / 2, 0, self:GetWide() / 2, self:GetTall() )
    surface.DrawTexturedRectRotated( self:GetWide() / 2, 4, 8, self:GetWide(), 270 )

    surface.DrawLine( self:GetWide() / 2, self:GetTall() / 2, self:GetWide(), self:GetTall() / 2 )
    surface.DrawTexturedRectRotated( self:GetWide() / 4 * 3, self:GetTall() / 2 + 4, 8, self:GetWide() / 2, -90 )

    surface.DrawLine(self:GetWide() / 2, 0, self:GetWide() / 2, self:GetTall())
    surface.DrawTexturedRectRotated( self:GetWide() / 2 - 4, self:GetTall() / 2, 8, self:GetTall(), 180 )
end

function skinsshop:DoClick()
    self:RepopulateList()
    surface.PlaySound( GAMEMODE.ButtonSounds.Accept[ math.random( #GAMEMODE.ButtonSounds.Accept ) ] )
end

vgui.Register( "SkinsShopPanel", skinsshop, "DPanel" )

--//

local modelsshopbutton = table.Copy( skinsshopbutton )

--//

local modelsshop = { }

vgui.Register( "ModelsShopPanel", modelsshop, "DPanel" )

--[[
    Feedback received over the Discord:
        - One user didn't like the Exo font
        - One user suggested making the font thicker
        - Tab names are too small compared to their size (in weapons)
        - Back arrow looked strange
        - Weapons shop has too many tabs/buttons (suggested doing one big list like in skins separated with dividers)
        - Weapon buy button not obvious
        - Shop could do with less team-specific coloring
        - Remove LVL-requirement icon when the player reaches the level (only shows up when too-low level)
        - Thicker font is being emphasized by a second user
        - Maybe highlight tabs instead of underline

    Day 3:
        - Scroll bar grab part could be team-colored
]]