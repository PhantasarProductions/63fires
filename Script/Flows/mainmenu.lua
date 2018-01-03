--[[
  mainmenu.lua
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
-- $USE libs/nothing

local mm = {}

local w,h = love.graphics.getDimensions( )

mm.allowload = true -- This only goes for the main menu. This will help me to load debug saves.


mm.items = {}
for i=1,6 do 
  HotCenter("MenuItem"..i)
  mm.items[i] = {enabled=true,y=(i*100)+w,goy=math.ceil(i*((h*.75)/10))+200}
end
if love.filesystem.isFile("savegames/dir.lua") then
  mm.p = 2
else
  mm.p = 1
  mm.items[2].enabled = false
end  
HotCenter("63logo")

mm.items[1].act = function()
      flow.use("newgame","script/flows/newgame")
      flow.set("newgame")
      flow.undef("mainmenu")
end      

mm.items[2].act = function()
      flow.use("continue","script/flows/continue")
      flow.set("continue")
      flow.undef("mainmenu")
end      
   

mm.items[3].act = function() 
    local url = "https://tricky.gamejolt.io/63fires/"
    local success = love.system.openURL( url )
    if not success then
       love.window.showMessageBox( RYANNA_TITLE, "Somehow the system failed to access: "..url, error, false )
    end   
end    

mm.items[4].act = function() 
    local url = "https://discord.gg/RU3V6YU"
    local success = love.system.openURL( url )
    if not success then
       love.window.showMessageBox( RYANNA_TITLE, "Somehow the system failed to access: "..url, error, false )
    end   
end    

mm.items[5].act = function() 
    local url = "https://github.com/PhantasarProductions/63fires/issues"
    local success = love.system.openURL( url )
    if not success then
       love.window.showMessageBox( RYANNA_TITLE, "Somehow the system failed to access: "..url, error, false )
    end   
end    
-- --[[
mm.items[6].act = function()
    quitdontask=true
    love.event.quit()
end    
--]]

function mm.mousepressed(x,y,but)
   (mm.items[mm.p].act or nothing)()
end



function mm.keypressed(key,scan)
  if key=='escape' then
     love.event.quit()
  end
end

function mm.draw()
  local x, y = love.mouse.getPosition( )
  --if keyhit('escape') then love.event.quit() end
  cls()
  white()
  DrawImage('63logo',w/2,150)
  local t = tick()
  for i,item in pairs(mm.items) do
      if y>item.y-10 and y<item.y+10 and item.enabled then mm.p=i end
      if mm.p==i then 
        white()
      elseif not item.enabled then
        color(50,50,50)
      else
        color(100,100,150)
      end
      if t then
        if item.y>item.goy then
           local spd = math.ceil((item.y-item.goy)/10)
           if spd>10 then spd=10 end
           item.y = item.y - spd
        elseif item.y<item.goy then
           item.y=item.goy
        end
      end
      DrawImage('MenuItem'..i,w/2,item.y)
  end  
  white()
  love.graphics.print("(c) Jeroen P. Broks",(w/2)-150,h-20)
end

function mm.arrive()
  flushkeys()
end


return mm
