--[[
  flw_end.lua
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
local einde = {}

function einde:chk_victory_default()
   local checkup = {Foe=true,Hero=true}
   -- for fuck,you in spairs(self) do console.write(type(you).." ",255,180,0) console.writeln(fuck,0,180,255) end
   for tag,data in pairs(self.fighters) do
       local defeated = false
       for _,stdata in self:statuses(tag) do
           defeated = defeated or stdata.defeated
       end
       checkup[data.group] = checkup[data.group] and defeated
   end 
   if checkup.Hero then return "Foe" end
   if checkup.Foe  then return "Hero" end
   -- Important to note, if BOTH parties are defeated it counts as a victory for the foes, because this has to render a "game over" screen after all.
end

function einde:victory_default()
    -- $USE script/subs/screen 
    -- $USE libs/deg2rad
    LoadImage("gfx/combat/end/you_win.png","YOUWIN",true)
    HotCenter("YOUWIN")
    self.vic_sc=(self.vic_sc or 0) 
    self.vic_dg=(self.vic_dg or 180) 
    self.vic_tm=(self.vic_tm or 200)
    if self.vic_dg >= 360 then       
       self.vic_tm  = self.vic_tm - 1
       if self.vic_tm<=0 then self.flow="terminate_combat" end
    else       
       self.vic_sc = self.vic_sc + .02
       self.vic_dg = self.vic_dg +   2
    end
    DrawImage("YOUWIN",screen.w/2,screen.h/2,1,deg2rad(self.vic_dg),self.vic_sc,self.vic_sc)
     --[[
       itext.write('Degrees: '..self.vic_dg,5,5)
       itext.write('InRad:   '..deg2rad(self.vic_dg),5,35)
       itext.write('Scale:   '..self.vic_sc,5,65)
       itext.write('EndTime: '..self.vic_tm,4,95)
    --]]
end


function einde:flow_victory()
    self["victory_"..(self.combatdata.victory or 'default')](self)
end

function einde:DidAnyoneWin()
    local victor = self['chk_victory_'..(self.combatdata.victorycheck or "default")](self)
    if victor=="Hero" then self.flow='victory' end
    if victor=='Foe'  then self.flow='defeat'  end
end

return einde
