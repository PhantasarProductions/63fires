--[[
  com_statuschanges.lua
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
local csc = {}

csc.statusdata = { Death = Use('script/data/combat/statuschanges/death.lua') }

function csc:statuses(chtag)
     local frame = 0
     local keys = {}
     local values = {}
     local si = 0
     TrickAssert(self.fighters[chtag],"character error",{tag=chtag,fighters=self.fighters})
     self.fighters[chtag].statuschanges = self.fighters[chtag].statuschanges or {} 
     for k,v in spairs(self.fighters[chtag].statuschanges) do
         si = si + 1
         keys[si]=k
         values[si]=values
     end
     return function()
         frame = frame + 1
         if rpg:Points(chtag,"HP").Have==0 then
            if frame<2 then return "Death",csc.statusdata.Death end    
            return nil
         end
         return keys[frame],values[frame]
     end
end


function csc:StatusTDRAW(stage)
    for k,_ in pairs(self.fighters) do
        for _,std in self:statuses(k) do
            if std[stage..'draw'] then std[stage..'draw'](self,k) end
        end
    end
end

function csc:StatusPreDraw()
    self:StatusTDRAW('pre')
end         

function csc:StatusPostDraw()
    self:StatusTDRAW('post')
end         


return csc
