--[[
  haken.lua
  Version: 18.12.13
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
local haken = {}

-- "haken" means "hooks" in Dutch.

local searchdebug = false -- Must be "false" in the release!


function haken:initHookSpots()
    local spots = {}
    local map = self:getmap()
    local total=0
    map.hookspots = spots -- They their their pointers, so whatever changes in the one directly affects the other... Or basically, they are both just pointers pointing the area were stuff changes :P
    for obj,lay in self:getmap().map:allobjects() do
        if obj.KIND=="Exit" and obj.DATA and obj.DATA.HOOK then
           assert(obj.TAG,"Tagless Hook Exit Point!")
           assert(map.map.TagMap[lay][obj.DATA.HOOK],"Hook exit pointing to non-existent hook spot! "..obj.DATA.HOOK)
           local target=map.map.TagMap[lay][obj.DATA.HOOK]
           spots[lay] = spots[lay] or {}
           spots[lay][obj.TAG]={ GOTOT = obj.DATA.HOOK, GOTOC = target.COORD, FROM=obj.COORD }
           total = total + 1 
        end
    end    
    return total
end

-- "Slave" is a regular term in the world of computers, so any "slave" activists, put the axes down.... slowly! 
local function HideSlaves()
   local map = field:GetMap()
   for i=2,4 do
       local slave = map.map.TagMap[map.layer][("PLAYER%d"):format(i)]
       if slave then slave.VISIBLE=false end
   end
end

local function ShowSlaves(adjust)
   local map = field:GetMap()
   local master = map.map:obj(map.layer,"PLAYER1")
   for i=2,4 do
       local slave = map.map.TagMap[map.layer][("PLAYER%d"):format(i)]
       if slave then 
          slave.VISIBLE=true 
          if adjust then
             slave.COORD.x=master.COORD.x
             slave.COORD.y=master.COORD.y
             slave.walking=false
             slave.moving=false
          end   
       end
   end
end



local function HookCross(self,coords)
    --CSay("Jumping not yet done! Please come back later!")
    HideSlaves()
    local map = self:getmap()
    local Ryanna = map.map:obj(map.layer,"PLAYER1")
    repeat
          cls()
          if Ryanna.COORD.x<coords.x then Ryanna.COORD.x=Ryanna.COORD.x+4 end
          if Ryanna.COORD.x>coords.x then Ryanna.COORD.x=Ryanna.COORD.x-4 end
          if Ryanna.COORD.y<coords.y then Ryanna.COORD.y=Ryanna.COORD.y+4 end
          if Ryanna.COORD.y>coords.y then Ryanna.COORD.y=Ryanna.COORD.y-4 end
          self:autoscroll()
          kthura.drawmap(map.map,map.layer,self.cam.x,self.cam.y)
          StatusBar(false,false)
          showstrip()
          Color(0,180,255)
          love.graphics.line(Ryanna.COORD.x-self.cam.x,(Ryanna.COORD.y-32)-self.cam.y,coords.x-self.cam.x,(coords.y-16)-self.cam.y)
          love.graphics.present()                   
    until math.abs(Ryanna.COORD.x-coords.x)<60 and math.abs(Ryanna.COORD.y-coords.y)<60       
    ShowSlaves(true)
end

function haken:findClosestHookSpot()
   local map = self:getmap()
   local spots = map.hookspots
   local lay = map.layer
   if not spots[lay] then CSay(("Ignored! No hookspots on this layer >> %s"):format(lay)) end
   local player = map.map:obj(map.layer,"PLAYER1")
   local px,py = player.COORD.x,player.COORD.y
   local available = {}
   -- Hoe ver zijn alle punten verwijderd van Ryanna?
   -- Dit kunnen me in 2D zo makkelijk checken dankzij de stelling van Pythagoras.
   for k,spot in pairs(spots[lay] or {}) do
       local sx,sy = spot.FROM.x,spot.FROM.y
       local rechthoekszijde1 = math.abs(px-sx)
       local rechthoekszijde2 = math.abs(py-sy)
       local totaal = (rechthoekszijde1^2) + (rechthoekszijde2^2)
       local hypotenusa = math.sqrt(totaal)
       available[hypotenusa] = k
   end
   -- Dat hebben we nu!
   -- En welke is het dichsta bij?
   for distance,spotkey in spairs(available,function(available,k1,k2) return k1<k2 end) do
       -- CSay(serialize('spots',spots).. "\nfrom\nSpotkey = "..spotkey.." distance: "..distance)   
       local stx,sty = math.floor(spots[lay][spotkey].FROM.x/32),math.floor(spots[lay][spotkey].FROM.y/32)
       console.write("Can I go to? ",255,255,0)
       console.writeln(("(%d,%d)"):format(stx,sty),0,255,255)
       if player:WalkTo(stx,sty) then
          self:SetArrival({HookCross,self,spots[lay][spotkey].GOTOC})
          CSay("Going!") 
          return
       end
   end
   CSay("No suitable hookspot found, so let's cut it!")
end

return haken
