--//This file is strictly for creating custom vgui elements for the shop
--//DAMN YE ALL WHO ENTER HERE

--[[local function ScalingColor( low, high, val, scale )
    low = low or 0
    high = high - low
    local hhigh = high / 2
    val = val - low
    local hval = val / 2
    local red, green, blue

    --//Scaling up means higher is better, so we should see blue at val's higher than 1/2 of high
    if scale == "up" then
        red = math.Clamp( hhigh - math.Clamp( val, 0, hhigh ) / hhigh, 0, 1 ) * 255
        green = math.Clamp( hhigh - math.abs( val - hhigh ) / hhigh, 0, 1 ) * 255
        blue = math.Clamp( ( math.Clamp( val, hhigh, high ) - hhigh ) * 2, 0, 1 ) * 255
    else
        red = math.Clamp( ( math.Clamp( val, hhigh, high ) - hhigh ) * 2, 0, 1 ) * 255
        green = math.Clamp( hhigh - math.abs( val - hhigh ) / hhigh, 0, 1 ) * 255
        blue = math.Clamp( hhigh - math.Clamp( val, 0, hhigh ) / hhigh, 0, 1 ) * 255
    end

    return Color( red, green, blue, 255 )
end]]

local uisoundtable = {
    "ambient/machines/keyboard2_clicks.wav",
    "ambient/machines/keyboard3_clicks.wav",
    "ambient/machines/keyboard1_clicks.wav",
    "ambient/machines/keyboard4_clicks.wav",
    "ambient/machines/keyboard5_clicks.wav",
    "ambient/machines/keyboard6_clicks.wav",
    "ambient/machines/keyboard7_clicks_enter.wav"
}

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
    surface.PlaySound( uisoundtable[ math.random( #uisoundtable ) ] )
end

function psheetbutton:Paint()
    surface.SetDrawColor( GAMEMODE.TeamColor )
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
            surface.SetDrawColor( colorScheme[LocalPlayer():Team()]["ButtonIndicator"] )
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
weaponsshopbutton.display = { ar = "Assault Rifle", smg = " Submachine Gun", sg = "Shotgun", sr = "Sniper Rifle", lmg = "Light Machine Gun", pt = "Pistol", mn = "Magnum", eq = "Equipment"}

function weaponsshopbutton:DoClick()
    if self.disabled then return end
    self:GetParent().selected = self.text
    self:GetParent():Reset( self.text )
    surface.PlaySound( uisoundtable[ math.random( #uisoundtable ) ] )
end

function weaponsshopbutton:Think()
    if self:GetParent().selected == self.text then
        self.selected = true
    else
        self.selected = false
    end
    if self.empty then
        self.disabled = true
    else
        self.disabled = false
    end
end

function weaponsshopbutton:DoGradient()
    self.gradient = true
end

function weaponsshopbutton:Paint()
    surface.SetDrawColor( GAMEMODE.TeamColor )
    surface.DrawRect( 0, 0, self:GetWide(), self:GetTall() )
    
    if self.gradient then
        surface.SetTexture( GAMEMODE.GradientTexture )
        surface.SetDrawColor( 0, 0, 0, 164 )
        surface.DrawTexturedRectRotated( self:GetWide() / 2, 4, 8, self:GetWide() + 3, 270 ) --self.TeamMain:GetWide() / 2, self.TeamMainTitleSize + 4, 8, self.TeamMain:GetWide(), 270
    end

    surface.SetFont( self.font )
    local twide, ttall = surface.GetTextSize( self.display[ self.text ] )
    surface.SetTextPos( self:GetWide() / 2 - ( twide / 2 ), self:GetTall() / 2 - ( ttall / 2) )
    if self.disabled then
        surface.SetTextColor( 80, 80, 80, 170 )
    else
        surface.SetTextColor( 255, 255, 255 )
    end
    surface.DrawText( self.display[ self.text ] )
    --draw.SimpleText( self.text, self.font, self:GetWide() / 2, self:GetTall() / 2, Color( 255,255,255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

    self.lerp = self.lerp or 0
    if ( self.hover or self.selected ) and !self.disabled then
        self.lerp = math.Clamp( self.lerp + 3, 0, self:GetWide() / 3 )
        if self.selected then
            surface.SetDrawColor( colorScheme[LocalPlayer():Team()]["ButtonIndicator"] )
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

vgui.Register( "WeaponsShopButton", weaponsshopbutton, "DButton" )

--[[
    So for any future programmer reading through this for whatever reason - I'm fairly certain this is NOT the intended use of custom vgui elements.
    As in, just using the custom element to nest a bunch of standard derma panels and adding 80 billion tables, BUT, I wanted cl_shop looking clean, 
    so I'm keeping this upcoming mess in the setup file instead of the front file.
]]

local weaponsshop = { }
weaponsshop.weaponname = "Nothing Selected"
weaponsshop.font = "ExoTitleFont"
weaponsshop.tabs = { "ar", "smg", "sg", "sr", "lmg", "pt", "mn", "eq" }
weaponsshop.wepinfosetup = {
    --//Scale up means higher is better, scale down means lower is better - use for color calculation
    { value = "Damage", display = "Damage", min = 0, max = 120, scale = "up" },
    { value = "FireDelay", display = "RPM", min = 30, max = 1200, scale = "up" },
    { value = "AimSpread", display = "Aimspread", min = 0.001, max = 0.03, scale = "down" },
    { value = "HipSpread", display = "Hipspread", min = 0.01, max = 0.5, scale = "down" },
    { value = "Recoil", display = "Recoil", min = 0.5, max = 5, scale = "down" },
    { value = "VelocitySensitivity", display = "Aim Sensitivity", min = 1, max = 3, scale = "down" },
    { value = "MaxSpreadInc", display = "Max Spread", min = 0.01, max = 0.4, scale = "down" },
    { value = "ClipSize", display = "Clipsize", min = 1, max = 100, scale = "up" },
    { value = "SpeedDec", display = "Weight", min = 10, max = 70, scale = "down" },
    { value = "SpreadCooldown", display = "Spread Cooldown", min = 0.01, max = 2, scale = "down" }
}
weaponsshop.wepinfo = {
    Damage = weaponsshop.wepinfosetup[ 1 ].min,
    DamageColor = Color( 0, 0, 0 ),
    FireDelay = weaponsshop.wepinfosetup[ 2 ].min,
    FireDelayColor = Color( 0, 0, 0 ),
    AimSpread = weaponsshop.wepinfosetup[ 3 ].min,
    AimSpreadColor = Color( 0, 0, 0 ),
    HipSpread = weaponsshop.wepinfosetup[ 4 ].min,
    HipSpreadColor = Color( 0, 0, 0 ),
    Recoil = weaponsshop.wepinfosetup[ 5 ].min,
    RecoilColor = Color( 0, 0, 0 ),
    VelocitySensitivity = weaponsshop.wepinfosetup[ 6 ].min,
    VelocitySensitivityColor = Color( 0, 0, 0 ),
    MaxSpreadInc = weaponsshop.wepinfosetup[ 7 ].min,
    MaxSpreadIncColor = Color( 0, 0, 0 ),
    ClipSize = weaponsshop.wepinfosetup[ 8 ].min,
    ClipSizeColor = Color( 0, 0, 0 ),
    SpeedDec = weaponsshop.wepinfosetup[ 9 ].min,
    SpeedDecColor = Color( 0, 0, 0 ),
    SpreadCooldown = weaponsshop.wepinfosetup[ 10 ].min,
    SpreadCooldownColor = Color( 0, 0, 0 )
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
    [ "cw_makarov" ] = { cam = Vector( 0, 35, 0 ), lookat = Vector( 0, 0, 0 ), pos = Vector( -6, 13.5, -1 ) },
    [ "cw_shorty" ] = { cam = Vector( 0, 35, 0 ), lookat = Vector( 0, 0, 0 ), pos = Vector( -9, 13.5, -2 ) },
    [ "cw_vss" ] = { cam = Vector( 0, 35, 0 ), lookat = Vector( 0, 0, 0 ), pos = Vector( -6, 13.5, -1 ) },
    [ "cw_b196" ] = { cam = Vector( 0, 35, 0 ), lookat = Vector( 0, 0, 0 ), pos = Vector( -6, 13.5, -1 ) },
    [ "cw_scorpin_evo3" ] = { cam = Vector( 0, 35, 0 ), lookat = Vector( 0, 0, 0 ), pos = Vector( -6, 13.5, -1 ) },
    [ "cw_tac338" ] = { cam = Vector( 0, 35, 0 ), lookat = Vector( 0, 0, 0 ), pos = Vector( -6, 13.5, -1 ) },
    [ "cw_ber_p90" ] = { cam = Vector( 0, 35, 0 ), lookat = Vector( 0, 0, 0 ), pos = Vector( -6, 13.5, -1 ) },
    [ "cw_ber_famas_felin" ] = { cam = Vector( 0, 35, 0 ), lookat = Vector( 0, 0, 0 ), pos = Vector( -6, 13.5, -1 ) },
    [ "cw_ber_spas12" ] = { cam = Vector( 0, 35, 0 ), lookat = Vector( 0, 0, 0 ), pos = Vector( -6, 13.5, -1 ) },
    [ "cw_amr2_rpk74" ] = { cam = Vector( 0, 35, 0 ), lookat = Vector( 0, 0, 0 ), pos = Vector( -6, 13.5, -1 ) },
    [ "cw_wf_m200" ] = { cam = Vector( 0, 35, 0 ), lookat = Vector( 0, 0, 0 ), pos = Vector( -6, 13.5, -1 ) },
    [ "cw_ber_hkmp7" ] = { cam = Vector( 0, 35, 0 ), lookat = Vector( 0, 0, 0 ), pos = Vector( -6, 13.5, -1 ) },
    [ "cw_amr2_mk46" ] = { cam = Vector( 0, 35, 0 ), lookat = Vector( 0, 0, 0 ), pos = Vector( -6, 13.5, -1 ) },
    [ "cw_fiveseven" ] = { cam = Vector( 0, 35, 0 ), lookat = Vector( 0, 0, 0 ), pos = Vector( -2.5, 13.5, -3.5 ) }
}

function weaponsshop:DoSetup()
    net.Start( "RequestLockedWeapons" )
    net.SendToServer()

    net.Receive( "RequestLockedWeaponsCallback", function()
        --//Table received with ordered numeric keys and and values as the keys to the locked guns in GAMEMODE.WeaponsList
        GAMEMODE.lockedweapons = net.ReadTable()

        --[[ I'd like for the menu to notify players of new unlocks, but I'd need to incorporate highlighting into the shop tabs, and that's too much for now
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

        --//We need to check if any weapon types are empty, and if they are, disable their respective buttons
        local throwawaytypecount = {}
        for k, v in pairs( self.tabs ) do
            throwawaytypecount[ v ] = 0
        end
        for k, v in pairs( GAMEMODE.lockedweapons ) do
            throwawaytypecount[ GAMEMODE.WeaponsList[ v ].type ] = throwawaytypecount[ GAMEMODE.WeaponsList[ v ].type ] + 1
        end
        for k, v in pairs( self.tabs ) do
            if throwawaytypecount[ v ] == 0 then
                self.WeaponsShopButtons[ v ].empty = true
            elseif !self.nextopenmenu or throwawaytypecount[ self.nextopenmenu ] == 0 then
                self.nextopenmenu = v
            end
        end

        if not self.Reset then
            timer.Simple( 0, function()
                self:Reset( self.nextopenmenu or "ar" )
            end )
        else
            self:Reset( self.nextopenmenu or "ar" )
        end
    end )
    
    for k, v in pairs( self.tabs ) do
        local rowoffset = 0
        local columnoffset = 0
        
        if k > 4 then 
            rowoffset = 56 
            columnoffset = 4
        end

        self.WeaponsShopButtons = self.WeaponsShopButtons or {}
        local throwaway = vgui.Create( "WeaponsShopButton", self )
        throwaway:SetSize( self:GetWide() / 4, 56 )
        throwaway:SetPos( throwaway:GetWide() * ( k - 1 - columnoffset ), rowoffset )
        throwaway:SetFont( self.font )
        throwaway:SetText( v )

        if k < 5 then
            throwaway:DoGradient()
        end

        self.WeaponsShopButtons[ v ] = throwaway
    end

    function self:Reset( type )
        if GAMEMODE.lockedweapons == nil then return end
        self.selected = type
        self:SelectWeapon() --//Resets DModelPanel and other crap, if we're swapping tabs
        
        self.scrollpanel = self.scrollpanel or vgui.Create( "DScrollPanel", self )
        self.scrollpanel:SetPos( 0, 56 * 2 )
        self.scrollpanel:SetSize( self:GetWide() / 3, self:GetTall() - ( 56 * 2 ) )
        self.scrollpanel.Paint = function()
            if self.scrollpanelbuttons then
                local openarea = self.scrollpanel:GetTall() - ( 45 * self.scrollpanelbuttonscount ) 
                surface.SetTexture( GAMEMODE.GradientTexture )
                surface.SetDrawColor( 0, 0, 0, 164 )
                surface.DrawTexturedRectRotated( self.scrollpanel:GetWide() - 4, self.scrollpanel:GetTall() - ( openarea / 2 ), 8, openarea, 180 )
                surface.DrawTexturedRectRotated( self.scrollpanel:GetWide() / 2, self.scrollpanel:GetTall() - openarea + 4, 8, self.scrollpanel:GetWide(), 270 )
                --surface.DrawTexturedRectRotated(x, y, width, height, rotation)
                surface.SetDrawColor( GAMEMODE.TeamColor )
                surface.DrawLine( -1, self.scrollpanel:GetTall() - openarea, self.scrollpanel:GetWide() + 1, self.scrollpanel:GetTall() - openarea )
            end
        end

        local sBar = self.scrollpanel:GetVBar()
        sBar.Paint = function() return end
        sBar.btnUp.Paint = function() return end
        sBar.btnDown.Paint = function() return end
        function sBar.btnGrip:Paint( w, h )
            return true
            --draw.RoundedBox( 4, 7, 0, w / 2, h, Color( 0, 0, 0, 128 ) )
        end

        if self.scrollpanelbuttons then
            for k, v in pairs( self.scrollpanelbuttons ) do
                if v:IsValid() then v:Remove() end
            end
        end

        self.scrollpanelbuttons = {}
        self.scrollpanelbuttonscount = 0
        for k, v in pairs( GAMEMODE.lockedweapons ) do
            if GAMEMODE.WeaponsList[ v ].type == type and GAMEMODE.WeaponsList[ v ][ 3 ] != 0 and GAMEMODE.WeaponsList[ v ][ 5 ] != 0 then
                local sloticon = GAMEMODE.Icons.Weapons[ GAMEMODE.WeaponsList[ v ].slot ]
                local sloticonsizelarge = 32
                local sloticonsizesmall = 32 --Didn't I set this to 16?

                --//This should probably be a custom vgui element too, but fuckit, the custom elements are only to keep cl_shop clean, not this file
                local throwaway = vgui.Create( "DButton", self.scrollpanel )
                throwaway.id = self.scrollpanelbuttonscount
                throwaway:SetSize( self.scrollpanel:GetWide() * 0.75, 45 )
                throwaway:Dock( TOP )
                throwaway:SetText( "" )
                throwaway.Paint = function()
                    surface.SetDrawColor( 255, 255,255 )
                    surface.DrawRect(0, 0, self:GetWide(), self:GetTall() )
                    surface.SetDrawColor( GAMEMODE.TeamColor )
                    surface.DrawLine( -1, 0, throwaway:GetWide() + 1, 0 )
                    --surface.DrawLine( 4, throwaway:GetTall(), throwaway:GetWide() - 4, throwaway:GetTall() )

                    surface.SetMaterial( sloticon )
                    surface.SetDrawColor( GAMEMODE.TeamColor )
                    surface.DrawTexturedRect( 4, throwaway:GetTall() / 2 - ( sloticonsizelarge / 2 ), sloticonsizelarge, sloticonsizelarge )
                    draw.SimpleText( GAMEMODE.WeaponsList[ v ][ 1 ], self.font, sloticonsizelarge + 8, throwaway:GetTall() / 2, Color( 0, 0, 0 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )

                    if ( !throwaway.hover and !throwaway.selected ) or !throwaway.unlocked then
                        surface.SetTexture( GAMEMODE.GradientTexture )
                        surface.SetDrawColor( 0, 0, 0, 164 )
                        surface.DrawTexturedRectRotated( throwaway:GetWide() / 2, throwaway:GetTall() - 4, 8, self:GetWide(), 90 )
                        surface.DrawTexturedRectRotated( throwaway:GetWide() - 4, throwaway:GetTall() / 2, 8, throwaway:GetTall(), 180 )
                        if throwaway.id != 0 then
                            surface.DrawTexturedRectRotated( throwaway:GetWide() / 2, 4, 8, self:GetWide(), 270 )
                        end
                    end

                    if throwaway.id == 0 then
                        surface.SetTexture( GAMEMODE.GradientTexture )
                        surface.SetDrawColor( 0, 0, 0, 164 )
                        surface.DrawTexturedRectRotated( throwaway:GetWide() / 2, 4, 8, self:GetWide(), 270 )
                    end

                    surface.SetMaterial( GAMEMODE.Icons.Menu.levellocked )
                    surface.SetDrawColor( 255, 0, 0 )
                    if throwaway.unlocked then
                        surface.SetMaterial( GAMEMODE.Icons.Menu.levelunlocked )
                        surface.SetDrawColor( 0, 255, 0 )
                    end
                    surface.DrawTexturedRect( throwaway:GetWide() - sloticonsizesmall - 4, throwaway:GetTall() / 2 - ( sloticonsizesmall / 2 ), sloticonsizesmall, sloticonsizesmall )

                    surface.SetMaterial( GAMEMODE.Icons.Menu.moneylocked )
                    surface.SetDrawColor( 255, 0, 0 )
                    if throwaway.canbuy then
                        surface.SetMaterial( GAMEMODE.Icons.Menu.moneyunlocked )
                        surface.SetDrawColor( 0, 255, 0 )
                    end
                    surface.DrawTexturedRect( throwaway:GetWide() - ( ( sloticonsizesmall + 4 ) * 2 ), throwaway:GetTall() / 2 - ( sloticonsizesmall / 2 ), sloticonsizesmall, sloticonsizesmall )
                end
                throwaway.DoClick = function()
                    if throwaway.unlocked then
                        self:SelectWeapon( GAMEMODE.WeaponsList[ v ][ 2 ] )
                        surface.PlaySound( uisoundtable[ math.random( #uisoundtable ) ] )
                        self.weaponprice = GAMEMODE.WeaponsList[ v ][ 5 ]
                    end
                end
                throwaway.OnCursorEntered = function()
                    throwaway.hover = true
                end
                throwaway.OnCursorExited = function()
                    throwaway.hover = false
                end
                throwaway.Think = function()
                    if GAMEMODE.WeaponsList[ v ][ 5 ] < GAMEMODE.MyMoney then
                        throwaway.canbuy = true
                    else
                        throwaway.canbuy = false
                    end

                    if GAMEMODE.WeaponsList[ v ][ 3 ] < GAMEMODE.MyLevel then
                        throwaway.unlocked = true
                    else
                        throwaway.unlocked = false
                    end

                    if self.selectedweapon == GAMEMODE.WeaponsList[ v ][ 2 ] then
                        throwaway.selected = true
                    else
                        throwaway.selected = false
                    end
                end
                self.scrollpanelbuttons[ GAMEMODE.WeaponsList[ v ][ 2 ] ] = throwaway
                self.scrollpanelbuttonscount = self.scrollpanelbuttonscount + 1
            end
        end
    end
end

function weaponsshop:SelectWeapon( wep )
    if wep == nil then 
        self.selectedweapon = nil
        if self.modelpanel then self.modelpanel:Remove() end
        self.modelpanel = nil
        self.DisplayStats = false
        self.weaponname = "Nothing Selected"
        self.weaponprice = 0
        return
    end

    self.selectedweapon = wep
    local wep = weapons.GetStored( wep )
    if !wep then return end
    self.modelpanel = self.modelpanel or vgui.Create( "DModelPanel", self )
    self.modelpanel:SetSize( self:GetWide() / 3 * 2, ( self:GetTall() - ( 56 * 2 ) ) / 2 )
    self.modelpanel:SetPos( self:GetWide() / 3, 56 * 2 )
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
    self.modelpanel:SetCamPos( self.modeloffsets[ self.selectedweapon ].cam or Vector( 0, 35, 0 ) ) --Courtesy of Spy
    self.modelpanel:SetLookAt( self.modeloffsets[ self.selectedweapon ].lookat or Vector( 0, 0, 0 ) ) --Courtesy of Spy
    self.modelpanel:SetFOV( 90 ) --Courtesy of Spy
    --self.modelpanel:GetEntity():SetAngles
    self.modelpanel:SetAmbientLight( Color( 255, 255, 255 ) )
    self.modelpanel.LayoutEntity = function() return true end --Disables rotation
    surface.CreateFont( "InsufficientFunds", { font = "Exo 2", size = 32 } )
    self.modelpanel.PaintOver = function( _, w, h )
        if self.scrollpanelbuttons[ self.selectedweapon ] == nil then return end
        if !self.scrollpanelbuttons[ self.selectedweapon ].canbuy then
            local diff = 6
            surface.SetDrawColor( 0, 0, 0, 190 )
            surface.DrawRect( diff, diff, w - ( diff * 2 ), h - ( diff  ) )
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
    self.weaponprice = self.weaponprice or 0

    if wep.Base == "cw_base" then
        self.DisplayStats = true
        for k, v in pairs( self.wepinfosetup ) do
            if v.value == "ClipSize" then
                --//Since the Clipsize value is nested under a second table, Primary, need a special check
                self.wepinfo[ v.value ] = math.Clamp( wep.Primary[ v.value ], v.min, v.max )
            elseif v.value == "Damage" and wep.Shots > 1 then
                --//If we're displaying damage for the shotgun, we should calculate out the max damage if all pellets hit
                self.wepinfo.Damage = math.Clamp( wep.Damage * wep.Shots, v.min, v.max )
            elseif v.value == "HipSpread" and wep.Shots > 1 then
                --//Since it's a shotgun, we'll swap HipSpread (which is unimportant) for clumpspread (far more important for shotguns)
                local newtab = { value = "ClumpSpread", display = "Clumpspread", min = 0.02, max = 0.05, scale = "down" }
                self.wepinfosetup[ k ] = newtab
                v = newtab
                self.wepinfo.ClumpSpread = math.Clamp( wep.ClumpSpread, v.min, v.max )
                --//Need to reset these
                self.leftlongesttext = 0
                self.rightlongesttext = 0
            elseif self.wepinfosetup[ k ].value == "ClumpSpread" and wep.Shots == 1 then
                --//This gave me a bit of a headache - if we're swapping from displaying shotgun information to anything else, we need to swap back to hipspread info
                local newtab = { value = "HipSpread", display = "Hipspread", min = 0.01, max = 0.5, scale = "down" }
                self.wepinfosetup[ k ] = newtab
                v = newtab
                self.wepinfo.HipSpread = math.Clamp( wep.HipSpread, v.min, v.max )
                --//Need to reset these
                self.leftlongesttext = 0
                self.rightlongesttext = 0
            elseif v.value == "FireDelay" then
                --//Since FireDelay as an integer is meaningless to players, I've converted it into RPM - rounds per minute
                self.wepinfo[ v.value ] = math.Round( math.Clamp( 1 / wep[ v.value ] * 60, v.min, v.max ) )
            else
                --//Default information displaying
                self.wepinfo[ v.value ] = math.Clamp( wep[ v.value ], v.min, v.max )
            end
            
            self.wepinfo[ v.value .. "Scale" ] = v.max - v.min
            self.wepinfo[ v.value .. "BoxLength" ] = self.wepinfo[ v.value ] - v.min
            local newcolor, scale, val = Color( 0, 0, 0 ), self.wepinfo[ v.value .. "Scale" ], self.wepinfo[ v.value .. "BoxLength" ]
            if v.scale == "up" then
                newcolor = Color( ( ( scale - val ) / scale ) * 255, ( val / scale ) * 255, 0 )
            else
                newcolor = Color( ( val / scale ) * 255, ( ( scale - val ) / scale ) * 255, 0 )
            end
            self.wepinfo[ v.value .. "Color" ] = newcolor
            --//ScalingColor - Can't seem to get it working exactly how I want it
        end
    else
        self.DisplayStats = false
    end

    
    self.buybutton = self.buybutton or vgui.Create( "DButton", self )
    self.buybutton:SetSize( 120 + 8, ( self:GetTall() - ( 56 * 2 ) ) / 2 / ( #self.wepinfosetup / 2 + 1 ) - 6 )
    self.buybutton:SetPos( self:GetWide() - self.buybutton:GetWide() - 6, ( self:GetTall() - ( 56 * 2 ) ) / 2 + 4 + ( 56 * 2 ) )
    self.buybutton:SetText( "" )
    self.buybutton.DoClick = function()
        if self.buybutton.canbuy and self.weaponprice != 0 then
            surface.PlaySound( "ambient/levels/labs/coinslot1.wav" )
            local success = GAMEMODE:AttemptBuyWeapon( self.selectedweapon )
            if success then
                net.Start( "RequestLockedWeapons" )
                net.SendToServer()
                self.nextopenmenu = self.selected
            end
        else
            surface.PlaySound( "buttons/combine_button_locked.wav" )
        end
    end
    self.buybutton.Paint = function()
        if self.buybutton.hover then
            draw.RoundedBox( 4, 0, 0, self.buybutton:GetWide(), self.buybutton:GetTall(), Color( 0, 0, 0, 120 ) )
        end
        --if self.weaponprice then
            draw.SimpleText( "Buy for $" .. self.weaponprice, self.font, self.buybutton:GetWide() / 2, self.buybutton:GetTall() / 2 - 2, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        --end           --Exo 2 Button
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
    self.infotall = ( self:GetTall() - ( 56 * 2 ) ) / 2 / ( #self.wepinfosetup / 2 + 1 )

    surface.SetDrawColor( GAMEMODE.TeamColor )
    surface.DrawLine( -1, 56 * 2, self:GetWide() + 1, 56 * 2 )
    surface.SetTexture( GAMEMODE.GradientTexture )
    surface.SetDrawColor( 0, 0, 0, 164 )
    surface.DrawTexturedRectRotated( self:GetWide() / 2, ( 56 * 2 ) + 4, 8, self:GetWide(), 270 )

    surface.SetDrawColor( GAMEMODE.TeamColor )
    surface.DrawRect( self:GetWide() / 3 + 6, ( self:GetTall() - ( 56 * 2 ) ) / 2 + 4 + ( 56 * 2 ), self:GetWide() - ( self:GetWide() / 3 + 6 ) - 6, self.infotall - 6 )

    local texty = ( self:GetTall() - ( 56 * 2 ) ) / 2 + 4 + ( 56 * 2 )
    surface.SetTextColor( 255, 255, 255 )
    surface.SetTextPos( self:GetWide() / 3 + 16, texty )
    surface.SetFont( self.font )
    surface.DrawText( self.weaponname )
    
    for k, v in pairs( self.wepinfosetup ) do

        surface.SetTextColor( GAMEMODE.TeamColor )
        surface.SetFont( self.font )

        if !self.DisplayStats then 
            --Draw some equipment information text here
            return
        end

        --//Stat Text Drawing

        local textwide, texttall = surface.GetTextSize( v.display )
        self.leftlongesttext = self.leftlongesttext or textwide
        self.rightlongesttext = self.rightlongesttext or textwide

        if k <= ( #self.wepinfosetup / 2 ) then
            if textwide > self.leftlongesttext then
                self.leftlongesttext = textwide
            end
        else
            if textwide > self.rightlongesttext then
                self.rightlongesttext = textwide
            end
        end
        self.boxwide = ( ( self:GetWide() / 3 * 2 ) - ( self.leftlongesttext + self.rightlongesttext ) - ( 2 * 6 ) ) / 2
        
        if k <= ( #self.wepinfosetup / 2 ) then
            surface.SetTextPos( self:GetWide() / 3 + 2 + ( self.leftlongesttext - textwide ), ( self:GetTall() / 2 ) + ( self.infotall * ( k + 1 ) ) + self.infotall )
        else
            surface.SetTextPos( self:GetWide() - 2 - self.rightlongesttext, ( self:GetTall() / 2 ) + ( self.infotall * ( k - 4 ) ) + self.infotall )
        end
        surface.DrawText( v.display )

        --//Box drawing

        local boxfill
        if self.wepinfo[ v.value .. "BoxLength" ] then
            boxfill = self.wepinfo[ v.value .. "BoxLength" ] / self.wepinfo[ v.value .. "Scale" ]
        end

        if k <= ( #self.wepinfosetup / 2 ) then
            if boxfill then
                surface.SetDrawColor( self.wepinfo[ v.value .. "Color" ] )
                surface.DrawRect( self:GetWide() / 3 + 2 + self.leftlongesttext + 2, ( self:GetTall() / 2 ) + ( self.infotall * ( k + 1 ) + self.infotall ), boxfill * self.boxwide, texttall )
            end
            surface.SetDrawColor( GAMEMODE.TeamColor )
            surface.DrawOutlinedRect( self:GetWide() / 3 + 2 + self.leftlongesttext + 2, ( self:GetTall() / 2 ) + ( self.infotall * ( k + 1 ) ) + self.infotall, self.boxwide, texttall )
            draw.SimpleTextOutlined( self.wepinfo[ v.value ], self.font, self:GetWide() / 3 + 2 + self.leftlongesttext + 2 + 4, ( self:GetTall() / 2 ) + ( self.infotall * ( k + 1 ) + ( self.infotall / 4 ) + self.infotall + 1 ), GAMEMODE.TeamColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 255, 255, 255 ) )
        else
            local boxspacer = 6
            if boxfill then
                surface.SetDrawColor( self.wepinfo[ v.value .. "Color" ] )
                surface.DrawRect( self:GetWide() / 3 + 2 + self.leftlongesttext + 2 + ( self.boxwide * 2 ) + boxspacer - ( boxfill * self.boxwide ), ( self:GetTall() / 2 ) + ( self.infotall * ( k - 4 ) + self.infotall ), boxfill * self.boxwide, texttall )
            end
            surface.SetDrawColor( GAMEMODE.TeamColor )
            surface.DrawOutlinedRect( self:GetWide() / 3 + 2 + self.leftlongesttext + 2 + self.boxwide + boxspacer, ( self:GetTall() / 2 ) + ( self.infotall * ( k - 4 ) + self.infotall ), self.boxwide, texttall )
            draw.SimpleTextOutlined( self.wepinfo[ v.value ], self.font, self:GetWide() / 3 + 2 + self.leftlongesttext + 2 + ( self.boxwide * 2 ) + boxspacer - 5, ( self:GetTall() / 2 ) + ( self.infotall * ( k - 4 ) + ( self.infotall / 4 ) + self.infotall + 1 ), GAMEMODE.TeamColor, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color( 255, 255, 255 ) )
        end
    end
end

function weaponsshop:Think()
    if not self:IsValid() then

    end
end

vgui.Register( "WeaponsShopPanel", weaponsshop, "DPanel" )

--//

local skinsshopbutton = {}
skinsshopbutton.texture = Material( "" )
skinsshopbutton.option = ""

function skinsshopbutton:SetSkin( dir )
    self.option = dir
    self.material = Material( dir )
end

function skinsshopbutton:DoClick()
    self:GetParent():SelectOption( self.option )
end

function skinsshopbutton:Paint()
    surface.SetMaterial( self.material )
    surface.DrawTexturedRect( 0, 0, self:GetWide(), self:GetTall() )
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

--How should the buttons be oriented? Vertically or horizontally?
--How should we organize the buttons? By pricing options?

local skinsshop = { }
skinsshop.skins = { }
skinsshop.skinbuttons = { }

function skinsshop:Init()
    self.scrollpanel = self.scrollpanel or vgui.Create( "DScrollPanel", self )
end

function skinsshop:AddSkin( dir )
    self.skins[ #self.skins + 1 ] = dir
    self:ResetList()
end

function skinsshop:SelectOption( dir )
    self.selected = dir
    --self.skinbuttons[ dir ]:DoClick()
    --Draw a model with the selected skin, display pricing
end

function skinsshop:ResetList()
    for k, v in pairs( self.skins ) do
        self.skinbuttons[ v ] = self.skinbuttons[ v ] or vgui.Create( "SkinsShopButton", self )
        self.skinbuttons[ v ]:SetSkin( v )
        --Create all of the buttons here
    end
end

function skinsshop:Paint()

end

vgui.Register( "SkinsShopPanel", skinsshop, "DPanel" )

--//

local modelsshopbutton = table.Copy( skinsshopbutton )

--//

local modelsshop = { }

vgui.Register( "ModelsShopPanel", modelsshop, "DPanel" )