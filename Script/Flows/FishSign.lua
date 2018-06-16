--[[
  FishSign.lua
  Version: 18.06.16
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
local fs = {}

-- $USE libs/qgfx
-- $USE libs/itext
-- $USE script/subs/screen
local hout = LoadImage("GFX/General/Wood.png")
local houtquad = love.graphics.newQuad(0,0,screen.w,screen.h,ImageSizes(hout))
local spots = Use("Script/Data/General/FishSpot.lua")
local fish  = Use("Script/Data/General/Fish.lua")
local lf = GetBoxTextFont()
itext.setfont(lf)

fs.spot = "?"

WrapImage(hout,'repeat','repeat')

function fs:odraw()
   assert(fs.spot and fs.spot~="?","No fish spot defined")
   Color(100,100,100)
   QuadImage(hout,houtquad,0,0)
   gamedata.fishscore = gamedata.fishscore or {}
   gamedata.fishmonster = gamedata.fishmonster or {}
   local fhave=gamedata.fishscore
   local mhave=gamedata.fishmonster
   local spot=spots[fs.spot]   
   assert(spot,"Spots "..fs.spot.." doesn't exist")
   color(0,180,255)   
   itext.write(spot.Name,screen.w/2,5,2,0)
   for i=1,10 do
       local y=i*40
       -- Fish
       local cfish = spot['Fish'..i]
       local cmonster = spot['Monster'..i]
       if cfish=="-" then
       elseif fhave[cfish] then
          Color(255,255,0)
          itext.write(fish[cfish].Name,10,y)
       else
          Color(120,120,0)
          local q=""
          for i=1,#fish[cfish].Name do q=q.."?" end
          itext.write(q,10,y)
       end
       -- Monster
       if cmonster=="-" then
       elseif mhave[cmonster] then
          Color(255,0,0)
          itext.write(cmonster,screen.w/2,y)
       else
          Color(120,120,0)
          local q=""
          for i=1,#("komt later") do q=q.."?" end
          itext.write(q,screen.w/2,y)
       end
   color(0,180,255)   
   itext.write(spot.Name,screen.w/2,5,2,0)
   itext.write(spot.Description,screen.w/2,screen.h-200,2,0)     
   StatusBar(false,false) 
   if mousehit(1) then flow.set(field) end
   end
end

return fs
