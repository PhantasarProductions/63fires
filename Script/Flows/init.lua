--[[
  init.lua
  Version: 18.01.04
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
-- $USE libs/omusic
-- $USE libs/console
-- $USE libs/qgfx


local function iLoadImage(pic,tag)
    console.writeln("Load Image: "..pic,180,0,255)
    return LoadImage(pic,tag)
end

local function titlemusic()
    console.writeln("Starting music if available")
    omusic.play('Music/Special/Angel Share.mp3')
end    

local finit = {}

local iacts = {
         { function() 
                console.writeln("Directory checkup",180,0,255)
                for d in each({"savegames","swap","swap/gameswap","swap/jswap"}) do
                   if not love.filesystem.isDirectory(d) then 
                      assert(love.filesystem.createDirectory(d),"I could not create work directory: "..d)
                      CSay("= Created dir: "..d)
                   end
                end   
           end }   ,
         { function() omusic.swap = 'swap/jswap' CSay("Configured music library swap") end},  
         {iLoadImage,"GFX/Logo/63.png","63logo"}        
      }

      
for i=1,6 do iacts[#iacts+1]={iLoadImage,"GFX/Menu/Item"..i..".png","MenuItem"..i} end      
local iact=0   


iacts[#iacts+1]={titlemusic} -- this MUST always be last!

function finit.draw()
   console.show()
end

function finit.arrive()
   laura.starttext()
   console.csaycolor = {r=0,g=180,b=255}
   CSay("Loading: "..RYANNA_TITLE)
   local w,h = love.graphics.getDimensions( )
   CSay("Screen dimensions: "..w.."x.."..h)
   CSay("")
end

function finit.update()
   iact = iact + 1
   if not iacts[iact] then
      flow.use("mainmenu","script/flows/mainmenu")
      flow.set("mainmenu")
      flow.undef("init")
      return
   end
   local act = iacts[iact]
   local f = act[1]
   local p1 = act[2]
   local p2 = act[3]
   local p3 = act[4]
   f(p1,p2,p3)   
end



return finit
