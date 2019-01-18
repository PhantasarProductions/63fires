--[[
  flw_idle.lua
  Version: 19.01.17
  Copyright (C) 2018, 2019 Jeroen Petrus Broks
  
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
local zooi = {  }

function zooi:validcard(card,allowondead)
       if not self.Cards[1].data then return CSay("= Invalid card: No data!") end
       if card.data.nextmove then
          local nmv  = card.data.nextmove
          local ctag = nmv.executor if not ctag then return CSay("= Invalid card: No executor!") end
          local exe  = self.fighters[ctag]    if not ctag then return CSay("= Invalid card: Executor no longer exists. Dead maybe?") elseif rpg:Points(ctag,'HP').Have==0 then return CSay("= Invalid card: Executor has 0 HP") end
          local tar  = nmv.targets if (not tar) then return CSay("= Invalid card: Targets not set at all") elseif #nmv.targets==0 then return CSay("= Invalid Card: No targets set") end
          local newtar = {}
          for nt in each(tar) do
              if      not self.fighters[nt]       then CSay(("= Target %s is non-existent"):format(nt))
              elseif  rpg:Points(nt,"HP").Have==0               
                 and  (prefixed(nt,"FOE_") or (not allowdead))
                                                  then CSay(("= Target %s has zero hp!"):format(nt))
              else newtar[#newtar+1]=nt end                                                  
          end
          if #newtar==0 then return CSay("= Invalid card: No more valid targets") end
          return true          
       end   
        
end

function zooi:flow_idle()
      local firstcard=self.Cards[1]
      local tag=self:CardTag(firstcard.data)
      local ctag
      if self.Cards[1].data then ctag=self.Cards[1].data.tag else ctag="" end
      self:DidAnyoneWin()
      if tag=="BACK" then
         return self:RemoveFirstCard()
      end
      if (prefixed(tag,"HERO") or prefixed(tag,"FOE")) and (rpg:Points(ctag,'HP').Have==0 or self:StatusProperty(ctag,'skipturn')) then
         for f in self:StatusPropertyValues(ctag,"skipturnexpire") do f(self,ctag) end
         return self:RemoveFirstCard()
      end 
      if firstcard.done then
         return self:RemoveFirstCard()
      end   
      if firstcard.data.nextmove then
         if self:validcard(firstcard) then
            self.nextmove=firstcard.data.nextmove
            self.flow="execution"
            return
         else
            CSay("Extra card no longer valid! Disposing!")
            return self:RemoveFirstCard()
         end            
      end     
      if prefixed(tag,"HERO") then      
         for f in self:StatusPropertyValues(ctag,"startturn") do f(self,ctag) end         
         self:StatusRemoveByProperty(ctag,"endonturn")
         self.flow = firstcard.altplayinput or "playerinput"
      end
      if prefixed(tag,"FOE") or prefixed(tag,"BOSS") then
         if rpg:Points(ctag,"HP").Have==0 then return self:RemoveFirstCard() end -- Let's force the AI to skip dead foes!   
         for f in self:StatusPropertyValues(ctag,"startturn") do f(self,ctag) end
         self:StatusRemoveByProperty(ctag,"endonturn")
         self.flow = firstcard.altplayinput or "foeinput"
      end
end



return zooi
