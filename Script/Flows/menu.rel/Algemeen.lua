--[[
  Algemeen.lua
  Version: 18.08.30
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
-- $USE Script/Subs/IconStrip

local width, height = love.graphics.getDimensions(  )
local tw = width-60
local cols = {{x=60,w=tw/2},{x=60+(tw/2),w=tw/2}}
local mod = {}

local skill = Var.G("%SKILL")
local equipdivfactor = ({5,10,25})[skill]
local equipabsolutemax = ({25,20,10})[skill]
local equippoint = 1

mod.menutype = "field"

function mod:cometome(mentype,character)
     local mt = mentype or "field"
     -- for k,_ in spairs(self) do CSay("MENU HAS FIELD: "..k) end -- debug field
     self[mt].parent=self
     self.menutype = mt
     self.iconstrip=self[mt].iconstrip
     self.active=self[mt]     
     self.char=character
     -- for k,_ in spairs(self.active) do CSay("ACTIVE MENU TYPE HAS SUBFIELD: "..k) end
     flow.set(self)
end

function mod:gomenu(character)
     self.char=character
end

function mod:showstatus(cd)
    local x=cd.x
    local w=cd.w
    local y=0
    local h=height-120
    --print ( serialize('self',self)) -- debugline
    DrawPortrait(self.char,x,200)
    local namefont = GetBoxTextFont()
    --[[
    love.graphics.setFont(fontGroot)
    love.graphics.print(self.char,x+200,180)
    ]]
    color(0,180,255)
    itext.setfont(namefont)
    itext.write(self.char,x+180,180,0,1)
    local cats = {'HP','AP','VIT'}
    local cols = {HP={0,0,0},AP={0,180,255},VIT={255,180,0}}
    cols.HP[2]=math.floor((rpg:Points(self.char,'HP').Have/rpg:Points(self.char,'HP').Maximum)*255)
    cols.HP[1]=255-cols.HP[2]
    for i,cat in ipairs(cats) do
        color(cols[cat][1],cols[cat][2],cols[cat][3])
        DrawImage("Pnt"..cat,x,200+(i*30))
        local p = rpg:Points(self.char,cat)
        diginum(p.Have,   x+math.floor(w*.50),200+(i*30))
        diginum(p.Maximum,x+math.ceil (w*.75),200+(i*30))
    end 
    
    local level=rpg:Stat(self.char,"Level")
    local cap=Var.G("%LEVELCAP")
    if level<=cap then
       white()
       itext.write("Level:",x,350)
       color(0,180,255)
       diginum(level,x+math.ceil (w*.75),350)
    end              
    if level<cap then
       white()
       itext.write("Experience:",x,380)
       color(0,180,255)
       diginum(rpg:Stat(self.char,"Experience"),x+math.ceil (w*.75),380)
    end  
    local eqm = math.floor(level/equipdivfactor)
    if eqm>equipabsolutemax then eqm=equipabsolutemax end 
    if eqm>0 then
       color(180,255,  0) itext.write("+", x      ,450)
       color(255,  0,  0) itext.write("-",(x+w)-25,450)
       color(  0,180,255) itext.write(equippoint.."/"..eqm)
    end              
end

function mod:odraw()
    self.clicked = mousehit(1)
    white()
    console.sback()
    self:showstatus(cols[1])
    self.active.modes[self.active.mode](cols[2].x,cols[2].w,self.char,self.clicked)    
    StatusBar(self.char,true)
    showstrip()
end



return mod
