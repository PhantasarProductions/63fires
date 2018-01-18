--[[
  zone action.lua
  Version: 18.01.13
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
local za = {}

local zoneactions = {}
local inzone = {}

local function Next()
    local m = field:getmap()
    local pl = m.layer
    assert(left(pl,1)=="#","Next may only be used in # based layers.")
    local n = tonumber(right(pl,#pl-1))
    assert(n,"Layer number "..sval(pl).." could not be converted into a calculatable number")
    assert(n<999,"I can't go past layer number #999")
    local gl = n+1
    local nl = "#"..right("00"..gl,3)
    field:GoToLayer(nl,'Start')
end

local function Prev()
    local m = field:getmap()
    local pl = m.layer
    assert(left(pl,1)=="#","Next may only be used in # based layers.")
    local n = tonumber(right(pl,#pl-1))
    assert(n,"Layer number "..sval(pl).." could not be converted into a calculatable number")
    assert(n>0,"I can't go below layer number #000")
    local gl = n-1
    local nl = "#"..right("00"..gl,3)
    field:GoToLayer(nl,'Einde')
end

function za:ZA_Add(list,zone,action,para)
     zoneactions[list]=zoneactions[list] or {}
     zoneactions[list][zone] = zoneactions[list][zone] or {}
     zoneactions[list][zone][#zoneactions[list][zone]+1]={action,para}
     console.write  (zone,0,255,255)
     console.write  (' has been registered in action list ',255,255,0)
     console.writeln(list,0,255,255)
end

function za:ZA_Enter(zone,action,para)
    self:ZA_Add('ENTER',zone,action,para) 
end

function za:ZA_Leave(zone,action,para)
    self:ZA_Add('LEAVE',zone,action,para) 
end

function za:ActorInZone(Actor,Zone)
    local me="ActorInZone(\""..Actor.."\",\""..Zone.."\"): "
    local map=self.map.map
    local lay=self.map.layer
    local act=map.TagMap[lay][Actor]
    assert(act,me.."Actor not found!")
    local zon=map.TagMap[lay][Zone]
    if not zon then return nil end
    assert(zon.KIND=='TiledArea' or zon.KIND=='Zone',me.."Object of kind '"..zon.KIND.."' cannot be used as zone for 'InZone' checks")
    assert(act.KIND=='Actor' or act.KIND=='Obstacle',"Object of kind "..act.KIND.."' cannot be used as actor for 'InZone' checks")
    if act.COORD.x>=zon.COORD.x and act.COORD.y>=zon.COORD.y and act.COORD.x<=zon.COORD.x+zon.SIZE.width and act.COORD.y<=zon.COORD.y+zon.SIZE.height then return true end
    return nil
end

local checkup = { ENTER={was=nil, wordt=true, zone=true}, LEAVE={was=true,wordt=nil,zone=true}}
function za:ZA_Check()
    local map=self.map.map
    --local lay=self.map.layer
    local act='PLAYER'..self.leader
    for check,condition in pairs(checkup) do
        zoneactions[check] = zoneactions[check] or {}
        --zoneactions[check][lay] = zoneactions[check][lay] or {}
        for tag,funcs in pairs(zoneactions[check]) do
           local now = self:ActorInZone(act,tag)
           if inzone[tag]==condition.was and now==condition.zone then
              --inzone[tag] =condition.wordt
              for actions in each(funcs) do actions[1](actions[2]) end              
           end
           inzone[tag]=now
        end
    end    
end

function za:ZA_Clear(nonextprev)
  local cl = {}
  for k,_ in pairs(zoneactions) do cl[#cl+1]=k end
  for clr in each(cl) do zoneactions[clr]=nil end
  if not nonextprev then
     za:ZA_Enter('Next',Next)
     za:ZA_Enter('Prev',Prev)
  end
  cl={}
  for k,_ in pairs(inzone) do cl[#cl+1]=k end
  for clr in each(cl)  do inzone[clr]=nil end  
end  

function za:ZA_Dump() -- ONLY FOR DEBUGGING PURPOSES
   local d=mysplit(serialize('local zoneactions',zoneactions),'\n')
   for i,l in ipairs(d) do
       local g=math.floor((i/#d)*255)
       local r=255-g
       console.writeln(l,r,g,0)
   end
end       

return za
