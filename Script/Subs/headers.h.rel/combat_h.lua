--[[
  combat_h.lua
  Version: 19.01.16
  Copyright (C) 2018, 2019 Jeroen Petrus Broks
  
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

-- $USE libs/qgfx

local bossfont = {
     head = love.graphics.newFont(JCR_D('fonts/oldlondon.ttf'),20),
     boss = love.graphics.newFont(JCR_D('fonts/oldlondon.ttf'),50)
}

local function SC_ANIM() 
   -- $USE Script/Subs/screen
   local screenshot = LoadImage(love.graphics.newImage(love.graphics.newScreenshot( ))); HotCenter(screenshot)
   local cx,cy=screen.w/2,screen.h/2     
   local r=0
   for i=1,0,-.02 do
       love.graphics.clear( )
       DrawImage(screenshot,cx,cy,1,r,i,i)
       r=r+.05
       love.graphics.present()
       love.timer.sleep(.03)
   end
   love.graphics.clear( )
   love.graphics.present()
   love.graphics.clear( )
   love.graphics.present()   
end

function StartCombat(data,noanim)
    if not noanim then SC_ANIM() end
    -- $USE Script/Flows/combat
    combat:Init(data)
    flow.set(combat)
end

LoadedFoeImages = LoadedFoeImages or {} -- Should remain in the memory even after the combat routine itself has been flushed!

function FoeImage(imgfile)
   local ifile = imgfile:upper()
   if suffixed(ifile,"/") then
      -- $USE libs/RandomFile 
      ifile = RandomFile(ifile)
   end   
   LoadedFoeImages[ifile] = LoadedFoeImages[ifile] or LoadImage(ifile)
   return LoadedFoeImages[ifile]
end   

function BossFight(head,boss,data,noanim)
   -- $USE Script/Subs/screen
   local screenshot = LoadImage(love.graphics.newImage(love.graphics.newScreenshot( ))); --HotCenter(screenshot)
   local red=255
   local ihead = Text2Img(head,bossfont.head,'cb')
   local iboss = Text2Img(boss,bossfont.boss,'ct')
   for i=255,0,-1 do
       love.graphics.clear( )
       local alpha=255-i
       red = red - .5
       color(math.ceil(red),i,i,255)
       DrawImage(screenshot,0,0)
       color(255,0,0,alpha)
       DrawImage(ihead,screen.w/2,(screen.h/2)-20)
       DrawImage(iboss,screen.w/2,(screen.h/2)+20)
       love.graphics.present()
       love.timer.sleep(.03)       
   end
   love.timer.sleep(4)
   data.music = data.music or 'Music/Boss'
   StartCombat(data,noanim)    
end
