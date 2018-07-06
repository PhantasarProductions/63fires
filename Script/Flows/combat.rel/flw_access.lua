--[[
  flw_access.lua
  Version: 18.07.06
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
local toegang = {}
local skill=Var.G("%SKILL")


function toegang:flow_selectdemon()
   -- $USE script/subs/screen
    local ch=self.invoeren
    -- local i,c,item
    local d,c
    local win = {x=math.floor(screen.w*.05), y=math.floor(screen.h*0.05),w=math.floor(screen.w*.90),h=math.floor(screen.h*70)}     
    Color(0,0,180,180)
    Rect(win.x,win.y,win.w,win.h)
    c = mousehit(1)
    d = TransList(win.x, win.y, win.w, win.h,c)
    if mousehit(2) then self.flow='playerinput' end
    if d then
       self.flow="idle"
       local level = rpg:Stat("Ryanna","Level")
       local APCost = math.ceil(level/({50,10,5})[skill])
       if rpg:Points("Ryanna","HP").Have<APCost then
          combat:TagMessage("Ryanna","Fail!")
          return
       end
       rpg:Points("Ryanna","HP").Have = rpg:Points("Ryanna","HP").Have - APCost
       if skill==1 then
          Var.D("%TRANSMAINTAIN",0)
       else
          Var.D("%TRANSMAINTAIN",math.ceil(level/({1,2,1.25})[skill]))
       end 
       self:RemoveFirstCard()
       self.invoeren=nil
       combat:RyannaTransform(d)              
    end    
end


return toegang
