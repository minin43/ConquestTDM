--//This file is strictly for creating custom vgui elements for the shop
--//DAMN YE ALL WHO ENTER HERE, this file is a damn clusterfuck

GM.slotmaterials = { Material( "vgui/prinary_icon.png" ), Material( "secondary_icon.png" ), Material( "equipment_icon.png" ) }
GM.typematerials = { Material( "vgui/ar_icon.png" ), Material( "vgui/smg_icon.png" ), Material( "vgui/shotgun_icon.png" ), Material( "vgui/sniper_icon.png" ),
    Material( "vgui/lmg_icon.png" ), Material( "vgui/pistol_icon.png" ), Material( "vgui/magnum_icon.png" ), Material( "vgui/equipment_icon.png" ), 
    ar = Material( "vgui/ar_icon.png" ), smg = Material( "vgui/smg_icon.png" ), sg = Material( "vgui/shotgun_icon.png" ), sr = Material( "vgui/sniper_icon.png" ),
    lmg = Material( "vgui/lmg_icon.png" ), pt = Material( "vgui/pistol_icon.png" ), mn = Material( "vgui/magnum_icon.png" ), eq = Material( "vgui/equipment_icon.png" ) }
GM.levelmaterials = { Material( "vgui/level_locked.png" ), Material( "vgui/level_unlocked.png" ) }
GM.moneymaterials = { Material( "vgui/money_locked.png" ), Material( "vgui/money_unlocked.png" ) }

surface.CreateFont( "Exo-20-600" , { font = "Exo 2", size = 20, weight = 600 } )
surface.CreateFont( "Exo-36-600" , { font = "Exo 2", size = 36, weight = 600 } )
surface.CreateFont( "Exo-32-600" , { font = "Exo 2", size = 32, weight = 600 } )
surface.CreateFont( "Exo-16-500" , { font = "Exo 2", size = 16, weight = 500 } )
surface.CreateFont( "Exo-16-600" , { font = "Exo 2", size = 16, weight = 600 } )
surface.CreateFont( "Exo-24-600" , { font = "Exo 2", size = 24, weight = 600 } )
surface.CreateFont( "Exo-32-400", { font = "Exo 2", size = 32 } )

surface.CreateFont( "Exo-28-600", { font = "Exo 2", size = 28, weight = 600 } )
surface.CreateFont( "Exo-40-600", { font = "Exo 2", size = 40, weight = 600 } )

--//

--WeaponInfo is used both in cl_shop_setup as well as cl_loadout_setup
local weaponinfo = {}
weaponinfo.font = "Exo-36-600"
weaponinfo.wepinfo = {}

function weaponinfo:SetFont( fnt )
    self.font = fnt
end

function weaponinfo:CreateStats( wepclass )
    local wep = weapons.GetStored( wepclass )
    if !wep then return end

    self.wepinfo = {
        { value = "Damage",     display = "Damage",     barfill = 0,    min = 0,        max = 120,  scale = "up" },
        { value = "FireDelay",  display = "Firerate",   barfill = 0,    min = 0.05,     max = 1.5,  scale = "up" },
        { value = "AimSpread",  display = "Accuracy",   barfill = 0,    min = 0.001,    max = 0.03, scale = "up" },
        { value = "Recoil",     display = "Recoil",     barfill = 0,    min = 0.1,      max = 2,    scale = "down" }
    }
    
    self.weaponname = wep.PrintName or "Nothing Selected"
    self.weaponprice = RetrieveWeaponTable( wepclass )[ 5 ] or 0

    if wep.Base == "cw_base" then
        self.DisplayStats = true
        for k, v in pairs( self.wepinfo ) do
            if v.value == "Damage" and wep.Shots > 1 then --If it's a shotgun, scale with shots * damage
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

    self.bar = Material( "vgui/ryg_gradient.png", "noclamp" )
    self.draw = true
end

function weaponinfo:Paint()
    if !self or !self.draw then return end
    --print("wtf")
    surface.SetFont( self.font )
    local headerw, headert = surface.GetTextSize( self.weaponname )
    surface.SetTextColor( GAMEMODE.TeamColor )
    surface.SetTextPos( self:GetWide() / 2 - ( headerw / 2 ), 0 )
    surface.DrawText( self.weaponname )

    local infobox = self:GetTall() - headert - 4 --//The height wepinfo has room to play with
    local individualt = infobox / ( #self.wepinfo + 1 )

    if self.DisplayStats then
        for k, v in pairs( self.wepinfo ) do
            draw.SimpleText( v.display, "Exo-16-600", self:GetWide() / 4, headert + (k - 1) * individualt + ( individualt / 2 ), Color( 0, 0, 0 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
            
            --//Box drawing
            local boxwide = self:GetWide() / 3 * 2 - 8
            if v.barfill then
                surface.SetDrawColor( 0, 0, 0, 80 )
                surface.DrawRect( self:GetWide() / 4 + 4, headert + (k - 1) * individualt + 2, boxwide, individualt - 4 )
                
                surface.SetDrawColor( 255, 255, 255 )
                surface.SetMaterial( self.bar )
                if v.scale == "up" then
                    surface.DrawTexturedRectUV( self:GetWide() / 4 + 4, headert + (k - 1) * individualt + 2, boxwide * v.barfill, individualt - 4, 0, 0, 1 * v.barfill, 1 )
                else
                    surface.DrawTexturedRectUV( self:GetWide() / 4 + 4, headert + (k - 1) * individualt + 2, boxwide * v.barfill, individualt - 4, 1, 1, 1 - v.barfill, 0 )
                end
                --draw.SimpleTextOutlined( v.barfill, "Exo-16-600", self:GetWide() / 4 + 8, headert + (k - 1) * individualt + 10, GAMEMODE.TeamColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 255, 255, 255 ) )
            end
        end
    else
        --Pretty much only for equipment, should display some description
    end
    return true
end

vgui.Register( "WeaponInfo", weaponinfo, "DPanel" )

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
        surface.SetFont( "Exo-16-500" )
        surface.SetTextPos( self:GetTall() + 12, self:GetTall() / 2 + 8 )
        surface.DrawText( "Cost: " .. comma_value( self.weapontable[ 5 ] ) )
    else
        --surface.SetDrawColor( colorScheme[ 1 ].TeamColor )
        --surface.SetMaterial( GAMEMODE.moneymaterials[ 1 ] )

        surface.SetTextColor( colorScheme[ 1 ].TeamColor )
        surface.SetFont( "Exo-16-500" )
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
            --surface.SetTexture( GAMEMODE.GradientTexture )
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
weaponsshop.font = "Exo-20-600"
--weaponsshop.tabs = { "ar", "smg", "sg", "sr", "lmg", "pt", "mn", "eq" } --To remove?
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
            surface.SetFont( "Exo-36-600" )
            local textw, textt = surface.GetTextSize( headers[ num ] )
            surface.SetTextColor( GAMEMODE.TeamColor )--66, 66, 66 )
            surface.SetTextPos( header:GetWide() / 2 - ( textw / 2 ), header:GetTall() / 2 - ( textt / 2 ) )
            surface.DrawText( headers[ num ] )

            surface.SetDrawColor( GAMEMODE.TeamColor )
            surface.DrawLine( header:GetWide() / 2 - ( textw / 2 ), header:GetTall() - 1, header:GetWide() / 2 + ( textw / 2 ), header:GetTall() - 1 )
        end
        self.weaponbuttons[ #self.weaponbuttons + 1 ] = header 

        for _, type in pairs( slot ) do
            for _, weptable in pairs( type ) do
                local button = vgui.Create( "WeaponsShopButton", self.scrollpanel )
                button:SetSize( self.scrollpanel:GetWide(), 56 )
                button:Dock( TOP )
                button:SetWeapon( weptable[ 2 ] )
                button:SetFont( "Exo-32-600" )
                button:SetTrueParent( self, #self.weaponbuttons + 1 )
                if GAMEMODE.MyLevel < weptable[ 3 ] then
                    button:Disable()
                end
                self.weaponbuttons[ #self.weaponbuttons + 1 ] = button
            end
            --[[local spacer = vgui.Create( "DPanel", self.scrollpanel )
            spacer:SetSize( self.scrollpanel:GetWide(), GAMEMODE.TitleBar / 4 )
            spacer:Dock( TOP )
            spacer.Paint = function( panel, w, h )
                surface.SetDrawColor( GAMEMODE.TeamColor )
                surface.DrawLine( 4, h / 2, w - 4, h / 2 )
            end]]
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

            surface.SetFont( "Exo-32-400" )
            local textw, textt = surface.GetTextSize("Insufficient")
            draw.SimpleTextOutlined( "Insufficient", "Exo-32-400", w / 2 - ( textw / 2 ), h / 2 - textt - 2, Color( 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
            textw, textt = surface.GetTextSize("Funds")
            draw.SimpleTextOutlined( "Funds", "Exo-32-400", w / 2 - ( textw / 2 ), h / 2 + 2, Color( 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
        end
    end

    self.weaponname = wep.PrintName or "Nothing Selected"
    self.weaponprice = RetrieveWeaponTable( self.selectedweapon )[ 5 ] or 0

    self.infopanel = self.infopanel or vgui.Create( "WeaponInfo", self )
    self.infopanel:SetPos( self:GetWide() / 2, self:GetTall() / 2 )
    self.infopanel:SetSize( self:GetWide() / 2, self:GetTall() / 2 )
    self.infopanel:CreateStats( self.selectedweapon )

    --[[if wep.Base == "cw_base" then
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
        surface.SetFont( "Exo-36-600" )
        local headerw, headert = surface.GetTextSize( self.weaponname )
        surface.SetTextColor( GAMEMODE.TeamColor )
        surface.SetTextPos( self.infopanel:GetWide() / 2 - ( headerw / 2 ), 0 )
        surface.DrawText( self.weaponname )

        local infobox = self.infopanel:GetTall() - headert - 4 --//The height wepinfo has room to play with
        local individualt = infobox / ( #self.wepinfo + 1 )

        if self.DisplayStats then
            for k, v in pairs( self.wepinfo ) do
                draw.SimpleText( v.display, "Exo-16-600", self.infopanel:GetWide() / 4, headert + (k - 1) * individualt + ( individualt / 2 ), Color( 0, 0, 0 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
                
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
                    --draw.SimpleTextOutlined( v.barfill, "Exo-16-600", self.infopanel:GetWide() / 4 + 8, headert + (k - 1) * individualt + 10, GAMEMODE.TeamColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 255, 255, 255 ) )
                end
            end
        else
            --Pretty much only for equipment, should display some description
        end
    end]]

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

        surface.SetFont( "Exo-20-600" )
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
skinsshopbutton.order = 0
skinsshopbutton.alpha = 0
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

    self.textureimage = vgui.Create( "DImage", self )
    self.textureimage:SetImage( self.option )
    self.textureimage:SetSize( self:GetTall() - 16, self:GetTall() - 16 )
    self.textureimage:SetPos( self:GetWide() * 0.8, 8 )
end

function skinsshopbutton:SetTrueParent( panel, order )
    --//Since these buttons are actually parented to a scroll panel nested inside my custom panel, I need them to reference the custom panel and not the scroll panel
    self.trueparent = panel
    self.order = order
end

function skinsshopbutton:DoClick()
    surface.PlaySound( GAMEMODE.ButtonSounds.Accept[ math.random( #GAMEMODE.ButtonSounds.Accept ) ] )
    self.trueparent:SelectOption( self.option )
end

function skinsshopbutton:Paint()
    --//The button should display the texture along the right-hand side of the button
    --[[if self.hover or self.trueparent.selected == self.option then
        surface.SetDrawColor( GAMEMODE.ColorRarities[ self.rarity ] )
        surface.SetTexture( GAMEMODE.GradientTexture )
        surface.DrawTexturedRectRotated( self:GetWide() / 4, self:GetTall() / 2, self:GetWide() / 2, self:GetTall(), 0 )
    end]]

    surface.SetFont( self.font )
    surface.SetTextColor( 0, 0, 0, 220 )
    if self.hover or self.selected then
        surface.SetTextColor( GAMEMODE.TeamColor )
    end
    local w, h = surface.GetTextSize( self.display )
    surface.SetTextPos( 16, self:GetTall() / 2 - ( h / 2 ) )
    surface.DrawText( self.display )

    if self.order != 1 and self.order != 0 then
        if self.trueparent.skinbuttonsnumerical[ self.order - 1 ].hover then
            surface.SetTexture( GAMEMODE.GradientTexture )
            surface.SetDrawColor( GAMEMODE.ColorRarities[ self.rarity ] )
            surface.DrawTexturedRectRotated( self:GetWide() / 2, 4, 8, self:GetWide(), -90 )
        end
    end
    if self.order != #self.trueparent.skinbuttonsnumerical then
        if self.trueparent.skinbuttonsnumerical[ self.order + 1 ].hover then
            surface.SetTexture( GAMEMODE.GradientTexture )
            surface.SetDrawColor( GAMEMODE.ColorRarities[ self.rarity ] )
            surface.DrawTexturedRectRotated( self:GetWide() / 2, self:GetTall() - 4, 8, self:GetWide(), 90 )
        end

        if !self.hover and !self.trueparent.skinbuttonsnumerical[ self.order + 1 ].hover then
            --surface.SetTexture( GAMEMODE.GradientTexture )
            surface.SetDrawColor( 0, 0, 0, 164)
            surface.DrawLine( self:GetTall() - 12, self:GetTall() - 1, self:GetWide(), self:GetTall() - 1 )
        end
    end

    return true
end

function skinsshopbutton:OnCursorEntered()
    self.hover = true
end

function skinsshopbutton:OnCursorExited()
    self.hover = false
end

function skinsshopbutton:Think()
    if self.trueparent.selected == self.option then
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

vgui.Register( "SkinsShopButton", skinsshopbutton, "DButton" )

--//

local skinsshop = { }
skinsshop.skins = { }
skinsshop.skinbuttons = { }
skinsshop.skinbuttonsnumerical = { }

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

        local weirdpaddingissue = 0
        if self.scrollpanel then weirdpaddingissue = 8 end
        self.scrollpanel = self.scrollpanel or vgui.Create( "DScrollPanel", self )
        self.scrollpanel:SetPos( 0, 0 )
        self.scrollpanel:SetSize( self:GetWide() / 2 - 16 + weirdpaddingissue, self:GetTall() ) --I have no idea why this is 8 pixels wider than weaponsshop
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

function skinsshop:ApplySkin( skin ) --//This function should only be called by skinsshop functions, skinsshopbuttons should call SelectOption()
    if not self.displayModel then
        self.displayModel = vgui.Create( "DModelPanel", self )
        self.displayModel:SetSize( self:GetWide() / 2, self:GetTall() / 2 )
        self.displayModel:SetPos( self:GetWide() / 2, 0 )
        self.displayModel:SetModel( "models/weapons/w_rif_m4a1.mdl" )
        self.displayModel:SetCamPos( Vector( 0, 35, 0 ) ) --Courtesy of Spy
        self.displayModel:SetLookAt( Vector( 0, 0, 0 ) ) --Courtesy of Spy    
        self.displayModel:GetEntity():SetPos( Vector( 4, 13, -4 ) )
        self.displayModel:SetFOV( 90 ) --Courtesy of Spy
        self.displayModel:SetAmbientLight( Color( 255, 255, 255 ) )
        self.displayModel.LayoutEntity = function() return true end --Disables rotation
    end
    
    self.displayModel.Entity:SetMaterial( skin )
end

function skinsshop:SelectOption( dir )
    if dir == nil then
        self.selected = nil
        if self.cashbutton then self.cashbutton:Remove() self.cashbutton = nil end
        if self.tokensbutton then self.tokensbutton:Remove() self.tokensbutton = nil end
        if self.creditsbutton then self.creditsbutton:Remove() self.creditsbutton = nil end
        self:ApplySkin()
        return
    end

    self.selected = dir
    self.display = GetSkinTableByDirectory( self.selected ).name
    self:ApplySkin( dir )

    --//Standard in-game cash. Only the shitty skins can be purchased with this currency
    local tab = GetSkinTableByDirectory( dir )
    local cashdisabled = tab.cash == 0
    local cashlocked = GAMEMODE.MyMoney < tab.cash
    self.cashbutton = self.cashbutton or vgui.Create( "DButton", self )
    self.cashbutton:SetSize( self:GetWide() / 6, self:GetTall() / 5 * 2 )
    self.cashbutton:SetPos( self:GetWide() / 2, self:GetTall() - self.cashbutton:GetTall() )
    self.cashbutton:SetText( "" )
    self.cashbutton.Paint = function( _, w, h )
        surface.SetDrawColor( 0, 0, 0, 190 )
        surface.SetMaterial( GAMEMODE.Icons.Menu.cashIcon )
        if self.cashbutton.hover and !cashdisabled then
            if !cashlocked then
                surface.SetDrawColor( GAMEMODE.TeamColor )
                surface.DrawTexturedRect( self.cashbutton:GetWide() / 2 - 48, 8, 96, 96 )
                draw.SimpleText( "$" .. comma_value( tab.cash ), "Exo-28-600", self.cashbutton:GetWide() / 2, self.cashbutton:GetTall() / 3 * 2, GAMEMODE.TeamColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
            else
                surface.DrawTexturedRect( self.cashbutton:GetWide() / 2 - 48, 8, 96, 96 )
                draw.SimpleText( "$" .. comma_value( tab.cash ), "Exo-28-600", self.cashbutton:GetWide() / 2, self.cashbutton:GetTall() / 3 * 2, Color( 0, 0, 0, 220 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
                
                surface.SetDrawColor( 0, 0, 0, 190 )
                surface.DrawRect( 4, 6, self.cashbutton:GetWide() - 8, self.cashbutton:GetTall() - 11 )

                surface.SetFont( "Exo-28-600" )
                local textw, textt = surface.GetTextSize("Low")
                draw.SimpleTextOutlined( "Low", "Exo-28-600", w / 2 - ( textw / 2 ), h / 2 - textt - 2, Color( 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
                textw, textt = surface.GetTextSize("Funds")
                draw.SimpleTextOutlined( "Funds", "Exo-28-600", w / 2 - ( textw / 2 ), h / 2 + 2, Color( 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
            end
        else
            if cashdisabled then
                draw.SimpleText( "Disabled", "Exo-28-600", self.cashbutton:GetWide() / 2, self.cashbutton:GetTall() / 3 * 2, Color( 0, 0, 0, 220 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
            else
                draw.SimpleText( "$" .. comma_value( tab.cash ), "Exo-28-600", self.cashbutton:GetWide() / 2, self.cashbutton:GetTall() / 3 * 2, Color( 0, 0, 0, 220 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
            end
            surface.DrawTexturedRect( self.cashbutton:GetWide() / 2 - 48, 8, 96, 96 )
        end
    end
    self.cashbutton.DoClick = function()
        if !cashlocked and !cashdisabled then
            local success = GAMEMODE:AttemptBuyWepSkin( self.selected, "cash" )
            if success then
                net.Start( "RequestLockedSkins" )
                net.SendToServer()

                surface.PlaySound( "ambient/levels/labs/coinslot1.wav" )
            end
        else
            surface.PlaySound( GAMEMODE.ButtonSounds.Deny[ math.random( #GAMEMODE.ButtonSounds.Deny ) ] )
        end
    end
    self.cashbutton.OnCursorEntered = function()
        self.cashbutton.hover = true
    end
    self.cashbutton.OnCursorExited = function()
        self.cashbutton.hover = false
    end

    --//Prestige tokens. All weapon skins except rarity 5 (the most rare) can be purchased with this currency
    local tokenslocked = GAMEMODE.MyPrestigeTokens < tab.tokens
    local tokensdisabled = tab.tokens == 0
    local tokensdisplay = "Tokens"
    if tab.tokens == 1 then tokensdisplay = "Token" end
    self.tokensbutton = self.tokensbutton or vgui.Create( "DButton", self )
    self.tokensbutton:SetSize( self:GetWide() / 6, self:GetTall() / 5 * 2 )
    self.tokensbutton:SetPos( self:GetWide() / 2 + self.tokensbutton:GetWide(), self:GetTall() - self.tokensbutton:GetTall() )
    self.tokensbutton:SetText( "" )
    self.tokensbutton.Paint = function( _, w, h )
        surface.SetDrawColor( 0, 0, 0, 190 )
        surface.SetMaterial( GAMEMODE.Icons.Menu.tokensIcon )
        if self.tokensbutton.hover and !tokensdisabled then
            if !tokenslocked then
                surface.SetDrawColor( GAMEMODE.TeamColor )
                surface.DrawTexturedRect( self.tokensbutton:GetWide() / 2 - 48, 8, 96, 96 )
                draw.SimpleText( tab.tokens .. " " .. tokensdisplay, "Exo-28-600", self.tokensbutton:GetWide() / 2, self.tokensbutton:GetTall() / 3 * 2, GAMEMODE.TeamColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
            else
                surface.DrawTexturedRect( self.tokensbutton:GetWide() / 2 - 48, 8, 96, 96 )
                draw.SimpleText( tab.tokens .. " " .. tokensdisplay, "Exo-28-600", self.tokensbutton:GetWide() / 2, self.tokensbutton:GetTall() / 3 * 2, Color( 0, 0, 0, 220 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
                
                surface.SetDrawColor( 0, 0, 0, 190 )
                surface.DrawRect( 4, 6, self.tokensbutton:GetWide() - 8, self.tokensbutton:GetTall() - 11 )

                surface.SetFont( "Exo-28-600" )
                local textw, textt = surface.GetTextSize("Low")
                draw.SimpleTextOutlined( "Low", "Exo-28-600", w / 2 - ( textw / 2 ), h / 2 - textt - 2, Color( 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
                textw, textt = surface.GetTextSize("Tokens")
                draw.SimpleTextOutlined( "Tokens", "Exo-28-600", w / 2 - ( textw / 2 ), h / 2 + 2, Color( 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
            end
        else
            if tokensdisabled then
                draw.SimpleText( "Disabled", "Exo-28-600", self.tokensbutton:GetWide() / 2, self.tokensbutton:GetTall() / 3 * 2, Color( 0, 0, 0, 220 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
            else
                draw.SimpleText( tab.tokens .. " " .. tokensdisplay, "Exo-28-600", self.tokensbutton:GetWide() / 2, self.tokensbutton:GetTall() / 3 * 2, Color( 0, 0, 0, 220 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
            end
            surface.DrawTexturedRect( self.tokensbutton:GetWide() / 2 - 48, 8, 96, 96 )
        end
    end
    self.tokensbutton.DoClick = function()
        if !tokenslocked and !tokensdisabled then
            local success = GAMEMODE:AttemptBuyWepSkin( self.selected, "tokens" )
            if success then
                net.Start( "RequestLockedSkins" )
                net.SendToServer()

                surface.PlaySound( "ambient/levels/labs/coinslot1.wav" )
            end
        else
            surface.PlaySound( GAMEMODE.ButtonSounds.Deny[ math.random( #GAMEMODE.ButtonSounds.Deny ) ] )
        end
    end
    self.tokensbutton.OnCursorEntered = function()
        self.tokensbutton.hover = true
    end
    self.tokensbutton.OnCursorExited = function()
        self.tokensbutton.hover = false
    end

    --//Donator credits. All skins can be purchased with this currency. Pricing barely changes across rarity levels
    local creditslocked = GAMEMODE.MyCredits < tab.credits
    local creditsdisplay = "Credits"
    if tab.credits == 1 then creditsdisplay = "Credit" end
    self.creditsbutton = self.creditsbutton or vgui.Create( "DButton", self )
    self.creditsbutton:SetSize( self:GetWide() / 6, self:GetTall() / 5 * 2 )
    self.creditsbutton:SetPos( self:GetWide() / 2 + ( self.creditsbutton:GetWide() * 2 ), self:GetTall() - self.creditsbutton:GetTall() )
    self.creditsbutton:SetText( "" )
    self.creditsbutton.Paint = function( _, w, h )
        surface.SetDrawColor( 0, 0, 0, 190 )
        surface.SetMaterial( GAMEMODE.Icons.Menu.creditsIcon )
        if self.creditsbutton.hover then
            if !creditslocked then
                surface.SetDrawColor( GAMEMODE.TeamColor )
                surface.DrawTexturedRect( self.cashbutton:GetWide() / 2 - 48, 8, 96, 96 )
                draw.SimpleText( tab.credits .. " " .. creditsdisplay, "Exo-28-600", self.creditsbutton:GetWide() / 2, self.creditsbutton:GetTall() / 3 * 2, GAMEMODE.TeamColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
            else
                surface.DrawTexturedRect( self.cashbutton:GetWide() / 2 - 48, 8, 96, 96 )
                draw.SimpleText( tab.credits .. " " .. creditsdisplay, "Exo-28-600", self.creditsbutton:GetWide() / 2, self.creditsbutton:GetTall() / 3 * 2, Color( 0, 0, 0, 220 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
                
                surface.SetDrawColor( 0, 0, 0, 190 )
                surface.DrawRect( 4, 6, self.creditsbutton:GetWide() - 8, self.creditsbutton:GetTall() - 11 )

                surface.SetFont( "Exo-28-600" )
                local textw, textt = surface.GetTextSize("Low")
                draw.SimpleTextOutlined( "Low", "Exo-28-600", w / 2 - ( textw / 2 ), h / 2 - textt - 2, Color( 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
                textw, textt = surface.GetTextSize("Credits")
                draw.SimpleTextOutlined( "Credits", "Exo-28-600", w / 2 - ( textw / 2 ), h / 2 + 2, Color( 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
            end
        else
            surface.DrawTexturedRect( self.cashbutton:GetWide() / 2 - 48, 8, 96, 96 )
            draw.SimpleText( tab.credits .. " " .. creditsdisplay, "Exo-28-600", self.creditsbutton:GetWide() / 2, self.creditsbutton:GetTall() / 3 * 2, Color( 0, 0, 0, 220 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        end
    end
    self.creditsbutton.DoClick = function()
        if !creditslocked then
            local success = GAMEMODE:AttemptBuyWepSkin( self.selected, "credits" )
            if success then
                net.Start( "RequestLockedSkins" )
                net.SendToServer()

                surface.PlaySound( "ambient/levels/labs/coinslot1.wav" )
            end
        else
            surface.PlaySound( GAMEMODE.ButtonSounds.Deny[ math.random( #GAMEMODE.ButtonSounds.Deny ) ] )
        end
    end
    self.creditsbutton.OnCursorEntered = function()
        self.creditsbutton.hover = true
    end
    self.creditsbutton.OnCursorExited = function()
        self.creditsbutton.hover = false
    end
end

function skinsshop:RepopulateList()
    self.listOrder = { [ 0 ] = {}, {}, {}, {}, {}, {} }
    for k, v in pairs( GAMEMODE.lockedskins ) do
        if self.listOrder[ GAMEMODE.WeaponSkins[ v ].rarity ] then
            table.insert( self.listOrder[ GAMEMODE.WeaponSkins[ v ].rarity ], GAMEMODE.WeaponSkins[ v ] )
        end
    end

    for k, v in pairs( self.skinbuttonsnumerical ) do
        if v and v:IsValid() then
            v:Remove()
        end
    end

    for k, v in pairs( self.listOrder ) do
        if #v == 0 then continue end

        local header = vgui.Create( "DPanel", self.scrollpanel )
        header:SetSize( self.scrollpanel:GetWide(), 34 )
        header:Dock( TOP )
        header.Paint = function()
            surface.SetFont( "Exo-40-600" )
            local textw, textt = surface.GetTextSize( "Tier " .. k + 1 )
            surface.SetTextColor( GAMEMODE.ColorRarities[ k ] )
            surface.SetTextPos( header:GetWide() / 2 - ( textw / 2 ), header:GetTall() / 2 - ( textt / 2 ) )
            surface.DrawText( "Tier " .. k + 1 )

            --draw.SimpleText( "Tier " .. k + 1, "Exo-40-600", header:GetWide() / 2, header:GetTall() / 2, GAMEMODE.ColorRarities[ k ], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
            surface.SetDrawColor( GAMEMODE.ColorRarities[ k ] )
            surface.DrawLine( header:GetWide() / 2 - ( textw / 2 ), header:GetTall() - 1, header:GetWide() / 2 + ( textw / 2 ), header:GetTall() - 1 )
        end
        self.skinbuttonsnumerical[ #self.skinbuttonsnumerical + 1 ] = header

        for k2, v2 in pairs( v ) do
            local button = vgui.Create( "SkinsShopButton", self.scrollpanel )
            button:SetFont( "Exo-28-600" )
            button:SetSize( self.scrollpanel:GetWide(), 56 )
            button:SetSkin( v2.directory )
            button:Dock( TOP )
            button:SetTrueParent( self, #self.skinbuttonsnumerical + 1 )
            self.skinbuttons[ v2.directory ] = button
            self.skinbuttonsnumerical[ #self.skinbuttonsnumerical + 1 ] = button
        end
    end

    self:SelectOption()
end

function skinsshop:Paint()
    surface.SetTexture( GAMEMODE.GradientTexture )
    surface.SetDrawColor( 0, 0, 0, 164 )

    if self.selected then
        surface.SetFont( "Exo-36-600" )
        local headerw, headert = surface.GetTextSize( self.display )
        surface.SetTextColor( GAMEMODE.TeamColor )
        surface.SetTextPos( self:GetWide() / 4 * 3 - ( headerw / 2 ), self:GetTall() / 2 + 8 )
        surface.DrawText( self.display )

        surface.DrawLine( self:GetWide() / 2 + ( self:GetWide() / 6 ), self:GetTall() / 2 + 21 + headert, self:GetWide() / 2 + ( self:GetWide() / 6 ), self:GetTall() - 8 )
        surface.DrawLine( self:GetWide() / 2 + ( self:GetWide() / 3 ), self:GetTall() / 2 + 21 + headert, self:GetWide() / 2 + ( self:GetWide() / 3 ), self:GetTall() - 8 )
    end

    surface.DrawLine( self:GetWide() / 2, 0, self:GetWide() / 2, self:GetTall() )
    surface.DrawTexturedRectRotated( self:GetWide() / 2, 4, 8, self:GetWide(), 270 )

    surface.DrawLine( self:GetWide() / 2, self:GetTall() / 2, self:GetWide(), self:GetTall() / 2 )
    surface.DrawTexturedRectRotated( self:GetWide() / 4 * 3, self:GetTall() / 2 + 4, 8, self:GetWide() / 2, -90 )

    surface.DrawLine(self:GetWide() / 2, 0, self:GetWide() / 2, self:GetTall())
    surface.DrawTexturedRectRotated( self:GetWide() / 2 - 4, self:GetTall() / 2, 8, self:GetTall(), 180 )
end

--[[function skinsshop:DoClick()
    self:RepopulateList()
    surface.PlaySound( GAMEMODE.ButtonSounds.Accept[ math.random( #GAMEMODE.ButtonSounds.Accept ) ] )
end]]

vgui.Register( "SkinsShopPanel", skinsshop, "DPanel" )

--//

local modelsshopbutton = {}--table.Copy( skinsshopbutton )
modelsshopbutton.font = "DermaDefault"
modelsshopbutton.rarity = 0
modelsshopbutton.order = 0
modelsshopbutton.alpha = 0
modelsshopbutton.display = ""
modelsshopbutton.model = ""

function modelsshopbutton:SetFont( fnt )
    self.font = fnt
end

function modelsshopbutton:SetModel( mdl )
    self.model = mdl
    self.modelinfo = GetModelTableByDirectory( mdl )
    self.display = self.modelinfo.name
end

function modelsshopbutton:SetTrueParent( panel, number )
    self.trueparent = panel
    self.order = number
end

function modelsshopbutton:DoClick()
    surface.PlaySound( GAMEMODE.ButtonSounds.Accept[ math.random( #GAMEMODE.ButtonSounds.Accept ) ] )
    self.trueparent:SelectOption( self.model )
end

function modelsshopbutton:Paint()
    surface.SetFont( self.font )
    surface.SetTextColor( 0, 0, 0, 220 )
    if self.hover or self.selected then
        surface.SetTextColor( GAMEMODE.TeamColor )
    end
    local w, h = surface.GetTextSize( self.display )
    surface.SetTextPos( 16, self:GetTall() / 2 - ( h / 1.5 ) )
    surface.DrawText( self.display )

    surface.SetFont( "Exo-16-500" )
    surface.SetTextColor( 0, 0, 0, 220 )
    surface.SetTextPos( self:GetTall() - 12, self:GetTall() / 2 + 8 )
    w, h = surface.GetTextSize( "Quality: " )
    surface.DrawText( "Quality: " )
    surface.SetTextColor( GAMEMODE.ColorRarities[ self.modelinfo.quality ] )
    surface.SetTextPos( self:GetTall() - 14 + w, self:GetTall() / 2 + 8 )
    surface.DrawText( "Tier ".. ( self.modelinfo.quality + 1 ) )

    if self.modelinfo.bodygroups then
        --draw.NoTexture()
        surface.SetDrawColor( colorScheme[ 0 ].TeamColor )
        surface.SetMaterial( GAMEMODE.Icons.Menu.bodygroupsIcon )
        surface.DrawTexturedRect( self:GetWide() - ( self:GetTall() / 4 * 3 ), self:GetTall() / 2 - 16, 32, 32 )
        --surface.DrawTexturedRect( self:GetWide() - self:GetTall() + 4, self:GetTall() / 2 - 26, 48, 48 )
    end
    if self.modelinfo.voiceover then
        surface.SetMaterial( GAMEMODE.Icons.Menu.voiceoverIcon )
        if self.modelinfo.bodygroups then
            surface.DrawTexturedRect( self:GetWide() - ( self:GetTall() / 4 * 3 ) - 32 - 4, self:GetTall() / 2 - 16, 32, 32 )
        else
            surface.DrawTexturedRect( self:GetWide() - ( self:GetTall() / 4 * 3 ), self:GetTall() / 2 - 16, 32, 32 )
        end
    end

    if self.order != 1 and self.order != 0 then
        if self.trueparent.modelbuttonsnumerical[ self.order - 1 ].hover then
            surface.SetTexture( GAMEMODE.GradientTexture )
            surface.SetDrawColor( GAMEMODE.ColorRarities[ self.rarity ] )
            surface.DrawTexturedRectRotated( self:GetWide() / 2, 4, 8, self:GetWide(), -90 )
        end
    end
    if self.order != #self.trueparent.modelbuttonsnumerical then
        if self.trueparent.modelbuttonsnumerical[ self.order + 1 ].hover then
            surface.SetTexture( GAMEMODE.GradientTexture )
            surface.SetDrawColor( GAMEMODE.ColorRarities[ self.rarity ] )
            surface.DrawTexturedRectRotated( self:GetWide() / 2, self:GetTall() - 4, 8, self:GetWide(), 90 )
        end

        if !self.hover and !self.trueparent.modelbuttonsnumerical[ self.order + 1 ].hover and self.trueparent.modelbuttonsnumerical[ self.order + 1 ].trueparent then
            --surface.SetTexture( GAMEMODE.GradientTexture )
            surface.SetDrawColor( 0, 0, 0, 164)
            surface.DrawLine( self:GetTall() - 12, self:GetTall() - 1, self:GetWide(), self:GetTall() - 1 )
        end
    end
    return true
end

function modelsshopbutton:OnCursorEntered()
    self.hover = true
end

function modelsshopbutton:OnCursorExited()
    self.hover = false
end

function modelsshopbutton:Think()
    if self.trueparent.selectedmodel == self.model then
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

vgui.Register( "ModelsShopButton", modelsshopbutton, "DButton" )

--//

local modelsshop = { }
modelsshop.models = { }
modelsshop.modelbuttons = { }
modelsshop.modelbuttonsnumerical = { }
modelsshop.display = ""

function modelsshop:DoSetup()
    net.Start( "RequestLockedModels" )
    net.SendToServer()

    net.Receive( "RequestLockedModelsCallback", function()
        GAMEMODE.lockedmodels = net.ReadTable()

        if #GAMEMODE.lockedmodels == 0 then
            function self:Paint()
                draw.DrawText( "All models purchased!", self.font, self:GetWide() / 2, self:GetTall() / 2, GAMEMODE.TeamColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
            end
            return
        end

        local weirdpaddingissue = 0
        if self.scrollpanel then weirdpaddingissue = 8 end
        self.scrollpanel = vgui.Create( "DScrollPanel", self )
        self.scrollpanel:SetPos( 0, 0 )
        self.scrollpanel:SetSize( self:GetWide() / 2 - 16 + weirdpaddingissue, self:GetTall() ) --I have no idea why this is 8 pixels wider than weaponsshop
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

function modelsshop:DrawModel( dir )
    if !dir then
        if self.modelpanel then self.modelpanel:Remove() self.modelpanel = nil end
        return
    end

    self.modelpanel = self.modelpanel or vgui.Create( "DModelPanel", self )
    self.modelpanel:SetModel( dir )
    self.modelpanel:SetSize( self:GetWide() / 2, self:GetTall() / 2 )
    self.modelpanel:SetPos( self:GetWide() / 2, 0 )
    self.modelpanel:GetEntity():SetPos( Vector( -15, -15, 0 ) )
    self.modelpanel.rotateamount = self.modelpanel.rotateamount or 0
    self.modelpanel.LayoutEntity = function( self, ent )
        ent:SetAngles( Angle( 0, ( 45 + self.rotateamount ) % 360 , 0 ) )
    end
    self.modelpanel.Think = function( self )
        self.rotateamount = self.rotateamount + 0.2 --This is a bad way of doing it, as it's dependent on the client framerate
    end
    if self.modelinfo.bodygroups then
        local bodygroups = self.modelpanel:GetEntity():GetBodyGroups()
        self.modelpanel.bodygroups = { lastupdate = 0 }
        for k, v in pairs( bodygroups ) do
            self.modelpanel.bodygroups[ v.id ] = { 0, v.num }
        end

        timer.Create( "ModelPanelBodygroupChanging", 1, 0, function()
            if !self.modelpanel then timer.Remove( "ModelPanelBodygroupChanging" ) return end
            self.modelpanel:GetEntity():SetSkin( ( self.modelpanel:GetEntity():GetSkin() + 1 ) % self.modelpanel:GetEntity():SkinCount() )

            self.modelpanel.bodygroups[ self.modelpanel.bodygroups.lastupdate ][ 1 ] = ( self.modelpanel.bodygroups[ self.modelpanel.bodygroups.lastupdate ][ 1 ] + 1 ) % ( self.modelpanel.bodygroups[ self.modelpanel.bodygroups.lastupdate ][ 2 ] )
            self.modelpanel:GetEntity():SetBodygroup( self.modelpanel.bodygroups.lastupdate, self.modelpanel.bodygroups[ self.modelpanel.bodygroups.lastupdate ][ 1 ] )
            if self.modelpanel.bodygroups[ self.modelpanel.bodygroups.lastupdate ][ 1 ] == 0 then 
                self.modelpanel.bodygroups.lastupdate = ( self.modelpanel.bodygroups.lastupdate + 1 ) % ( #self.modelpanel.bodygroups + 1 )
            end
        end )
    end
end

function modelsshop:SelectOption( dir )
    if !dir then
        self.selectedmodel = nil
        if self.cashbutton then self.cashbutton:Remove() self.cashbutton = nil end
        if self.tokensbutton then self.tokensbutton:Remove() self.tokensbutton = nil end
        if self.creditsbutton then self.creditsbutton:Remove() self.creditsbutton = nil end
        self:DrawModel()
        return
    end

    self.selectedmodel = dir
    self.modelinfo = GetModelTableByDirectory( dir )
    self.display = self.modelinfo.name
    self:DrawModel( dir )

    --//Standard in-game cash. Only the shitty skins can be purchased with this currency
    local tab = GetModelTableByDirectory( dir )
    local cashdisabled = tab.cash == 0
    local cashlocked = GAMEMODE.MyMoney < tab.cash
    self.cashbutton = self.cashbutton or vgui.Create( "DButton", self )
    self.cashbutton:SetSize( self:GetWide() / 6, self:GetTall() / 5 * 2 )
    self.cashbutton:SetPos( self:GetWide() / 2, self:GetTall() - self.cashbutton:GetTall() )
    self.cashbutton:SetText( "" )
    self.cashbutton.Paint = function( _, w, h )
        surface.SetDrawColor( 0, 0, 0, 190 )
        surface.SetMaterial( GAMEMODE.Icons.Menu.cashIcon )
        if self.cashbutton.hover and !cashdisabled then
            if !cashlocked then
                surface.SetDrawColor( GAMEMODE.TeamColor )
                surface.DrawTexturedRect( self.cashbutton:GetWide() / 2 - 48, 8, 96, 96 )
                draw.SimpleText( "$" .. comma_value( tab.cash ), "Exo-28-600", self.cashbutton:GetWide() / 2, self.cashbutton:GetTall() / 3 * 2, GAMEMODE.TeamColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
            else
                surface.DrawTexturedRect( self.cashbutton:GetWide() / 2 - 48, 8, 96, 96 )
                draw.SimpleText( "$" .. comma_value( tab.cash ), "Exo-28-600", self.cashbutton:GetWide() / 2, self.cashbutton:GetTall() / 3 * 2, Color( 0, 0, 0, 220 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
                
                surface.SetDrawColor( 0, 0, 0, 190 )
                surface.DrawRect( 4, 6, self.cashbutton:GetWide() - 8, self.cashbutton:GetTall() - 11 )

                surface.SetFont( "Exo-28-600" )
                local textw, textt = surface.GetTextSize("Low")
                draw.SimpleTextOutlined( "Low", "Exo-28-600", w / 2 - ( textw / 2 ), h / 2 - textt - 2, Color( 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
                textw, textt = surface.GetTextSize("Funds")
                draw.SimpleTextOutlined( "Funds", "Exo-28-600", w / 2 - ( textw / 2 ), h / 2 + 2, Color( 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
            end
        else
            if cashdisabled then
                draw.SimpleText( "Disabled", "Exo-28-600", self.cashbutton:GetWide() / 2, self.cashbutton:GetTall() / 3 * 2, Color( 0, 0, 0, 220 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
            else
                draw.SimpleText( "$" .. comma_value( tab.cash ), "Exo-28-600", self.cashbutton:GetWide() / 2, self.cashbutton:GetTall() / 3 * 2, Color( 0, 0, 0, 220 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
            end
            surface.DrawTexturedRect( self.cashbutton:GetWide() / 2 - 48, 8, 96, 96 )
        end
    end
    self.cashbutton.DoClick = function()
        if !cashlocked and !cashdisabled then
            local success = GAMEMODE:AttemptBuyPModel( self.selectedmodel, "cash" )
            if success then
                net.Start( "RequestLockedModels" )
                net.SendToServer()

                surface.PlaySound( "ambient/levels/labs/coinslot1.wav" )
            end
        else
            surface.PlaySound( GAMEMODE.ButtonSounds.Deny[ math.random( #GAMEMODE.ButtonSounds.Deny ) ] )
        end
    end
    self.cashbutton.OnCursorEntered = function()
        self.cashbutton.hover = true
    end
    self.cashbutton.OnCursorExited = function()
        self.cashbutton.hover = false
    end

    --//Prestige tokens. All weapon skins except rarity 5 (the most rare) can be purchased with this currency
    local tokenslocked = GAMEMODE.MyPrestigeTokens < tab.tokens
    local tokensdisabled = tab.tokens == 0
    local tokensdisplay = "Tokens"
    if tab.tokens == 1 then tokensdisplay = "Token" end
    self.tokensbutton = self.tokensbutton or vgui.Create( "DButton", self )
    self.tokensbutton:SetSize( self:GetWide() / 6, self:GetTall() / 5 * 2 )
    self.tokensbutton:SetPos( self:GetWide() / 2 + self.tokensbutton:GetWide(), self:GetTall() - self.tokensbutton:GetTall() )
    self.tokensbutton:SetText( "" )
    self.tokensbutton.Paint = function( _, w, h )
        surface.SetDrawColor( 0, 0, 0, 190 )
        surface.SetMaterial( GAMEMODE.Icons.Menu.tokensIcon )
        if self.tokensbutton.hover and !tokensdisabled then
            if !tokenslocked then
                surface.SetDrawColor( GAMEMODE.TeamColor )
                surface.DrawTexturedRect( self.tokensbutton:GetWide() / 2 - 48, 8, 96, 96 )
                draw.SimpleText( tab.tokens .. " " .. tokensdisplay, "Exo-28-600", self.tokensbutton:GetWide() / 2, self.tokensbutton:GetTall() / 3 * 2, GAMEMODE.TeamColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
            else
                surface.DrawTexturedRect( self.tokensbutton:GetWide() / 2 - 48, 8, 96, 96 )
                draw.SimpleText( tab.tokens .. " " .. tokensdisplay, "Exo-28-600", self.tokensbutton:GetWide() / 2, self.tokensbutton:GetTall() / 3 * 2, Color( 0, 0, 0, 220 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
                
                surface.SetDrawColor( 0, 0, 0, 190 )
                surface.DrawRect( 4, 6, self.tokensbutton:GetWide() - 8, self.tokensbutton:GetTall() - 11 )

                surface.SetFont( "Exo-28-600" )
                local textw, textt = surface.GetTextSize("Low")
                draw.SimpleTextOutlined( "Low", "Exo-28-600", w / 2 - ( textw / 2 ), h / 2 - textt - 2, Color( 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
                textw, textt = surface.GetTextSize("Tokens")
                draw.SimpleTextOutlined( "Tokens", "Exo-28-600", w / 2 - ( textw / 2 ), h / 2 + 2, Color( 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
            end
        else
            if tokensdisabled then
                draw.SimpleText( "Disabled", "Exo-28-600", self.tokensbutton:GetWide() / 2, self.tokensbutton:GetTall() / 3 * 2, Color( 0, 0, 0, 220 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
            else
                draw.SimpleText( tab.tokens .. " " .. tokensdisplay, "Exo-28-600", self.tokensbutton:GetWide() / 2, self.tokensbutton:GetTall() / 3 * 2, Color( 0, 0, 0, 220 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
            end
            surface.DrawTexturedRect( self.tokensbutton:GetWide() / 2 - 48, 8, 96, 96 )
        end
    end
    self.tokensbutton.DoClick = function()
        if !tokenslocked and !tokensdisabled then
            local success = GAMEMODE:AttemptBuyPModel( self.selectedmodel, "tokens" )
            if success then
                net.Start( "RequestLockedModels" )
                net.SendToServer()

                surface.PlaySound( "ambient/levels/labs/coinslot1.wav" )
            end
        else
            surface.PlaySound( GAMEMODE.ButtonSounds.Deny[ math.random( #GAMEMODE.ButtonSounds.Deny ) ] )
        end
    end
    self.tokensbutton.OnCursorEntered = function()
        self.tokensbutton.hover = true
    end
    self.tokensbutton.OnCursorExited = function()
        self.tokensbutton.hover = false
    end

    --//Donator credits. All skins can be purchased with this currency. Pricing barely changes across rarity levels
    local creditslocked = GAMEMODE.MyCredits < tab.credits
    local creditsdisplay = "Credits"
    if tab.credits == 1 then creditsdisplay = "Credit" end
    self.creditsbutton = self.creditsbutton or vgui.Create( "DButton", self )
    self.creditsbutton:SetSize( self:GetWide() / 6, self:GetTall() / 5 * 2 )
    self.creditsbutton:SetPos( self:GetWide() / 2 + ( self.creditsbutton:GetWide() * 2 ), self:GetTall() - self.creditsbutton:GetTall() )
    self.creditsbutton:SetText( "" )
    self.creditsbutton.Paint = function( _, w, h )
        surface.SetDrawColor( 0, 0, 0, 190 )
        surface.SetMaterial( GAMEMODE.Icons.Menu.creditsIcon )
        if self.creditsbutton.hover then
            if !creditslocked then
                surface.SetDrawColor( GAMEMODE.TeamColor )
                surface.DrawTexturedRect( self.cashbutton:GetWide() / 2 - 48, 8, 96, 96 )
                draw.SimpleText( tab.credits .. " " .. creditsdisplay, "Exo-28-600", self.creditsbutton:GetWide() / 2, self.creditsbutton:GetTall() / 3 * 2, GAMEMODE.TeamColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
            else
                surface.DrawTexturedRect( self.cashbutton:GetWide() / 2 - 48, 8, 96, 96 )
                draw.SimpleText( tab.credits .. " " .. creditsdisplay, "Exo-28-600", self.creditsbutton:GetWide() / 2, self.creditsbutton:GetTall() / 3 * 2, Color( 0, 0, 0, 220 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
                
                surface.SetDrawColor( 0, 0, 0, 190 )
                surface.DrawRect( 4, 6, self.creditsbutton:GetWide() - 8, self.creditsbutton:GetTall() - 11 )

                surface.SetFont( "Exo-28-600" )
                local textw, textt = surface.GetTextSize("Low")
                draw.SimpleTextOutlined( "Low", "Exo-28-600", w / 2 - ( textw / 2 ), h / 2 - textt - 2, Color( 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
                textw, textt = surface.GetTextSize("Credits")
                draw.SimpleTextOutlined( "Credits", "Exo-28-600", w / 2 - ( textw / 2 ), h / 2 + 2, Color( 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
            end
        else
            surface.DrawTexturedRect( self.cashbutton:GetWide() / 2 - 48, 8, 96, 96 )
            draw.SimpleText( tab.credits .. " " .. creditsdisplay, "Exo-28-600", self.creditsbutton:GetWide() / 2, self.creditsbutton:GetTall() / 3 * 2, Color( 0, 0, 0, 220 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        end
    end
    self.creditsbutton.DoClick = function()
        if !creditslocked then
            local success = GAMEMODE:AttemptBuyPModel( self.selectedmodel, "credits" )
            if success then
                net.Start( "RequestLockedModels" )
                net.SendToServer()

                surface.PlaySound( "ambient/levels/labs/coinslot1.wav" )
            end
        else
            surface.PlaySound( GAMEMODE.ButtonSounds.Deny[ math.random( #GAMEMODE.ButtonSounds.Deny ) ] )
        end
    end
    self.creditsbutton.OnCursorEntered = function()
        self.creditsbutton.hover = true
    end
    self.creditsbutton.OnCursorExited = function()
        self.creditsbutton.hover = false
    end
end

function modelsshop:RepopulateList()
    self.listOrder = {}
    for k, v in pairs( GAMEMODE.lockedmodels ) do
        if !self.listOrder[ GAMEMODE.PlayerModels[ v ].collection ] then
            self.listOrder[ #self.listOrder + 1 ] = { header = "The " .. GAMEMODE.PlayerModels[ v ].collection .. " Collection" }
            self.listOrder[ GAMEMODE.PlayerModels[ v ].collection ] = #self.listOrder
        end
        table.insert( self.listOrder[ self.listOrder[ GAMEMODE.PlayerModels[ v ].collection ] ], GAMEMODE.PlayerModels[ v ] )
    end

    for k, v in pairs( self.modelbuttonsnumerical ) do
        if v and v:IsValid() then
            v:Remove()
        end
    end

    for k, v in ipairs( self.listOrder ) do
        if #v == 0 then continue end --Should ignore the header entry because it's not numerically indexed

        local header = vgui.Create( "DPanel", self.scrollpanel )
        header:SetSize( self.scrollpanel:GetWide(), 44 )
        header:Dock( TOP )
        header.Paint = function()
            surface.SetFont( "Exo-28-600" )
            local textw, textt = surface.GetTextSize( self.listOrder[ k ].header )
            surface.SetTextColor( GAMEMODE.TeamColor ) --Could also be the highlight?
            surface.SetTextPos( header:GetWide() / 2 - ( textw / 2 ), header:GetTall() / 2 - ( textt / 2 ) )
            surface.DrawText( self.listOrder[ k ].header )

            surface.SetDrawColor( GAMEMODE.TeamColor )
            surface.DrawLine( header:GetWide() / 2 - ( textw / 2 ), header:GetTall() - 1, header:GetWide() / 2 + ( textw / 2 ), header:GetTall() - 1 )
        end
        self.modelbuttonsnumerical[ #self.modelbuttonsnumerical + 1 ] = header

        for k2, v2 in ipairs( v ) do
            local button = vgui.Create( "ModelsShopButton", self.scrollpanel )
            button:SetModel( v2.model )
            button:SetFont( "Exo-28-600" )
            button:SetSize( self.scrollpanel:GetWide(), 56 )
            button:Dock( TOP )
            button:SetTrueParent( self, #self.modelbuttonsnumerical + 1 )
            self.modelbuttons[ v2.model ] = button
            self.modelbuttonsnumerical[ #self.modelbuttonsnumerical + 1 ] = button
        end
    end

    self:SelectOption()
end

function modelsshop:Paint()
    surface.SetTexture( GAMEMODE.GradientTexture )
    surface.SetDrawColor( 0, 0, 0, 164 )

    if self.selectedmodel then
        surface.SetFont( "Exo-36-600" )
        local headerw, headert = surface.GetTextSize( self.display )
        surface.SetTextColor( GAMEMODE.TeamColor )
        surface.SetTextPos( self:GetWide() / 4 * 3 - ( headerw / 2 ), self:GetTall() / 2 + 8 )
        surface.DrawText( self.display )

        surface.DrawLine( self:GetWide() / 2 + ( self:GetWide() / 6 ), self:GetTall() / 2 + 21 + headert, self:GetWide() / 2 + ( self:GetWide() / 6 ), self:GetTall() - 8 )
        surface.DrawLine( self:GetWide() / 2 + ( self:GetWide() / 3 ), self:GetTall() / 2 + 21 + headert, self:GetWide() / 2 + ( self:GetWide() / 3 ), self:GetTall() - 8 )
    end

    surface.DrawLine( self:GetWide() / 2, 0, self:GetWide() / 2, self:GetTall() )
    surface.DrawTexturedRectRotated( self:GetWide() / 2, 4, 8, self:GetWide(), 270 )

    surface.DrawLine( self:GetWide() / 2, self:GetTall() / 2, self:GetWide(), self:GetTall() / 2 )
    surface.DrawTexturedRectRotated( self:GetWide() / 4 * 3, self:GetTall() / 2 + 4, 8, self:GetWide() / 2, -90 )

    surface.DrawLine(self:GetWide() / 2, 0, self:GetWide() / 2, self:GetTall())
    surface.DrawTexturedRectRotated( self:GetWide() / 2 - 4, self:GetTall() / 2, 8, self:GetTall(), 180 )
end

vgui.Register( "ModelsShopPanel", modelsshop, "DPanel" )

--[[
    Feedback received over the Discord:
        - One user didn't like the Exo font
        - Back arrow looked strange
        - Shop could do with less team-specific coloring
        - Find a new back icon for the menus in general
]]