--//Quality goes from 0 (shit) to 5 (amazing) - I think I'll reserve 5 for special skins, 4 will be the default "really good" quality marker
GM.SkinsMasterTable = {
    { name = "Stone Blue", dir = "models/XQM/BoxFull_diffuse", quality = 1 },
    { name = "Artic Breeze", dir = "models/XQM/CellShadedCamo_diffuse", quality = 1 },
    { name = "", dir = "models/XQM/LightLinesRed", quality = 4 },
    { name = "", dir = "models/XQM/LightLinesRed_tool", quality = 4 },
    { name = "Polex", dir = "models/XQM/PoleX1_diffuse", quality = 1 },
    { name = "Arctic Block", dir = "models/XQM/SquaredMatInverted", quality = 2 },
    { name = "Grassy Knoll", dir = "models/XQM/WoodTexture_1", quality = 0 },
    { name = "Black Hole", dir = "models/onfire", quality = 2 },
    { name = "Viscera", dir = "models/zombie_fast/fast_zombie_sheet", quality = 2 },
    { name = "Wisp", dir = "models/Airboat/airboat_blur02", quality = 3 },
    { name = "Striped Slate", dir = "phoenix_storms/black_brushes", quality = 2 },
    { name = "Vent", dir = "phoenix_storms/future_vents", quality = 1 },
    { name = "Plasmid", dir = "plastic", quality = 2 },
    { name = "True Ice", dir = "ice_tool/ice_texture", quality = 3 },
    { name = "Wireframed", dir = "models/wireframe", quality = 3 },
    { name = "Chrome", dir = "debug/env_cubemap_model", quality = 4 },
    { name = "Flow", dir = "models/shadertest/shader3", quality = 4 },
    { name = "Red Flow", dir = "models/shadertest/shader4", quality = 4 },
    { name = "Mosaic", dir = "models/shadertest/shader5", quality = 4 },
    { name = "Stasis", dir = "models/props_combine/stasisshield_sheet", quality = 4 },
    { name = "Jiuce", dir = "models/props_lab/Tank_Glass001", quality = 4 },
    { name = "Mirror", dir = "models/screenspace", quality = 3 },
    { name = "Flesh", dir = "models/flesh", quality = 2 },
    { name = "ATTENTION ATTENTION", dir = "phoenix_storms/stripes", quality = 1 },
    { name = "Green Wire", dir = "phoenix_storms/wire/pcb_green", quality = 3 },
    { name = "Red Wire", dir = "phoenix_storms/wire/pcb_red", quality = 3 },
    { name = "Blue Wire", dir = "phoenix_storms/wire/pcb_blue", quality = 3 }--[[,
    { name = "", dir = "", quality = 0 },
    { name = "", dir = "", quality = 0 },
    { name = "", dir = "", quality = 0 },
    { name = "", dir = "", quality = 0 },
    { name = "", dir = "", quality = 0 },
    { name = "", dir = "", quality = 0 },
    { name = "", dir = "", quality = 0 },
    { name = "", dir = "", quality = 0 },
    { name = "", dir = "", quality = 0 },
    { name = "", dir = "", quality = 0 },
    { name = "", dir = "", quality = 0 },
    { name = "", dir = "", quality = 0 },
    { name = "", dir = "", quality = 0 },
    { name = "", dir = "", quality = 0 },
    { name = "", dir = "", quality = 0 },
    { name = "", dir = "", quality = 0 },
    { name = "", dir = "", quality = 0 },
    { name = "", dir = "", quality = 0 }]]
}

function GetSkinTableByDirectory( dir )
    for k, v in pairs( GAMEMODE.SkinsMasterTable ) do
        if v.dir == dir then return v end
    end
    error( "Function GetSkinTableByDirectory given bad skin texture: " .. dir )
end