--[[
  init.lua
  Version: 18.04.21
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


-- $USE Script/Subs/Error

local function iLoadImage(pic,tag)
    if suffixed(pic:upper(),".JPBF") then
       console.writeln("Load Image Bundle: "..pic,180,0,255)
    else   
       console.writeln("Load Single Image: "..pic,180,0,255)
    end   
    return LoadImage(pic,tag)
end

local function titlemusic()
    console.writeln("Starting music if available")
    omusic.play('Music/Special/Angel Share.mp3')
end    

local function netconfig()
     mynet = GAHD_get('DATA/GJ_ANNA/GJ_ANNA.ghd')
     mynet[    "ANNA.AWARDS"] = GAHD_get("DATA/GJ_ANNA/Awards_Anna.GHD").data
     mynet["GAMEJOLT.AWARDS"] = GAHD_get("DATA/GJ_ANNA/Awards_GameJolt.GHD").data
     -- print ( serialize('mynet',mynet))
     
end

local function SerifFontLoad()
    fontGroot = love.graphics.newFont(JCR_D('Fonts/CHANTICL.TTF'),40)
    fontMiddel = love.graphics.newFont(JCR_D('Fonts/CHANTICL.TTF'),20)
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
         { CSay, "Configuring networks"},  {netconfig},
         { function() omusic.swap = 'swap/jswap' CSay("Configured music library swap") end},  
         {iLoadImage,"GFX/Logo/63.png","63logo"},
         {iLoadImage,"GFX/General/Arrow_right.png",'NEXT'},
         --[[
         {iLoadImage,"GFX/PlayerSprites/Ryanna.South.jpbf","RYANNA.S"}  ,
         {iLoadImage,"GFX/PlayerSprites/Ryanna.North.jpbf","RYANNA.N"}  ,
         {iLoadImage,"GFX/PlayerSprites/Ryanna.West.jpbf", "RYANNA.W"}  ,
         {iLoadImage,"GFX/PlayerSprites/Ryanna.East.jpbf", "RYANNA.E"}  ,
         ]]
         {CSay,"Loading Fonts/CHANTICL.TTF"},
         {SerifFontLoad}      
      }

      
for i=1,6 do iacts[#iacts+1]={iLoadImage,"GFX/Menu/Item"..i..".png","MenuItem"..i} end      
local iact=0   


iacts[#iacts+1]={titlemusic} -- this MUST always be last!

function finit.draw()
   console.show()
end

function finit.arrive()
   PreNote(function(one,two) console.write(one,255,255,0) console.writeln(two,0,255,255) end)
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
