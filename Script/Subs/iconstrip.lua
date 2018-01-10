--[[
  iconstrip.lua
  Version: 18.01.10
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
-- $USE libs/nothing

local width, height = love.graphics.getDimensions( )
local isquad
local isback
local icons={}
local helpmode --= "craq"

function iconstriphelp() 
   helpmode=not helpmode
   CSay("Help mode is now: "..sval(helpmode))
   --error("WERKT HET NU WEL OF NIET?") 
end
--function cancelhelp() helpmode=false end


function click(x,y,w,h,hit,help,callback)
     local mx,my=love.mouse.getPosition()
     --love.graphics.print(x..","..y.."   "..mx..","..my.."  "..sval(hit).." "..sval(helpmode),x,y) -- debug line
     --if hit and helpmode and callback==iconstriphelp then helpmode=false return end     
     if mx>x and mx<x+w and my>y and my<y+h then
        if helpmode then
           love.graphics.setFont(console.font)
           color(0,0,0,150)
           local ht=mysplit(help,"\n")
           Rect(0,0,width,(#ht*20)+10)
           color(255,255,255,255)
           for i,hl in ipairs(ht) do
               love.graphics.print(hl,5,((i-1)*20)+5)
           end
        end
        if hit then
           if not callback then CSay("WARNING! No callback set for this action") end
           (callback or nothing)()   
           return true
        end
     end 
end



function showstrip()
     white()
     local f = flow.get()
     assert(f.iconstrip,"Hey? There is no iconstrop set for this flow!")
     local is=f.iconstrip
     local x,y=love.mouse.getPosition()
     is.x = is.x or 100
     if x>50 and is.hide and is.x<60 then
        is.x = is.x + 1
     elseif (x<50 or (not is.hide)) and is.x>0  then is.x=is.x-1 end
     isback = isback or LoadImage(console.background)
     isquad = isquad or love.graphics.newQuad(0,0,45,height-120,ImageWidth(isback),ImageHeight(isback))
     if is.back then QuadImage(isback,isquad,0-is.x,0) end
     for i,icon in ipairs(is) do
        local iy = math.floor((i/(#is+2)) * (height-120))
        icons[icon.icon]=icons[icon.icon] or LoadImage('GFX/Buttons/'..icon.icon..'.png')
        DrawImage(icons[icon.icon],2-is.x,iy)
        click(2,iy,40,40,f.clicked,icon.tut,icon.cb)
     end
end     



return true
