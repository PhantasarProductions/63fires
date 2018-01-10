--[[
  startgame.lua
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
-- $USE libs/omusic
-- $USE libs/console
-- $USE libs/qgfx

local iact = 0

local function iLoadImage(pic,tag)
    console.writeln("Load Image: "..pic,180,0,255)
    return LoadImage(pic,tag)
end

local function UseField()
   -- $USE Script/Flows/Field
   field=Field
end   

local function LoadMap(m,l)
      -- $USE Script/Flows/Field
      Field:LoadMap(m,l)
end      

local function loadstatusbar()
  -- $USE Script/Subs/StatusBar
end  

local finit = {}

local iacts = {
            {CSay,"Compiling Field Flow"},
            {UseField},
--            {CSay,"Chaining background"},
--            {LoadImage,console.background,"Background"},
            {CSay,"Compiling status bar"},
            {loadstatusbar}
         }
function finit.draw()
   console.show()
end

local stype
function finit.starttype(astype)
  stype=astype
  if stype=='newgame' then
     iacts[#iacts+1]={CSay,"Giving life to Ryanna"}
     iacts[#iacts+1]={laura.makechar,"Ryanna",1}
     iacts[#iacts+1]={CSay,"Initiating party"}
     iacts[#iacts+1]={rpg.SetParty,rpg,1,"Ryanna"}     
     iacts[#iacts+1]={CSay,"Loading the graveyard map"}
     iacts[#iacts+1]={LoadMap,'DUNG_Graveyard',"#001"}
  end
end

function finit.arrive()         
     laura.assert(stype,"And what kind of startup did we require, mr?","None has been received, you know!")
     console.writeln("Starting up game",180,255,0)
     if Var.C('$ANNA.ID')~="" then
        iacts[#iacts+1]={CSay,Var.S("Logging into Anna as #$ANNA.ID")}
        iacts[#iacts+1]={function()
             local gdata = mynet
             local query = {HC='Game',A='Auth',Game=gdata.data['ANNA.ID'],GameSecu=gdata.data['ANNA.KEY'],Version='0.0.0',id=Var.C('$ANNA.ID'),secu=Var.C('$ANNA.SECU')}
             gdata.annalogin = {id=query.id,secu=query.secu}
             retries = 0
             repeat
               local s,r = Anna_Request(query)
               local reason = "OK"
               local ok
               if not s then reason = r 
                   local p = love.window.showMessageBox("Anna Error", "Logging in to Anna failed!\n- Is your internet connection up?\n- Is the game not blocked by firewalls?\n- Any issues with Game Jolt itself?\n- Login data correct?\n- You did enter your TOKEN and not your password, right?\n- Login data changed?\n - "..reason,{"Ignore","Retry","Quit",escapebutton=3})
                   if p==1 then ok = 'true' end
                   if p==2 then retries=retries+1 laura.assert(retries<20,"Sorry, with this many retries I am not gonna continue anymore.") CSay("Retry attempt #"..retries) if retries>=20 then ok='true' end end 
                   if p==3 then ok = 'true' quitdontask=true love.event.quit() end
                else
                   mynet.loggedin_anna = true
                   ok='true'   
                end
              until ok=='true'

        end}
     end
     if Var.C('$GAMEJOLT.USER')~="" then
        iacts[#iacts+1]={CSay,Var.S("Logging into Game Jolt as $GAMEJOLT.USER")}
        iacts[#iacts+1]={function()
              gjapi:init(mynet.data['GAMEJOLT.ID'],mynet.data['GAMEJOLT.KEY'])
              local retries=0
              repeat 
                local user = Var.C("$GAMEJOLT.USER")
                local token = Var.C("$GAMEJOLT.TOKEN")
                laura.assert(token,"'nil' for token",VarList())
                print("GJ LOGIN:",user,token)
                local ok = gjapi:users_auth(user,token)                
                if ok~='true' then
                   local p = love.window.showMessageBox("Game Jolt Error", "Logging in to Game Jolt failed!\n- Is your internet connection up?\n- Is the game not blocked by firewalls?\n- Any issues with Game Jolt itself?\n- Login data correct?\n- You did enter your TOKEN and not your password, right?\n- Login data changed?",{"Ignore","Retry","Quit",escapebutton=3})
                   if p==1 then ok = 'true' end
                   if p==2 then retries=retries+1 laura.assert(retries<20,"Sorry, with this many retries I am not gonna continue anymore.") CSay("Retry attempt #"..retries) if retries>=20 then ok='true' end end 
                   if p==3 then ok = 'true' quitdontask=true love.event.quit() end
                else
                   mynet.loggedin_gj = true   
                end
              until ok=='true'
        end}
     end
     iacts[#iacts+1]={CSay,"Starting Clock"}
     iacts[#iacts+1]={addupdatefunc,update_time}
end

function finit.update()
   iact = iact + 1
   if not iacts[iact] then
      --flow.use("field","script/flows/field")
      flow.set(Field)
      flow.undef("startgame")
      return
   end
   local act = iacts[iact]
   local f = act[1]
   local p1 = act[2]
   local p2 = act[3]
   local p3 = act[4]
   if laura.assert(f,'No function',{actionnumber=iact,param1=p1,param2=p2,param3=p3}) then f(p1,p2,p3) end   
end



return finit
