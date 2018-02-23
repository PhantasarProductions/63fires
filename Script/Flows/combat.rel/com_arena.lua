--[[
  com_arena.lua
  Version: 18.02.23
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
local Arena = {}

local defaultarena = {
    load = function (arena,afile)
        -- $USE Subs/screen
        local w,h
        local file=afile
        if not suffixed(file:lower(),".png") then file=file..".png" end
        arena.image = LoadImage('gfx/combat/arena/'..file) w,h = ImageSize(arena.image)
        arena.quad  = love.graphics.newQuad(-((screen.w/2)-(w/2)),-(((screen.h-120)/2)-((h-120)/2)),screen.w,screen.h-120,w,h)
        WrapImage(arena.image,"mirroredrepeat","clamp") --:setWrap("mirroredrepeat","clamp")
        HotCenter(arena.image)
    end,
    
    draw = function(arena)
        -- $USE Subs/screen
        white()
        QuadImage(arena.image,arena.quad,0,0)
    end    
    
    
           
}

function Arena:DrawArena()
    
    self.arenamod.draw(self.arenadata)
end


function Arena:SetUpArena(arenafile)
     local af = "script/data/arena/"..arenafile..".lua"
     self.arenadata = { file=arenafile }
     if JCR_Exists(af) then self.arenamod = Use(af) else self.arenamod=defaultarena end
     self.arenamod.load(self.arenadata,arenafile)
end

function Arena:Draw()
    self.arenamod.draw(self.arenadata)
end    

return Arena
