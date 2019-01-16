--[[
  com_pain.lua
  Version: 18.02.03
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
local pijn = {}




function pijn:Hurt(targettag,damage,element)
   local ret = damage
   local effect = 3
   element = element or "None"
   local function p() return math.floor(ret+.5) end
   if rpg:StatExists(targettag,"END_ER_"..element) then
      effect = rpg:Stat(targettag,"END_ER_"..element)
   end
   if effect==0 then
      ret = rpg:Points(targettag,"HP").Have
      self:TagMessage(targettag,"DEATH",255,0,0)
   elseif effect==1 then
      ret = ret * 4.1
      self:TagMessage(targettag,p(),255,0,0)
   elseif effect==2 then
      ret = ret * 2.3
      self:TagMessage(targettag,p(),180,60,0)
   elseif effect==3 then
      self:TagMessage(targettag,p(),255,255,255)
   elseif effect==4 then
      ret = ret / 2
      self:TagMessage(targettag,p(),255,255,0)
   elseif effect==4 then
      ret = 0
      self:TagMessage(targettag,"No effect!",255,255,255)
   elseif effect==5 then
       self:TagMessage(targettag,p(),0,255,0)
       ret = ret * -1
   else
       error("Unknown elemental resistance effect: "..sval(effect))
   end 
   rpg:Points(targettag,"HP"):Dec(p())
   return p()          
end

function pijn:Strike(data)
   ---------------------------------------------------
   -- Needed elements                               --
   -- atk = attack value                            --
   -- amd = attack modifier                         --
   -- def = defense value                           --
   -- exe = executor tag                            --
   -- tar = target tag                              --
   -- elem = element (optional)                     --
   -- allowcrit = allow critical (optional)         --
   ---------------------------------------------------
   --CSay(serialize('strike.data',data))
   local skill  = Var.G("%SKILL")
   local defmod  = { Foe = { .25,.50,.75},Hero={.50,.30,.15}}
   local critmod = { Foe = {1.25,2.1,2.9},Hero={4.1,2.1,1.3}}
   local f = {exe=self.fighters[data.exe],tar=self.fighters[data.tar]}
   local atk = data.atk * data.amd --rep:Stat(exe.tag,"END_"..act.Attack_AttackStat) * ((act.Attack or 100)/100)
   local def = data.def
   --CSay(sval(def)) CSay(serialize("defmod",defmod)) CSay(sval(skill))
   def = def * defmod[f.tar.group][skill]
   local rate = atk-def
   local damage = rate + love.math.random(0,math.ceil(rate/4))
   if damage<1 then damage=1 end
   local criticalrate = 0
   local critical = false
   critical = rpg:SafeStat(data.exe,"END_Critical")>0
   critical = critical and data.allowcrit 
   critical = critical and love.math.rand(0,100)<rpg:SafeStat(data.exe,"END_Critical")
   if critical then 
       damage = love.math.rand(damage,damage*critmod[f[data.exe]][skill])
       self:TagMessage(data.tar,'Critical!',255,0,0,-20) 
   end
   self:Hurt(data.tar,damage,data.elem or "None")   
end


return pijn
