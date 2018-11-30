--[[
  Fishing.lua
  Version: 18.11.30
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
gamedata.fishlevel  = gamedata.fishlevel or 1
gamedata.fishcaught = gamedata.fishcaught or 0

local debug = false

local stage
local bed
local caught
local countdown
local vis = {}
local chk={'Fish','Monster'}
local shot
local timer
local range
local fightcount
local pointer = LoadImage('GFX/General/FishPointer.png'); QHot(pointer,'cb')
local pointx,pointd

-- "Slave" is a regular term in the world of computers, so any "slave" activists, put the axes down.... slowly! 
local function HideSlaves()
   local map = field:GetMap()
   for i=2,4 do
       local slave = map.map.TagMap[map.layer][("PLAYER%d"):format(i)]
       if slave then slave.VISIBLE=false end
   end
end

local function ShowSlaves()
   local map = field:GetMap()
   for i=2,4 do
       local slave = map.map.TagMap[map.layer][("PLAYER%d"):format(i)]
       if slave then slave.VISIBLE=true end
   end
end



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
      range=80+(skill*5)
   else 
      assert(fish,"No fish for record: "..sval(fishid))
      rate=math.floor(fish.Rate*(1+(skill/10)))
      range=(10-skill)+(gamedata.fishlevel-rate)      
   end
   local rnd = love.math.random(1,gamedata.fishlevel)
   caught=bed[fi]
   return rnd>rate or rnd==15
end

local function extracatchdata()
   local rand = love.math.random
   local xcd = {}
   xcd.fish = Fish[caught.catch]
   xcd.fishcode = left(Fish[caught.catch].Fish,#Fish[caught.catch].Fish-4) -- .lua removal, ya know...
   local got,fishname = ItemGive(xcd.fishcode)
   xcd.overloaded = not got
   xcd.name=fishname
   xcd.length=rand(xcd.fish.MinLen,xcd.fish.MaxLen)
   xcd.score=math.ceil(xcd.length/10)*xcd.fish.ScoreByDm
   xcd.new=not gamedata.fishscore[caught.catch]
   if (gamedata.fishscore[caught.catch] or 0)<xcd.score then
      xcd.record = not xcd.new
      gamedata.fishscore[caught.catch] = xcd.score
   end
   local total=0
   for _,t in pairs(gamedata.fishscore) do total = total + t end
   while gamedata.fishlevel<15 and total>2^(gamedata.fishlevel+1) do gamedata.fishlevel=gamedata.fishlevel+1 end
   gamedata.fishcaught = gamedata.fishcaught + 1
   xcd.total=total   
   return xcd
end   

local fightchain = {
     Fish =    {[true]='catch',[false]='fail'},
     Monster = {[true]='mster',[false]='fail'}
}

local stages = {
      wacht = function()
                local skill = Var.G('%SKILL')
                local map = field:GetMap()
                local Ryanna = map.map.TagMap[map.layer].PLAYER1
                assert(Ryanna,"Where's Ryanna?")
                Ryanna.TEXTURE="GFX/PlayerSprites/Ryanna.Fish.png"
                countdown=countdown-1
                if countdown<=0 then
                   if bite() then stage='vecht' else stage='fail' end
                   countdown=5
                   fightcount=280/skill
                   flushkeys()                   
                end
                kthura.drawmap(map.map,map.layer,field.cam.x,field.cam.y)
                if debug then love.graphics.print("CD: "..countdown,0,0) end
                StatusBar(false,false)  
                timer:wait(1)
              end,
      vecht = function()
                -- $USE Script/Subs/screen
                --error("No fight routine yet!")
                local map = field:GetMap()
                kthura.drawmap(map.map,map.layer,field.cam.x,field.cam.y)
                StatusBar(false,false)
                local tr = {50-(range/2),50+(range/2)}
                local bx = math.floor(screen.w/2)-50
                local by = math.floor(screen.h/2)
                local font=GetBoxTextFont()
                color(0,0,140,180)
                Rect(0,0,screen.w,screen.h)
                color(100,100,100)
                Rect(bx,by,100,25)
                color(180,100,0)
                Rect(bx+tr[1],by,range,25)
                color(0,180,255)
                itext.setfont(font)
                itext.write("PLAYER vs FISH",bx,by-20,2,1)
                white()
                pointd = pointd or 4
                pointx = (pointx or 0) + pointd
                if pointx<=0   then pointd= 4 end
                if pointx>=100 then pointd=-4 end
                DrawImage(pointer,bx+pointx,by)
                itext.write("Time: "..fightcount,bx,by+100,2,2)
                fightcount = fightcount - 1
                if mouseclick(1) or fightcount<=0 then
                   stage = fightchain[caught.ctype][pointx>tr[1] and pointx<tr[2]]    
                   flushkeys()               
                end
                timer:wait(.05)
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
                    ShowSlaves()
                 end
                 timer:wait(1)   
              end,
      catch = function()
                local cfish=Fish[caught.caught]
                -- $USE Script/Subs/screen
                --error("No fight routine yet!")
                local map = field:GetMap()
                local Ryanna = map.map.TagMap[map.layer].PLAYER1
                Ryanna.TEXTURE="GFX/PlayerSprites/Rynna.Catch.png"
                kthura.drawmap(map.map,map.layer,field.cam.x,field.cam.y)
                StatusBar(false,false)
                local font=GetBoxTextFont()
                color(35,70,140,180)
                Rect(0,0,screen.w,screen.h)
                caught.xdata = caught.xdata or extracatchdata()
                color(180,255,0,255) itext.write('CATCH',5,5)
                local sdy=35
                local function sd(f,d) 
                    color(255,255,255) itext.write(f,5,sdy)
                    color(  0,180,255) itext.write(d,screen.w/2,sdy)
                    sdy=sdy+30
                end
                if caught.xdata.new then color(255,180,0) itext.write("NEW!",screen.w-5,sdy,1,0) end
                sd('Fish:'  ,caught.xdata.name)                
                sd('Length:',caught.xdata.length.."cm")
                sd('Average:',caught.xdata.fish.MinLen.."cm - "..caught.xdata.fish.MaxLen.. "cm")
                if caught.xdata.record then color(255,180,0) itext.write("NEW RECORD!",screen.w-5,sdy,1,0) end
                sd("Score:", caught.xdata.score)
                sd("Total:", caught.xdata.total)
                sd("Caught:",gamedata.fishcaught)
                sd("Rank:",fishinglevels[gamedata.fishlevel])
                --error("You caught a "..caught.catch..", but catching itself is not yet scripted")
                if caught.xdata.overloaded then
                   sd("Note:","The fish is calculated in your fish statistics, but")
                   sd("","as you've reached the max amount for this item it's NOT added to your inventory.")
                end
                if mousehit(1) then flow.set(field) ShowSlaves() end
              end,
      mster = function()
                   local map = field.getmap()
                   local Maps = map.map
                   local skill = Var.G('%SKILL')
                   local countparty = #RPGParty --CountPartyMembers()
                   local rand = love.math.random
                   local arena = FishSpot.Arena or Maps.Meta.Arena or ""; if not suffixed(arena:lower(),".png") then arena = arena..".png" end
                   local combatdata = {foes={caught.caught}, arena=arena}
                   ShowSlaves()
                   StartCombat(combatdata)
                   -- error("Monster catch not scripted yet")
              end        
              
}
function vis:LoadSpot(aspot)
   -- $USE libs/klok
   bed = {}
   local spot = aspot:upper()
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
   HideSlaves()
end

function vis:odraw()
   -- error("Sorry, can't fish yet!")
   stages[stage]()
end



return vis


-- In case you don't speak Dutch... "vis" means "fish" in Dutch :P                          
