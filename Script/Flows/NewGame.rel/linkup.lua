--[[
  linkup.lua
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
local lu={}
local me

function lu.arrive()
    print(serialize("newgame",lu)) -- debug
    love.window.showMessageBox( RYANNA_TITLE, "Welcome to 63 fire of lung.\nBefore we begin I will first ask you a few setting.\nWhich are language setting, difficulty setting and network settings for achievement.\n\nYou cannot change these beyond this point, so think it out well.", 'info', false )
    lu.stage="language"
    me=flow.get()
end     

function lu.draw()
   assert(me[lu.stage],"I don't have no sub: "..lu.stage)
   me[lu.stage].draw()
end

function lu.mousepressed(b,x,y)
   print("mouse button ",b," pressed at (",x,",",y,")")
   assert(me[lu.stage],"I don't have no sub: "..lu.stage);
   (me[lu.stage].mousepressed or nothing)(b,x,y)
end   

function lu.textinput( txt )
  (me[lu.stage].textinput or nothing)( txt )
end


function lu.gostage(s) lu.stage = s end

return lu   
