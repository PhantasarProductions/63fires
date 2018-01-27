--[[
  com_cards.lua
  Version: 18.01.26
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
local ccards = {}

local Cards

function ccards:SetUpCards()
    self.Cards = {}
    self.cards = Cards
    Cards = self.Cards
end    

function ccards:YCards()
    for i=1,25 do
        Cards[i] = Cards[i] or {}
        Cards[i].x=-25
        Cards[i].y=SH+((25-i)*100)        
    end
end

function ccards:CreateOrder()
     self.order = { speedtable = {}, tagorder = {}, iorder = {} }
     local order=self.order
     local sid,strid,group
     -- first set up a table easily usable by spairs.
     -- for group,groupdata in pairs(Fighters) do -- No longer needed
         for tag,data in pairs(groupdata) do
             if prefixed(tag,"FOE_") then group="Foe" else group="Hero" end
             sid = 10000 - RPG.Stat(data.tag,"END_Speed")
             strid = right("00000"..sid,5)
             while order.speedtable[strid] do
                sid = sid + 1 
                strid = right("00000"..sid,5)
             end
             order.speedtable[strid] = {group=group,tag=data.tag}
         end
     --end
     -- And let us now set up the actual work order
     local oid = 0
     for key,fid in spairs(order.speedtable) do
         oid = oid + 1
         order.tagorder[fid.tag]=oid
         order.iorder[oid] = fid
         if fid.group=="Foe" then fid.letter=self.foes[fid.tag].letter end
     end
end

function ccards:SetupInitialCards(adata,empty)
   local cdata = adata or {} 
   self:CreateOrder()
   Cards = Cards or {}
   if empty then ClearTable(Cards) end
   local card,cidx,pi
   for i,data in pairs(self.order.iorder) do
       local goed = true
       goed = goed and not(cdata.initiative and data.group=='Foe')
       goed = goed and not(cdata.ambush     and data.group=='Hero')
       pi   = 0
       if goed then
          pi = pi + 1
          cidx=pi*3
          Cards[cidx] = Cards[cidx] or {}
          card = Cards[cidx]
          card.data=data
          CSay("Defining card: "..cidx) 
          CSay(serialize("card["..cidx.."]",card))
        end
   end
   CSay(serialize('Cards',Cards))
end

function ccards:ResetCards() ccards:SetupInitialCards({},true) end




return ccards
