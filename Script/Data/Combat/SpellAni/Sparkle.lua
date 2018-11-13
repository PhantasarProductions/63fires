--[[
  Sparkle.lua
  Version: 18.11.13
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
local Sparkle = {}


function Sparkle:EXE(combat,nm)
   self.counter = (self.counter or 0) + 1
    for i=1,20 do
      for target in each(nm.targets) do
          local x=math.random(-16,16)
          local y=math.random(-64,0)
          local r=math.random(0,255)
          local g=math.random(0,255)
          local b=math.random(0,255)
          Color(r,g,b)
          local dx=combat.fighters[target].x + x
          local dy=combat.fighters[target].y + y
          love.graphics.points(dx,dy)
          color(r/2,g/2,b/2)
          love.graphics.points(dx-1,dy,
                               dx+1,dy,
                               dx  ,dy-1,
                               dx  ,dy+1)
      end
    end
    return self.counter<20        
end


return Sparkle
