--[[
  Fishing.lua
  Version: 18.03.07
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
local Fish,FishSpot -- It's done this way and not through $LOCALUSE in order to set my syntax highlight settings right ;)
-- $USE Script/Data/General/Fish.lua
-- $USE Script/Data/General/FishSpot.lua

local fishinglevels = {
                          "Noob",
                          "Beginner",
                          "Beginner+",
                          "Beginner++",
                          "Rookie",
                          "Rookie+",
                          "Rookie++",
                          "Master Fisher",
                          "Master Fisher+",
                          "Master Fisher++",                         
                          "Master of Angling",
                          "Master of Angling+",
                          "Master of Angling++",
                          "Master of Angling+++",
                          "Lady Neptuna"
                          }
                          
gamedata.fishscore = gamedata.fishscore or {}
local fishscore = gamedata.fishscore
gamedata.fishlevel = gamedata.fishlevel or 1

local debug = false

local stage
local bed
local countdown
local vis = {}
local chk={'Fish','Monster'}
local shot
local timer

local function bite() 
   local rand = love.math.random
   local skill = Var.G('%SKILL')
   local fi = rand(1,math.floor(#bed*(skill*.75))+1)
   if fi>#bed then return end
   local fishid=bed[fi].catch
   local fish=Fish[fishid]
   local rate ; 
   --CSay(serialize('bed',bed)) -- debug
   if bed[fi].ctype=='Monster' then 
      rate=0 
   else 
      assert(fish,"No fish for record: "..sval(fishid))
      rate=math.floor(fish.Rate*(1+(skill/10)))      
   end
   local rnd = love.math.random(1,gamedata.fishlevel)
   return rnd>rate or rnd==15
end

local stages = {
      wacht = function()
                local map = field:GetMap()
                local Ryanna = map.map.TagMap[map.layer].PLAYER1
                assert(Ryanna,"Where's Ryanna?")
                Ryanna.TEXTURE="GFX/PlayerSprites/Ryanna.Fish.png"
                countdown=countdown-1
                if countdown<=0 then
                   if bite() then stage='vecht' else stage='fail' end
                   countdown=5
                end
                kthura.drawmap(map.map,map.layer,field.cam.x,field.cam.y)
                if debug then love.graphics.print("CD: "..countdown,0,0) end
                StatusBar(false,false)  
                timer:wait(1)
              end,
      vecht = function()
                error("No fight routine yet!")
              end,
      fail  = function()
                 local map = field:GetMap()
                 local Ryanna = map.map.TagMap[map.layer].PLAYER1
                 assert(Ryanna,"Where's Ryanna?")
                 Ryanna.TEXTURE="GFX/PlayerSprites/Ryanna.Miss.png"
                 kthura.drawmap(map.map,map.layer,field.cam.x,field.cam.y)
                 StatusBar(false,false)
                 countdown=countdown-1
                 if countdown<=0 then
                    flow.set(field)
                 end
                 timer:wait(1)   
              end,
      catch = function()
              end,
      mster = function() 
              end        
              
}
function vis:LoadSpot(spot)
   -- $USE libs/klok
   bed = {}
   assert(FishSpot[spot],"There is no fishing spot named: "..sval(spot))
   for ft in each(chk) do
       for i=1,10 do
           local s = FishSpot[spot][ft..i]
           if s~="-" then bed[#bed+1]={catch=s,ctype=ft} end
       end
   end
   stage='wacht'
   countdown=5 --2500
   timer=klok:CreateTimer()
   shot=nil
end

function vis:odraw()
   -- error("Sorry, can't fish yet!")
   stages[stage]()
end



return vis


-- In case you don't speak Dutch... "vis" means "fish" in Dutch :P                          
