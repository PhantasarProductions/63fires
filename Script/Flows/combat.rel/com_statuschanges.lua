--[[
  com_statuschanges.lua
  Version: 19.01.23
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
local csc = {}

csc.statusdata = { Death = Use('script/data/combat/statuschanges/death.lua') }

function csc:statuses(chtag)
     local frame = 0
     local keys = {}
     local values = {}
     local si = 0
     TrickAssert(self.fighters[chtag],"character error",{tag=chtag}) --,fighters=self.fighters})
     self.fighters[chtag].statuschanges = self.fighters[chtag].statuschanges or {} 
     for k,v in spairs(self.fighters[chtag].statuschanges) do
         si = si + 1
         keys[si]=k
         values[si]=v -- values
     end
     return function()
         frame = frame + 1
         if (not rpg:CharExists(chtag)) then
            console.write("WARNING! ",180,100,0)
            console.write("Char: "..chtag.."; Frame: "..frame.."; Character no longer exists! Aborting foreach loop!\n",255,255,0) 
            return nil 
         end         
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

function csc:StatusTagDRAW(tag,stage)
   -- CSay("Status: "..tag)
   if not self.fighters[tag] then
      --[[ debug
      console.Write  ("NOTE!!! ",255,0,0)
      console.Write  ("There is no fighter tagged ",255,255,0)
      console.WriteLn(tag,0,180,255)
      -- ]] -- end debug 
      return 
   end
   for _,std in self:statuses(tag) do
       if std ["tag"..stage..'draw'] then 
          std ["tag"..stage..'draw'](self,tag)
          -- CSay("tag"..stage..'draw on '..tag) -- debug
       --[[ debug
       else 
          CSay("There is no ".."tag"..stage..'draw'.." function in this status")
       -- ]] 
       end
   end
end   

function csc:StatusTagPreDraw(tag)
    self:StatusTagDRAW(tag,'pre')
end         

function csc:StatusTagPstDraw(tag)
    self:StatusTagDRAW(tag,'post')
end         


function csc:StatusProperty(ch,prop)
    for _,std in self:statuses(ch) do
        if std[prop] then return true end
    end
    return false
end

function csc:StatusPropertyValues(ch,prop)
    local t = {}
    for _,std in self:statuses(ch) do
        if std[prop] then t[#t+1]=std[prop] end
    end
    local i=0
    return function()
        i = i + 1
        return t[i]
    end
end        

function csc:StatusRemoveByProperty(ctag,prop)
    local kill = {}
    for st,std in self:statuses(ctag) do
        if std[prop] then kill[#kill+1]=st end
    end
    local c = self.fighters[ctag]
    for killstatus in each(kill) do
        c[killstatus]=nil
    end
end

function csc:StatusExecuteProperty(ctag,prop)
    local done = false        
    for st,std in self:statuses(ctag) do
        if std[prop] then done = std[prop](self,ctag) or done end
    end
    return done
end

return csc
