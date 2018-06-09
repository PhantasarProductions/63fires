--[[
  SaveLoadScreen.lua
  Version: 18.06.09
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
-- $USE libs/console

local SLS = {}

local scw,sch = love.graphics.getDimensions( )
local eh = (sch-150)/15
local hover = nil
local todo
local font = GetBoxTextFont()
itext.setfont(font)

local pages

if love.filesystem.isFile("savegames/dir.lua") then
   local fd = love.filesystem.load("savegames/dir.lua")
   assert(fd,"Illegal savegame directory!")
   pages = fd()
else
   pages = {page=1}   
end   

function SLS.todo(t) todo=t end

function SLS.mousepressed(b,x,y)
    CSay(b.."."..x.."."..y)
    if b==2 then 
       if     todo=='SAVE' then flow.set(field)
       elseif todo=='CONTINUE' then flow.set("mainmenu")
       else   error("Where do you want me to go today?") end 
       return end
    if not hover then return end
    if todo =='SAVE' then
       local m=field:getmap()
       local tit = m.map.Meta.Title
       local lvl = rpg:Stat('Ryanna','Level')
       pages[pages.page][hover] = "Level "..lvl.." - "..Var.C("$PLAYTIME").." - "..tit
       love.filesystem.write('savegames/dir.lua',serialize('local ret',pages).."\n\nreturn ret")
       Save("Page"..pages.page.."_Slot"..hover)
       CSay("The game has been saved!")
       flow.set(field)
    elseif todo=='CONTINUE' then
       if not pages[pages.page][hover] then return end -- nothing to do... slot's empty!
       local Load = Use("script/subs/loadgame")
       Load("Page"..pages.page.."_Slot"..hover)
       flow.undef("mainmenu")
    else
       error("You know what to do, because I don't!?")
    end   
end

function SLS.keypressed(kc)
   if kc=='pageup' and pages.page>1 then pages.page=pages.page-1 end
   if kc=='pagedown' then
      if pages.page==#pages then
         local cl = love.window.showMessageBox(RYANNA_TITLE, "Do you want to add an extra page to the page list?", {"Yes","No",escapebutton=2})
         if cl==2 then return end
      end
      pages.page=pages.page+1
   end
end

function SLS.draw()
    local mx,my=love.mouse.getPosition()
    white()
    console.sback()
    love.graphics.setFont(console.font)
    love.graphics.print("Page: "..pages.page.."/"..#pages,3,3)
    color(0,180,255)
    itext.write(todo.." GAME",scw/2,50,2,2)
    pages[pages.page] = pages[pages.page] or {}
    local entries=pages[pages.page]
    for i=1,15 do
        local y = 100+(eh*i)
        local dispname=entries[i] or "<< EMPTY SLOT >>"
        while itext.width(dispname)>scw-10 do dispname = left(dispname,#dispname-1) end
        if my>y-15 and my<y+15 then
           hover=i
        end
        if hover==i then color(255,255,0) else white() end
        itext.write(dispname,scw/2,y,2,2)
    end    
end

return SLS
