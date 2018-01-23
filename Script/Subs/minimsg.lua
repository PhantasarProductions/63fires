--[[
  minimsg.lua
  Version: 18.01.23
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
local mm = {}

local dminimsg = {}
local wit = {255,255,255}
local basecoord = {500,500}

function mm:MMsg(text,col,coord)
    --love.graphics.setFont(console.font)
    local i = love.graphics.newText(console.font,text)
    dminimsg[#dminimsg+1] = {text=text,itext=i,w=i:getWidth(),h=i:getHeight(),color=col or wit,coord=coord or basecoord,time=250,speed=.25}
    --[[
    local dmdbg = mysplit(serialize("minimessage queue",dminimsg),"\n")
    for l in each(dmdbg) do
        CSay(l)
    end
    --]]    
end

function mm:Show()
    if #dminimsg<=0 then return end
    for imm in each(dminimsg) do
        imm.ox = imm.ox or math.floor(imm.w/2)
        imm.oy = imm.oy or math.floor(imm.h/2)
        color(imm.color[1],imm.color[2],imm.color[3])
        love.graphics.draw(imm.itext,math.floor(imm.coord[1]),math.floor(imm.coord[2]),0,1,1,imm.ox,imm.oy)
        imm.coord[2]=imm.coord[2]-imm.speed
        imm.time = imm.time - 1   
    end
    if dminimsg[1].time<=0 then table.remove(dminimsg,1) end
end



return mm
