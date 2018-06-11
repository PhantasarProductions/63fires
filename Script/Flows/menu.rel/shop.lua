--[[
  shop.lua
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
local width, height = love.graphics.getDimensions(  )
local shop = { nomerge=true, modes={} }
--local stats = {"Power","Defense","Intelligence","Resistance","Speed","Accuracy","Evasion"} --,"HP","AP","Awareness"}

local skill = Var.G("%SKILL")
shop.mode = 'buy'

shop.iconstrip = {
     {icon='buy',tut='Buy items',cb=function() shop.mode='buy' end},
     {icon='sell',tut='Sell items',cb=function() shop.mode='sell' end},
     {icon='help',tut="How does it all work!",cb=iconstriphelp}
}

local iaawin = {y=0,h=height-140}

local allowprefixes = {'ITM_'}
local stock

function shop:load(shopfile)
    stock = Use('Script/Data/Shops/'..shopfile..".lua")
end

local function buy(itm)
   -- $USE libs/audio
   local item = ItemGet(itm)
   local max = IAA.itemmax[skill]
   local cash = Var.G("%CASH")
   if (gamedata.inventory[itm] and gamedata.inventory[itm]>=max) or cash<item.ITM_ShopPrice then
       QuickPlay("Audio/Gen/NoWay.mp3")
       return
   end
   QuickPlay("Audio/Gen/ChaChing.ogg")
   Var.D("%CASH",cash-item.ITM_ShopPrice)
   gamedata.inventory[itm] = (gamedata.inventory[itm] or 0) + 1       
end

local function sell(itm)
   -- $USE libs/audio
   local item = ItemGet(itm)
   --local max = IAA.itemmax[skill]
   local cash = Var.G("%CASH")
   QuickPlay("Audio/Gen/ChaChing.ogg")
   Var.D("%CASH",cash+math.ceil(item.ITM_ShopPrice/skill))
   gamedata.inventory[itm] = (gamedata.inventory[itm] or 0) - 1
   if gamedata.inventory[itm]<=0 then gamedata.inventory[itm]=nil end
end             


function shop.modes.buy(x,w,ch,clicked)
    for i=1,20 do
        -- CSay(i) -- debug! MUST be "remmed" when in release form.        
        local allow
        local itemcode = stock["Slot"..i]:upper()
        local item,num
        local py=i*35
        for ap in each(allowprefixes) do allow = allow or prefixed(itemcode,ap) end
        if allow then
           item = ItemGet(itemcode)
           num = gamedata.inventory[itemcode] or 0
           white()
           love.graphics.setFont(fontMiddel)
           love.graphics.print(item.Title,x+10,py)
           ember()
           love.graphics.setFont(monofontmiddel)
           love.graphics.print(DumpCash(item.ITM_ShopPrice),x+(w/3),py)
           color(0,180,255)
           diginum(num,x+w-20,py)
           local tut = IAA:itemhelp(item).."\n \nClicking now will let you buy this item for: "..DumpCash(item.ITM_ShopPrice)
           click(x,py,w,30,clicked,tut,buy,itemcode)           
        end
    end
   
end

function shop.modes.sell(x,w,ch,clicked)
       iaawin.x=x
       iaawin.w=w
       local i = ItemSelector('sell',x,0,clicked,iaawin,true)
       if i then sell(i) end
end


return shop
