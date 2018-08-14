--[[
  inventory_h.lua
  Version: 18.08.14
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

-- $IF IGNORE
local IAA
-- $FI

function InitIAA()
    local skill = Var.G("%SKILL")
    gamedata.inventory = gamedata.inventory or { ITM_HERB=12/skill, ITM_ANTIDOTE=6/skill}
    -- $USE Script/Subs/IAA
end


function ItemSelector(env,x,y,click,win,sell)
    InitIAA()
    return IAA:selectitems(env,x,y,click,win,sell)
end

function ItemGet(icode)
    InitIAA()
    return IAA:ItemGet(icode)
end    

function ItemGive(icode,amount)
    InitIAA()
    return IAA:ItemGive(icode,amount)
end

function ItemRemove(icode,amount)
    InitIAA()
    IAA:ItemRemove(icode,amount)
end RemoveItem=ItemRemove

function TreasureChest(tag)
    InitIAA()
    return IAA:TreasureChest(tag)
end        


local lastcash,lastoutcome

function DumpCash(cash)
   local c = cash or (tonumber(Var.C("%CASH")) or 0 )
   if c==0 then return "0oc" end
   local oc,hd,bt=c,0,0
   if c==lastcash then return lastoutcome end
   while oc>=8 do
         oc = oc - 8
         hd = hd + 1
   end
   while hd>=16 do
         hd = hd - 16
         bt = bt + 1
   end
   local ret = ""
   if oc>0 then ret = oc.."oc" end
   if hd>0 then ret = hd.."hd "..ret end
   if bt>0 then ret = bt.."bt "..ret end
   lastcash=c
   lastoutcome=ret
   return ret
end   
