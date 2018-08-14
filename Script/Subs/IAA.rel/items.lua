--[[
  items.lua
  Version: 18.06.11
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

itemsm.itemmax = {50,25,5}

local mayshow = {
                      -- 1 = Healing / Defensive
                      function (item)
                          return item["ITM_Type"] == "Consumable" and (item.Target=='1A' or item.Target=='AA')
                      end,    
                      -- 2 = Offensive
                      function (item)
                          return item["ITM_Type"] == "Consumable" and  item.Target~='1A' and item.Target~='AA'
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

function itemsm:selectitems(env,x,y,aclick,win,selling)
     -- $USE libs/nothing
     local mx,my=love.mouse.getPosition()
     assert(win,"No windowdata")
     assert(win.x and win.y and win.h and win.w,"Window data for items incomplete")
     love.graphics.setFont(fontMiddel)
     self.tab = self.tab or {}
     self.tab[env]=self.tab[env] or 1
     local ot=self.tab[env]
     local owt=allowtabs[ot]
     invheaders[ot] = invheaders[ot] or LoadImage("GFX/Inventory_Head/"..ot..".png"); QHot(invheaders[ot],"ct")
     pm[ot]=pm[ot] or 0
     p [ot]=p [ot] or 1
     local ip = 0
     local pmx = math.floor((win.h-60)/30)
     local py=35
     local helptext
     white()
     DrawImage(invheaders[ot],win.x+(win.w/2),win.y+3)
     if click(win.x,win.y,win.h,35,aclick,"Click here to see other pages") then
        self.tab[env] = self.tab[env] + 1
        if self.tab[env]>#allowtabs[env] then self.tab[env]=1 end
        ot = self.tab[env]
        pm[ot]=pm[ot] or 0
        p [ot]=p [ot] or 1
     end
     for icode,num in spairs(gamedata.inventory) do
         local item = self:ItemGet(icode)
         if mayshow[ot](item) then
            ip = ip + 1
            if ip>pm[ot] and ip<pm[ot]+pmx then
               helptext = self:itemhelp(item)
            end
            white()
            love.graphics.setFont(fontMiddel)
            love.graphics.print(item.Title,win.x+10,win.y+py)
            if selling then
               if item.ITM_Sellable and item.ITM_ShopPrice and item.ITM_ShopPrice>0 then
                  love.graphics.setFont(monofontmiddel)
                  color(255,180,0)
                  love.graphics.print(DumpCash(math.ceil(item.ITM_ShopPrice/3)),win.x+10+(win.w/3),win.y+py)
                  helptext=helptext.."\n \nIf you click now you'll sell this item for: "..DumpCash(math.ceil(item.ITM_ShopPrice/3))
               else
                  red()
                  love.graphics.print("Cannot sell!",win.x+10+(win.w/3),win.y+py)   
                  helptext=helptext.."\n \nYou cannot sell this item"
               end   
            end
            color(0,180,255)
            diginum(num,win.x+win.w-20,win.y+py)
            if click(win.x,win.y+py,win.w,30,aclick,helptext,nothing) then return icode end
            py = py + 35 -- Must be last before the "end" of the 'mayshow' if!!!
         end
     end
end

function itemsm:ItemGive(itemcode,amount)
       local ic=itemcode:upper()
       local skill=Var.G("%SKILL")
       if not (prefixed(ic,"ITM_") or prefixed(ic,"FISH_")) then
          if JCR_Exists("JWL_"..ic) then
             ic="JWL_"..ic
          else 
             ic="ITM_"..ic
          end 
       end
       local item=self:ItemGet(ic)
       if gamedata.inventory[ic] and gamedata.inventory[ic]>=self.itemmax[skill] then return false,item.Title end -- Max reached
       gamedata.inventory[ic] = (gamedata.inventory[ic] or 0) + (amount or 1)
       if gamedata.inventory[ic]>=self.itemmax[skill] then gamedata.inventory[ic] = self.itemmax[skill] end
       return true,item.Title
end

function itemsm:ItemRemove(itemcode,amount,crashcheck)
  local ic=itemcode:upper()
  local am=amount or 1
  assert(not( crashcheck and (gamedata.inventory[ic] or 0) < am ),'Trying to remove items that are not there') 
  if not gamedata.inventory[ic] then return end
  gamedata.inventory[ic] = gamedata.inventory[ic] - am
  if gamedata.inventory[ic]<=0 then gamedata.inventory[ic]=nil end  
end

function itemsm:TreasureChest(tag)
       -- $USE libs/audio
       local map = field:GetMap()
       local obj = map.map.TagMap[map.layer][tag]
       assert(obj,"Trying to open non-existent treasure chest: "..tag)
       local icode = obj.DATA.ITEM
       local msg,msgcol
       local coord = {obj.COORD.x-field.cam.x,obj.COORD.y-field.cam.y}
       if obj.FRAME==2 then return end
       obj.FRAME=2
       if not prefixed(icode:upper(),"CASH:") then
          local success,name = self:ItemGive(icode)
          if success then
             QuickPlay("Audio/Gen/Pickup.Wav")
             MiniMSG(name.." obtained",{180,255,0},coord)
             field:permawrite("field:laykill('"..map.layer.."','"..tag.."')")
          else
             MiniMSG(name.." overloaded",{255,0,0},coord)
             QuickPlay("Audio/Gen/NoWay.mp3")
             obj.FRAME=1       
          end
       else
          local getcash=tonumber(right(icode,#icode-5)) or 1
          local cash=Var.G("%CASH")
          if cash>=128000000 then 
             QuickPlay("Audio/Gen/NoWay.mp3")
             MiniMSG("Sorry, you're getting too rich!",{255,0,0},coord)
             --field:permawrite("field:laykill('"..map.layer.."','"..tag.."')")
             obj.FRAME=1
          else
             QuickPlay("Audio/Gen/ChaChing.ogg")
             MiniMSG(DumpCash(getcash).." obtained!",{180,255,0},coord)
             cash=cash+getcash
             if cash>128000000 then cash=128000000 end
             Var.D('%CASH',cash) -- This is a safer route than just an Inc routine. This did lead to bugs in past games.
             field:permawrite("field:laykill('"..map.layer.."','"..tag.."')")
          end               
       end
end


return itemsm
