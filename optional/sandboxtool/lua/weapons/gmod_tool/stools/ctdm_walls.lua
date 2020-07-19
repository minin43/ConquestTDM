AddCSLuaFile()

if !game.SinglePlayer() then return end

if CLIENT then
    language.Add( "tool.ctdm_walls.name", "CTDM Wall Setup" )
    language.Add( "tool.ctdm_walls.desc", "Used to spawn invisible walls for CTDM servers" )
    language.Add( "Tool.ctdm_walls.0", "Primary: Mark corners   Secondary: Delete a created wall   Reload: Undo previous marking" )
	--language.Add( "Tool.ctdm_walls.set", "Weight:" )
	language.Add( "Tool.ctdm_walls.set_desc", "Walls" )
end

TOOL.Category = "ConquestTDM"
TOOL.Name = "#tool.ctdm_walls.name"

if SERVER then
    if engine.ActiveGamemode() != "sandbox" then return end

    util.AddNetworkString( "UpdateWallInfo" )
    util.AddNetworkString( "DeleteWallValues" )
    util.AddNetworkString( "EditWall" )
    util.AddNetworkString( "SaveWall" )

    TOOL.Marked = TOOL.Marked or {}
    TOOL.Marked.Walls = TOOL.Marked.Walls or {}
    --This tool uses ctdm_props's backend

    net.Receive( "SaveWall", function( len, ply )
        local myTool = ply:GetWeapon( "gmod_tool" ).Tool["ctdm_walls"]
        local cornerOne = net.ReadVector()
        local cornerTwo = net.ReadVector()

        myTool:ClearWallValues()

        local wall = ents.Create( "ctdm_invis_wall" )
        if wall then
            wall:SetPos( cornerOne )
            --wall:SetMinBound( cornerOne ) -- Just the position for now
            wall:SetMaxBound( cornerTwo )
            wall:Spawn()
            wall:PhysicsInitBox( Vector(0,0,0), cornerTwo - cornerOne )

            local phys = wall:GetPhysicsObject()
            if IsValid( phys ) then
                phys:EnableMotion( false )
            end

            myTool.Marked.Walls[ wall ] = {vec1 = cornerOne, vec2 = cornerTwo}
        end
    end )
end

function TOOL:Init()
    if ( CLIENT ) then return true end

end

function TOOL:UpdateSpawnPos( which, vec, ply )
    net.Start( "UpdateSpawnPosition" )
        net.WriteInt( self:GetClientInfo( "team" ), 3 )
        net.WriteInt( which, 3 )
        net.WriteVector( vec )
    net.Send( ply )
end

function TOOL:Think()
    if CLIENT then
        if LocalPlayer():GetActiveWeapon() == LocalPlayer():GetWeapon( "gmod_tool" ) then
            LocalPlayer():GetActiveWeapon().Tool["ctdm_walls"].IsHeld = true
        end
    end
end

function TOOL:UpdateWall( stage, vector )
    net.Start( "UpdateWallInfo" )
        net.WriteInt( stage, 4 )
        net.WriteVector( vector )
    net.Send( self:GetOwner() )
end

function TOOL:LeftClick( trace )
    if !trace.HitPos then return false end
    if ( CLIENT ) then return true end

    self.StartedWallPlacement = true
    local ply = self:GetOwner()
    self.posOne = self.posOne
    self.posTwo = self.posTwo
    self.wallTall = self.wallTall

    if !self.posOne then
        ply:ChatPrint( "Corner one placed - click again to place corner two" )
        self.posOne = trace.HitPos
        self:UpdateWall( 1, self.posOne )
    elseif !self.posTwo then
        ply:ChatPrint( "Corner two placed - click again to set wall height" )
        self.posTwo = trace.HitPos
        self:UpdateWall( 2, self.posTwo )
    elseif !self.wallTall then
        ply:ChatPrint( "Wall height set - click again to review the values" )
        self.wallTall = trace.HitPos
        self:UpdateWall( 3, self.wallTall )
    else
        net.Start( "EditWall" )
        net.Send( ply )
    end

    self.Weapon:EmitSound( Sound( "Airboat.FireGunRevDown" ) )
    self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
    
    local effectdata = EffectData()
		effectdata:SetOrigin( trace.HitPos )
		effectdata:SetNormal( trace.HitNormal )
		effectdata:SetEntity( trace.Entity )
		effectdata:SetAttachment( trace.PhysicsBone )
	util.Effect( "selection_indicator", effectdata )	
	
	local effectdata = EffectData()
		effectdata:SetOrigin( trace.HitPos )
		effectdata:SetStart( self:GetOwner():GetShootPos() )
		effectdata:SetAttachment( 1 )
		effectdata:SetEntity( self.Weapon )
	util.Effect( "ToolTracer", effectdata )
end

--Deletes any placed walls
function TOOL:RightClick( trace )
    if ( CLIENT ) then return true end

    local walls = ents.FindInSphere( trace.HitPos, 5 )
    for k, v in pairs( walls ) do
        if v:GetClass() == "ctdm_invis_wall" then 
            v:Remove() 
            self.Marked.Walls[ v ] = nil
        end
    end
        
    self.Weapon:EmitSound( Sound( "Airboat.FireGunRevDown" ) )
    self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
    
    local effectdata = EffectData()
		effectdata:SetOrigin( trace.HitPos )
		effectdata:SetNormal( trace.HitNormal )
		effectdata:SetEntity( trace.Entity )
		effectdata:SetAttachment( trace.PhysicsBone )
	util.Effect( "selection_indicator", effectdata )	
	
	local effectdata = EffectData()
		effectdata:SetOrigin( trace.HitPos )
		effectdata:SetStart( self:GetOwner():GetShootPos() )
		effectdata:SetAttachment( 1 )
		effectdata:SetEntity( self.Weapon )
	util.Effect( "ToolTracer", effectdata )
end

--Removes the last placement
function TOOL:Reload( trace )
    if ( CLIENT ) then return true end
    local ply = self:GetOwner()

    if self.StartedWallPlacement then
        if self.wallTall then
            self.wallTall = nil
            ply:ChatPrint( "Undone wall height" )
            self:UpdateWall( 3, Vector(0, 0, 0) )
        elseif self.posTwo then
            self.posTwo = nil
            ply:ChatPrint( "Undone corner two placement" )
            self:UpdateWall( 2, Vector(0, 0, 0) )
        elseif self.posOne then
            self.posOne = nil
            self.StartedWallPlacement = false
            ply:ChatPrint( "Undone corner one placement" )
            net.Start( "DeleteWallValues" )
            net.Send( ply )
        end

        self.Weapon:EmitSound( Sound( "Airboat.FireGunRevDown" ) )
        self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
        
        local effectdata = EffectData()
            effectdata:SetOrigin( trace.HitPos )
            effectdata:SetNormal( trace.HitNormal )
            effectdata:SetEntity( trace.Entity )
            effectdata:SetAttachment( trace.PhysicsBone )
        util.Effect( "selection_indicator", effectdata )	
        
        local effectdata = EffectData()
            effectdata:SetOrigin( trace.HitPos )
            effectdata:SetStart( self:GetOwner():GetShootPos() )
            effectdata:SetAttachment( 1 )
            effectdata:SetEntity( self.Weapon )
        util.Effect( "ToolTracer", effectdata )
    end
end

function TOOL:ClearWallValues()
    if SERVER then
        self.StartedWallPlacement = false
        self.posOne = nil
        self.posTwo = nil
        self.wallTall = nil
    else
        self.tempVec = nil
        self.tempVec2 = nil
        self.tempVecBackup = nil
        self.tempVec2Backup = nil
        self.tempVecSep = nil
        self.tempVec2Sep = nil
        self.tempHeight = nil
        self.tempHeightBackup = nil
    end
end

function TOOL:Holster()
    self:ClearWallValues()
    self.IsHeld = false
end

function TOOL.BuildCPanel( CPanel )
    CPanel:AddControl( "Header", { Description = "#tool.ctdm_walls.name" } )

    local info = vgui.Create( "DLabel", CPanel )
    info:Dock( TOP )
    info:SetTall( 50 )
    info:DockMargin( 10, 22, 10, 22 )
    info:SetTextColor( Color( 0, 0, 0, 200 ) )
    info:SetText( "Invisible walls utilize the CTDM Prop Setup\ntool's backend, and as such, are loaded and\nsaved with its buttons, and not\nanything here." )
end

if CLIENT then
    local myTool = TOOL
    myTool.WallTable = myTool.WallTable or {}

    function ConfirmWall()
        if myTool.main then return end

        myTool.main = vgui.Create( "DFrame" )
        myTool.main:SetSize( 400, 170 )
        myTool.main:SetTitle( "Approve, Edit, or Reject Wall Points" )
        myTool.main:SetVisible( true )
        myTool.main:SetDraggable( false )
        myTool.main:ShowCloseButton( false )
        myTool.main:MakePopup()
        myTool.main:Center()

        local propertiesBuffer = 20
        local titleBuffer = 20
        local buttonWide = myTool.main:GetWide() / 4
        local buttonTall = 20

        myTool.cornerOne = vgui.Create( "DProperties", myTool.main )
        myTool.cornerOne:SetPos( propertiesBuffer, propertiesBuffer + titleBuffer )
        myTool.cornerOne:SetSize( myTool.main:GetWide() / 2 - propertiesBuffer - ( propertiesBuffer / 2 ), myTool.main:GetTall() )

        myTool.coX = myTool.cornerOne:CreateRow( "First Base Corner", "X Coord" )
        myTool.coX:Setup( "Integer" )
        myTool.coX:SetValue( myTool.tempVec.x )
        myTool.coX.DataChanged = function( self, data )
            myTool.tempVecSep.x = data
        end

        myTool.coY = myTool.cornerOne:CreateRow( "First Base Corner", "Y Coord" )
        myTool.coY:Setup( "Integer" )
        myTool.coY:SetValue( myTool.tempVec.y )
        myTool.coY.DataChanged = function( self, data )
            myTool.tempVecSep.y = data
        end

        myTool.coZ = myTool.cornerOne:CreateRow( "First Base Corner", "Z Coord" )
        myTool.coZ:Setup( "Integer" )
        myTool.coZ:SetValue( myTool.tempVec.z )
        myTool.coZ.DataChanged = function( self, data )
            myTool.tempVecSep.z = data
        end

        myTool.cornerTwo = vgui.Create( "DProperties", myTool.main )
        myTool.cornerTwo:SetPos( myTool.main:GetWide() / 2 + ( propertiesBuffer / 2 ), propertiesBuffer + titleBuffer )
        myTool.cornerTwo:SetSize( myTool.main:GetWide() / 2 - titleBuffer - ( titleBuffer / 2 ), myTool.main:GetTall() )

        myTool.ctX = myTool.cornerTwo:CreateRow( "Second Base Corner", "X Coord" )
        myTool.ctX:Setup( "Integer" )
        myTool.ctX:SetValue( myTool.tempVec2.x )
        myTool.ctX.DataChanged = function( self, data )
            myTool.tempVec2Sep.x = data
        end

        myTool.ctY = myTool.cornerTwo:CreateRow( "Second Base Corner", "Y Coord" )
        myTool.ctY:Setup( "Integer" )
        myTool.ctY:SetValue( myTool.tempVec2.y )
        myTool.ctY.DataChanged = function( self, data )
            myTool.tempVec2Sep.y = data
        end

        myTool.wallH = myTool.cornerTwo:CreateRow( "Second Base Corner", "Wall Height" )
        myTool.wallH:Setup( "Integer" )
        myTool.wallH:SetValue( myTool.tempHeight.z - myTool.tempVec.z )
        myTool.wallH.DataChanged = function( self, data )
            if data == "" then data = 0 end
            myTool.tempHeight.z = math.max( myTool.tempVec.z + data, myTool.tempVec.z )
        end

        myTool.accept = vgui.Create( "DButton", myTool.main )
        myTool.accept:SetSize( buttonWide, buttonTall )
        myTool.accept:SetPos( myTool.main:GetWide() / 4 - ( buttonWide / 2 ), myTool.main:GetTall() - buttonTall - ( buttonTall / 2 ) )
        myTool.accept:SetText( "Accept & Close" )
        myTool.accept.DoClick = function()
            myTool.tempVec = Vector( myTool.tempVecSep.x, myTool.tempVecSep.y, myTool.tempVecSep.z )
            myTool.tempVec2 = Vector( myTool.tempVec2Sep.x, myTool.tempVec2Sep.y, myTool.tempHeight.z )

            net.Start( "SaveWall" )
                net.WriteVector( myTool.tempVec )
                net.WriteVector( Vector( myTool.tempVec2.x, myTool.tempVec2.y, myTool.tempHeight.z --[[- myTool.tempVec.z]] ) )
            net.SendToServer()

            --LocalPlayer():GetWeapon( "gmod_tool" ).Tool["ctdm_walls"]:ClearWallValues()
            myTool:ClearWallValues()
            myTool.main:Remove()
            myTool.main = nil
        end

        myTool.preview = vgui.Create( "DButton", myTool.main )
        myTool.preview:SetSize( buttonWide, buttonTall  )
        myTool.preview:SetPos( myTool.main:GetWide() / 4 * 2 - ( buttonWide / 2 ), myTool.main:GetTall() - buttonTall - ( buttonTall / 2 ) )
        myTool.preview:SetText( "Close & Preview" )
        myTool.preview.DoClick = function()
            myTool.tempVec = Vector( myTool.tempVecSep.x, myTool.tempVecSep.y, myTool.tempVecSep.z )
            myTool.tempVec2 = Vector( myTool.tempVec2Sep.x, myTool.tempVec2Sep.y, myTool.tempVecSep.z ) --Done intentionally
            --myTool.tempHeight = myTool.tempHeight

            myTool.main:Remove()
            myTool.main = nil
            LocalPlayer():ChatPrint( "Click again to re-open the menu, or press R to remove corners" )
        end

        myTool.default = vgui.Create( "DButton", myTool.main )
        myTool.default:SetSize( buttonWide, buttonTall  )
        myTool.default:SetPos( myTool.main:GetWide() / 4 * 3 - ( buttonWide / 2 ), myTool.main:GetTall() - buttonTall - ( buttonTall / 2 ) )
        myTool.default:SetText( "Reset Values" )
        myTool.default.DoClick = function()
            myTool.tempVec = myTool.tempVecBackup
            myTool.tempVec2 = myTool.tempVec2Backup
            myTool.tempHeight.z = myTool.tempHeightBackup.z

            myTool.main:Close()
            myTool.main = nil
            ConfirmWall()
        end
    end

    net.Receive( "UpdateWallInfo", function()
        local stage = net.ReadInt( 4 )
        local vector = net.ReadVector()

        if stage == 1 then
            myTool.tempVec = vector
            myTool.tempVecBackup = myTool.tempVec
            myTool.tempVecSep = { x = myTool.tempVec.x, y = myTool.tempVec.y, z = myTool.tempVec.z }
            if myTool.tempVec == Vector( 0, 0, 0 ) then
                myTool.tempVec = nil
            end
        elseif stage == 2 then
            myTool.tempVec2 = vector
            myTool.tempVec2Backup = myTool.tempVec2
            myTool.tempVec2Sep = { x = myTool.tempVec2.x, y = myTool.tempVec2.y, z = myTool.tempVec.z }
            if myTool.tempVec2 == Vector( 0, 0, 0 ) then
                myTool.tempVec2 = nil
            end
        else
            myTool.tempHeight = vector
            myTool.tempHeightBackup = myTool.tempHeight
            if myTool.tempHeight == Vector( 0, 0, 0 ) then
                myTool.tempHeight = nil
                myTool.tempHeightBackup = nil
            end
        end
    end )

    net.Receive( "DeleteWallValues", function()
        myTool:ClearWallValues()
        --LocalPlayer():GetWeapon( "gmod_tool" ).Tool["ctdm_walls"]:ClearWallValues()
    end )

    net.Receive( "EditWall", function()
        ConfirmWall()
    end )

    hook.Add( "PostDrawOpaqueRenderables", "DrawWalls", function()
        if !LocalPlayer():Alive() or !LocalPlayer():GetWeapon( "gmod_tool" ).Tool then return end
        if not myTool or not LocalPlayer():GetWeapon( "gmod_tool" ).Tool["ctdm_walls"] then return end

        --//Draw wall creation
        local colormat = Material("color")
        local white = Color(255,150,0,30)
        if myTool.tempVec then
            cam.Start3D()
                render.SetMaterial(colormat)
                local x = myTool.tempVec
                local y
                if myTool.tempVec2 then
                    if myTool.tempHeight then
                        y = Vector(myTool.tempVec2.x - myTool.tempVec.x, myTool.tempVec2.y - myTool.tempVec.y, myTool.tempHeight.z - myTool.tempVec.z) --Displaying demo
                    else
                        y = Vector(myTool.tempVec2.x - myTool.tempVec.x, myTool.tempVec2.y - myTool.tempVec.y, LocalPlayer():GetEyeTrace().HitPos.z - myTool.tempVec.z) --Setting height
                    end
                else
                    y = Vector(LocalPlayer():GetEyeTrace().HitPos.x - myTool.tempVec.x, LocalPlayer():GetEyeTrace().HitPos.y - myTool.tempVec.y, 0) --Setting 2nd point
                end

                if x and y then
                    render.DrawBox(x, Angle(0,0,0), Vector(0,0,0), y, white, true)
                end
            cam.End3D()
        end
    end )
end