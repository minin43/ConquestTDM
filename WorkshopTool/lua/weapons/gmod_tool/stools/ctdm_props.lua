AddCSLuaFile()

if !game.SinglePlayer() then return end

if CLIENT then
    language.Add( "tool.ctdm_props.name", "CTDM Prop Setup" )
    language.Add( "tool.ctdm_props.desc", "Used to save props and remove map entities for CTDM" )
    language.Add( "Tool.ctdm_props.0", "Primary: Mark/Unmark USER SPAWNED Prop For Saving   Secondary: Mark/Unmark MAP SPAWNED Prop for Deletion   Reload: Area Trace for Deletion" )
	--language.Add( "Tool.ctdm_props.set", "Weight:" )
	language.Add( "Tool.ctdm_props.set_desc", "Set " )
end

TOOL.Category = "ConquestTDM"
TOOL.Name = "#tool.ctdm_props.name"

if SERVER then
    if engine.ActiveGamemode() != "sandbox" then return end

    TOOL.Marked = {}
    TOOL.Marked.Props = {}
    TOOL.Marked.Deletion = {}

    util.AddNetworkString( "PropSearchResults" )
    util.AddNetworkString( "PropSearchResultsCallback" )
    util.AddNetworkString( "ReadConfigFromDisc" )
    util.AddNetworkString( "SaveConfigToDisc" )

    net.Receive( "PropSearchResultsCallback", function( len, ply )
        local tbl = net.ReadTable()

        myTool = ply:GetWeapon( "gmod_tool" ).Tool["ctdm_props"]
        for k, v in pairs( tbl ) do --k is ent, v in mapspawnID
            if !v then
                if myTool.Marked.Deletion[ k:MapCreationID() ] then
                    ply:ChatPrint( "Unmarked map-created entity " .. k:GetClass() .. " [" .. k:EntIndex() .. "] for removal.")
                    k:SetColor( Color( 255, 255, 255 ) )
                end
                myTool.Marked.Deletion[ k:MapCreationID() ] = false
            else
                myTool.Marked.Deletion[ k:MapCreationID() ] = true
                ply:ChatPrint( "Marked map-created entity " .. k:GetClass() .. " [" .. k:EntIndex() .. "] for removal (ID: " .. k:MapCreationID() .. ").")
		        k:SetColor( Color( 200, 0, 0 ) )
            end
        end
    end )

    net.Receive( "ReadConfigFromDisc", function( len, ply )
        myTool = ply:GetWeapon( "gmod_tool" ).Tool["ctdm_props"]

        for k, v in pairs( myTool.Marked.Props ) do
            k:Remove()
        end
        myTool.Marked.Props = {}
        
        for k, v in pairs( myTool.Marked.Deletion ) do
            ents.GetMapCreatedEntity( k ):SetColor( Color( 255, 255, 255 ) )
        end
        myTool.Marked.Deletion = {}

        local mapFile = file.Read( "tdm/tool/map_edits/" .. game.GetMap() .. ".txt", "DATA")
        local extractedInfo = util.JSONToTable( mapFile )

        for k, v in pairs( extractedInfo.propSpawns ) do
            local prop = ents.Create( "prop_physics" )
            if !IsValid( prop ) then return end
            prop:SetModel( v.model )
            prop:SetPos( v.pos )
            prop:SetAngles( v.ang )
            prop:Spawn()
            prop:SetColor( Color( 0, 255, 0 ) )

            local physobject = prop:GetPhysicsObject()
            physobject:EnableMotion( false )
            myTool.Marked.Props[ prop ] = { model = v.model, pos = v.pos, ang = v.ang }
        end

        for k, v in pairs( extractedInfo.Deletions ) do
            ents.GetMapCreatedEntity( k ):SetColor( Color( 255, 0, 0 ) )
            myTool.Marked.Deletion[ k ] = true
        end

        ply:ChatPrint( "Loading saved prop information..." )
    end )

    net.Receive( "SaveConfigToDisc", function( len, ply )
        myTool = ply:GetWeapon( "gmod_tool" ).Tool["ctdm_props"]
        
        local fixedProps = {}
        for k, v in pairs( myTool.Marked.Props ) do
            if k:IsValid() and v then
                fixedProps[ #fixedProps + 1 ] = v
            end
        end

        local fixedDeletion = {}
        for k, v in pairs( myTool.Marked.Deletion ) do
            if v then
                fixedDeletion[ k ] = true --v is a bool, so we can set equal to true or v
            end
        end

        file.Write( "tdm/tool/map_edits/" .. game.GetMap() .. ".txt", util.TableToJSON( { propSpawns = fixedProps, Deletions = fixedDeletion } ) )
    end )
end

function TOOL:Init()
    if ( CLIENT ) then return true end

    if not file.Exists( "tdm", "DATA" ) then
        file.CreateDir( "tdm" )
    end

    if not file.Exists( "tdm/tool", "DATA" ) then
        file.CreateDir( "tdm/tool" )
    end

    if not file.Exists( "tdm/tool/map_edits", "DATA" ) then
        file.CreateDir( "tdm/tool/map_edits" )
    end

    if not file.Exists( "tdm/tool/map_edits/" .. game.GetMap() .. ".txt", "DATA" ) then
        file.Write( "tdm/tool/map_edits/" .. game.GetMap() .. ".txt" )
    end
end

--//Marks user-spawned props for saving, to spawn when loaded into the server
function TOOL:LeftClick( trace )
    if !trace.HitPos or ( IsValid( trace.Entity ) and trace.Entity:GetClass() != "prop_physics" or trace.Entity:MapCreationID() != -1 or trace.Entity:IsWorld() ) then return false end --Has to be a regular 'ol prop
    if ( CLIENT ) then return true end

    if self.Marked.Props[ trace.Entity ] then
        self.Marked.Props[ trace.Entity ] = false
        self:GetOwner():ChatPrint( "Unmarked prop " .. trace.Entity:GetClass() .. " [" .. trace.Entity:EntIndex() .. "] for saving.")
        trace.Entity:SetColor( Color( 255, 255, 255 ) )
        
        local physobject = trace.Entity:GetPhysicsObject()
        physobject:EnableMotion( true )
    else
        self.Marked.Props[ trace.Entity ] = { model = trace.Entity:GetModel(), pos = trace.Entity:GetPos(), ang = trace.Entity:GetAngles() }
        self:GetOwner():ChatPrint( "Marked prop " .. trace.Entity:GetClass() .. " [" .. trace.Entity:EntIndex() .. "] for saving.")
        trace.Entity:SetColor( Color( 0, 200, 0 ) )
        
        local physobject = trace.Entity:GetPhysicsObject()
        physobject:EnableMotion( false )
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

--//Marks mapcreated entites for removing, to delete when loaded into the server
function TOOL:RightClick( trace )
    if !trace.HitPos or ( IsValid( trace.Entity ) and trace.Entity:MapCreationID() == -1 or trace.Entity:IsWorld() ) then return false end --Has to be a baked-in ent
    if ( CLIENT ) then return true end
    
    if self.Marked.Deletion[ trace.Entity:MapCreationID() ] then
        self.Marked.Deletion[ trace.Entity:MapCreationID() ] = false
        self:GetOwner():ChatPrint( "Unmarked map-created entity " .. trace.Entity:GetClass() .. " [" .. trace.Entity:EntIndex() .. "] for removal.")
		trace.Entity:SetColor( Color( 255, 255, 255 ) )
    else
        self.Marked.Deletion[ trace.Entity:MapCreationID() ] = true
        self:GetOwner():ChatPrint( "Marked map-created entity " .. trace.Entity:GetClass() .. " [" .. trace.Entity:EntIndex() .. "] for removal (ID: " .. trace.Entity:MapCreationID() .. ").")
		trace.Entity:SetColor( Color( 200, 0, 0 ) )
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

--//Does an area check around the trace, looking for all map-spawned ents (which we can then set to delete)
function TOOL:Reload( trace )
    if ( CLIENT ) then return true end

    local tbl = ents.FindInSphere( trace.HitPos, 100 )
    local send = {}
    for k, v in pairs( tbl ) do
        local id = v:MapCreationID()
        if IsValid( v ) and v != Entity(0) and id != -1 and string.sub(v:GetClass(), 1, 5) != "class" then
            send[ v ] = self.Marked.Deletion[ id ] or false
        end
    end
    net.Start( "PropSearchResults" )
        net.WriteTable( send )
    net.Send( self:GetOwner() )

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
    CPanel:AddControl( "Header", { Description = "#tool.ctdm_props.name" } )
    
    local discRead = vgui.Create( "DButton", CPanel )
    discRead:Dock( TOP )
    discRead:SetTall( 22 )
    discRead:DockMargin( 10, 22, 10, 22 )
    discRead:SetText( "Open Saved File From Disc" )
    discRead.DoClick = function()
        net.Start( "ReadConfigFromDisc" )
        net.SendToServer()
    end

    local discWrite = vgui.Create( "DButton", CPanel )
    discWrite:Dock( TOP )
    discWrite:SetTall( 22 )
    discWrite:DockMargin( 10, 22, 10, 22 )
    discWrite:SetText( "Save Current Configuration To Disc" )
    discWrite.DoClick = function()
        net.Start( "SaveConfigToDisc" )
        net.SendToServer()
        LocalPlayer():ChatPrint( "Prop saving & deletion have been saved! Find the file in data/tdm/tool/map_edits/" .. game.GetMap() .. ".txt" )
    end

    local info = vgui.Create( "DLabel", CPanel )
    info:Dock( TOP )
    info:SetTall( 22 )
    info:DockMargin( 10, 22, 10, 22 )
    info:SetText( "[WARNING] Saving to disc overwrites what was\npreviously stored. If you don't want to lose it, create a backup. ALSO, opening the currently-saved"
                    .. " config also removes all un-saved edits. Use with caution." )
end

if CLIENT then
    --//Thanks for this, Zet
    function CreateWindowEntityList()
		local tbl = net.ReadTable()
		
		local frame = vgui.Create("DFrame")
		frame:SetSize(300, 300)
		frame:SetTitle("Mark props for removal ...")
		frame:Center()
		frame:MakePopup()
		
		local entlist = vgui.Create("DScrollPanel", frame)
		entlist:SetPos(10, 30)
		entlist:SetSize(280, 230)
		entlist:SetPaintBackground(true)
		entlist:SetBackgroundColor( Color(200, 200, 200) )
		
		local entchecklist = vgui.Create( "DIconLayout", entlist )
		entchecklist:SetSize( 265, 250 )
		entchecklist:SetPos( 5, 5 )
		entchecklist:SetSpaceY( 5 )
		entchecklist:SetSpaceX( 5 )
		
		for k,v in pairs(tbl) do
			if IsValid(k) and string.sub(k:GetClass(), 1, 5) != "class" then
				local entity = entchecklist:Add( "DPanel" )
				entity:SetSize( 130, 20 )
				
				local check = entity:Add("DCheckBox")
				check:SetPos(2,2)
				check:SetValue(v)
				check.OnChange = function(self, val)
					tbl[k] = val
				end
				check:SetTooltip(tostring(k))
				
				local name = entity:Add("DLabel")
				name:SetTextColor(Color(50,50,50))
				name:SetSize(105, 20)
				name:SetPos(20,1)
				name:SetText(k:GetClass())
				name:SetTooltip(tostring(k))
			end
		end
		
		local submit = vgui.Create("DButton", frame)
		submit:SetSize(200, 25)
		submit:SetText("Submit")
		submit:SetPos(50, 265)
		submit.DoClick = function(self)
			net.Start( "PropSearchResultsCallback" )
				net.WriteTable( tbl )
			net.SendToServer()
		end
    end
    
    net.Receive( "PropSearchResults", CreateWindowEntityList )
end