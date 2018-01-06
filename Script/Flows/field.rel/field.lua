-- $USE Libs/Lib_kthura
-- $USE Libs/nothing
local field = {}


local map

function field:LoadMap(KthuraMap,layer)
    if not laura.assert(layer,"No layer requested!",{LoadMap=KthuraMap}) then return end    
    map= {layer=layer}
    print("Loading map: ",KthuraMap)
    CSay("Loading map: "..KthuraMap)
    CSay("= Map itself")
    map.map = kthura.load("Script/Maps/Kthura/"..KthuraMap)
    if not laura.assert(map.map,"Loading the map failed!") then return end
    CSay("= Map script")
    local scr = "Script/Maps/Script/"..KthuraMap..".lua"
    if not(JCR_Exists(scr)) then
       local src = "-- No script\nreturn {}"
       console.write("WARNING! ",255,180,0)
       console.writeln("No script file! Using empty script!")
       local fun = load(src,"* NOSCRIPT *")
       map.script = fun() 
    else
       map.script = use(scr)
    end    
    CSay("= Map Events")
    -- Will be put in later!
    CSay("= Changes")
    -- Will be put in later!
    CSay("= OnLoad")
    ;(map.script.onload or nothing)()
    
end

field.cam = {x=0,y=0}

function field:odraw()   
    --for k,v in spairs(self) do print(type(v),k) end
    --print (serialize('map',map))
    kthura.drawmap(map.map,map.layer,self.cam.x,self.cam.y)
end    

function field:map() return map end

return field