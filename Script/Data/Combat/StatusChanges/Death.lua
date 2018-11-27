--[[
  Death.lua
  Version: 18.11.24
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

local exprandomrates = {{125,200},{100,150},{0,100}}

local  fd = { Hero = function(self,chtag)
         end,
         
         Foe = function(self,chtag)
             local skill = Var.G("%SKILL")
             local warrior = self.fighters[chtag] 
             warrior.deathscale = warrior.deathscale - .01
             if warrior.deathscale<=0 then
                -- experience
                local exp = rpg:Stat(chtag,"EXP")
                local rate
                for pch in each(RPGParty) do 
                    rate = love.math.random(exprandomrates[skill][1],exprandomrates[skill][2])/100
                    local get = math.ceil(exp*rate)
                    if get>0 and rpg:Stat(pch,"Level")<Var.G("%LEVELCAP") then
                       rpg:DecStat(pch,"Experience",get)
                       self:TagMessage(pch,get.." experience points",100,180,0)
                    end
                end
                -- item drops
                local dropped
                local inum = math.random(0,#warrior.drops or {})
                local itag = warrior.drops[inum]
                if inum>0 and itag then
                   local item = ItemGet(itag)
                   local name
                   dropped,name = ItemGive(itag)
                   if dropped then self:TagMessage(chtag,("%s dropped"):format(name),255,225,200) end
                end
                -- money if no items
                if not dropped then
                   local getcash = rpg:Stat(chtag,"Cash")
                   local dump = DumpCash(getcash)
                   if getcash<128000000 then
                      self:TagMessage(chtag,("%s dropped"):format(dump),225,200,255)
                      Var.D('%CASH',Var.G("%CASH")+getcash)
                   end 
                end
                -- update bestiary
                gamedata.bestiary = gamedata.bestiary or {}
                -- CSay(serialize('warrior',warrior))
                gamedata.bestiary[warrior.ufil] = (gamedata.bestiary[warrior.ufil] or 0) + 1
                -- cleanup
                self.fighters[chtag]=nil
                self.foe[chtag]=nil
                self.foedraworder={}
                local orderkill={}
                for k,myfoe in spairs(self.foedrawordertag) do
                    if myfoe.tag==chtag then 
                       orderkill[#orderkill+1]=k
                    else   
                       self.foedraworder[#self.foedraworder+1]=myfoe
                    end    
                end
                for k in each(orderkill) do self.foedrawordertag[k]=nil end                 
             end
         end
       }

local DEATH = {


  predraw = function(self,chtag)
    local warrior = self.fighters[chtag] 
    cleartable(warrior.statuschanges)
    fd[warrior.group](self,chtag)   
  end,

  blockhealing = true,
  blockexperience = true,
  noturn = true,
  defeated = true, -- If set to "true" this status will count as 'defeated' when checking the victory conditions in the default setting.
  
  cause = function(self,chtag)
      local zombie
      for statkey,statdata in self:statuses(chtag) do
          zombie = zombie or statdata.zombie
      end
      local HP = rpg:Points(chtag,"HP")
      if zombie then
         HP.Have = HP.Maximum
         self:TagMessage(chtag,"Max!",180,255,0,20)
         return
      end
      HP.Have=0
  end

}

if Var.G("%SKILL")==1 then
   DEATH.blockexperience=false
end

return DEATH
