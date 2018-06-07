--[[
  crystal.lua
  Version: 18.06.07
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
local crystal = {}

function crystal:CrystalInit()
    self.crystals = {}
    local skill = Var.G("%SKILL")
    local kill3
    local map = self:getmap()
    for lay,objlist in pairs(map.map.MapObjects) do
        for obj in each(objlist) do
            if prefixed(obj.TAG,"CRYSTAL") then
               if skill==3 then
                  kill3 = kill3 or {}
                  kill3[#kill3+1]=obj.TAG
               else
                  self.crystals[lay] = self.crystals[lay] or {}
                  self.crystals[lay][#self.crystals[lay]+1]=obj
                  if skill==1 and prefixed(obj.TAG,"CRYSTALH") then obj.COLOR = {r=180,g=255,b=0} end
               end
            elseif obj.TAG=='DemonCrystal' then
               CSay("= Found a demon crystal on layer '"..lay.."'")   
            end
        end
        CSay("= Crystals in layer '"..lay.."': "..#(self.crystals[lay] or {}))
        if kill3 then for tag in each(kill3) do self:laykill(lay,tag,false) end kill3=nil end
    end       
end

function crystal:CrystalGrab()
    local skill = Var.G("%SKILL")
    local PLAYER = self:GetActiveActor()
    local map = self:getmap()
    local lay=map.layer
    if skill==3 then return end -- Saves performance in hard mode. Why process something that is not needed, eh?
    if not self.crystals[lay] then return end -- Saves performance when there are no crystals.
    local kill = {}
    for i,obj in pairs(self.crystals[lay]) do
        if math.abs(PLAYER.COORD.x-obj.COORD.x)<64 and math.abs(PLAYER.COORD.y-obj.COORD.y)<64 then -- Ignore all crystals that are too far away
           local gx = PLAYER.COORD.x
           local gy = PLAYER.COORD.y-32
           if obj.COORD.x>gx then obj.COORD.x = obj.COORD.x-1 end
           if obj.COORD.x<gx then obj.COORD.x = obj.COORD.x+1 end
           if obj.COORD.y>gy then obj.COORD.y = obj.COORD.y-1 end
           if obj.COORD.y<gy then obj.COORD.y = obj.COORD.y+1 end
           if obj.COORD.x==gx and obj.COORD.y == gy then
              -- $USE libs/audio
              QuickPlay("Audio/Gen/Crystal.Wav")
              CSay("Grabbed Crystal: "..obj.TAG)
              kill[#kill+1]=i
              if prefixed(obj.TAG,"CRYSTALH") then
                 CSay("= Health Crystal")
                 for ch in each(RPGParty) do 
                    CSay("= "..ch)
                    rpg:Points(ch,"VIT"):Inc(1)
                    if skill==1 then rpg:Points(ch,"HP") :Inc(math.ceil(rpg:Points(ch,"HP").Maximum/100)) end
                 end   
              elseif prefixed(obj.TAG,"CRYSTALM") then
                 for ch in each(RPGParty) do                  
                     rpg:Points(ch,"AP") :Inc(math.ceil(rpg:Points(ch,"AP").Maximum/100))                    
                 end   
              end
           end
        end 
    end 
    for i in each(kill) do 
        self:kill(self.crystals[lay][i].TAG)
        self.crystals[lay][i]=nil 
    end
end

return crystal
