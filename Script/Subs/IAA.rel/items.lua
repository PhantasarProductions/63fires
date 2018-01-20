--[[
  items.lua
  Version: 18.01.20
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
local itemsm = {}


local mayshow = {
                      -- 1 = Healing / Defensive
                      function (item)
                          return item["ITM_Type"] == "Consumable" and (item.Target=='1A' or item.Target=='AA')
                      end,    
                      -- 2 = Offensive
                      function (item)
                          return item["ITM_Type"] == "Consumable" and  item.Targe~='1A' and item.Target~='AA'
                      end,    
                      -- 3 = Accesoiry
                      function (item)
                           return item.ITM_Type == "Accesoiry"
                      end,     
                      -- 4 = Key items
                      function (item)
                            return item.ITM_Type == "Key item"
                      end      
                 }

local allowtabs = { field = {1,2,3,4}, sell={1,2,3}, combat={1,2}}

local invheaders = {}
local p,pm={},{}

function itemsm:selectitems(env,x,y,aclick,win)
     -- $USE libs/nothing
     local mx,my=love.mouse.getPosition()
     assert(win,"No windowdata")
     assert(win.x and win.y and win.h and win.w,"Window data for items incomplete")
     love.graphics.setFont(fontMiddel)
     self.tab = self.tab or {}
     self.tab[env]=self.tab[env] or 1
     local ot=self.tab[env]
     local owt=allowtabs[ot]
     invheaders[ot] = invheaders[ot] or LoadImage("GFX/Inventory_Head/"..ot..".png")
     pm[ot]=pm[ot] or 0
     p [ot]=p [ot] or 1
     local ip = 0
     local pmx = math.floor((win.h-60)/30)
     local py=35
     local helptext
     for icode,num in spairs(gamedata.inventory) do
         local item = self:ItemGet(icode)
         if mayshow[ot](item) then
            ip = ip + 1
            if ip>pm[ot] and ip<pm[ot]+pmx then
               helptext = self:itemhelp(item)
            end
            white()
            love.graphics.setFont(fontMiddel)
            love.graphics.print(item.Title,win.x+10,py)
            color(0,180,255)
            diginum(num,win.x+win.w-20,py)
            if click(win.x,win.y+py,win.w,30,aclick,helptext,nothing) then return icode end
            py = py + 35 -- Must be last before the "end" of the 'mayshow' if!!!
         end
     end
end




return itemsm
