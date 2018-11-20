--[[
  com_debug.lua
  Version: 18.11.13
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

local fuck = {} -- Sorry! I was frustrated, mind you!
fuck.consolecommands={}


function fuck.consolecommands.FIGHTERS(self,para)
      CSay(serialize("combat.fighters",self.fighters))
end      
function fuck.consolecommands.ESF(self)
      CSay(serialize('esf',self.esf))
end      
function fuck.consolecommands.BATTLEFLOW(self)
      for k,v in spairs(self) do
          if v==self then
             CSay("self "..k)
          else
             CSay(serialize(type(v).." "..k,v))
          end
      end      
end
function fuck.consolecommands.KILL(self,para)
    if not(self.fighters[para]) then return console.writeln("Fighter list does not contain a record named: "..para) end
    CSay("Assasinating character: "..para)
    rpg:Points(para,"HP").Have=0
end          
function fuck.consolecommands.SHOWHP(self,para)
    if para then
       if not self.fighters[para] then
          CSay("Who the hell is: "..para.."?")
          return
       end
       CSay(("%s has %4d out of %4d HP"):format(para,rpg:Points(para,"HP").Have,rpg:Points(para,"HP").Maximum))
    else
       for ch,_ in spairs(self.fighters) do self.consolecommands.KILL(self,ch) end
    end
end

function fuck.consolecommands.CARDS(self,apara)
   local c = serialize('cards',self.Cards)
   local sc = mysplit(c,"\n")
   local r,g,b
   for i,l in ipairs(sc) do
       local r=math.ceil((i/#sc)*255)
       local b=255-r
       local g=255-math.ceil((r+b)/2)
       console.writeln(l,r,g,b)       
   end
end  

function fuck.consolecommands.FULLAP(self,para)
   if not field then 
      console.writeln("HUH? Field flow is not there???",255,0,0)
      return
   end   
   field.consolecommands.FULLAP(self,para)
end   

function fuck.consolecommands.COMBATFLOW(self)
  CSay("Current Combat Flow: "..self.flow)
  if self.flow=="execution" then
     CSay("= Execution Sub Flow: "..self.esf)
  end
end  

return fuck
