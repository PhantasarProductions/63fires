--[[
  abilities.lua
  Version: 18.03.09
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
local abl={}
local data = {}

gamedata.learned = gamedata.learned or {}
local learned = gamedata.learned

function abl:selectabilities(env,ch,aclick,win)
     local mx,my=love.mouse.getPosition()
     learned[ch] = learned[ch] or {}
     local has = learned[ch]
     assert(win,"No windowdata")
     assert(win.x and win.y and win.h and win.w,"Window data for items incomplete")
     love.graphics.setFont(fontMiddel)
     local ly = 25
     local hover
     data[ch] = data[ch] or Use("Script/Data/CharAbility/"..ch..".lua")
     for key,abldata in spairs(data[ch].abl) do
         has[key] = has[key] or abldata.start
         hover = mx>win.x and mx<win.x+win.h and my>win.y+ly and my<win.y+ly+30
         local sname,sdesc,sap 
         if has[key] then
               
               abldata.item = abldata.item or ItemGet('ABL_HERO_'..ch.."_"..key)
               sname=abldata.item.Title
               sap=abldata.item.ABL_APCost or 0
               sdesc=self:itemhelp(abldata.item)
         else
               sname="---"
               sap=0
               sdesc=data[ch]:TutTeach(key)
         end
         white()
         if hover then color(0,180,255) end
         love.graphics.setFont(fontMiddel)
         love.graphics.print(sname,win.x+10,ly)
         color(0,128,255)
         if hover then color(0,180,255) end
         if sap and sap>0 then diginum(sap,win.x+win.w-20,ly) end
         if click(win.x,win.y+ly,win.w,30,aclick,sdesc,nothing) then return key end
         ly = ly + 35
     end
end
abl.selectability=abl.selectabilities

return abl
