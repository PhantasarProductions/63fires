--[[
  __ScrollEffect.lua
  Version: 18.10.10
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
local s={}

local stimer={}
local sicons={}
local picons={}

--[[ This is not a status change by itself, but rather a helper that several status changes will use to cause a certain effect ]]

function s:ico(tag,statusicon)
    -- $USE libs/klok
    local ts = tag..statusicon
    stimer[ts] = stimer[ts] or klok:CreateTimer(0.15)
    local tm = stimer[ts]
    if not tm:enough() then return end
    local warrior=combat.fighters[tag]
    local newico = {
        x = math.random((warrior.x or 25)-16,(warrior.x or 25)+16),
        y = warrior.y or 1000,
        timeout = math.random(50,100),
        spd = math.random(1,4),
        icon=statusicon 
    }
    sicons[#sicons+1] = newico
end

function s:icoshow()
    local kill = {}
    for idx,ico in pairs(sicons) do
        picons[ico.icon] = picons.icon or LoadImage("GFX/COMBAT/STATUSCHANGEICONS/"..ico.icon..".PNG")
        ico.y=ico.y-ico.spd
        DrawImage(picons[ico.icon],ico.x,ico.y)
        ico.timeout = ico.timeout - 1
        if ico.timeout<=0 then kill[#kill+1]=idx end -- Prevent spooking up the loop, as Lua is pretty sensitive to such things!
    end
    for k in each(kill) do sicons[k]=nil end
end    


return s
