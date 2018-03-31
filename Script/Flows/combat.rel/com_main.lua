--[[
  com_main.lua
  Version: 18.03.31
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
-- $USE Script/Subs/Headers.h AS Headers_h
local cmain = {}


cmain.consolecommands = {}
function cmain.consolecommands.FIGHTERS(self,para)
      CSay(serialize("combat.fighters",self.fighters))
end      
function cmain.consolecommands.ESF(self)
      CSay(serialize('esf',self.esf))
end      
function cmain.consolecommands.BATTLEFLOW(self)
      for k,v in spairs(self) do
          if v==self then
             CSay("self "..k)
          else
             CSay(serialize(type(v).." "..k,v))
          end
      end      
end
function cmain.consolecommands.KILL(self,para)
    if not(self.fighters[para]) then return console.writeln("Fighter list does not contain a record named: "..para) end
    CSay("Assasinating character: "..para)
    rpg:Points(para,"HP").Have=0
end          


function cmain:TagMessage(tag,message,r,g,b,ymod)
    local x,y = 0,0
    x = self.fighters[tag].x
    y = self.fighters[tag].y + (ymod or 0)
    MiniMSG(message,{r or 255,g or 255, b or 255},{x,y})
end

function cmain:basedraw()
      self:DrawArena()
      self:DrawCards()
      self:StatusPreDraw()
      self:DrawFoes(self.targeted,self.inaction)
      self:DrawHeroes(self.targeted,self.inaction,self.acting,self.heroframe)      
end

cmain.BoxTextBack = cmain.basedraw

function cmain:odraw()
      self:basedraw()
      self.flow = self.flow or "idle"
      assert(self["flow_"..self.flow],"No combat flow function for "..self.flow)
      self['flow_'..self.flow](self)
      StatusBar(false,true)
      dbgcon()    
      ShowMiniMSG()
end















return cmain

