--//This file is strictly for creating custom vgui elements for the shop

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

function weaponsshopbutton:DoClick()
    self:GetParent().selected = self.text
    self:GetParent():Reset()
    --//Maybe do a sound
end

function weaponsshopbutton:Think()
    if self:GetParent().selected == self.text then
        self.selected = true
    else
        self.selected = false
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
        surface.DrawTexturedRectRotated( self:GetWide() / 2, 4, 8, self:GetWide(), 270 ) --self.TeamMain:GetWide() / 2, self.TeamMainTitleSize + 4, 8, self.TeamMain:GetWide(), 270
    end

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

vgui.Register( "WeaponsShopButton", weaponsshopbutton, "DButton" )

local weaponsshop = { }
weaponsshop.font = "ExoTitleFont"
weaponsshop.tabs = { "ar", "smgs", "sg", "sr", "lmg", "pt", "mn", "eq" }
weaponsshop.wepinfosetup = {
--//Scale up means higher is better, scale down means lower is better - use for color calculation
    { value = "Damage", display = "Damage", min = 0, max = 100, scale = "up" },
    { value = "FireDelay", display = "Firerate", min = 0.5, max = 2, scale = "up" },
    { value = "AimSpread", display = "Aimspread", min = 0.001, max = 0.03, scale = "down" },
    { value = "HipSpread", display = "Hipspread", min = 0.01, max = 0.5, scale = "down" },
    { value = "Recoil", display = "Recoil", min = 0.5, max = 5, scale = "down" },
    { value = "VelocitySensitivity", display = "Aim Sensitivity", min = 1, max = 3, scale = "down" },
    { value = "MaxSpread", display = "Max Spread", min = 0.01, max = 0.4, scale = "down" },
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
    MaxSpread = weaponsshop.wepinfosetup[ 7 ].min,
    MaxSpreadColor = Color( 0, 0, 0 ),
    ClipSize = weaponsshop.wepinfosetup[ 8 ].min,
    ClipSizeColor = Color( 0, 0, 0 ),
    SpeedDec = weaponsshop.wepinfosetup[ 9 ].min,
    SpeedDecColor = Color( 0, 0, 0 ),
    SpreadCooldown = weaponsshop.wepinfosetup[ 10 ].min,
    SpreadCooldownColor = Color( 0, 0, 0 )
}

function weaponsshop:DoSetup()
    net.Start( "RequestLockedWeapons" )
    net.SendToServer()

    net.Receive( "RequestLockedWeaponsCallback", function()
        --//Table received with meaningless keys and and values as the keys to the locked guns in GAMEMODE.WeaponsList
        self.lockedweapons = net.ReadTable()
        if not self.Reset then
            timer.Simple( 0, function()
                self:Reset( "ar" )
            end )
        else
            self:Reset( "ar" )
        end
    end )
    
    for k, v in pairs( self.tabs ) do
        local rowoffset = 0
        --print( k, v )
        if k > 4 then rowoffset = 56 end

        local throwaway = vgui.Create( "WeaponsShopButton", self )
        print( self:GetWide(), self:GetTall(), self )
        throwaway:SetSize( self:GetWide() / 4, 56 )
        throwaway:SetPos( throwaway:GetWide() * ( k - 1 - rowoffset ), rowoffset )
        throwaway:SetText( v )
        if k > 4 then
            throwaway:DoGradient()
        end

        --self.tabs[ v ] = throwaway
    end

    function self:Reset( type )
        if !IsValid( self.lockedweapons ) then return end

        self.scrollpanel = vgui.Create( "DScrollPanel", self )
        self.scrollpanel:SetPos( 0, 56 * 2 )
        self.scrollpanel:SetSize( self:GetWide() / 3, self:GetTall() - ( 56 * 2 ) )

        self.scrollpanelbuttons = {}
        for k, v in pairs( self.lockedweapons ) do
            if GAMEMODE.WeaponsList[ v ].type == type then
                local sloticon = GAMEMODE.Icons.Weapons[ GAMEMODE.WeaponsList[ v ].slot ]
                local sloticonsize = 16

                --//This should probably be a custom vgui element, but fuckit, the custom elements are only to keep cl_shop clean, not this file
                local throwaway = vgui.Create( "DButton", self.scrollpanel )
                throwaway:SetSize( self.scrollpanel:GetWide() * 0.75, 45 )
                throwaway:Dock( TOP )
                throwaway:SetText( "" )
                throwaway.Paint = function()
                    surface.SetDrawColor( GAMEMODE.TeamColor )
                    surface.DrawLine( 4, 1, throwaway:GetWide() - 4, 1 )
                    --surface.DrawLine( 4, throwaway:GetTall(), throwaway:GetWide() - 4, throwaway:GetTall() )

                    surface.SetTexture( sloticon )
                    surface.SetDrawColor( GAMEMODE.TeamColor )
                    surface.DrawTexturedRect( sloticonsize, throwaway:GetTall() / 2 - ( sloticonsize / 2 ), sloticonsize, sloticonsize )
                    draw.SimpleText( GAMEMODE.WeaponsList[ v ][ 1 ], self.font, ( sloticonsize * 2 ) + 4, throwaway:GetTall() / 2, Color( 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )

                    if ( !throwaway.hover and !throwaway.selected ) or !throwaway.unlocked then
                        surface.SetTexture( GAMEMODE.GradientTexture )
                        surface.SetDrawColor( 0, 0, 0, 164 )
                        surface.DrawTexturedRectRotated( throwaway:GetWide() / 2, 4, 8, self:GetWide(), 270 )
                        surface.DrawTexturedRectRotated( throwaway:GetWide() / 2, throwaway:GetTall() - 4, 8, self:GetWide(), 90 )
                    end

                    --[[surface.SetTexture(  )
                    surface.SetDrawColor( 255, 0, 0 )
                    if throwaway.unlocked then
                        surface.SetTexture(  )
                        surface.SetDrawColor( 0, 255, 0 )
                    end
                    surface.DrawTexturedRect(  )

                    surface.SetTexture(  )
                    surface.SetDrawColor( 255, 0, 0 )
                    if throwaway.canbuy then
                        surface.SetTexture(  )
                        surface.SetDrawColor( 0, 255, 0 )
                    end
                    surface.DrawTexturedRect(  ) ]]
                end
                throwaway.DoClick = function()
                    if throwaway.unlocked then
                        self:SelectWeapon( GAMEMODE.WeaponsList[ v ][ 2 ] )
                        --Add sound?
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
                self.scrollpanelbuttons[ GAMEMODE.WeaponsList[ v ] ] = throwaway
            end
        end
    end

end

function weaponsshop:SelectWeapon( wep )
    self.selectedweapon = wep
    local wep = weapons.GetStored( wep )
    self.modelpanel = vgui.Create( "DModelPanel", self )
    self.modelpanel:SetSize( self:GetWide() / 3 * 2, ( self:GetTall() - ( 56 * 2 ) ) / 2 )
    self.modelpanel:SetPos( self:GetWide() / 3, 56 * 2 )
    self.modelpanel:SetModel( wep.WorldModel )
    self.modelpanel:SetCamPos( Vector( 0, 35, 0 ) ) --Courtesy of Spy
    self.modelpanel:SetLookAt( Vector( 0, 0, 0 ) ) --Courtesy of Spy
    self.modelpanel:SetFOV( 90 ) --Courtesy of Spy
    --self.modelpanel:GetEntity():SetAngles
    self.modelpanel:GetEntity():SetPos( Vector( -6, 13.5, -1) )
    self.modelpanel:SetAmbientLight( Color( 255, 255, 255 ) )
    self.modelpanel.LayoutEntity = function() return true end --Disables rotation

    self.weaponname = wep.DisplayName

    for k, v in pairs( self.wepinfosetup ) do
        if v.value == "ClipSize" then
            self.wepinfo[ v.value ] = math.Clamp( wep.Primary[ v.value ], v.min, v.max )
        elseif v.value == "Damage" and wep.Shots > 1 then
            self.wepinfo.Damage = math.Clamp( wep.Damage * wep.Shots, v.mix, v.max )
        elseif v.value == "HipSpread" and v.Shots > 1 then
            local newtab = { value = "ClumpSpread", display = "Clumpspread", min = 0.02, max = 0.05, scale = "down" }
            self.wepinfosetup[ k ] = newtab
            v = newtab
            self.wepinfo.ClumpSpread = math.Clamp( wep.ClumpSpread, v.min, v.max )
        else
            self.wepinfo[ v.value ] = math.Clamp( wep[ v.value ], v.min, v.max )
        end
        
        local newcolor, scale, val = Color( 0, 0, 0 ), v.max - v.min, self.wepinfo[ v.value ] - v.min
        if v.scale == "up" then
            newcolor = Color( ( ( scale - val ) / scale ) * 255, ( val / scale ) * 255, 0 )
        else
            newcolor = Color( ( val / scale ) * 255, ( ( scale - val ) / scale ) * 255, 0 )
        end
        self.wepinfo[ v.value .. "Color" ] = newcolor
    end
end

function weaponsshop:Paint()
    self.infotall = ( self:GetTall() - ( 56 * 2 ) ) / 2 / ( #self.wepinfosetup / 2 + 1 )

    draw.SimpleText( self.weaponname, self.font, self:GetWide() / 3 + 12, self:GetTall() / 2, Color( 0, 0, 0 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
    for k, v in pairs( self.wepinfosetup ) do
        surface.SetTextColor( GAMEMODE.TeamColor )
        surface.SetFont( self.font )

        local textwide, texttall = surface.GetTextSize( v.display )
        self.longesttext = self.longesttext or textwide
        if textwide > self.longesttext then self.longesttext = textwide end
        
        if k <= ( #self.wepinfosetup / 2 ) then
            --draw.SimpleText( v.display )
            surface.SetTextPos( self:GetWide() / 3 + 2, ( self:GetTall() / 2 ) + ( self.infotall * ( k ) ) )
        else
            surface.SetTextPos( self:GetWide() - 2 - textwide, ( self:GetTall() / 2 ) + ( self.infotall * ( k - 1 ) ) )
        end
        surface.DrawText( v.display )

        --//Box drawing

        surface.SetDrawColor( self.wepinfo[ v.value .. "Color" ] )
        surface.DrawRect( 0, 0, 0, 0 )

        surface.SetDrawColor( GAMEMODE.TeamColor )
        surface.DrawOutlinedRect( 0, 0, 0, 0 )

        draw.SimpleTextOutlined( self.wepinfo[ v.value ], self.font, 0, 0, GAMEMODE.TeamColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 255, 255, 255 ) )
    end
end

vgui.Register( "WeaponsShopPanel", weaponsshop, "DPanel" )

--//

local skinsshop = { }

vgui.Register( "SkinsShopPanel", skinsshop, "DButton" )

--//

local modelsshop = { }