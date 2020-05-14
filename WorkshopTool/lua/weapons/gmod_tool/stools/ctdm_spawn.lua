AddCSLuaFile()

if !game.SinglePlayer() then return end

if CLIENT then
    language.Add( "tool.ctdm_spawn.name", "CTDM Spawner" )
    language.Add( "tool.ctdm_spawn.desc", "Used to place & save spawn & flag zones for CTDM servers" )
    language.Add( "Tool.ctdm_spawn.0", "Primary: Spawner   Secondary: Flag   Reload: Reset" )
	--language.Add( "Tool.ctdm_spawn.set", "Weight:" )
	language.Add( "Tool.ctdm_spawn.set_desc", "Set spawns" )
end

TOOL.Category = "ConquestTDM"
TOOL.Name = "#tool.ctdm_spawn.name"
TOOL.ClientConVar[ "team" ] = 1 --1 is red team, 2 is blue team
TOOL.ClientConVar[ "write_to_disc" ] = "false"
TOOL.SpawnTable = {}
TOOL.FlagTable = {}

if SERVER then
    if engine.ActiveGamemode() != "sandbox" then return end

    util.AddNetworkString( "UpdateSpawnPosition" )
    util.AddNetworkString( "UpdateFlagPosition" )
    util.AddNetworkString( "ReviewValues" )
    util.AddNetworkString( "DeleteClientValues" )
    util.AddNetworkString( "SaveValues" )
    util.AddNetworkString( "StartingValues" )
    util.AddNetworkString( "ServerSaveToDisc" )
    --util.AddNetworkString( "RunServerInitDipshit" )
    util.AddNetworkString( "DeleteSpawn" )
    util.AddNetworkString( "DeleteFlag" )
    util.AddNetworkString( "UpdateSpawnerValue" )
    util.AddNetworkString( "UpdateFlagValue" )

    net.Receive( "SaveValues", function( len, ply )
        local myTool = ply:GetWeapon( "gmod_tool" ).Tool["ctdm_spawn"]

        local which = net.ReadInt( 3 )
        if which == 1 then
            team = net.ReadInt( 3 )
            posOne = net.ReadVector()
            posTwo = net.ReadVector()
            id = net.ReadString()
            table.insert( myTool.SpawnTable, { team, posOne, posTwo, id } )
        else
            flagLetter = net.ReadString()
            posOne = net.ReadVector()
            flagSize = net.ReadInt( 16 )
            id = net.ReadString()
            table.insert( myTool.FlagTable, { flagLetter, posOne, flagSize, 0, id } )
        end

        net.Start( "DeleteClientValues" )
        net.Send( ply )

        myTool:ClearValues()
    end )

    net.Receive( "ServerSaveToDisc", function( len, ply )
        local myTool = ply:GetWeapon( "gmod_tool" ).Tool["ctdm_spawn"]

        local str = ""
        for k, v in pairs( myTool.SpawnTable ) do
            str = str .. util.TableToJSON( v ) .. "\n"
        end
        for k, v in pairs( myTool.FlagTable ) do
            str = str .. util.TableToJSON( v ) .. "\n"
        end

        file.Write( "tdm/tool/" .. game.GetMap() .. ".txt", str )
    end )

    net.Receive( "DeleteSpawn", function( len, ply )
        local myTool = ply:GetWeapon( "gmod_tool" ).Tool["ctdm_spawn"]
        local toDelete = net.ReadInt( 8 )
        
        table.remove( myTool.SpawnTable, toDelete )
    end )

    net.Receive( "DeleteFlag", function( len, ply )
        local myTool = ply:GetWeapon( "gmod_tool" ).Tool["ctdm_spawn"]
        local toDelete = net.ReadInt( 8 )
        
        table.remove( myTool.FlagTable, toDelete )
    end )

    net.Receive( "UpdateSpawnerValue", function( len, ply )
        local myTool = ply:GetWeapon( "gmod_tool" ).Tool["ctdm_spawn"]
        local toUpdate = net.ReadInt( 8 )
        local newVec1 = net.ReadVector()
        local newVec2 = net.ReadVector()
        local newID = net.ReadString()

        myTool.SpawnTable[toUpdate] = {myTool.SpawnTable[toUpdate][1], newVec1, newVec2, newID }
    end )

    net.Receive( "UpdateFlagValue", function( len, ply )
        local myTool = ply:GetWeapon( "gmod_tool" ).Tool["ctdm_spawn"]
        local toUpdate = net.ReadInt( 8 )
        local newVec = net.ReadVector()
        local newRad = net.ReadInt( 16 )
        local newLet = net.ReadString()
        local newID = net.ReadString()

        myTool.FlagTable[toUpdate] = { newLet, newVec, newRad, 0, newID }
    end )
end

function TOOL:Init()
    if SERVER then
        if not file.Exists( "tdm", "DATA" ) then
            file.CreateDir( "tdm" )
        end

        if not file.Exists( "tdm/tool", "DATA" ) then
            file.CreateDir( "tdm/tool" )
        end
    
        if not file.Exists( "tdm/tool/" .. game.GetMap() .. ".txt", "DATA" ) then
            file.Write( "tdm/tool/" .. game.GetMap() .. ".txt" )
        else
            self.MapFile = file.Read( "tdm/tool/" .. game.GetMap() .. ".txt", "DATA")
            self.MapExtract = string.Explode( "\n", self.MapFile )

            for k, v in pairs( self.MapExtract ) do
                local val = util.JSONToTable( v )
                if val and tonumber( val[1] ) then --it's a spawn
                    table.insert( self.SpawnTable, { tonumber( val[1] ), val[2], val[3], val[4] or "" } )
                elseif val then --it's a flag
                    table.insert( self.FlagTable, { val[1], val[2], val[3], tonumber( val[4] ), 0, val[6] or "" } )
                end
            end

            net.Start( "StartingValues" )
                net.WriteTable( self.FlagTable )
                net.WriteTable( self.SpawnTable )
            net.Send( player.GetAll()[1] )
        end
    end
end

function TOOL:UpdateSpawnPos( which, vec, ply )
    net.Start( "UpdateSpawnPosition" )
        net.WriteInt( self:GetClientInfo( "team" ), 3 )
        net.WriteInt( which, 3 )
        net.WriteVector( vec )
    net.Send( ply )
end

function TOOL:UpdateFlagPos( which, val, ply )
    net.Start( "UpdateFlagPosition" )
        net.WriteInt( which, 3 )
        if isvector( val ) then
            net.WriteVector( val )
        else
            net.WriteInt( val, 16 )
        end
    net.Send( ply )
end

function TOOL:Think()
    if CLIENT then
        if LocalPlayer():GetActiveWeapon() == LocalPlayer():GetWeapon( "gmod_tool" ) then--== ply:GetWeapon( "gmod_tool" ).Tool["ctdm_spawn"] then
            LocalPlayer():GetActiveWeapon().Tool["ctdm_spawn"].IsHeld = true
        end
    end
end

function TOOL:LeftClick( trace )
    if !trace.HitPos or ( IsValid( trace.Entity ) and !trace.Entity:IsWorld() ) then return false end --Has to be the ground
    if ( CLIENT ) then return true end
    
    if self.StartedFlagPlacement then return end

    if !self.StartedSpawnPlacement then
        self.StartedSpawnPlacement = true
    end

    local ply = self:GetOwner()

    self.PosOne = self.PosOne
    self.PosTwo = self.PosTwo

    if self.PosOne == nil then
        self.PosOne = trace.HitPos
        ply:ChatPrint( "Point one placed - click again to place point two" )
        self:UpdateSpawnPos( 1, self.PosOne, ply )
    elseif self.PosTwo == nil then
        self.PosTwo = trace.HitPos
        ply:ChatPrint( "Point two placed - click again to review the values" )
        self:UpdateSpawnPos( 2, self.PosTwo, ply )
    else
        net.Start( "ReviewValues" )
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

function TOOL:RightClick( trace )
    if !trace.HitPos or ( IsValid( trace.Entity ) and !trace.Entity:IsWorld() ) then return false end --Has to be the ground
    if ( CLIENT ) then return true end

    if self.StartedSpawnPlacement then return end
    
    if !self.StartedFlagPlacement then
        self.StartedFlagPlacement = true
    end

    local ply = self:GetOwner()

    self.FlagPos = self.FlagPos
    self.FlagSize = self.FlagSize
    
    if !self.FlagPos then
        self.FlagPos = trace.HitPos
        ply:ChatPrint( "Flag position placed - click again to set flag interaction size" )
        self:UpdateFlagPos( 1, self.FlagPos, ply )
    elseif !self.FlagSize then
        self.FlagSize = math.abs( math.Distance( self.FlagPos.x, self.FlagPos.y, trace.HitPos.x, trace.HitPos.y ) )
        ply:ChatPrint( "Flag interaction size taken - click again to review the values" )
        self:UpdateFlagPos( 2, self.FlagSize, ply )
    else
        net.Start( "ReviewValues" )
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

function TOOL:ClearValues()
    if SERVER then
        self.PosOne = nil
        self.PosTwo = nil
        self.SpawnerID = nil
        self.StartedSpawnPlacement = false
        self.FlagPos = nil
        self.FlagSize = nil
        self.FlagID = nil
        self.StartedFlagPlacement = false
    elseif CLIENT then
        self.PosOne = nil
        self.PosTwo = nil
        self.SpawnerID = nil
        self.FlagPos = nil
        self.FlagSize = nil
        self.FlagID = nil
    end
end

--//Suppose this'll need to run disables on the 3D2D drawing on client
function TOOL:Holster()
    self:ClearValues()
    self.IsHeld = false
end

--//Undoes the last action - spawn placement or flag placement
function TOOL:Reload( trace )
    local ply = self:GetOwner()

    if self.StartedSpawnPlacement then
        if self.PosTwo then
            self.PosTwo = nil
            ply:ChatPrint( "Undid point two placement" )
        elseif self.PosOne then
            self.PosOne = nil
            self.StartedSpawnPlacement = false
            ply:ChatPrint( "Undid point one placement" )
            net.Start( "DeleteClientValues" )
            net.Send( ply )
        end
    elseif self.StartedFlagPlacement then
        if self.FlagSize then
            self.FlagSize = nil
            ply:ChatPrint( "Undid flag size" )
        elseif self.FlagPos then
            self.FlagPos = nil
            self.StartedFlagPlacement = false
            ply:ChatPrint( "Undid flag position" )
            net.Start( "DeleteClientValues" )
            net.Send( ply )
        end
    else
        return
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

function TOOL.BuildCPanel( CPanel )
    local TOOL = LocalPlayer():GetWeapon( "gmod_tool" ).Tool["ctdm_spawn"]
    print( TOOL, LocalPlayer():GetWeapon( "gmod_tool" ), LocalPlayer():GetWeapon( "gmod_tool" ).Tool )
    CPanel:AddControl( "Header", { Description = "#tool.ctdm_spawn.name" } )
    CPanel:AddControl( "Slider", { Description = "Sets which team the current player spawn is for", Label = "1 = Red, 2 = Blue", Command = "ctdm_spawn_team", Type = "Integer", Min = 1, Max = 2, Help = false })
    --CPanel:AddControl( "Button", { Text = "Save To Disc", Command = "ctdm_spawn_write_to_disc" } )

    --local currentSpawns = vgui.Create( "", CPanel ) --Next update

    --local currentFlags = vgui.Create( "", CPanel ) --Next update

    local discWrite = vgui.Create( "DButton", CPanel )
    discWrite:Dock( TOP )
    discWrite:SetTall( 22 )
    discWrite:DockMargin( 10, 11, 10, 11 )
    discWrite:SetText( "Save To Disc" )
    discWrite.DoClick = function()
        net.Start( "ServerSaveToDisc" )
        net.SendToServer()
        LocalPlayer():ChatPrint( "Flags & Spawns have been saved! Find the file in data/tdm/tool/" .. game.GetMap() .. ".txt" )
        TOOL.RebuildCPanel()
        --LocalPlayer():ChatPrint( "From that file, you can delete any flag or spawn placements - the next update will provide an easier solution" )
    end

    local refresh = vgui.Create( "DButton", CPanel )
    refresh:Dock( TOP )
    refresh:SetTall( 22 )
    refresh:DockMargin( 10, 11, 10, 11 )
    refresh:SetText( "Refresh Saved Info" )
    refresh.DoClick = function()
        TOOL.RebuildCPanel()
    end

    local function UpdateValues( num )
        net.Start( "UpdateSpawnerValue" )
            net.WriteInt( num, 8 )
            net.WriteVector( TOOL.SpawnTable[num][2] )
            net.WriteVector( TOOL.SpawnTable[num][3] )
            net.WriteString( TOOL.SpawnTable[num][4] or "" )
        net.SendToServer()
    end
    local function UpdateFlagValues( num )
        net.Start( "UpdateFlagValue" )
            net.WriteInt( num, 8 )
            net.WriteVector( TOOL.FlagTable[num][2] )
            net.WriteInt( TOOL.FlagTable[num][3], 16 )
            net.WriteString( TOOL.FlagTable[num][1] )
            net.WriteString( TOOL.FlagTable[num][5] or "" )
        net.SendToServer()
    end

    function TOOL.RebuildCPanel()
        if TOOL.clientInfo then
            TOOL.clientInfo:Remove()
        end

        local clientInfo = vgui.Create( "DCategoryList", CPanel )
        clientInfo:Dock( TOP )
        clientInfo:SetTall( 600 )
        clientInfo:DockMargin( 10, 11, 10, 11 )
        TOOL.clientInfo = clientInfo

        local warning = vgui.Create( "DLabel", clientInfo )
        warning:SetTall( 20 )
        warning:Dock( TOP )
        warning:SetText( "Make sure you click Save To Disc in order to save ANY\nchanges made here - INCLUDING deleting!")
        warning:SetAutoStretchVertical( true )
        warning:SetTextColor( Color( 0, 0, 0, 200 ) )

        local spawns1 = clientInfo:Add( "Saved Spawns - Red Team" )
        local spawns2 = clientInfo:Add( "Saved Spawns - Blue Team" )
        local flags = clientInfo:Add( "Saved Flags" )

        for k, v in pairs( TOOL.SpawnTable ) do
            local infoproperties
            if v[1] == 1 then infoproperties = vgui.Create( "DProperties", spawns1 ) else infoproperties = vgui.Create( "DProperties", spawns2 ) end
            infoproperties:SetTall( 192 )
            infoproperties:Dock( TOP )

            local info1x = infoproperties:CreateRow( "First Corner Position", "X Coord" )
            info1x:Setup( "Integer" )
            info1x:SetValue( v[2].x )
            info1x.DataChanged = function( self, data )
                TOOL.SpawnTable[k][2].x = data
                UpdateValues( k )
            end
            info1y = infoproperties:CreateRow( "First Corner Position", "Y Coord" )
            info1y:Setup( "Integer" )
            info1y:SetValue( v[2].y )
            info1y.DataChanged = function( self, data )
                TOOL.SpawnTable[k][2].y = data
                UpdateValues( k )
            end
            info1z = infoproperties:CreateRow( "First Corner Position", "Z Coord" )
            info1z:Setup( "Integer" )
            info1z:SetValue( v[2].z )
            info1z.DataChanged = function( self, data )
                TOOL.SpawnTable[k][2].z = data
                UpdateValues( k )
            end

            local info2x = infoproperties:CreateRow( "Second Corner Position", "X Coord" )
            info2x:Setup( "Integer" )
            info2x:SetValue( v[3].x )
            info2x.DataChanged = function( self, data )
                TOOL.SpawnTable[k][3].x = data
                UpdateValues( k )
            end
            info2y = infoproperties:CreateRow( "Second Corner Position", "Y Coord" )
            info2y:Setup( "Integer" )
            info2y:SetValue( v[3].y )
            info2y.DataChanged = function( self, data )
                TOOL.SpawnTable[k][3].y = data
                UpdateValues( k )
            end
            --[[info2z = infoproperties:CreateRow( "Second Corner Position", "Z Coord" )
            info2z:Setup( "Integer" )
            info2z:SetValue( v[3].z )
            info2z.DataChanged = function( self, data )
                TOOL.SpawnTable[k][3].z = data
            end]]

            local extra = infoproperties:CreateRow( "Extra", "Spawner ID" )
            extra:Setup( "String" )
            extra:SetValue( v[4] or "" )
            extra.DataChanged = function( self, data )
                TOOL.SpawnTable[k][4] = data
                UpdateValues( k )
            end

            local delete
            if v[1] == 1 then delete = vgui.Create( "DButton", spawns1 ) else delete = vgui.Create( "DButton", spawns2 ) end
            delete:SetTall( 20 )
            delete:Dock( TOP )
            delete:SetText( "Delete Spawn" )
            delete.DoClick = function()
                net.Start( "DeleteSpawn" )
                    net.WriteInt( k, 8 )
                net.SendToServer()
                table.remove( TOOL.SpawnTable, k )
                TOOL.RebuildCPanel()
            end
        end
        for k, v in pairs( TOOL.FlagTable ) do
            local infoproperties = vgui.Create( "DProperties", flags )
            infoproperties:SetTall( 168 )
            infoproperties:Dock( TOP )

            local flagx = infoproperties:CreateRow( "Flag Position", "X Coord" )
            flagx:Setup( "Integer" )
            flagx:SetValue( v[2].x )
            flagx.DataChanged = function( self, data )
                TOOL.FlagTable[k][2].x = data
                UpdateFlagValues( k )
            end
            local flagy = infoproperties:CreateRow( "Flag Position", "Y Coord" )
            flagy:Setup( "Integer" )
            flagy:SetValue( v[2].y )
            flagy.DataChanged = function( self, data )
                TOOL.FlagTable[k][2].y = data
                UpdateFlagValues( k )
            end
            local flagz = infoproperties:CreateRow( "Flag Position", "Z Coord" )
            flagz:Setup( "Integer" )
            flagz:SetValue( v[2].z )
            flagz.DataChanged = function( self, data )
                TOOL.FlagTable[k][2].z = data
                UpdateFlagValues( k )
            end

            local flagr = infoproperties:CreateRow( "Flag Interaction Values", "Circle radius" )
            flagr:Setup( "Integer" )
            flagr:SetValue( v[3] )
            flagr.DataChanged = function( self, data )
                TOOL.FlagTable[k][3] = tostring( math.Clamp( tonumber( data ) or 0, 0, 600 ) or 0 )
                UpdateFlagValues( k )
            end
            local flagl = infoproperties:CreateRow( "Flag Interaction Values", "Flag Letter" )
            flagl:Setup( "String" )
            flagl:SetValue( v[1] )
            flagl.DataChanged = function( self, data )
                TOOL.FlagTable[k][1] = data
                UpdateFlagValues( k )
            end
            local flagid = infoproperties:CreateRow( "Flag Interaction Values", "Flag ID" )
            flagid:Setup( "String" )
            flagid:SetValue( v[5] or "" )
            flagid.DataChanged = function( self, data )
                TOOL.FlagTable[k][5] = data
                UpdateFlagValues( k )
            end

            local delete = vgui.Create( "DButton", flags )
            delete:SetTall( 20 )
            delete:Dock( TOP )
            delete:SetText( "Delete Flag" )
            delete.DoClick = function()
                net.Start( "DeleteFlag" )
                    net.WriteInt( k, 8 )
                net.SendToServer()
                table.remove( TOOL.FlagTable, k )
                TOOL.RebuildCPanel()
            end
        end
    end
    TOOL.RebuildCPanel()
end

if CLIENT then
    myTool = myTool or TOOL
    myTool.SpawnTable = myTool.SpawnTable or {}
    myTool.FlagTable = myTool.FlagTable or {}
    ColorTable = { Color( 255, 0, 0 ), Color( 0, 0, 255 ) }

    function OpenMenu( spawn )
        if myTool.main then return end

        myTool.main = vgui.Create( "DFrame" )
        myTool.main:SetSize( 400, 170 )
        myTool.main:SetTitle( "Approve, Edit, or Reject Vector Points" )
        myTool.main:SetVisible( true )
        myTool.main:SetDraggable( false )
        myTool.main:ShowCloseButton( false )
        myTool.main:MakePopup()
        myTool.main:Center()

        local propertiesBuffer = 20
        local titleBuffer = 20
        local buttonWide = myTool.main:GetWide() / 4
        local buttonTall = 20

        if spawn then
            myTool.propertiesOne = vgui.Create( "DProperties", myTool.main )
            myTool.propertiesOne:SetPos( propertiesBuffer, propertiesBuffer + titleBuffer )
            myTool.propertiesOne:SetSize( myTool.main:GetWide() / 2 - propertiesBuffer - ( propertiesBuffer / 2 ), myTool.main:GetTall() )

            myTool.oneValOne = myTool.propertiesOne:CreateRow( "First Corner Position", "X Coord" )
            myTool.oneValOne:Setup( "Integer" )
            myTool.oneValOne:SetValue( myTool.PosOne.x )
            myTool.oneValOne.DataChanged = function( self, data )
                myTool.PosOneSep.x = data
            end

            myTool.oneValTwo = myTool.propertiesOne:CreateRow( "First Corner Position", "Y Coord" )
            myTool.oneValTwo:Setup( "Integer" )
            myTool.oneValTwo:SetValue( myTool.PosOne.y )
            myTool.oneValTwo.DataChanged = function( self, data )
                myTool.PosOneSep.y = data
            end

            myTool.oneValThree = myTool.propertiesOne:CreateRow( "First Corner Position", "Z Coord" )
            myTool.oneValThree:Setup( "Integer" )
            myTool.oneValThree:SetValue( myTool.PosOne.z )
            myTool.oneValThree.DataChanged = function( self, data )
                myTool.PosOneSep.z = data
            end

            myTool.propertiesTwo = vgui.Create( "DProperties", myTool.main )
            myTool.propertiesTwo:SetPos( myTool.main:GetWide() / 2 + ( propertiesBuffer / 2 ), propertiesBuffer + titleBuffer )
            myTool.propertiesTwo:SetSize( myTool.main:GetWide() / 2 - titleBuffer - ( titleBuffer / 2 ), myTool.main:GetTall() )

            myTool.twoValOne = myTool.propertiesTwo:CreateRow( "Second Corner Position", "X Coord" )
            myTool.twoValOne:Setup( "Integer" )
            myTool.twoValOne:SetValue( myTool.PosTwo.x )
            myTool.twoValOne.DataChanged = function( self, data )
                myTool.PosTwoSep.x = data
            end

            myTool.twoValTwo = myTool.propertiesTwo:CreateRow( "Second Corner Position", "Y Coord" )
            myTool.twoValTwo:Setup( "Integer" )
            myTool.twoValTwo:SetValue( myTool.PosTwo.y )
            myTool.twoValTwo.DataChanged = function( self, data )
                myTool.PosTwoSep.y = data
            end

            myTool.twoValThree = myTool.propertiesTwo:CreateRow( "Second Corner Position", "Spawner ID" )
            myTool.twoValThree:Setup( "String" )
            myTool.twoValThree:SetValue( myTool.SpawnerID )
            myTool.twoValThree.DataChanged = function( self, data )
                myTool.SpawnerID = data
            end

            --[[myTool.propertiesThree = vgui.Create( "DProperties", myTool.main )
            myTool.propertiesThree:SetPos( propertiesBuffer, (propertiesBuffer * 2) + titleBuffer + myTool.propertiesOne:GetTall() )
            myTool.propertiesThree:SetSize( myTool.main:GetWide() - (titleBuffer * 2), myTool.main:GetTall() / 3 )

            myTool.threeValOne = myTool.propertiesThree:CreateRow( "Spawner Interaction Values", "Spawner ID" )
            myTool.threeValOne:Setup( "String" )
            myTool.threeValOne:SetValue( myTool.SpawnerID )
            myTool.threeValOne.DataChanged = function( self, data )
                myTool.SpawnerID = data
            end]]
        else
            myTool.propertiesOne = vgui.Create( "DProperties", myTool.main )
            myTool.propertiesOne:SetPos( propertiesBuffer, propertiesBuffer + titleBuffer )
            myTool.propertiesOne:SetSize( myTool.main:GetWide() / 2 - propertiesBuffer - ( propertiesBuffer / 2 ), myTool.main:GetTall() )

            myTool.valOne = myTool.propertiesOne:CreateRow( "Flag Position", "X Coord" )
            myTool.valOne:Setup( "Integer" )
            myTool.valOne:SetValue( myTool.FlagPos.x )
            myTool.valOne.DataChanged = function( self, data )
                myTool.FlagPosSep.x = data
            end

            myTool.valTwo = myTool.propertiesOne:CreateRow( "Flag Position", "Y Coord" )
            myTool.valTwo:Setup( "Integer" )
            myTool.valTwo:SetValue( myTool.FlagPos.y )
            myTool.valTwo.DataChanged = function( self, data )
                myTool.FlagPosSep.y = data
            end

            myTool.valThree = myTool.propertiesOne:CreateRow( "Flag Position", "Z Coord" )
            myTool.valThree:Setup( "Integer" )
            myTool.valThree:SetValue( myTool.FlagPos.z )
            myTool.valThree.DataChanged = function( self, data )
                myTool.FlagPosSep.z = data
            end

            myTool.propertiesTwo = vgui.Create( "DProperties", myTool.main )
            myTool.propertiesTwo:SetPos( myTool.main:GetWide() / 2 + ( propertiesBuffer / 2 ), propertiesBuffer + titleBuffer )
            myTool.propertiesTwo:SetSize( myTool.main:GetWide() / 2 - titleBuffer - ( titleBuffer / 2 ), myTool.main:GetTall() )

            myTool.valFour = myTool.propertiesTwo:CreateRow( "Flag Interaction Values", "Circle radius" )
            myTool.valFour:Setup( "Integer" )
            myTool.valFour:SetValue( myTool.FlagSize )
            myTool.valFour.DataChanged = function( self, data )
                myTool.FlagSize = tostring( math.Clamp( tonumber( data ) or 0, 0, 600 ) or 0 )
            end

            myTool.valFive = myTool.propertiesTwo:CreateRow( "Flag Interaction Values", "Flag Letter" )
            myTool.valFive:Setup( "String" )
            myTool.valFive:SetValue( myTool.FlagLetter )
            myTool.valFive.DataChanged = function( self, data )
                myTool.FlagLetter = data
            end

            myTool.valSix = myTool.propertiesTwo:CreateRow( "Flag Interaction Values", "Flag ID" )
            myTool.valSix:Setup( "String" )
            myTool.valSix:SetValue( myTool.FlagID )
            myTool.valSix.DataChanged = function( self, data )
                myTool.FlagID = data
            end
        end

        myTool.accept = vgui.Create( "DButton" , myTool.main )
        myTool.accept:SetSize( buttonWide, buttonTall )
        myTool.accept:SetPos( myTool.main:GetWide() / 4 - ( buttonWide / 2 ), myTool.main:GetTall() - buttonTall - ( buttonTall / 2 ) )
        myTool.accept:SetText( "Accept & Close" )
        myTool.accept.DoClick = function()
            net.Start( "SaveValues" )
                if spawn then
                    local pos1 = Vector( myTool.PosOneSep.x, myTool.PosOneSep.y, myTool.PosOneSep.z )
                    local pos2 = Vector( myTool.PosTwoSep.x, myTool.PosTwoSep.y, myTool.PosOneSep.z )
                    net.WriteInt( 1, 3 )
                    net.WriteInt( myTool.PosTeam, 3 )
                    net.WriteVector( pos1 )
                    net.WriteVector( pos2 )
                    net.WriteString( myTool.SpawnerID )
                    table.insert( myTool.SpawnTable, { myTool.PosTeam, pos1, pos2, myTool.SpawnerID } ) --Used for 3D drawing
                else
                    net.WriteInt( 2, 3 )
                    net.WriteString( myTool.FlagLetter )
                    net.WriteVector( Vector( myTool.FlagPos.x, myTool.FlagPos.y, myTool.FlagPos.z ) )
                    net.WriteInt( myTool.FlagSize, 16 )
                    net.WriteString( myTool.FlagID )
                    table.insert( myTool.FlagTable, { myTool.FlagLetter, Vector( myTool.FlagPos.x, myTool.FlagPos.y, myTool.FlagPos.z ), myTool.FlagSize, 0, myTool.FlagID } ) --Used for 3D drawing
                end
            net.SendToServer()

            myTool.main:Remove()
            myTool.main = nil
        end

        myTool.preview = vgui.Create( "DButton" , myTool.main )
        myTool.preview:SetSize( buttonWide, buttonTall  )
        myTool.preview:SetPos( myTool.main:GetWide() / 4 * 2 - ( buttonWide / 2 ), myTool.main:GetTall() - buttonTall - ( buttonTall / 2 ) )
        myTool.preview:SetText( "Close & Preview" )
        myTool.preview.DoClick = function()
            if spawn then
                myTool.PosOne = Vector( myTool.PosOneSep.x, myTool.PosOneSep.y, myTool.PosOneSep.z )
                myTool.PosTwo = Vector( myTool.PosTwoSep.x, myTool.PosTwoSep.y, myTool.PosOneSep.z ) --Done intentionally
            else
                myTool.FlagPos = Vector( myTool.FlagPosSep.x, myTool.FlagPosSep.y, myTool.FlagPosSep.z )
                --myTool.FlagSize = myTool.FlagSizeBackup
            end

            myTool.main:Remove()
            myTool.main = nil
            LocalPlayer():ChatPrint( "Click again to re-open the menu, or press R to remove points" )
        end

        myTool.default = vgui.Create( "DButton" , myTool.main )
        myTool.default:SetSize( buttonWide, buttonTall  )
        myTool.default:SetPos( myTool.main:GetWide() / 4 * 3 - ( buttonWide / 2 ), myTool.main:GetTall() - buttonTall - ( buttonTall / 2 ) )
        myTool.default:SetText( "Reset Values" )
        myTool.default.DoClick = function()
            if spawn then
                myTool.PosOne = myTool.PosOneBackup
                myTool.PosOneSep = { x = myTool.PosOneBackup.x, y = myTool.PosOneBackup.y, z = myTool.PosOneBackup.z }
                
                myTool.PosTwo = myTool.PosTwoBackup
                myTool.PosTwoSep = { x = myTool.PosTwoBackup.x, y = myTool.PosTwoBackup.y, z = myTool.PosTwoBackup.z }

                myTool.SpawnerID = ""
            else
                myTool.FlagPos = myTool.FlagPosBackup
                myTool.FlagPosSep = { x = myTool.FlagPosBackup.x, y = myTool.FlagPosBackup.y, z = myTool.FlagPosBackup.z }

                myTool.FlagSize = myTool.FlagSizeBackup
                myTool.FlagLetter = ""
                myTool.FlagID = ""
            end

            myTool.main:Close()
            myTool.main = nil
            OpenMenu( spawn or false )
        end

    end
    
    net.Receive( "UpdateSpawnPosition", function()
        myTool.PosTeam = net.ReadInt( 3 ) --Team first
        local which = net.ReadInt( 3 ) --Identify which position
        if which == 1 then
            myTool.PosOne = net.ReadVector()
            myTool.PosOneBackup = myTool.PosOne
            myTool.PosOneSep = { x = myTool.PosOne.x, y = myTool.PosOne.y, z = myTool.PosOne.z }
            if myTool.PosOne == Vector( 0, 0, 0 ) then
                myTool.PosOne = nil
            end
        else
            myTool.PosTwo = net.ReadVector()
            myTool.PosTwoBackup = myTool.PosTwo
            myTool.PosTwoSep = { x = myTool.PosTwo.x, y = myTool.PosTwo.y, z = myTool.PosOne.z }
            if myTool.PosTwo == Vector( 0, 0, 0 ) then
                myTool.PosTwo = nil
            end
        end
        myTool.SpawnerID = ""
    end )

    net.Receive( "UpdateFlagPosition", function()
        local which = net.ReadInt( 3 )
        if which == 1 then
            myTool.FlagPos = net.ReadVector()
            myTool.FlagPosBackup = myTool.FlagPos
            myTool.FlagPosSep = { x = myTool.FlagPos.x, y = myTool.FlagPos.y, z = myTool.FlagPos.z }
        else
            myTool.FlagSize = net.ReadInt( 16 )
            myTool.FlagSizeBackup = myTool.FlagSize
            myTool.FlagLetter = ""
            myTool.FlagID = ""
        end
    end )

    net.Receive( "ReviewValues", function()
        if myTool.PosOne and myTool.PosTwo then
            OpenMenu( true )
        elseif myTool.FlagPos and myTool.FlagSize then
            OpenMenu()
        end
    end )

    net.Receive( "DeleteClientValues", function()
        myTool:ClearValues()
        --LocalPlayer():GetWeapon( "gmod_tool" ).Tool["ctdm_spawn"]:ClearValues()
    end )

    net.Receive( "StartingValues", function()
        local tab1 = net.ReadTable()
        local tab2 = net.ReadTable()
        
        myTool.FlagTable = tab1 or {}
        myTool.SpawnTable = tab2 or {}
    end )
    
    surface.CreateFont( "FlagNames", { font = "Arial", size = 40 } )
    hook.Add( "PostDrawOpaqueRenderables", "DrawSpawnsFlags", function()
        if !LocalPlayer():Alive() or !LocalPlayer():GetWeapon( "gmod_tool" ).Tool then return end
        myTool = LocalPlayer():GetWeapon( "gmod_tool" ).Tool["ctdm_spawn"]
        if not myTool or not myTool.IsHeld then return end
        --//Draw placed flags
        for k, v in next, myTool.FlagTable do
            local trace = v[ 2 ]
            local offset = Vector( 0, 0, 85 )

            local ang = LocalPlayer():EyeAngles()
            local pos = trace + Vector( 0, 0, 85 ) + ang:Up()
            
            ang:RotateAroundAxis( ang:Forward(), 90 )
            ang:RotateAroundAxis( ang:Right(), 90 )
            surface.SetDrawColor( Color( 255, 255, 255 ) )
            cam.Start3D2D( pos, Angle( 0, ang.y, 90 ), 0.25 )
                surface.DrawLine( 0, -100, 0, 375 )
                surface.DrawLine( 0, -100, 70, 20 )
                surface.DrawLine( 0, 20, 70, 20 )
                draw.SimpleText( v[1], "FlagNames", 20, -5, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
            cam.End3D2D()
            
            cam.Start3D2D( v[2] + Vector( 0, 0, 2 ), Angle( 0, 0, 0 ), 1 )
                surface.DrawCircle( 0, 0, v[3], Color( 255, 255, 255 ) )
                surface.DrawCircle( 1, 0, v[3], Color( 255, 255, 255 ) )
                surface.DrawCircle( 0, 1, v[3], Color( 255, 255, 255 ) )
                surface.DrawCircle( 1, 1, v[3], Color( 255, 255, 255 ) )
            cam.End3D2D()
        end
        
        --//Draw placed spawns
        for k, v in next, myTool.SpawnTable do
            local color
            if v[1] == 1 then color = Color( 255, 0, 0 ) else color = Color( 0, 0, 255 ) end
            local pos = v[ 2 ]
            local pos2 = v[ 3 ]

            cam.Start3D2D( pos + Vector( 0, 0, 20 ), Angle( 0, 0, 0 ), 1 )
                surface.SetDrawColor( color )
                surface.DrawOutlinedRect( 0, 0, pos2.x - pos.x, pos.y - pos2.y )
            cam.End3D2D()
        end

        --//Draw spawn creation
        if myTool.PosOne and !myTool.FlagPos then
            if !myTool.PosTwo then
                local pos = myTool.PosOne
                local pos2 = LocalPlayer():GetEyeTrace().HitPos
                cam.Start3D2D( pos + Vector( 0, 0, 2 ), Angle( 0, 0, 0 ), 1 )
                    surface.SetDrawColor( ColorTable[ myTool.PosTeam ] )
                    surface.DrawOutlinedRect( 0, 0, pos2.x - pos.x, pos.y - pos2.y )
                cam.End3D2D()
            else
                local pos = myTool.PosOne
                local pos2 = myTool.PosTwo
                cam.Start3D2D( pos + Vector( 0, 0, 2 ), Angle( 0, 0, 0 ), 1 )
                    surface.SetDrawColor( ColorTable[ myTool.PosTeam ] )
                    surface.DrawOutlinedRect( 0, 0, pos2.x - pos.x, pos.y - pos2.y )
                cam.End3D2D()
            end
        end

        --//Draw flag creation
        if myTool.FlagPos and !myTool.PosOne then
            local trace = myTool.FlagPos
            local offset = Vector( 0, 0, 85 )

            local ang = LocalPlayer():EyeAngles()
            local pos = trace + offset + ang:Up()
            
            ang:RotateAroundAxis( ang:Forward(), 90 )
            ang:RotateAroundAxis( ang:Right(), 90 )
            surface.SetDrawColor( Color( 255, 255, 255 ) )
            cam.Start3D2D( pos, Angle( 0, ang.y, 90 ), 0.25 )
                surface.DrawLine( 0, -100, 0, 375 )
                surface.DrawLine( 0, -100, 70, 20 )
                surface.DrawLine( 0, 20, 70, 20 )
            cam.End3D2D()

            if myTool.FlagSize then --If we've set the interaction size
                local pos = myTool.FlagPos
                local pos2 = myTool.FlagSize
                cam.Start3D2D( pos + Vector( 0, 0, 2 ), Angle( 0, 0, 0 ), 1 )
                    surface.DrawCircle( 0, 0, pos2, Color( 255, 255, 255 ) )
                    surface.DrawCircle( 1, 0, pos2, Color( 255, 255, 255 ) )
                    surface.DrawCircle( 0, 1, pos2, Color( 255, 255, 255 ) )
                    surface.DrawCircle( 1, 1, pos2, Color( 255, 255, 255 ) )
                cam.End3D2D()
            else
                local pos = myTool.FlagPos
                local pos2 = LocalPlayer():GetEyeTrace().HitPos
                local dist = math.Distance( pos.x, pos.y, pos2.x, pos2.y )

                cam.Start3D2D( pos + Vector( 0, 0, 2 ), Angle( 0, 0, 0 ), 1 )
                    surface.DrawCircle( 0, 0, math.Clamp( dist, 0, 600 ), Color( 255, 255, 255 ) )
                    surface.DrawCircle( 1, 0, math.Clamp( dist, 0, 600 ), Color( 255, 255, 255 ) )
                    surface.DrawCircle( 0, 1, math.Clamp( dist, 0, 600 ), Color( 255, 255, 255 ) )
                    surface.DrawCircle( 1, 1, math.Clamp( dist, 0, 600 ), Color( 255, 255, 255 ) )
                cam.End3D2D()
            end
        end
    end )
end