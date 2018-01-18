--[[
  field.lua
  Version: 18.01.18
  Copyright (C) 2018 Jeroen Petrus Broks
  
  ===========================
  This file is part of a project related to the Phantasar Chronicles or another
  series or saga which is property of Jeroen P. Broks.
  This means that it may contain references to a story-line plus characters
  which are property of Jeroen Broks. These references may only be distributed
  along with an unmodified version of the game. 
  
  As soon as you remove or replace ALL references to the storyline or character
  references, or any termology specifically set up for the Phantasar universe,
  or any other univers a story of Jeroen P. Broks is set up for,
  the restrictions of this file are removed and will automatically become
  zLib licensed (see below).
  
  Please note that doing so counts as a modification and must be marked as such
  in accordance to the zLib license.
  ===========================
  zLib license terms:
  This software is provided 'as-is', without any express or implied
  warranty.  In no event will the authors be held liable for any damages
  arising from the use of this software.
  Permission is granted to anyone to use this software for any purpose,
  including commercial applications, and to alter it and redistribute it
  freely, subject to the following restrictions:
  1. The origin of this software must not be misrepresented; you must not
     claim that you wrote the original software. If you use this software
     in a product, an acknowledgment in the product documentation would be
     appreciated but is not required.
  2. Altered source versions must be plainly marked as such, and must not be
     misrepresented as being the original software.
  3. This notice may not be removed or altered from any source distribution.
]]

-- $USE Libs/Lib_kthura
-- $USE Libs/nothing
-- $USE Script/Subs/Headers.h AS Headers_h
-- $USE Script/Subs/IconStrip
local field = {}
local full, fstype = love.window.getFullscreen( )
local scw,sch = love.graphics.getDimensions( )

field.iconstrip = {}

local arrival
local is = field.iconstrip
is.hide=full
is.back=true
is.x=60

-- When playing full screen this icon is the quit feature. It won't be visible in Windows mode, since 
if full then is[1]={ icon='stoppen', tut='Quits the game\nWarning unsaved data will NOT be saved and will thus be lost', cb=love.event.quit } end

-- Tools. By default all empty. Can be set by changing characters providing they have the tool
for i=1,3 do is[#is+1]={icon='empty', tut='???', cb=nothing, tool_id=i} end

is[#is+1] = {icon='Prestaties', tut='Overview of your earned achievements', cb=function() flow.use('ach','Script/Flows/Achievements.lua') flow.set('ach') end}

-- Help! Must ALWAYS be last!!
is[#is+1] = {icon='Help', tut="Provides help", cb=iconstriphelp}

local map


field.leader=1

local function follow(tagslave,tagmaster)
end

function field:GetActive()
   return RPGParty[self.leader]
end

function field:followdaleader()
  for i=1,#RPGParty do
      local a=map.map:obj(map.layer,"PLAYER"..i)
      a.TEXTURE = "GFX/PlayerSprites/"..RPGParty[i].."."..a.WIND..".jpbf"
      if i~=self.leaader then
         if i==1 then follow("PLAYER1","PLAYER"..#RPGParty) 
         else         follow("PLAYER"..i,"PLAYER"..math.floor(i-1)) end
      end   
  end  
end

function field:SpawnPlayer(exitpoint)
    local xd = {}
    local exitspot = exitpoint
    if type(exitspot)=='string' then exitspot = map.map.TagMap[map.layer][exitpoint] else  exitpoint.COORD =  exitpoint.COORD or exitpoint.COORDS or {} exitpoint.x=exitpoint.x or exitpoint.COORD.x exitpoint.y=exitpoint.y or exitpoint.COORD.y end
    TrickAssert(exitspot,"Can't spawn on an unknown spot",{F='SpawnPlayer',Exit=exitpoint,Map=map.file,Layer=map.layer})
    xd.FRAME=1
    xd.WIND='South'
    if not exitspot.DATA then exitspot.DATA = {WIND=exitspot.WIND} end
    if     exitspot.DATA.Wind=="S" then xd.WIND="South"
    elseif exitspot.DATA.Wind=="N" then xd.WIND="North"
    elseif exitspot.DATA.Wind=="E" then xd.WIND="East"
    elseif exitspot.DATA.Wind=="W" then xd.WIND="West" end 
    TrickAssert(#RPGParty>0,"Empty party! Can't spawn!",serialize('Chars',RPGParty))           
    for i=1,#RPGParty do
         CSay("Spawning "..RPGParty[i].." as character #"..i)
         xd.TEXTURE="GFX/PlayerSprites/"..RPGParty[i].."."..xd.WIND..".jpbf"
         kthura.Spawn(map.map,map.layer,exitpoint,'PLAYER'..i,xd)
    end     
end

function field:MTclick(tag)
     local act=map.map.TagMap[map.layer]['PLAYER'..self.leader]
     act.Wind='North'
     MapText(tag:upper())
end
 

function field:gomenu(ch)
   -- $USE script/flows/menu
   menu:cometome('field',ch)
end

function field:LoadMap(KthuraMap,layer)
    if not laura.assert(layer,"No layer requested!",{LoadMap=KthuraMap}) then return end    
    map= {layer=layer,file=KthuraMap}
    self:ZA_Clear()    
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
       console.write("  Compiling: ",255,255,0)
       console.writeln(scr,0,255,255)
       map.script = Use(scr)
       TrickAssert(type(map.script)=='table','MapScripts must return tables, but this is not a table.',{['Loaded Script']=scr,['Returned type']=type(map.script)})
    end
    -- CSay("= Map Events") -- dropped
    -- Will be put in later!
    CSay("= MapText")
    local lfile = 'Scenario/'..Var.C('$LANG')..'/Maps/'..KthuraMap
    CSay("  "..lfile)
    if JCR_Exists(lfile) then
       LoadScenario('MAP','Maps/'..KthuraMap)
    else
       console.write("WARNING! ",180,100,0)
       console.writeln("MapText has not been found for this map!",255,255,0)
    end      
    CSay("= Changes")
    -- Will be put in later!
    CSay("= Music function")
    if map.script.music then
       CSay("= running mapscript music routine") 
       map.script:music() 
    elseif map.map.Meta.Music~="" then 
       console.write  ('  Loading: ',255,255,0)
       console.writeln(map.map.Meta.Music,0,255,255)
       omusic.play(map.map.Meta.Music) 
    end
    CSay("= OnLoad")
    ;(map.script.onload or nothing)()
    self.map=map    
end

field.cam = {x=0,y=0}

function field:BoxTextBack()
    cls()
    kthura.drawmap(map.map,map.layer,self.cam.x,self.cam.y)
end

function field:objectclicked()
    local mx,my=love.mouse.getPosition()
    local tm = map.map.TagMap[map.layer]
    local act = map.map.TagMap[map.layer]['PLAYER'..self.leader]
    local ret = true
    for tag,obj in spairs(tm) do
        local touched = obj:touch(mx+self.cam.x,my+self.cam.y)
        CSay("Touching "..tag.." returned "..sval(touched))
        if touched then 
           local utag=tag:upper()
           local tstx=obj.COORD.x
           local tsty=obj.COORD.y+32
           local stx = math.floor(tstx/32)
           local sty = math.floor(tsty/32)
           if     prefixed(utag,"NPC_MT_") and act:WalkTo(stx,sty) then arrival={self.MTclick,self,utag,tag=tag} return true
           elseif prefixed(utag,"NPC_")    and act:WalkTo(stx,sty) then arrival={map.script[utag],tag=tag} return true
           elseif prefixed(utag,"SAVE_")   and act:WalkTo(stx,sty) then arrival={GoSaveGame,"SAVE",tag=tag} return true
           else   ret=false
           end
        else
           ret=false   
        end      
    end
    return ret
end

function field:laykill(layer,objtag,perm)
    local killi
    for i,obj in ipairs(map.map.MapObjects[layer]) do
        if obj.TAG==objtag then killi=i end
    end
    if killi then map.map.MapObjects[layer][killi] = nil else console.write("NOTE! ",255,0,255) console.writeln("There is no object tagged "..objtag..", so I can't remove it!") end
    map.map:remapall()
    if perm then
       local swap = "swap/gameswap/perma."..map.file..".lua"
       if not love.filesystem.isFile(swap) then love.filesystem.write(swap,"-- Permanent changes to "..map.file.."\n\n") end
       love.filesystem.append(swap,"field:laykill('"..layer.."','"..objtag.."')\n")
    end   
end

function field:kill(objtag,perm)
   self:laykill(map.layer,objtag,perm)
end   

function field:GoToLayer(lay,spot)
    for i=1,4 do self:kill("PLAYER"..i) end
    map.layer=lay
    self:SpawnPlayer(spot)
end

function field:odraw()
    local mx,my=love.mouse.getPosition()
    self.clicked = mousehit(1)
    --if self.clicked then cancelhelp() end
    local width, height = love.graphics.getDimensions( )   
    local staty = height-140
    --for k,v in spairs(self) do print(type(v),k) end
    --print (serialize('map',map))
    self:followdaleader()
    kthura.drawmap(map.map,map.layer,self.cam.x,self.cam.y)
    -- debug mark
     --[[
       color(255,0,0,80)
       for x=16,scw,32 do for y=16,sch-120,32 do
           if map.map:block(map.layer,x,y) then Rect(x-16,y-16,32,32) end
       end end    
       local marko=map.map:obj(map.layer,'PLAYER1')
       white()
       Mark(marko.COORD.x-self.cam.x,marko.COORD.y-self.cam.y)       
       if mx>40 and my<height-120 then
          color(0,0,255,100)
          local gx = math.floor((mx+self.cam.x)/32)
          local gy = math.floor((my+self.cam.y)/32)
          Rect(gx*32,gy*32,32,32)
       end   
    --]]
    StatusBar(false,true)
    showstrip()
    love.graphics.setFont(console.font)
    love.graphics.print(Var.S("Time: $PLAYTIME"),width-200,staty)
    local player=map.map:obj(map.layer,"PLAYER"..self.leader)
    if self.clicked and mx>40 and my<height-120 then
           if player and self:objectclicked() then
              CSay("Player clicked an object which has been marked as special ("..((arrival or {tag="BULLSHIT!"}).tag or "?")..")")
           elseif player then 
              local gx = math.floor((mx+self.cam.x)/32)
              local gy = math.floor((my+self.cam.y)/32)
              CSay("Player requested object 'PLAYER"..self.leader.."' to walk to ("..gx..","..gy..")")
              player:WalkTo(gx,gy)
              arrival=nil               
           end
       end
    if arrival and (not player.walking) and (not player.moving) then arrival[1](arrival[2],arrival[3],arrival[4],arrival[5]); arrival=nil end       
    self:ZA_Check()    
    dbgcon()    
end    

function field:map() return map end
function field:getmap() return map end

PF_Block = function(x,y) -- needed for the pathfinder to function correctly
   return map.map:block(map.layer,x,y)
end   

field.consolecommands = {}
function field.consolecommands.BLOCKMAP(self,para)
     local bm,w,h = kthura.serialblock(map.map,map.layer)
     for bl in each(bm) do 
         console.writeln(bl,0,255,0)
     end
     CSay("Map size in gridblocks: "..w.."x"..h)
end         
function field.consolecommands.MYPOS(self,para)
     for i=1,#RPGParty do
         local c = map.map.TagMap[map.layer]['PLAYER'..i]
         CSay("Char #"..i..": "..c.COORD.x..","..c.COORD.y.." Dom:"..sval(c.DOMINANCE))
     end     
end
function field.consolecommands.REMAP(self,para)
     map.map:remapall()
end     
function field.consolecommands.MOVETO(self,para)
     local player=map.map:obj(map.layer,"PLAYER"..self.leader)
     local x,y
     local sp = mysplit(para)
     x=tonumber(sp[1]) or 0
     y=tonumber(sp[2]) or 0
     player:MoveTo(x,y)
end
function field.consolecommands.OBJPIC(self,para)
     local o = map.map:obj(map.layer,para)
     if not o then console.writeln("? That object does not exist!") return end
     local k=mysplit(serialize(para..".PICS",o.LoadedTexture),"\n")
     for i,l in ipairs(k) do
         local g = math.floor((i/#k)*255)
         local r = 255-g
         console.writeln(l,r,g,0)
         console.show()
         love.graphics.present()
     end
end
--field.consolecommands.__cam=field.cam
function field.consolecommands.CAM(self,para)
    CSay("Camera: ("..sval(self.cam.x)..","..sval(self.cam.y)..")")
end         

function field.consolecommands.ZADUMP(self,para)
    self:ZA_Dump()
end         

function field.consolecommands.ASSETS(self)
    for k,_ in spairs(assets) do
        CSay("Loaded: "..k)
    end
end            

function field.consolecommands.SAVE(self,apara)
    local para=apara or "DEBUG"
    if para=="" then para="DEBUG" end
    Save("debug."..para)
end    

return field
