--[[
  flw_foeinput.lua
  Version: 18.02.07
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
local foei = {}


function foei:alltargets(tabelletje,deadallowed)
    local subtabel = {}
    for k,_ in spairs(tabelletje) do
        if deadallowed or rpg:Points(k,'HP').Have>0 then 
           subtabel[#subtabel+1]=k
        end    
    end
    if #subtabel==0 then return nil end
    return subtabel
end

function foei:randomsingletarget(tabelletje,deadallowed)
    local subtabel = self:alltargets(tabelletje,deadallowed)
    if not subtabel then return nil end
    if #subtabel==0 then return nil end
    return {subtabel[love.math.random(1,#subtabel)]}
end

function foei:randomtarget(myfoe,item)
       local ret
       if     item.Target=='1F' then ret=self:randomsingletarget(self.hero)
       elseif item.Target=='1A' then ret=self:randomsingletarget(self.foe)
       elseif item.Target=='AF' then ret=self:alltargets(self.hero)
       elseif item.Target=='AA' then ret=self:alltargets(self.foe)
       elseif item.Target=='AB' then ret=self:randomsingletarget(self.fighters) -- AB = anybody
       elseif item.Target=='EV' then ret=self:alltargets(self.fighter)
       elseif item.Target=='OS' then ret={myfoe.self} 
       else   error('Unknown target type: '..item.Target) end
       return ret
end


function foei:flow_foeinput()
    local gelukt
    local timeout=20000
    local mytag = self.cards[1].data.tag
    local myfoe = self.fighters[mytag]
    local ai    = rpg:GetData(mytag,"Ai")
    local ailua = "script/data/combat/ai/"..ai..".lua"
    local aifun = Use(ailua)
    repeat
        timeout = timeout - 1
        assert(timeout>0,"Foe input time-out!")
        gelukt = aifun(self,myfoe)
    until gelukt    
    self.nextmove.executor = myfoe.tag
end



return foei
