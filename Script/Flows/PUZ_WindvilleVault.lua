--[[
  PUZ_WindvilleVault.lua
  Version: 18.06.02
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
-- Yes! It's THAT code! :P
local solution = {
     "up",
     "up",
     "down",
     "down",
     "left",
     "right",
     "left",
     "right",
     "b",
     "a"
}
local buttons = {
    up           = {bx= 53,by= 61,ex= 81,ey= 79},
    down         = {bx= 53,ex= 81,by=108,ey=122},
    left         = {bx= 38,by= 81,ex= 55,ey=104},
    right        = {bx= 85,by= 81,ex=100,ey=104},
    select       = {bx=132,by=105,ex=156,ey=110},
    start        = {bx=176,by=105,ex=199,ey=110},
    a            = {bx=269,by= 95,ex=300,ey=122},
    b            = {bx=226,by= 95,ex=257,ey=122}
}

local entered = {}

local mflow={}

-- $USE script/subs/screen
local lock = LoadImage('GFX/Puzzle/KVault/Controller.png')
local lw,lh = lock:Sizes()
local sx = math.floor((screen.w/2)-(lw/2))
local sy = math.floor((screen.h/2)-(lh/2))
local pressed = {}
local codew = math.floor(screen.w/#solution)


function mflow:odraw()
    white()
    console.sback()
    DrawImage ( lock,sx,sy )
    local tmx,tmy = mousecoords()
    local mx,my = tmx-sx,tmy-sy
    local mhit = mousehit(1)
    for key,coords in pairs(buttons) do
        if keyhit(key) or (mhit and mx>=coords.bx and mx<=coords.ex and my>=coords.by and my<=coords.ey) then
           pressed[#pressed+1] = copytable(coords)
           pressed[#pressed  ].alpha = 1
           entered[#entered+1] = key
           pressed[#pressed  ].r = math.random(0,255)
           pressed[#pressed  ].g = math.random(0,255)
           pressed[#pressed  ].b = math.random(0,255)
           CSay("I got: "..key)
        end        
    end
    for p in each(pressed) do
        if p.alpha>0 then
           p.alpha=p.alpha-.0001
           Color (p.r, p.g, p.b, p.alpha)
           Rect(p.bx,p.by,p.ex-p.bx,p.ey-p.by,'fill')
        end
    end
    if pressed[1] and pressed[1].alpha<=0 then table.delete(pressed,1) end
    for i,key in ipairs(entered) do
        Color(0,180,255)
        local x = (i-1)*codew
        local b = buttons[key]
        b.image = b.image or LoadImage('GFX/Puzzle/KVault/Buttons/'..key..'.png') 
        DrawImage ( b.image,x,5 )
    end
    StatusBar(false,false)
    local cgoed = true
    if #entered>=#solution then
       for i,e in ipairs(entered) do
           cgoed = cgoed and e==solution[i]
       end
       flow.set(field)
       if cgoed then
          for k,v in spairs(self) do CSay("V "..type(v).." "..k) end -- debug
          for k,v in spairs(self.mapscript) do CSay("M "..type(v).." "..k) end -- debug
          self:good(self.mapscript)
          destroylib(self)  
       end         
    end
    
end

flushkeys()


return mflow
