--[[
  language.lua
  Version: 18.01.03
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
local lan = {}

lan.nomerge=true


local langs = { NL='Dutch', EN='English'}
local flags = {}
local flagy = {}
local flagx = {}

local function loadflags()
  local w,h = love.graphics.getDimensions( )
  local y=15
  local x=15
  for key,lan in pairs(langs) do
      CSay("Loading image: GFX/Flags/"..lan..".png")
      flags[key] = LoadImage("GFX/Flags/"..lan..".png")
      flagy[key]=y
      flagx[key]=x
      x = x + 350
      if x+350>w then
         x=15
         y=y+200
      end      
  end
end loadflags()      

function lan.draw()
   local w,h = love.graphics.getDimensions( )
   cls()
   console.sback()
   white()
   for key,lang in pairs(langs) do
       DrawImage(flags[key],flagx[key],flagy[key])
   end
   
   love.graphics.print("The language you choose will only affect the scenario",15,h-100)
   love.graphics.print("System messages, menu items, item names and spell names",15,h-80)
   love.graphics.print("will always be in English regardless of the chosen language",15,h-60)
end

function lan.mousepressed(b,x,y)
   local chosen
   print("Did we click a flag?")
   if b~=1 then return end -- left mouse button only, please!
   for key,lang in pairs(langs) do
       print("Checking:",key)
       if x>flagx[key] and x<flagx[key]+300 and y>flagy[key] and y<flagy[key]+150 then chosen=key end
   end
   if chosen then
      flow.get().gostage("skill")
      Var.D("$LANG",chosen)
      CSay("Language set to: "..chosen)
      print(Var.S("Language is now set to $LANG!"))
  end    
end


return lan
