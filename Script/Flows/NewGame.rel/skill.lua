--[[
  skill.lua
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
local sk = { nomerge = true }

local skills = {}

local function loadskill()
     local w,h = love.graphics.getDimensions( )
     for i=1,3 do
         skills[i]={ img = LoadImage("GFX/Skills/"..i..".png"), x=(w/4)*i }
         HotCenter(skills[i].img)
     end
end loadskill()

skills[1].desc = {"In the easy mode, the game is heavily simplefied","It was designed for beginners in the RPG genre only","","Or for yellow chickens who don't like a challenge.","","If you have any experience in the RPG genre you may consider this mode 'too easy'."}
skills[2].desc = {"In the casual mode the game will be the way it was meant to be","Most players, should play the game in this difficulty setting, to experience it the way it was intended"}
skills[3].desc = {"If it's a hard game want, a hard game you'll get!","Can you finish Final Fantasy X without using the Sphere Grid?","Is Breath of Fire DQ too easy for you?","You want an impossible challenge?","Then this mode is for you!"}

skills[1].name = "Easy"
skills[2].name = "Casual"
skills[3].name = "Hard"

local pk = 0

function sk.draw()
    local x, y = love.mouse.getPosition( )
    Cls()
    console.sback()
    love.graphics.print("How tough are you?",30,30)
    pk=0    
    for i,s in pairs(skills) do
        DrawImage(s.img,s.x,120)
        if x>s.x-100 and x<s.x+100 and y>90 and y<150 then
           love.graphics.print(s.name,x+30,y)
           for n,l in pairs(s.desc) do
               love.graphics.print(l,10+n,(20*n)+200)
               pk=i               
           end    
        end    
    end
end    

function sk.mousepressed()
    if pk==0 then return end
    Var.D("%SKILL",pk)
    Var.D("$SKILLNAME",skills[pk].name)
    flow.get().gostage("network")
end    


return sk
