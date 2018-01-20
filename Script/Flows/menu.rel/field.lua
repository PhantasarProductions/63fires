--[[
  field.lua
  Version: 18.01.20
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

-- Menu.field -- Not the actual field lib

local width, height = love.graphics.getDimensions(  )
local fld = { nomerge=true }
local stats = {"Power","Defense","Intelligence","Resistance","Speed","Accuracy","Evasion"} --,"HP","AP","Awareness"}

fld.mode = 'status'

local function go_status() fld.mode='status' end
local function go_inventaris() fld.mode='inventaris' end
local function go_ability() fld.mode='ability' end

fld.iconstrip = {
     {icon="status",tut="Statistics, data\nJust the general data about your character can be found here",cb=go_status},
     {icon="inventaris", tut="What items are you carrying with you?", cb=go_inventaris},
     {icon='vaardigheden', tut='Skills, special moves, spells?\nWhatever a character can do is listed here!',cb=go_ability},
     {icon='help',tut="Help me, Ryanna! You're my only hope!",cb=iconstriphelp}
}


local iaawin = {y=0,h=height-140}


fld.modes = {

    status = function ( x,w,ch,click )
      love.graphics.setFont(fontMiddel)      
      for i,stat in ipairs(stats) do
         white() 
         love.graphics.print(stat..":",x+math.floor(w*.05),i*30)
         color(0,180,255)
         diginum(rpg:Stat(ch,"END_"..stat),x+math.ceil(w*.95),i*30)
      end      
    end,
    
    inventaris = function (x,w,ch,click)
       iaawin.x=x
       iaawin.w=w
       local i = ItemSelector('field',x,0,click,iaawin)
    end,
    
    ability = function( x,w,ch )
    end

}


return fld
