--[[
  field.lua
  Version: 18.01.10
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
-- $USE Libs/Lib_kthura
-- $USE Libs/nothing
-- $USE Script/Subs/IconStrip
local field = {}
local full, fstype = love.window.getFullscreen( )

field.iconstrip = {}


local is = field.iconstrip
is.hide=full
is.back=true
is.x=60

-- When playing full screen this icon is the quit feature. It won't be visible in Windows mode, since 
if full then is[1]={ icon='stoppen', tut='Quits the game\nWarning unsaved data will NOT be saved and will thus be lost', cb=love.event.quit } end

-- Tools. By default all empty. Can be set by changing characters providing they have the tool
for i=1,3 do is[#is+1]={icon='empty', tut='???', cb=nothing, tool_id=i} end

is[#is+1] = {icon='Prestaties', tut='Overview of your earned achievements', cb=function() flow.use('ach','Script/Flows/Achievements.lua') flow.set('ach') end}

-- Help! Must ALWAYS be last!!
is[#is+1] = {icon='Help', tut="Provides help", cb=iconstriphelp}

local map


local players = {}

function field:followdaleader()
   players.leader = players.leader or 1

end
 

function field:gomenu(ch)
   -- $USE script/flows/menu
   menu:cometome('field',ch)
end

function field:LoadMap(KthuraMap,layer)
    if not laura.assert(layer,"No layer requested!",{LoadMap=KthuraMap}) then return end    
    map= {layer=layer}
    print("Loading map: ",KthuraMap)
    CSay("Loading map: "..KthuraMap)
    CSay("= Map itself")
    map.map = kthura.load("Script/Maps/Kthura/"..KthuraMap)
    if not laura.assert(map.map,"Loading the map failed!") then return end
    CSay("= Map script")
    local scr = "Script/Maps/Script/"..KthuraMap..".lua"
    if not(JCR_Exists(scr)) then
       local src = "-- No script\nreturn {}"
       console.write("WARNING! ",255,180,0)
       console.writeln("No script file! Using empty script!")
       local fun = load(src,"* NOSCRIPT *")
       map.script = fun() 
    else
       map.script = use(scr)
    end    
    CSay("= Map Events")
    -- Will be put in later!
    CSay("= Changes")
    -- Will be put in later!
    CSay("= OnLoad")
    ;(map.script.onload or nothing)()
    
end

field.cam = {x=0,y=0}

function field:odraw()
    self.clicked = mousehit(1)
    --if self.clicked then cancelhelp() end
    local width, height = love.graphics.getDimensions( )   
    local staty = height-140
    --for k,v in spairs(self) do print(type(v),k) end
    --print (serialize('map',map))
    kthura.drawmap(map.map,map.layer,self.cam.x,self.cam.y)
    StatusBar(false,true)
    showstrip()
    love.graphics.setFont(console.font)
    love.graphics.print(Var.S("Time: $PLAYTIME"),width-200,staty)
    dbgcon()    
end    

function field:map() return map end



return field
