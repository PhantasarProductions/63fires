--[[
  Death.lua
  Version: 18.02.09
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

local  fd = { Hero = function(self,chtag)
         end,
         
         Foe = function(self,chtag)
             local warrior = self.fighters[chtag] 
             warrior.deathscale = warrior.deathscale - .01
             if warrior.deathscale<=0 then
                -- experience
                -- item drops
                -- money if no items
                -- cleanup
                self.fighters[chtag]=nil
                self.foe[chtag]=nil                
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
