--[[
  Ryanna_Main.lua
  Version: 18.01.02
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
love.filesystem.setIdentity(RYANNA_TITLE) -- Make sure that no matter how the game is run the savedir is always the title, other wise direct calls I need to do on Mac to read the stdout output will get in the 'love' directory were I don't want it to be!

print("Let's try to fire this all up, shall we?")
-- $USE libs/laura


function update_time()
   local t = os.date("%H:%M:%S")
   oldtime = oldtime or t
   if t~=oldtime then
      Inc("%TIME.SEC")
      if Var.G("%TIME.SEC")>=60 then
         Dec("%TIME.SEC",60)
         Inc("%TIME.MIN")
      end   
      if Var.G("%TIME.MIN")>=60 then
         Dec("%TIME.MIN",60)
         Inc("%TIME.HOUR")
      end
   local dtime = Var.G('%TIME.HOUR') .. ":" .. right("00"..Var.C("%TIME.MIN"),2) .. ":" ..right("00"..Var.C('%TIME.SEC'),2)
   Var.D('$PLAYTIME',dtime)
   oldtime=t        
   end
end


function save_gcfg()
   love.filesystem.write("globalconfig.lua",serialize('local ret',globalconfig).."\n\nreturn ret\n\n\n\n\n\n")
end   

function love.load()
    local full
    console.csaycolor = {r=0,g=180,b=255}
    if love.filesystem.isFile("globalconfig.lua") then
       globalconfigf = love.filesystem.load("globalconfig.lua") -- Not through JCR. This file is dynamic, and JCR does not account for that (yet).
       globalconfig = globalconfigf()
    else
       globalconfig = {}
    end
    globalconfig[RYANNA_BUILDTYPE] = globalconfig[RYANNA_BUILDTYPE] or {}
    gcfg = globalconfig[RYANNA_BUILDTYPE]
    if gcfg.fullscreen==nil then
       local title = RYANNA_TITLE
       local buttons = {"Full Screen this time","Windowed this time","Always Full Screen","Always Windowed","quit",escapebutton=5}
       local pressedbutton = love.window.showMessageBox(title, "Do you want to play this game Windowed or Full Screen?", buttons)
       if pressedbutton==5 then return bye() end
       if pressedbutton==3 or pressedbutton==4 then gcfg.fullscreen=pressedbutton==3 save_gcfg() end
       if pressedbutton==1 or pressedbutton==1 then full = true end
    end
    full = full or gcfg.fullscreen
    if full then
          repeat 
             local suc = love.window.setFullscreen( true )
             local ciw
             if not suc then
               local but2 = {"Try again","Continue in Windowed mode","Quit",escapebutton=3}
               local pb = love.window.showMessageBox(title, "Entering Full Screen Failed!", but2)
               if pb==2 then ciw=true end
               if pb==3 then return bye() end
             end
          until suc or ciw
    end
    flow.use("init","script/flows/init.lua")
    flow.set("init")
end
