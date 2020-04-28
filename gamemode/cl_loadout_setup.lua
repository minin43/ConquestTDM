--//This file is strictly for creating/registering custom vgui elements for the loadout menu

surface.CreateFont( "Exo-18-400", { font = "Exo 2", size = 24 } )

--A base to derives all incoming Loadout buttons from
--Not much different from a DButton, but includes OnCursorEntered/Exited so I don't have to rewrite that 80 billion times
local basebutton = {}
basebutton.display = ""
basebutton.font = "DermaDefault"

function basebutton:SetText( txt )
    self.display = txt
end

function basebutton:SetFont( fnt )
    self.font = fnt
end

function basebutton:OnCursorEntered()
    --surface.PlaySound( "" )
    self.hover = true
end

function basebutton:OnCursorExited()
    self.hover = false
end

function basebutton:DoClick()
    surface.PlaySound( "" )
end

function basebutton:Paint()
    draw.SimpleText( self.Text, self.Font, self:GetWide() / 2, self:GetTall() / 2, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    return true
end

vgui.Register( "LoganButton", basebutton, "DButton" )

--//

--//The slider object itself, 
local baseslider = {}
AccessorFunc( baseslider, "m_fSlideX", "SlideX" )
AccessorFunc( baseslider, "m_fSlideY", "SlideY" )
AccessorFunc( baseslider, "m_iLockX", "LockX" )
AccessorFunc( baseslider, "m_iLockY", "LockY" )
AccessorFunc( baseslider, "Dragging", "Dragging" )
AccessorFunc( baseslider, "m_bTrappedInside", "TrapInside" )
AccessorFunc( baseslider, "m_iNotches", "Notches" )

function baseslider:Init()
	self:SetMouseInputEnabled( true )

	self:SetSlideX( 0.5 )
	self:SetSlideY( 0.5 )

	self.Knob = vgui.Create( "DButton", self )
	self.Knob:SetText( "" )
	self.Knob:SetSize( 15, 15 )
	self.Knob:NoClipping( true )
    self.Knob.Paint = function( panel, w, h ) 
        surface.SetDrawColor( GAMEMODE.TeamColor )
        surface.DrawRect( w / 2 - 2, 0, 4, h )
    end
	self.Knob.OnCursorMoved = function( panel, x, y )
		local x, y = panel:LocalToScreen( x, y )
		x, y = self:ScreenToLocal( x, y )
		self:OnCursorMoved( x, y )
	end

	self:SetLockY( 0.5 )
end

function baseslider:IsEditing()
	return self.Dragging || self.Knob.Depressed
end

function baseslider:SetEnabled( b )
	self.Knob:SetEnabled( b )
	FindMetaTable( "Panel" ).SetEnabled( self, b ) -- There has to be a better way!
end

function baseslider:OnCursorMoved( x, y )
	if ( !self.Dragging && !self.Knob.Depressed ) then return end

	local w, h = self:GetSize()
	local iw, ih = self.Knob:GetSize()

	if ( self.m_bTrappedInside ) then

		w = w - iw
		h = h - ih

		x = x - iw * 0.5
		y = y - ih * 0.5

	end

	x = math.Clamp( x, 0, w ) / w
	y = math.Clamp( y, 0, h ) / h

	if ( self.m_iLockX ) then x = self.m_iLockX end
	if ( self.m_iLockY ) then y = self.m_iLockY end

	x, y = self:TranslateValues( x, y )

	self:SetSlideX( x )
	self:SetSlideY( y )

	self:InvalidateLayout()
end

function baseslider:TranslateValues( x, y )
	-- Give children the chance to manipulate the values..
	return x, y
end

function baseslider:OnMousePressed( mcode )
	if ( !self:IsEnabled() ) then return true end

	self:SetDragging( true )
	self:MouseCapture( true )

	local x, y = self:CursorPos()
	self:OnCursorMoved( x, y )
end

function baseslider:OnMouseReleased( mcode )
	self:SetDragging( false )
	self:MouseCapture( false )
end

function baseslider:PerformLayout()
	local w, h = self:GetSize()
	local iw, ih = self.Knob:GetSize()

	if ( self.m_bTrappedInside ) then

		w = w - iw
		h = h - ih
		self.Knob:SetPos( ( self.m_fSlideX || 0 ) * w, ( self.m_fSlideY || 0 ) * h )

	else

		self.Knob:SetPos( ( self.m_fSlideX || 0 ) * w - iw * 0.5, ( self.m_fSlideY || 0 ) * h - ih * 0.5 )

	end
end

function baseslider:SetSlideX( i )
	self.m_fSlideX = i
	self:InvalidateLayout()
end

function baseslider:SetSlideY( i )
	self.m_fSlideY = i
	self:InvalidateLayout()
end

function baseslider:GetDragging()
	return self.Dragging || self.Knob.Depressed
end

vgui.Register( "BaseSlider", baseslider, "DPanel" )

--//

--I don't like the default DNumSlider look, plus DNumberScratch is stupid
local newslider =  {}
newslider.MinValue = 0
newslider.MaxValue = 10
newslider.CurrentValue = 0
newslider.display = ""

function newslider:StartDraw()
	self.Slider = self:Add( "BaseSlider", self )
	self.Slider:SetLockY( 0.5 )
	self.Slider.TranslateValues = function( slider, x, y ) return self:TranslateSliderValues( x, y ) end
	self.Slider:SetTrapInside( true )
    self.Slider:SetSize( self:GetWide() / 2, self:GetTall() )
    self.Slider:SetPos( self:GetWide() / 2, 0 )
	self.Slider:SetHeight( self:GetTall() )
	self.Slider.Knob.OnMousePressed = function( panel, mcode )
		if ( mcode == MOUSE_MIDDLE ) then
			self:ResetToDefaultValue()
			return
		end
		self.Slider:OnMousePressed( mcode )
	end
    self.Slider.Paint = function( panel, w, h )
        surface.SetDrawColor( 255, 255, 255 )
        surface.DrawRect( 0, 0, self.Slider:GetWide(), self.Slider:GetTall() )
        surface.SetDrawColor( 0, 0, 0, 220 )
        surface.DrawLine( 6, h / 2, w - 8, h / 2 )
        for c = 0, panel:GetNotches() do
            surface.DrawLine( 6 + ((w - 14) / panel:GetNotches() * c), h / 2 - 4, 6 + ((w - 14) / panel:GetNotches() * c), h / 2 + 4 )
        end
    end

	self.Label = vgui.Create ( "DPanel", self )
    self.Label:SetSize( self:GetWide() / 2, self:GetTall() )
    self.Label:SetPos( 0, 0 )
    self.Label.Paint = function( panel, w, h )
        surface.SetDrawColor( 255, 255, 255 )
        surface.DrawRect( 0, 0, w, h )
        --surface.SetDrawColor( 0, 0, 0 )
        --surface.DrawOutlinedRect( 0, 0, w, h)

        surface.SetTextColor( GAMEMODE.TeamColor )
        surface.SetFont( "Exo-24-400" )
        local w, h = surface.GetTextSize( self.display )
        surface.SetTextPos( self.Label:GetWide() / 2 - (w / 2), self.Label:GetTall() / 2 - (h / 2) )
        surface.DrawText( self.display )
    end
end

function newslider:Paint( w, h )
    surface.SetDrawColor( 0, 0, 0, 220 )
    surface.DrawLine( 8, h, 2 - 8, h )
end

function newslider:TranslateSliderValues( x, y )
	self:SetValue( self.MinValue + ( x * (self.MaxValue - self.MinValue) ) )

	return self:GetFraction(), y
end

function newslider:UpdateNotches()
	local range = self.MaxValue - self.MinValue
	self.Slider:SetNotches( nil )

	if ( range < self:GetWide() / 4 ) then
		return self.Slider:SetNotches( range )
	else
		self.Slider:SetNotches( self:GetWide() / 4 )
	end
end

function newslider:ValueChanged( val )
	self.Slider:SetSlideX( self:GetFraction() )

	self:OnValueChanged( val )
end

function newslider:ResetToDefaultValue()
    self:SetValue( self.MinValue )
end

function newslider:OnValueChanged( val )
	-- For override
end

function newslider:SetMin( num )
    self.MinValue = tonumber( num ) or 0

    self:UpdateNotches()
end

function newslider:SetMax( num )
    self.MaxValue = tonumber( num ) or 10

    self:UpdateNotches()
end

function newslider:SetValue( num )
    self.CurrentValue = math.Clamp( num or 0, self.MinValue, self.MaxValue )

    self:ValueChanged( self.CurrentValue )
end

function newslider:SetText( txt )
    self.display = txt
    --self.Label:SetText( txt )
end

function newslider:GetFraction()
    return (self.CurrentValue - self.MinValue) / (self.MaxValue - self.MinValue)
end

vgui.Register( "LoganSlider", newslider, "DPanel" )

--//

local playermodelpanel = {}
playermodelpanel.RebelModels = { "models/player/group03/male_01.mdl", "models/player/group03/male_02.mdl", "models/player/group03/male_03.mdl", "models/player/group03/male_04.mdl",
    "models/player/group03/male_05.mdl", "models/player/group03/male_06.mdl", "models/player/group03/male_07.mdl", "models/player/group03/male_08.mdl", "models/player/group03/male_09.mdl" }
playermodelpanel.Sequences = { "idle_ar2", "pose_standing_02", "idle_all_01", "cidle_ar2" }
playermodelpanel.EntityBodygroup = {}
playermodelpanel.DefaultWeapon = "models/weapons/w_rif_m4a1.mdl"
playermodelpanel.model = playermodelpanel.RebelModels[ math.random( #playermodelpanel.RebelModels ) ]
playermodelpanel.WeaponEntity = nil
playermodelpanel.OptionsButton = nil
playermodelpanel.OptionsPanel = nil
playermodelpanel.rotate = 0
playermodelpanel.rotatemult = 0.25

AccessorFunc( playermodelpanel, "WeaponEntity", "WeaponEntity" )

function playermodelpanel:SetDefaultModel( mdl )
    self.model = mdl
end

--//Modified DModelPanel SetModel function, allows a second model be added as a weapon to equip to the first model
function playermodelpanel:SetModel( strModelName, strModelName2 )

    if !strModelName and !strModelName2 then
        if self.Entity then
            self.Entity:Remove()
            self.Entity = nil
        end
        if self.WeaponEntity then
            self.WeaponEntity:Remove()
            self.WeaponEntity = nil
        end
    end

    local firstModel = strModelName or self.model
    self.model = strModelName or self.model
    local secondModel = strModelName2 or self.DefaultWeapon

    if strModelName or (!self.Entity and strModelName2) then
        if ( IsValid( self.Entity ) ) then
            self.Entity:Remove()
            self.Entity = nil
        end

        if ( !ClientsideModel ) then return end

        self.Entity = ClientsideModel( firstModel, RENDERGROUP_OTHER )
        if ( !IsValid( self.Entity ) ) then return end

        self.Entity:SetNoDraw( true )
        self.Entity:SetIK( false )

        local iSeq = self.Entity:LookupSequence( "walk_all" )
        if ( iSeq <= 0 ) then iSeq = self.Entity:LookupSequence( "WalkUnarmed_all" ) end
        if ( iSeq <= 0 ) then iSeq = self.Entity:LookupSequence( "walk_all_moderate" ) end

        if ( iSeq > 0 ) then self.Entity:ResetSequence( iSeq ) end

        if IsValid( self.WeaponEntity ) then
            self.WeaponEntity:SetParent( self.Entity )
            self.WeaponEntity:AddEffects( EF_BONEMERGE )
        end
    end
    
    if strModelName2 then        
        if IsValid( self.WeaponEntity ) then
            self.WeaponEntity:Remove()
            self.WeaponEntity = nil
        end

        self.WeaponEntity = ClientsideModel( secondModel, RENDERGROUP_OTHER )
        if ( !IsValid( self.WeaponEntity ) ) then return end
    
        self.WeaponEntity:SetParent( self.Entity )
        self.WeaponEntity:SetNoDraw( true )
        if !self.specialdraw then
            self.WeaponEntity:AddEffects( EF_BONEMERGE )
        end
        if self.WeaponSkin then
            self.WeaponEntity:SetMaterial( self.WeaponSkin )
        end

        timer.Simple( 0, function()
            if self then
                self:SetSequence( self.EntitySequence or 1 )
            end
        end )
    end
end

function playermodelpanel:DrawModel()

	local curparent = self
	local leftx, topy = self:LocalToScreen( 0, 0 )
	local rightx, bottomy = self:LocalToScreen( self:GetWide(), self:GetTall() )
	while ( curparent:GetParent() != nil ) do
		curparent = curparent:GetParent()

		local x1, y1 = curparent:LocalToScreen( 0, 0 )
		local x2, y2 = curparent:LocalToScreen( curparent:GetWide(), curparent:GetTall() )

		leftx = math.max( leftx, x1 )
		topy = math.max( topy, y1 )
		rightx = math.min( rightx, x2 )
		bottomy = math.min( bottomy, y2 )
		previous = curparent
	end

	render.SetScissorRect( leftx, topy, rightx, bottomy, true )

	local ret = self:PreDrawModel( self.Entity )
	if ( ret != false ) then
		self.Entity:DrawModel()
        self:PostDrawModel( self.Entity )
        
        if self.WeaponEntity then
            self.WeaponEntity:DrawModel()
        end
	end

	render.SetScissorRect( 0, 0, 0, 0, false )

end

function playermodelpanel:Paint( w, h )

	if ( !IsValid( self.Entity ) ) then return end

	local x, y = self:LocalToScreen( 0, 0 )

    --self:LayoutEntity( self.Entity )
    self.Entity:SetAngles( Angle( 0, (45 + self.rotate) % 360, 0 ) )

	local ang = self.aLookAngle
	if ( !ang ) then
		ang = ( self.vLookatPos - self.vCamPos ):Angle()
	end

	cam.Start3D( self.vCamPos, ang, self.fFOV, x, y, w, h, 5, self.FarZ )

	render.SuppressEngineLighting( true )
	render.SetLightingOrigin( self.Entity:GetPos() )
	render.ResetModelLighting( self.colAmbientLight.r / 255, self.colAmbientLight.g / 255, self.colAmbientLight.b / 255 )
	render.SetColorModulation( self.colColor.r / 255, self.colColor.g / 255, self.colColor.b / 255 )
	render.SetBlend( ( self:GetAlpha() / 255 ) * ( self.colColor.a / 255 ) ) -- * surface.GetAlphaMultiplier()

	for i = 0, 6 do
		local col = self.DirectionalLight[ i ]
		if ( col ) then
			render.SetModelLighting( i, col.r / 255, col.g / 255, col.b / 255 )
		end
	end

	self:DrawModel()

	render.SuppressEngineLighting( false )
	cam.End3D()

	self.LastPaint = RealTime()

    surface.SetTexture( GAMEMODE.GradientTexture )
    surface.SetDrawColor( 0, 0, 0, 164 )
    surface.DrawTexturedRectRotated( w / 2, h - 4 - GAMEMODE.TitleBar, 8, w, 90 )
    surface.DrawTexturedRectRotated( w / 2, (h / 4) + 4 , 8, w, -90 )
end

function playermodelpanel:PaintOver( w, h )
    if self.OptionsPanel and self.OptionsPanel:IsValid() then
        local panelx, panely = panel:GetPos()
        surface.SetTexture( GAMEMODE.GradientTexture )
        surface.SetDrawColor( 0, 0, 0, 164 )
        surface.DrawTexturedRectRotated( w / 2, panely - 4, 8, w, 90 )
    end
end

function playermodelpanel:OnRemove()
	if ( IsValid( self.Entity ) ) then
		self.Entity:Remove()
    end
    
    if IsValid( self.WeaponEntity ) then
        self.WeaponEntity:Remove()
    end
end

function playermodelpanel:Think()
    self.rotate = self.rotate + self.rotatemult

    if self.specialdraw then
        wm = self.WeaponEntity --self.WMEnt
		
        if IsValid(self.Entity) then
            pos, ang = self.Entity:GetBonePosition( self.Entity:LookupBone("ValveBiped.Bip01_R_Hand") )
            
            if pos and ang then
                ang:RotateAroundAxis(ang:Right(), self.WMAng[1])
                ang:RotateAroundAxis(ang:Up(), self.WMAng[2])
                ang:RotateAroundAxis(ang:Forward(), self.WMAng[3])

                pos = pos + self.WMPos[1] * ang:Right() 
                pos = pos + self.WMPos[2] * ang:Forward()
                pos = pos + self.WMPos[3] * ang:Up()
                
                wm:SetRenderOrigin(pos)
                wm:SetRenderAngles(ang)
                wm:DrawModel()
            end
        else
            wm:SetRenderOrigin(self:GetPos())
            wm:SetRenderAngles(self:GetAngles())
            wm:DrawModel()
            wm:DrawShadow()
        end
    end
end

function playermodelpanel:SetRotate( num )
    self.rotatemult = math.Clamp( num, 0, 5 )
end

--CW2.0 weapons draw the world model a special way, and because of that, their wmodels have no righthand bone, so we have to work around that with this
function playermodelpanel:SetSpecialDraw( weptable )
    if !weptable then
        self.specialdraw = false
        return
    end

    self.WMEnt = weptable.WMEnt or weptable.WM
    self.WMAng = weptable.WMAng
    self.WMPos = weptable.WMPos
    self.specialdraw = true
end

function playermodelpanel:SetSequence( num )
    if IsValid( self.Entity ) then
        self.Entity:SetSequence( self.Sequences[ math.Clamp(num, 1, #self.Sequences) ] )
        self.EntitySequence = num
    end
end

function playermodelpanel:GetSequence()
    if IsValid( self.Entity ) then
        return self.EntitySequence
    end
end

function playermodelpanel:SetSkin( num )
    self.EntitySkin = num
    self.Entity:SetSkin( math.Clamp( num, 1, self.Entity:SkinCount() ) )
end

function playermodelpanel:SetOptionsPanel( panel )
    self.OptionsPanel = panel
end

function playermodelpanel:SetOptionsButton( panel )
    self.OptionsButton = panel
end

function playermodelpanel:ResetOptionsButton()
    if self.OptionsButton then
        self.OptionsButton:RefreshOptions()
    end
end

function playermodelpanel:SetBodygroup( bodygroup, value )
    self.EntityBodygroup[bodygroup] = value
    self.Entity:SetBodygroup( bodygroup, value )
end

vgui.Register( "PlayermodelPanel", playermodelpanel, "DModelPanel")

--//

local playermodelpaneloptions = {}
playermodelpaneloptions.referencepanel = nil

function playermodelpaneloptions:SetModelPanel( panel )
    self.referencepanel = panel

    self:RefreshOptions()
end

function playermodelpaneloptions:RefreshOptions()
    if self.scrollpanel and self.scrollpanel:IsValid() then
        self.scrollpanel:Remove()
    end

    local reducedSize = 0
    if ((self.referencepanel.Entity:SkinCount() > 1) and #self.referencepanel.Entity:GetBodyGroups() > 2) or #self.referencepanel.Entity:GetBodyGroups() > 3 then
        reducedSize = 14
    end

    local scrollpanel = vgui.Create( "DScrollPanel", self )
    scrollpanel:SetSize( self:GetWide(), self:GetTall() )
    scrollpanel:SetPos( 0, 0 )
    local sBar = scrollpanel:GetVBar()
    function sBar:Paint( w, h )
        draw.RoundedBox( 4, w / 4, 16, w / 2, h - 32, Color( 66, 66, 66 ) )
        return 
    end
    function sBar.btnGrip:Paint( w, h )
        draw.RoundedBox( 4, w / 4, 0, w / 2, h, GAMEMODE.TeamColor )
    end
    sBar.btnUp.Paint = function() return end
    sBar.btnDown.Paint = function() return end
    self.scrollpanel = scrollpanel
    local numElements = 0

    local stances = vgui.Create( "LoganSlider", scrollpanel )
    stances:SetSize( self:GetWide() - reducedSize, scrollpanel:GetTall() / 3 )--GAMEMODE.TitleBar / 2 )
    stances:Dock( TOP )
    stances:StartDraw()
    stances:SetText( "Stance:" )
    stances:SetMin( 1 )
    stances:SetMax( 4 )
    stances:SetValue( self.referencepanel.EntitySequence or 1 )
    stances.OnValueChanged = function( _, num )
        self.referencepanel:SetSequence( math.Round( num ) )
    end
    self.referencepanel:SetSequence( self.referencepanel.EntitySequence or 1 )
    numElements = numElements + 1
    
    local numskins = self.referencepanel.Entity:SkinCount()
    if numskins > 1 then
        local skins = vgui.Create( "LoganSlider", scrollpanel )
        skins:SetSize( self:GetWide() - reducedSize, scrollpanel:GetTall() / 3 )
        skins:Dock( TOP )
        skins:StartDraw()
        skins:SetText( "Skin:" )
        skins:SetMin( 1 )
        skins:SetMax( numskins )
        skins:SetValue( 1 )
        skins.OnValueChanged = function( _, num )
            self.referencepanel:SetSkin( math.Round( num ) )
        end
    else
        if #self.referencepanel.Entity:GetBodyGroups() == 1 then
            local skins = vgui.Create( "DPanel", scrollpanel )
            skins:SetSize( self:GetWide() - reducedSize, scrollpanel:GetTall() / 3 * 2 )
            skins:Dock( TOP )
            skins.Paint = function()
                draw.SimpleText( "- Cannot be edited -", "Exo-18-400", skins:GetWide() / 2, skins:GetTall() / 2, GAMEMODE.TeamColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
            end
        end
    end
    numElements = numElements + 1

    for k, v in pairs( self.referencepanel.Entity:GetBodyGroups() ) do
        if v.num > 1 then
            local bg = vgui.Create( "LoganSlider", scrollpanel )
            bg:SetSize( self:GetWide() - reducedSize, scrollpanel:GetTall() / 3 )
            bg:Dock( TOP )
            bg:StartDraw()
            bg:SetText( string.upper(string.Left(v.name, 1)) .. string.Right(v.name, #v.name - 1) .. ":" )
            bg:SetMin( 0 )
            bg:SetMax( v.num - 1 )
            bg:SetValue( 0 )
            bg.OnValueChanged = function( _, num )
                self.referencepanel:SetBodygroup( v.id, math.Round( num ) )
            end
            numElements = numElements + 1
        end
    end
end

function playermodelpaneloptions:Paint()
    surface.SetDrawColor( 255, 255, 255 )
    surface.DrawRect( 0, 0, self:GetWide(), self:GetTall() )
    return true
end

vgui.Register( "PlayermodelPanelOptions", playermodelpaneloptions, "DPanel" )

--//

local playermodelpanelmodels = table.Copy( basebutton )
playermodelpanelmodels.models = {}
playermodelpanelmodels.trueparent = nil

function playermodelpanelmodels:SetModels( tab )
    self.models = tab
end

function playermodelpanelmodels:SetTrueParent( panel )
    self.trueparent = panel
end

function playermodelpanelmodels:Paint()
    surface.SetDrawColor( 255, 255, 255 )
    surface.DrawRect( 0, 0, self:GetWide(), self:GetTall() )
    surface.SetFont( "Exo-24-400" )
    local w, h = surface.GetTextSize( "Select Playermodel" )
    surface.SetTextPos( self:GetWide() / 2 - (w / 2), self:GetTall() / 2 - (h / 2) )
    surface.SetTextColor( 0, 0, 0, 220 )
    if self.hover then
        surface.SetTextColor( GAMEMODE.TeamColor )
    end
    surface.DrawText( "Select Playermodel" )
    return true
end

--Prepare thy buttcheeks
function playermodelpanelmodels:DoClick()
    if #self.models == 0 then
        surface.PlaySound( GAMEMODE.ButtonSounds.Deny[ math.random( #GAMEMODE.ButtonSounds.Deny ) ] )
        return
    end
    if self.moving then return end

    if self.extended then
        self.moving = true
        if self.listpanel.selected then
            self.trueparent:SetModel( self.listpanel.selected )
            self.trueparent:ResetOptionsButton()
        end
        self.listpanel:MoveTo( 0, self.trueparent:GetTall(), 0.75, 0, -1, function()
            self.moving = false
            self.extended = false
            self.listpanel:Remove()
        end )
    else
        self.moving = true

        self.listpanel = vgui.Create( "DPanel", self.trueparent )
        self.listpanel:SetSize( self:GetWide(), math.min( GAMEMODE.TitleBar * (#self.models + 1), self.trueparent:GetTall() / 4 * 3 - (GAMEMODE.TitleBar) ) )
        self.listpanel:SetPos( 0, self.trueparent:GetTall() )
        self.listpanel.Paint = function()
            if !self.listpanel then return end
            surface.SetDrawColor( 255, 255, 255 )
            surface.DrawRect( 0, 0, self.listpanel:GetWide(), self.listpanel:GetTall() )
            surface.SetDrawColor( 0, 0, 0 )
            surface.DrawLine( 0, 0, self.listpanel:GetWide(), 0 )
            surface.DrawLine( 0, 1, self.listpanel:GetWide(), 1 )
            surface.SetTexture( GAMEMODE.GradientTexture )
            surface.SetDrawColor( 0, 0, 0, 164 )
            surface.DrawTexturedRectRotated( self.listpanel:GetWide() / 2, self.listpanel:GetTall() - 4, 8, self.listpanel:GetWide(), 90 )
        end
        
        self.trueparent.PaintOver = function( panel, w, h )
            if self.listpanel and self.listpanel:IsValid() then
                local panelx, panely = self.listpanel:GetPos()
                surface.SetTexture( GAMEMODE.GradientTexture )
                surface.SetDrawColor( 0, 0, 0, 200 )
                surface.DrawTexturedRectRotated( w / 2, panely - 6, 12, w, 90 )
            end
        end

        if !self.listpanel.scrollpanel then
            self.listpanel.scrollpanel = vgui.Create( "DScrollPanel", self.listpanel )
            self.listpanel.scrollpanel:SetPos( 0, 0 )
            self.listpanel.scrollpanel:SetSize( self.listpanel:GetWide(), self.listpanel:GetTall() )
            local sBar = self.listpanel.scrollpanel:GetVBar()
            function sBar:Paint( w, h )
                draw.RoundedBox( 4, w / 4, 16, w / 2, h - 32, Color( 66, 66, 66 ) )
                return 
            end
            function sBar.btnGrip:Paint( w, h )
                draw.RoundedBox( 4, w / 4, 0, w / 2, h, GAMEMODE.TeamColor )
            end
            sBar.btnUp.Paint = function() return end
            sBar.btnDown.Paint = function() return end
            self.listpanel.modelbuttonsnumerical = {}
            self.listpanel.modelbuttons = {}

            local order = {}
            for k, v in pairs( GAMEMODE.MyModels ) do
                if !order[ GAMEMODE.PlayerModels[ v ].collection ] then
                    order[ #order + 1 ] = {}
                    order[ GAMEMODE.PlayerModels[ v ].collection ] = #order
                end
                table.insert( order[ order[ GAMEMODE.PlayerModels[ v ].collection ] ], GAMEMODE.PlayerModels[ v ] )
            end

            local default = vgui.Create( "DButton", self.listpanel.scrollpanel )
            default:SetSize( self.listpanel.scrollpanel:GetWide(), 56 )
            default:Dock( TOP )
            default:SetText("Default")
            default.Paint = function()
                surface.SetFont( "Exo-28-600" )
                surface.SetTextColor( 0, 0, 0, 220 )
                if default.hover or self.trueparent.model == self.listpanel.selected then
                    surface.SetTextColor( GAMEMODE.TeamColor )
                end
                local w, h = surface.GetTextSize( "Default Skin" )
                surface.SetTextPos( 16, default:GetTall() / 2 - ( h / 1.5 ) )
                surface.DrawText( "Default Skin" )

                surface.SetFont( "Exo-16-500" )
                surface.SetTextColor( 0, 0, 0, 220 )
                surface.SetTextPos( default:GetTall() - 12, default:GetTall() / 2 + 8 )
                w, h = surface.GetTextSize( "Quality: " )
                surface.DrawText( "Quality: " )
                surface.SetTextColor( GAMEMODE.ColorRarities[ 0 ] )
                surface.SetTextPos( default:GetTall() - 14 + w, default:GetTall() / 2 + 8 )
                surface.DrawText( "Tier 1" )
                return true
            end
            default.OnCursorEntered = function()
                default.hover = true
            end
            default.OnCursorExited = function()
                default.hover = false
            end
            default.DoClick = function()
                self.listpanel.selected = self.trueparent.model
                surface.PlaySound( GAMEMODE.ButtonSounds.Accept[ math.random( #GAMEMODE.ButtonSounds.Accept ) ] )
            end

            for k, v in ipairs( order ) do        
                for k2, v2 in pairs( v ) do
                    local button = vgui.Create( "DButton", self.listpanel.scrollpanel )
                    button:SetSize( self.listpanel.scrollpanel:GetWide(), 56 )
                    button:Dock( TOP )
                    button.Paint = function()
                        surface.SetFont( "Exo-28-600" )
                        surface.SetTextColor( 0, 0, 0, 220 )
                        if button.hover or v2.model == self.listpanel.selected then
                            surface.SetTextColor( GAMEMODE.TeamColor )
                        end
                        local w, h = surface.GetTextSize( v2.name )
                        surface.SetTextPos( 16, button:GetTall() / 2 - ( h / 1.5 ) )
                        surface.DrawText( v2.name )

                        surface.SetFont( "Exo-16-500" )
                        surface.SetTextColor( 0, 0, 0, 220 )
                        surface.SetTextPos( button:GetTall() - 12, button:GetTall() / 2 + 8 )
                        w, h = surface.GetTextSize( "Quality: " )
                        surface.DrawText( "Quality: " )
                        surface.SetTextColor( GAMEMODE.ColorRarities[ v2.quality ] )
                        surface.SetTextPos( button:GetTall() - 14 + w, button:GetTall() / 2 + 8 )
                        surface.DrawText( "Tier ".. ( v2.quality + 1 ) )
                        return true
                    end
                    button.OnCursorEntered = function()
                        button.hover = true
                    end
                    button.OnCursorExited = function()
                        button.hover = false
                    end
                    button.DoClick = function()
                        self.listpanel.selected = v2.model
                        surface.PlaySound( GAMEMODE.ButtonSounds.Accept[ math.random( #GAMEMODE.ButtonSounds.Accept ) ] )
                    end

                    self.listpanel.modelbuttons[ v2.model ] = button
                    self.listpanel.modelbuttonsnumerical[ #self.listpanel.modelbuttonsnumerical + 1 ] = button
                end
            end
        end

        self.listpanel:MoveTo( 0, self.trueparent:GetTall() - self.listpanel:GetTall() - (GAMEMODE.TitleBar), 0.75, 0, -1, function()
            self.moving = false 
            self.extended = true
        end )
    end
end

function playermodelpanelmodels:GetMovingPanel()
    return self.listpanel
end

vgui.Register( "PlayermodelPanelModels", playermodelpanelmodels, "DButton" )

--//

local weaponskinoptions = table.Copy( basebutton )
weaponskinoptions.skins = {}
weaponskinoptions.trueparent = nil

function weaponskinoptions:SetSkins( tab )
    self.skins = tab
end

function weaponskinoptions:SetTrueParent( panel )
    self.trueparent = panel
end

function weaponskinoptions:Paint()
    surface.SetDrawColor( 255, 255, 255 )
    surface.DrawRect( 0, 0, self:GetWide(), self:GetTall() )
    surface.SetFont( "Exo-24-400" )
    local w, h = surface.GetTextSize( "Select Weapon Skin" )
    surface.SetTextPos( self:GetWide() / 2 - (w / 2), self:GetTall() / 2 - (h / 2) )
    surface.SetTextColor( 0, 0, 0, 220 )
    if self.hover then
        surface.SetTextColor( GAMEMODE.TeamColor )
    end
    surface.DrawText( "Select Weapon Skin" )

    surface.SetDrawColor( 0, 0, 0, 200 )
    surface.DrawLine( 0, -1, 0, self:GetTall() )
    return true
end

function weaponskinoptions:OnRemove()
    if self.listpanel then
        if self.listpanel.scrollpanel then
            self.listpanel.scrollpanel:Remove()
        end
        self.listpanel:Remove()
    end
end

function weaponskinoptions:DoClick()
    if #self.skins == 0 then
        surface.PlaySound( GAMEMODE.ButtonSounds.Deny[ math.random( #GAMEMODE.ButtonSounds.Deny ) ] )
        return
    end
    if self.moving then return end

    if self.extended then
        self.moving = true
        if self.listpanel.selected then
            self.trueparent:SelectSkin( self.listpanel.selected )
        end
        self.listpanel:MoveTo( 0, self.trueparent:GetTall(), 0.75, 0, -1, function()
            self.moving = false
            self.extended = false
            self.listpanel:Remove()
        end )
    else
        self.moving = true

        self.listpanel = vgui.Create( "DPanel", self.trueparent )
        self.listpanel:SetSize( self:GetWide(), math.min( GAMEMODE.TitleBar * (#self.skins + 1), self.trueparent:GetTall() / 2 - GAMEMODE.TitleBar ) )
        self.listpanel:SetPos( 0, self.trueparent:GetTall() )
        self.listpanel.Paint = function()
            if !self.listpanel then return end
            surface.SetDrawColor( 255, 255, 255 )
            surface.DrawRect( 0, 0, self.listpanel:GetWide(), self.listpanel:GetTall() )
            surface.SetDrawColor( 0, 0, 0 )
            surface.DrawLine( 0, 0, self.listpanel:GetWide(), 0 )
            surface.DrawLine( 0, 1, self.listpanel:GetWide(), 1 )
            surface.SetTexture( GAMEMODE.GradientTexture )
            surface.SetDrawColor( 0, 0, 0, 164 )
            surface.DrawTexturedRectRotated( self.listpanel:GetWide() / 2, self.listpanel:GetTall() - 4, 8, self.listpanel:GetWide(), 90 )
            surface.SetDrawColor( 66, 66, 66 )
            surface.DrawLine( 0, 0, 0, self.listpanel:GetTall() )
        end
        
        self.trueparent.PaintOver = function( panel, w, h )
            if self.listpanel and self.listpanel:IsValid() then
                local panelx, panely = self.listpanel:GetPos()
                if panely < self.trueparent:GetTall() - self:GetTall() then
                    surface.SetTexture( GAMEMODE.GradientTexture )
                    surface.SetDrawColor( 0, 0, 0, 200 )
                    surface.DrawTexturedRectRotated( w / 2, panely - 6, 12, w, 90 )
                end
            end
        end

        if !self.listpanel.scrollpanel then
            self.listpanel.scrollpanel = vgui.Create( "DScrollPanel", self.listpanel )
            self.listpanel.scrollpanel:SetPos( 0, 0 )
            self.listpanel.scrollpanel:SetSize( self.listpanel:GetWide(), self.listpanel:GetTall() )
            local sBar = self.listpanel.scrollpanel:GetVBar()
            function sBar:Paint( w, h )
                draw.RoundedBox( 4, w / 4, 16, w / 2, h - 32, Color( 66, 66, 66 ) )
                return 
            end
            function sBar.btnGrip:Paint( w, h )
                draw.RoundedBox( 4, w / 4, 0, w / 2, h, GAMEMODE.TeamColor )
            end
            sBar.btnUp.Paint = function() return end
            sBar.btnDown.Paint = function() return end

            local default = vgui.Create( "DButton", self.listpanel.scrollpanel )
            default:SetSize( self.listpanel.scrollpanel:GetWide(), 56 )
            default:Dock( TOP )
            default:SetText("")
            default.Paint = function()
                if !self.listpanel then return end
                surface.SetFont( "Exo-28-600" )
                surface.SetTextColor( 0, 0, 0, 220 )
                if default.hover or self.listpanel.selected == "" or self.trueparent.selectedskin == "" then
                    surface.SetTextColor( GAMEMODE.TeamColor )
                end
                local w, h = surface.GetTextSize( "No Skin" )
                surface.SetTextPos( 16, default:GetTall() / 2 - ( h / 1.5 ) )
                surface.DrawText( "No Skin" )

                surface.SetFont( "Exo-16-500" )
                surface.SetTextColor( 0, 0, 0, 220 )
                surface.SetTextPos( default:GetTall() - 12, default:GetTall() / 2 + 8 )
                w, h = surface.GetTextSize( "Quality: " )
                surface.DrawText( "Quality: " )
                surface.SetTextColor( GAMEMODE.ColorRarities[ 0 ] )
                surface.SetTextPos( default:GetTall() - 14 + w, default:GetTall() / 2 + 8 )
                surface.DrawText( "Tier 1" )
                return true
            end
            default.OnCursorEntered = function()
                default.hover = true
            end
            default.OnCursorExited = function()
                default.hover = false
            end
            default.DoClick = function()
                self.listpanel.selected = ""
                self.trueparent:SelectSkin( self.listpanel.selected )
                surface.PlaySound( GAMEMODE.ButtonSounds.Accept[ math.random( #GAMEMODE.ButtonSounds.Accept ) ] )
            end

            local order = {}
            for k, v in pairs( GAMEMODE.MySkins ) do
                order[ GAMEMODE.SkinsMasterTable[ v ].quality ] = order[ GAMEMODE.SkinsMasterTable[ v ].quality ] or {}
                order[ GAMEMODE.SkinsMasterTable[ v ].quality ][ #order[ GAMEMODE.SkinsMasterTable[ v ].quality ] + 1 ] = GAMEMODE.SkinsMasterTable[ v ]
            end
            
            for k, v in ipairs( order ) do
                for _, skintable in ipairs( v ) do
                    local button = vgui.Create( "DButton", self.listpanel.scrollpanel )
                    button:SetSize( self.listpanel.scrollpanel:GetWide(), 56 )
                    button:Dock( TOP )
                    button.Paint = function()
                        if !self.listpanel then return end
                        surface.SetFont( "Exo-28-600" )
                        surface.SetTextColor( 0, 0, 0, 220 )
                        if button.hover or skintable.dir == self.listpanel.selected or skintable.dir == self.trueparent.selectedskin then
                            surface.SetTextColor( GAMEMODE.TeamColor )
                        end
                        local w, h = surface.GetTextSize( skintable.name )
                        surface.SetTextPos( 16, button:GetTall() / 2 - ( h / 1.5 ) )
                        surface.DrawText( skintable.name )

                        surface.SetFont( "Exo-16-500" )
                        surface.SetTextColor( 0, 0, 0, 220 )
                        surface.SetTextPos( button:GetTall() - 12, button:GetTall() / 2 + 8 )
                        w, h = surface.GetTextSize( "Quality: " )
                        surface.DrawText( "Quality: " )
                        surface.SetTextColor( GAMEMODE.ColorRarities[ skintable.quality ] )
                        surface.SetTextPos( button:GetTall() - 14 + w, button:GetTall() / 2 + 8 )
                        surface.DrawText( "Tier ".. ( skintable.quality + 1 ) )
                        return true
                    end
                    button.OnCursorEntered = function()
                        button.hover = true
                    end
                    button.OnCursorExited = function()
                        button.hover = false
                    end
                    button.DoClick = function()
                        self.listpanel.selected = skintable.dir
                        self.trueparent:SelectSkin( self.listpanel.selected )
                        surface.PlaySound( GAMEMODE.ButtonSounds.Accept[ math.random( #GAMEMODE.ButtonSounds.Accept ) ] )
                    end
                end
            end
        end

        self:MoveToFront()

        self.listpanel:MoveTo( 0, self.trueparent:GetTall() - self.listpanel:GetTall() - (GAMEMODE.TitleBar), 0.75, 0, -1, function()
            self.moving = false 
            self.extended = true
        end )
    end
end

function weaponskinoptions:GetMovingPanel()
    return self.listpanel
end

vgui.Register( "WeaponSkinButton", weaponskinoptions, "DButton" )

--//

local primariesbutton = {}

function primariesbutton:Paint()
    surface.SetDrawColor( GAMEMODE.TeamColor )
    surface.SetMaterial( GAMEMODE.typematerials[ self.weapontable.type ] )
    surface.DrawTexturedRect( 2, 8, self:GetTall() - 16, self:GetTall() - 16 )

    surface.SetTextColor( 0, 0, 0, 220 )
    if self.hover or self.selected then
        surface.SetTextColor( GAMEMODE.TeamColor )
    end
    surface.SetFont( "Exo-24-600" )
    local w, h = surface.GetTextSize( self.display )
    surface.SetTextPos( self:GetTall() - 14, self:GetTall() / 2 - ( h / 2 ) - 2 )
    surface.DrawText( self.display )

    return true
end

--I considered allowing players to spawn w/out a primary, but that messes with my custom DModelPanel
--[[function primariesbutton:DoClick()
    if self.trueparent.selectedweapon == self.weaponclass then 
        self.trueparent:SelectWeapon()
        return 
    end
    self.trueparent:SelectWeapon( self.weaponclass, self.order )
    surface.PlaySound( GAMEMODE.ButtonSounds.Accept[ math.random( #GAMEMODE.ButtonSounds.Accept ) ] )
end]]

vgui.Register( "PrimariesButton", primariesbutton, "WeaponsShopButton" )

--//

local primariespanel = {}

function primariespanel:DoSetup()
    net.Start( "GetUnlockedWeapons" )
    net.SendToServer()

    self.scrollpanel = vgui.Create( "DScrollPanel", self )
    self.scrollpanel:SetPos( 0, 0 )
    self.scrollpanel:SetSize( self:GetWide(), self:GetTall() / 2 )
    self.scrollpanel.buttons = {}
    local sBar = self.scrollpanel:GetVBar()
    function sBar:Paint( w, h )
        draw.RoundedBox( 4, w / 4, 16, w / 2, h - 32, Color( 66, 66, 66 ) )
        return 
    end
    function sBar.btnGrip:Paint( w, h )
        draw.RoundedBox( 4, w / 4, 0, w / 2, h, GAMEMODE.TeamColor )
    end
    sBar.btnUp.Paint = function() return end
    sBar.btnDown.Paint = function() return end

    hook.Add( "ReceivedUnlockedWeapons", "PrimariesPanelPopulate", function()
        self:RepopulateList()
    end )
end

function primariespanel:RepopulateList()
    local header = vgui.Create( "DPanel", self.scrollpanel )
    header:SetSize( self.scrollpanel:GetWide(), GAMEMODE.TitleBar / 4 * 3 )
    header:Dock( TOP )
    header.Paint = function( panel, w, h )
        surface.SetFont( "Exo-32-600" )
        local tw, th = surface.GetTextSize( "Primaries" )
        surface.SetTextColor( GAMEMODE.TeamColor )
        surface.SetTextPos( w / 2 - (tw / 2), h / 2 - (th / 2) )
        surface.DrawText( "Primaries" )
        surface.SetDrawColor( GAMEMODE.TeamColor )
        surface.DrawLine( w / 2 - (tw / 2) - 4, h / 2 + (th / 2) - 2, w / 2 + (tw / 2) + 4, h / 2 + (th / 2) - 2 )
    end

    for k, v in pairs( GAMEMODE.UnlockedPrimaries ) do
        for _, weptable in pairs( v ) do
            local button = vgui.Create( "PrimariesButton", self.scrollpanel )
            button:SetSize( self.scrollpanel:GetWide(), GAMEMODE.TitleBar )
            button:Dock( TOP )
            button:SetTrueParent( self, k )
            button:SetWeapon( weptable[2] )
            self.scrollpanel.buttons[ weptable[2] ] = button
        end
        if k != #GAMEMODE.UnlockedPrimaries and #v > 0 then
            local spacer = vgui.Create( "DPanel", self.scrollpanel )
            spacer:SetSize( self.scrollpanel:GetWide(), GAMEMODE.TitleBar / 4 )
            spacer:Dock( TOP )
            spacer.Paint = function( panel, w, h )
                surface.SetDrawColor( GAMEMODE.TeamColor )
                surface.DrawLine( 4, h / 2, w - 4, h / 2 )
            end
        end
    end

    self:SelectWeapon()
end

function primariespanel:SetReferenceModelPanel( panel )
    self.modelpanel = panel
end

function primariespanel:SelectWeapon( wepclass )
    self.selectedweapon = wepclass or "cw_ar15"
    self.weaponinfo = self.weaponinfo or vgui.Create( "WeaponInfo", self )
    self.weaponinfo:SetPos( 0, self:GetTall() / 2 )
    self.weaponinfo:SetSize( self:GetWide(), self:GetTall() / 2 )
    self.weaponinfo:SetFont( "Exo-32-600" )
    self.weaponinfo:CreateStats( self.selectedweapon )

    self.skinbutton = self.skinbutton or vgui.Create( "WeaponSkinButton", self )
    self.skinbutton:SetSize( self:GetWide(), GAMEMODE.TitleBar )
    self.skinbutton:SetPos( 0, self:GetTall() - self.skinbutton:GetTall() )
    self.skinbutton:SetTrueParent( self )
    if self.possibleskins then
        self.skinbutton:SetSkins( self.possibleskins )
    end

    local wepTable = weapons.GetStored( self.selectedweapon )
    if wepTable and wepTable.WM and !wepTable.DrawTraditionalWorldModel then
        self.modelpanel:SetSpecialDraw( weapons.Get(self.selectedweapon) )
    else
        self.modelpanel:SetSpecialDraw()
    end
    self.modelpanel:SetModel( nil, RetrieveWeaponTable( self.selectedweapon )[ 4 ] )
end

function primariespanel:SelectSkin( skin )
    self.selectedskin = skin
    self.modelpanel.WeaponEntity:SetMaterial( skin )
    self.modelpanel.WeaponSkin = skin
end

function primariespanel:SetSkins( tbl )
    self.possibleskins = tbl
    if self.skinbutton then
        self.skinbutton:SetSkins( tbl )
    end
end

function primariespanel:Paint()
    surface.SetTexture( GAMEMODE.GradientTexture )
    surface.SetDrawColor( 0, 0, 0, 164 )
    surface.DrawTexturedRectRotated( self:GetWide() / 2, self:GetTall() / 2 - 4, 8, self:GetWide(), 90 )
    surface.DrawTexturedRectRotated( self:GetWide() / 2, self:GetTall() - GAMEMODE.TitleBar - 4, 8, self:GetWide(), 90 )
    return true
end

vgui.Register( "PrimariesPanel", primariespanel, "DPanel" )

--//

local secondariesbutton = {}

function secondariesbutton:Paint()
    surface.SetDrawColor( GAMEMODE.TeamColor )
    surface.SetMaterial( GAMEMODE.typematerials[ self.weapontable.type ] )
    surface.DrawTexturedRect( 2, 8, self:GetTall() - 16, self:GetTall() - 16 )

    surface.SetTextColor( 0, 0, 0, 220 )
    if self.hover or self.selected then
        surface.SetTextColor( GAMEMODE.TeamColor )
    end
    surface.SetFont( "Exo-24-600" )
    local w, h = surface.GetTextSize( self.display )
    surface.SetTextPos( self:GetTall() - 14, self:GetTall() / 2 - ( h / 2 ) - 2 )
    surface.DrawText( self.display )
    return true
end

function secondariesbutton:DoClick()
    if self.trueparent.selectedweapon == self.weaponclass then 
        self.trueparent:SelectWeapon()
        return 
    end
    self.trueparent:SelectWeapon( self.weaponclass, self.order )
    surface.PlaySound( GAMEMODE.ButtonSounds.Accept[ math.random( #GAMEMODE.ButtonSounds.Accept ) ] )
end

vgui.Register( "SecondariesButton", secondariesbutton, "WeaponsShopButton" )

--//

local secondariespanel = {}

function secondariespanel:DoSetup()
    --[[net.Start( "GetUnlockedWeapons" )
    net.SendToServer()]]

    self.scrollpanel = vgui.Create( "DScrollPanel", self )
    self.scrollpanel:SetPos( 0, 0 )
    self.scrollpanel:SetSize( self:GetWide(), self:GetTall() / 2 )
    self.scrollpanel.buttons = {}
    local sBar = self.scrollpanel:GetVBar()
    function sBar:Paint( w, h )
        draw.RoundedBox( 4, w / 4, 16, w / 2, h - 32, Color( 66, 66, 66 ) )
        return 
    end
    function sBar.btnGrip:Paint( w, h )
        draw.RoundedBox( 4, w / 4, 0, w / 2, h, GAMEMODE.TeamColor )
    end
    sBar.btnUp.Paint = function() return end
    sBar.btnDown.Paint = function() return end

    hook.Add( "ReceivedUnlockedWeapons", "SecondariesPanelPopulate", function()
        self:RepopulateList()
    end )
end

function secondariespanel:RepopulateList()
    local header = vgui.Create( "DPanel", self.scrollpanel )
    header:SetSize( self.scrollpanel:GetWide(), GAMEMODE.TitleBar / 4 * 3 )
    header:Dock( TOP )
    header.Paint = function( panel, w, h )
        surface.SetFont( "Exo-32-600" )
        local tw, th = surface.GetTextSize( "Secondaries" )
        surface.SetTextColor( GAMEMODE.TeamColor )
        surface.SetTextPos( w / 2 - (tw / 2), h / 2 - (th / 2) )
        surface.DrawText( "Secondaries" )
        surface.SetDrawColor( GAMEMODE.TeamColor )
        surface.DrawLine( w / 2 - (tw / 2) - 4, h / 2 + (th / 2) - 2, w / 2 + (tw / 2) + 4, h / 2 + (th / 2) - 2 )
    end

    for k, v in pairs( GAMEMODE.UnlockedSecondaries ) do
        for _, weptable in pairs( v ) do
            local button = vgui.Create( "SecondariesButton", self.scrollpanel )
            button:SetSize( self.scrollpanel:GetWide(), GAMEMODE.TitleBar )
            button:Dock( TOP )
            button:SetTrueParent( self, k )
            button:SetWeapon( weptable[2] )
            self.scrollpanel.buttons[ weptable[2] ] = button
        end
        if k != #GAMEMODE.UnlockedSecondaries and #v > 0 then
            local spacer = vgui.Create( "DPanel", self.scrollpanel )
            spacer:SetSize( self.scrollpanel:GetWide(), GAMEMODE.TitleBar / 4 )
            spacer:Dock( TOP )
            spacer.Paint = function( panel, w, h )
                surface.SetDrawColor( GAMEMODE.TeamColor )
                surface.DrawLine( 4, h / 2, w - 4, h / 2 )
            end
        end
    end
end

function secondariespanel:SelectWeapon( wepclass )
    if !wepclass then
        if self.weaponinfo then
            self.weaponinfo:Remove()
            self.weaponinfo = nil
        end
        self.selectedweapon = ""
        
        if self.skinbutton then
            self.skinbutton:Remove()
            self.skinbutton = nil
        end
        return
    end

    self.selectedweapon = wepclass
    self.weaponinfo = self.weaponinfo or vgui.Create( "WeaponInfo", self )
    self.weaponinfo:SetPos( 0, self:GetTall() / 2 )
    self.weaponinfo:SetSize( self:GetWide(), self:GetTall() / 2 --[[* 1.2]] )
    self.weaponinfo:SetFont( "Exo-32-600" )
    self.weaponinfo:CreateStats( self.selectedweapon )

    self.skinbutton = self.skinbutton or vgui.Create( "WeaponSkinButton", self )
    self.skinbutton:SetSize( self:GetWide(), GAMEMODE.TitleBar )
    self.skinbutton:SetPos( 0, self:GetTall() - self.skinbutton:GetTall() )
    self.skinbutton:SetTrueParent( self )
    if self.possibleskins then
        self.skinbutton:SetSkins( self.possibleskins )
    end
end

function secondariespanel:SelectSkin( skin )
    self.selectedskin = skin
end

function secondariespanel:SetSkins( tbl )
    self.possibleskins = tbl
    if self.skinbutton then
        self.skinbutton:SetSkins( tbl )
    end
end

function secondariespanel:Paint()
    surface.SetTexture( GAMEMODE.GradientTexture )
    surface.SetDrawColor( 0, 0, 0, 164 )
    surface.DrawTexturedRectRotated( self:GetWide() / 2, self:GetTall() / 2 - 4, 8, self:GetWide(), 90 )
    surface.DrawTexturedRectRotated( self:GetWide() / 2, self:GetTall() - GAMEMODE.TitleBar - 4, 8, self:GetWide(), 90 )
    return true
end

vgui.Register( "SecondariesPanel", secondariespanel, "DPanel" )

--//

local equipmentbutton = {}--table.Copy( basebutton )

function equipmentbutton:Paint()
    surface.SetDrawColor( GAMEMODE.TeamColor )
    surface.SetMaterial( GAMEMODE.typematerials[ self.weapontable.type ] )
    surface.DrawTexturedRect( 2, 8, self:GetTall() - 16, self:GetTall() - 16 )

    surface.SetTextColor( 0, 0, 0, 220 )
    if self.hover or self.selected then
        surface.SetTextColor( GAMEMODE.TeamColor )
    end
    surface.SetFont( "Exo-24-600" )
    local w, h = surface.GetTextSize( self.display )
    surface.SetTextPos( self:GetTall() - 14, self:GetTall() / 2 - ( h / 2 ) - 2 )
    surface.DrawText( self.display )
    return true
end

function equipmentbutton:DoClick()
    if self.trueparent.selectedweapon == self.weaponclass then 
        self.trueparent:SelectWeapon()
        return 
    end
    self.trueparent:SelectWeapon( self.weaponclass, self.order )
    surface.PlaySound( GAMEMODE.ButtonSounds.Accept[ math.random( #GAMEMODE.ButtonSounds.Accept ) ] )
end


vgui.Register( "EquipmentButton", equipmentbutton, "WeaponsShopButton" )

--//

local equipmentpanel = {}

function equipmentpanel:DoSetup()
    self.scrollpanel = vgui.Create( "DScrollPanel", self )
    self.scrollpanel:SetPos( 0, 0 )
    self.scrollpanel:SetSize( self:GetWide(), self:GetTall() / 2 )
    self.scrollpanel.buttons = {}
    local sBar = self.scrollpanel:GetVBar()
    function sBar:Paint( w, h )
        draw.RoundedBox( 4, w / 4, 16, w / 2, h - 32, Color( 66, 66, 66 ) )
        return 
    end
    function sBar.btnGrip:Paint( w, h )
        draw.RoundedBox( 4, w / 4, 0, w / 2, h, GAMEMODE.TeamColor )
    end
    sBar.btnUp.Paint = function() return end
    sBar.btnDown.Paint = function() return end

    hook.Add( "ReceivedUnlockedWeapons", "EquipmentPanelPopulate", function()
        self:RepopulateList()
    end )
end

function equipmentpanel:RepopulateList()
    local header = vgui.Create( "DPanel", self.scrollpanel )
    header:SetSize( self.scrollpanel:GetWide(), GAMEMODE.TitleBar / 4 * 3 )
    header:Dock( TOP )
    header.Paint = function( panel, w, h )
        surface.SetFont( "Exo-32-600" )
        local tw, th = surface.GetTextSize( "Equipment" )
        surface.SetTextColor( GAMEMODE.TeamColor )
        surface.SetTextPos( w / 2 - (tw / 2), h / 2 - (th / 2) )
        surface.DrawText( "Equipment" )
        surface.SetDrawColor( GAMEMODE.TeamColor )
        surface.DrawLine( w / 2 - (tw / 2) - 4, h / 2 + (th / 2) - 2, w / 2 + (tw / 2) + 4, h / 2 + (th / 2) - 2 )
    end

    if #GAMEMODE.UnlockedEquipment == 0 then
        local noequip = vgui.Create( "DPanel", self.scrollpanel )
        noequip:SetSize( self.scrollpanel:GetWide(), GAMEMODE.TitleBar )
        noequip:Dock( TOP )
        noequip.Paint = function()
            draw.SimpleText( "No equipment", "Exo-24-600", noequip:GetWide() / 2, noequip:GetTall() / 2, GAMEMODE.TeamColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        end
    else
        for k, v in pairs( GAMEMODE.UnlockedEquipment ) do
            for _, weptable in pairs( v ) do
                local button = vgui.Create( "EquipmentButton", self.scrollpanel )
                button:SetSize( self.scrollpanel:GetWide(), GAMEMODE.TitleBar )
                button:Dock( TOP )
                button:SetTrueParent( self, k )
                button:SetWeapon( weptable[2] )
                self.scrollpanel.buttons[ weptable[2] ] = button
            end
        end
    end
end

function equipmentpanel:SelectWeapon( wepclass )
    if !wepclass then
        if self.weaponinfo then
            self.weaponinfo:Remove()
            self.weaponinfo = nil
        end
        self.selectedweapon = ""
        return
    end

    self.selectedweapon = wepclass
    self.weptable = RetrieveWeaponTable( self.selectedweapon )
    self.wepdesc = self.weptable.desc or ""
    self.wepdisplay = self.weptable[ 1 ]
    self.descmarkup = markup.Parse( "<font=Exo-24-600><colour=88,88,88>" .. self.wepdesc .. "</colour></font>", self:GetWide() - 16 )
    self.weaponinfo = self.weaponinfo or vgui.Create( "DPanel", self )
    self.weaponinfo:SetPos( 0, self:GetTall() / 2 )
    self.weaponinfo:SetSize( self:GetWide(), self:GetTall() / 2 )
    self.weaponinfo.Paint = function()
        draw.SimpleText( self.wepdisplay, "Exo-32-600", self.weaponinfo:GetWide() / 2, 16, GAMEMODE.TeamColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        surface.SetDrawColor( 255, 255, 255 ) 
        surface.SetTextColor( 255, 255, 255 )
        self.descmarkup:Draw( self.weaponinfo:GetWide() / 2, 44, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
    end
end

function equipmentpanel:Paint()
    surface.SetTexture( GAMEMODE.GradientTexture )
    surface.SetDrawColor( 0, 0, 0, 164 )
    surface.DrawTexturedRectRotated( self:GetWide() / 2, self:GetTall() / 2 - 4, 8, self:GetWide(), 90 )
    surface.DrawTexturedRectRotated( self:GetWide() / 2, self:GetTall() - GAMEMODE.TitleBar - 4, 8, self:GetWide(), 90 )
    return true
end

vgui.Register( "EquipmentPanel", equipmentpanel, "DPanel" )

--//

local perksbutton = table.Copy( basebutton )

function perksbutton:Paint()
    if !self.startdraw then return end
    surface.SetTextColor( 0, 0, 0, 220 )
    if self.hover or self.selected then
        surface.SetTextColor( GAMEMODE.TeamColor )
    end
    surface.SetFont( "Exo-24-600" )
    local w, h = surface.GetTextSize( self.display )
    surface.SetTextPos( 12, self:GetTall() / 2 - ( h / 2 ) - 2 )
    surface.DrawText( self.display )
    return true
end

function perksbutton:DoClick()
    if self.selected then 
        self.trueparent:SelectPerk()
        return 
    end
    self.trueparent:SelectPerk( self.perktable )
    surface.PlaySound( GAMEMODE.ButtonSounds.Accept[ math.random( #GAMEMODE.ButtonSounds.Accept ) ] )
end

function perksbutton:Think()
    if self.trueparent and self.trueparent.selectedperk == self.perktable[ 2 ] then
        self.selected = true
    else
        self.selected = false
    end
end

function perksbutton:SetTrueParent( panel )
    self.trueparent = panel
end

function perksbutton:SetPerkTable( tbl )
    self.startdraw = true
    self.display = tbl[ 1 ]
    self.perktable = tbl
end

vgui.Register( "PerksButton", perksbutton, "DButton" )

--//

local perkspanel = {}

function perkspanel:DoSetup()
    net.Start( "GetUnlockedPerks" )
    net.SendToServer()

    --Because perks aren't sent to the client (even though they could be...) this is ran and handled differently from the weapons
    net.Receive( "GetUnlockedPerksCallback", function()
        GAMEMODE.Perks = net.ReadTable()
        self:RepopulateList()
    end )

    self.scrollpanel = vgui.Create( "DScrollPanel", self )
    self.scrollpanel:SetPos( 0, 0 )
    self.scrollpanel:SetSize( self:GetWide(), self:GetTall() / 2 )
    self.scrollpanel.buttons = {}
    local sBar = self.scrollpanel:GetVBar()
    function sBar:Paint( w, h )
        draw.RoundedBox( 4, w / 4, 16, w / 2, h - 32, Color( 66, 66, 66 ) )
        return 
    end
    function sBar.btnGrip:Paint( w, h )
        draw.RoundedBox( 4, w / 4, 0, w / 2, h, GAMEMODE.TeamColor )
    end
    sBar.btnUp.Paint = function() return end
    sBar.btnDown.Paint = function() return end

    function GetPerkTable( perkid )
        if !GAMEMODE.Perks then return end

        for k, v in pairs( GAMEMODE.Perks ) do
            if perkid == v[2] then
                return v
            end
        end
        for k, v in pairs( GAMEMODE.Perks.locked ) do
            if perkid == v[2] then
                return v
            end
        end

        return false
    end
end

function perkspanel:RepopulateList()
    local header = vgui.Create( "DPanel", self.scrollpanel )
    header:SetSize( self.scrollpanel:GetWide(), GAMEMODE.TitleBar / 4 * 3 )
    header:Dock( TOP )
    header.Paint = function( panel, w, h )
        surface.SetFont( "Exo-32-600" )
        local tw, th = surface.GetTextSize( "Perks" )
        surface.SetTextColor( GAMEMODE.TeamColor )
        surface.SetTextPos( w / 2 - (tw / 2), h / 2 - (th / 2) )
        surface.DrawText( "Perks" )
        surface.SetDrawColor( GAMEMODE.TeamColor )
        surface.DrawLine( w / 2 - (tw / 2) - 4, h / 2 + (th / 2) - 2, w / 2 + (tw / 2) + 4, h / 2 + (th / 2) - 2 )
    end

    for _, perktable in ipairs( GAMEMODE.Perks ) do
        local button = vgui.Create( "PerksButton", self.scrollpanel )
        button:SetSize( self.scrollpanel:GetWide(), GAMEMODE.TitleBar )
        button:Dock( TOP )
        button:SetTrueParent( self )
        button:SetPerkTable( perktable )
        self.scrollpanel.buttons[ perktable[2] ] = button
    end
    for _, perktable in ipairs( GAMEMODE.Perks.locked ) do
        local locked = vgui.Create( "DPanel", self.scrollpanel )
        locked:SetSize( self.scrollpanel:GetWide(), GAMEMODE.TitleBar )
        locked:Dock( TOP )
        locked.Paint = function( panel )
            if !locked then return end
            surface.SetTextColor( 0, 0, 0, 220 )
            surface.SetFont( "Exo-24-600" )
            local w, h = surface.GetTextSize( perktable[ 1 ] )
            surface.SetTextPos( 12, panel:GetTall() / 2 - ( h / 2 ) - 2 )
            surface.DrawText( perktable[ 1 ] )

            surface.SetFont( "Exo-16-500" )
            surface.SetTextColor( colorScheme[1].TeamColor )
            surface.SetTextPos( 24, panel:GetTall() / 2 + ( h / 2 ) - 4 )
            surface.DrawText( "Unlocks at Level " .. perktable[ 3 ] )
            return true
        end
    end
end

function perkspanel:SelectPerk( perktable )
    if !perktable then
        if self.weaponinfo then
            self.weaponinfo:Remove()
            self.weaponinfo = nil
        end
        self.selectedperk = ""
        return
    end

    self.selectedperk = perktable[ 2 ]
    self.wepdesc = perktable[ 4 ] or ""
    self.wepdisplay = perktable[ 1 ]
    self.descmarkup = markup.Parse( "<font=Exo-24-600><colour=88,88,88>" .. self.wepdesc .. "</colour></font>", self:GetWide() - 16 )
    self.weaponinfo = self.weaponinfo or vgui.Create( "DPanel", self )
    self.weaponinfo:SetPos( 0, self:GetTall() / 2 )
    self.weaponinfo:SetSize( self:GetWide(), self:GetTall() / 2 - GAMEMODE.TitleBar )
    self.weaponinfo.Paint = function()
        draw.SimpleText( self.wepdisplay, "Exo-32-600", self.weaponinfo:GetWide() / 2, 16, GAMEMODE.TeamColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        self.descmarkup:Draw( self.weaponinfo:GetWide() / 2, 44, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
    end
end

function perkspanel:Paint()
    surface.SetTexture( GAMEMODE.GradientTexture )
    surface.SetDrawColor( 0, 0, 0, 164 )
    surface.DrawTexturedRectRotated( self:GetWide() / 2, self:GetTall() / 2 - 4, 8, self:GetWide(), 90 )
    return true
end

vgui.Register( "PerksPanel", perkspanel, "DPanel" )

--//

net.Receive( "GetUnlockedWeaponsCallback", function()
    GAMEMODE.UnlockedWeapons = net.ReadTable()
    GAMEMODE.UnlockedPrimaries = { {}, {}, {}, {}, {} }
    GAMEMODE.UnlockedSecondaries = { {}, {}, {}, {}, {}, {}, {} }
    GAMEMODE.UnlockedEquipment = {}
    
    local typetoint = { ar = 1, smg = 2, sg = 3, sr = 4, lmg = 5, pt = 6, mn = 7, eq = 8 }
    for k, v in pairs( GAMEMODE.UnlockedWeapons ) do
        if GAMEMODE.WeaponsList[ v ].slot == 1 then
            --GAMEMODE.UnlockedPrimaries[ typetoint[GAMEMODE.WeaponsList[ v ].type] ] = GAMEMODE.UnlockedPrimaries[ typetoint[GAMEMODE.WeaponsList[ v ].type] ] or {}
            table.insert( GAMEMODE.UnlockedPrimaries[ typetoint[GAMEMODE.WeaponsList[ v ].type] ], GAMEMODE.WeaponsList[ v ] )
        end
        if GAMEMODE.WeaponsList[ v ].slot == 2 then
            --GAMEMODE.UnlockedSecondaries[ typetoint[GAMEMODE.WeaponsList[ v ].type] ] = GAMEMODE.UnlockedSecondaries[ typetoint[GAMEMODE.WeaponsList[ v ].type] ] or {}
            table.insert( GAMEMODE.UnlockedSecondaries[ typetoint[GAMEMODE.WeaponsList[ v ].type] ], GAMEMODE.WeaponsList[ v ] )
        end
        if GAMEMODE.WeaponsList[ v ].slot == 3 then
            GAMEMODE.UnlockedEquipment[ typetoint[GAMEMODE.WeaponsList[ v ].type] ] = GAMEMODE.UnlockedEquipment[ typetoint[GAMEMODE.WeaponsList[ v ].type] ] or {}
            table.insert( GAMEMODE.UnlockedEquipment[ typetoint[GAMEMODE.WeaponsList[ v ].type] ], GAMEMODE.WeaponsList[ v ] )
        end
    end
    hook.Run( "ReceivedUnlockedWeapons" )
end )