--[[
**********************************************
  
  DUNG_Prairie.lua
  (c) Jeroen Broks, 2018, All Rights Reserved.
  
  This file contains material that is related 
  to a storyline that is which is strictly
  copyrighted to Jeroen Broks.
  
  This file may only be used in an unmodified
  form with an unmodified version of the 
  software this file belongs to.
  
  You may use this file for your study to see
  how I solved certain things in the creation
  of this project to see if you find valuable
  leads for the creation of your own.
  
  Mostly this file comes along with a project
  that is for most part released under an
  open source license and that means that if
  you use that code with this file removed
  from it, you can use it under that license.
  Please check out the other files to find out
  which license applies.
  This file comes 'as-is' and in no possible
  way the author can be held responsible of
  any form of damages that may occur due to 
  the usage of this file
  
  
 **********************************************
 
version: 18.12.21
]]




return function (map,surf)

  local Console=console
  local function d(x1,y1,x2,y2) --[[ Thank you, Pythagoras! ]]  return math.sqrt((math.abs(x1-x2)^2)+(math.abs(y1-y2)^2)) end
  local function objectd(o1,o2) return d(o1.COORD.x,o1.COORD.y,o2.COORD.x,o2.COORD.y) end
  local Shirley      

  local tagmap = map.TagMap["surface"]

  local panw=math.random(255,1023)
  local panh=math.random(125,555)
  local totw=panw*10
  local toth=panh*10
  CSay(("PRAIRIE: Panel size:   %d x %d"):format(panw,panh))
  
  -- Dijkstra marker
  if true then -- force a scoop
    local KNO={}
    surf[#surf+1] = KNO
    KNO["KIND"]="Zone"
    KNO["COORD"]={x=totw-32,y=toth-32}
    KNO["SIZE"]={width=32,height=96}
    KNO.IMPASSIBLE=true
    KNO.FORCEPASSIBLE=false
    KNO.TAG="Dijkstra"
    KNO.VISIBLE=true
    tagmap["Dijkstra"]=KNO
  end  
  
  -- The entrance and exit
  if true then -- force a scoop
    local KNO={}
    surf[#surf+1] = KNO
    KNO["KIND"]="Exit"
    KNO["COORD"]={x=math.ceil(totw/2),y=toth-96}
    KNO["TAG"]="Start"
    KNO["IMPASSIBLE"] = false
    KNO["FORCEPASSIBLE"] = false
    KNO["DOMINANCE"]=20
    KNO["VISIBLE"]=true
    map.TagMap["surface"]["Start"]=KNO
    
    KNO={}
    surf[#surf+1] = KNO
    KNO["KIND"]="Zone"
    KNO["COORD"]={x=0,y=toth-64}
    KNO["SIZE"]={width=totw,height=76}
    KNO["TAG"]="PrimosRegion"
    KNO["IMPASSIBLE"] = false
    KNO["FORCEPASSIBLE"] = false
    KNO["DOMINACE"] = 1
    map.TagMap["surface"]["PrimosRegion"]=KNO  
    for f,_ in spairs(map.TagMap.surface) do CSay("I have now: "..f) end 
  end
  
  -- The grass panels
  -- --[[
  for x=0,9 do for y=0,9 do
    local KNO={}
    local ox=x*panw
    local oy=y*panh
    surf[#surf+1] = KNO
    KNO["KIND"] = "TiledArea"
    KNO["COORD"] = { x = ox, y = oy } 
    KNO["INSERT"] = { x = 0-(ox%32), y = 0-(oy%32) } 
    KNO["ROTATION"] = 0
    KNO["SIZE"] = { width = panw, height = panh } 
    KNO["TAG"] = "" --("MyPanel %d.%d"):format(x,y)
      -- map.TagMap["surface"][("Panel %d.%d"):format(x,y)] = KNO
    KNO["LABELS"] = ""
    KNO["DOMINANCE"] = 2
    KNO["TEXTURE"] = "GFX/Textures/Prairie/Dry_Grass.png"
    KNO["CURRENTFRAME"] = 0
    KNO["FRAMESPEED"] = -1
    KNO["ALPHA"] = 1.0000000000000000
    KNO["VISIBLE"] = true
    KNO["COLOR"] = { r = 255, g = 255, b = 255 } 
    KNO["IMPASSIBLE"] = false
    KNO["FORCEPASSIBLE"] = false
    KNO["SCALE"] = { x = 1000, y = 1000 } 
    KNO["BLEND"] = 0    
 end end
 -- ]]
 
 -- Shirley herself
 if true then -- force a new scoop
    local KNO--={}
    KNO=tagmap.NPC_Shirley
    --surf[#surf+1]=KNO
    Shirley=KNO
    --[[
    KNO.KIND="Obstacle"
    KNO.TEXTURE='GFX/Textures/Prairie/Shirley.png' -- "GFX/PlayerSprites/Shirley.South.jpbf"
    KNO.ROTATION=0
    KNO.TAG="NPC_Shirley"
    KNO.DOMINANCE=20
    KNO.CURRENTFRAME=0
    KNO.FRAMESPEED=-1
    KNO.ALPHA=1.0000000000000000
    KNO.VISIBLE=true
    KNO.COLOR={ r = 255, g = 255, b = 255 } 
    KNO.IMPASSIBLE = true
    KNO.FORCEPASSIBLE = false
    KNO.SCALE={ x = 1000, y = 1000 } 
    KNO.BLEND=0
    KNO.COORD={x=0,y=0}
    KNO.SIZE={width=32,height=32}
    -- ]]
    --tagmap.NPC_Shirley=KNO
    -- Shirley can pop up ANYWHERE, but not too close to the starting position
    -- This cannot completely rule out the player won't find here upon entering this place
    -- But at least we can lower the chance significantly.
    repeat
       KNO.COORD.x=math.random(100,totw-100)
       KNO.COORD.y=math.random(100,toth-100)
    until objectd(Shirley,tagmap['Start'])>1000
    CSay(("Shirley is located on (%d,%d)\nnThe player is located on (%d,%d)"):format(KNO.COORD.x,KNO.COORD.y,tagmap.Start.COORD.x,tagmap.Start.COORD.y))   
 end
 
 -- Bushes
 local Bushes = {}
 local num = math.random(250,600)
 for i=1,num do
     Console.Write("Prairie Bush: ",255,255,0)
     Console.Write(("%3d/%3d"):format(i,num),0,255,255)
     Console.WriteLn("!",255,0,0)
     local KNO={}
     surf[#surf+1]=KNO
     KNO.KIND="Obstacle"
     KNO.TEXTURE="GFX/Textures/Prairie/DrogeStruik.png"
     KNO.ROTATION=0
     KNO.TAG=""
     KNO.DOMINANCE=20
     KNO.CURRENTFRAME=0
     KNO.FRAMESPEED=-1
     KNO.ALPHA=1
     KNO.VISIBLE=true
     KNO.COLOR={ r = 255, g = 255, b = 255 } 
     KNO.IMPASSIBLE = true
     KNO.FORCEPASSIBLE=false
     KNO.SIZE = { width = 0, height = 0 } 
     KNO.SCALE={ x = math.random(1000,1111), y = math.random(1000,1234) } 
     KNO.BLEND=0
     KNO.COORD={x=0,y=0}
     -- Bushes may not collide with each other and should not be to close to Shirley and not too close to the player's starting point, either.
     repeat
       KNO.COORD.x=math.random(100,totw-100)
       KNO.COORD.y=math.random(100,toth-100)
       local Col=false
       for O in each(Bushes) do Col=Col or (objectd(O,KNO)<120) end
    until (not Col) and objectd(Shirley,KNO)>400 and(objectd(KNO,tagmap.Start))>500 
     
 end
 
 -- CSay(serialize("zooi",map))
 
 for KNO in each(surf) do 
     KNO.LABELS = KNO.LABELS or ""
     KNO.DOMINANCE = KNO.DOMINANCE or 1 
     KNO.ROTATION = KNO.ROTATION or 0
     KNO.SIZE = KNO.SIZE or {width=1,height=1}
 end
 
 return map
end
