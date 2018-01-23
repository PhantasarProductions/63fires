--[[
  LoadGame.lua
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

local function Doing(a,b)
   print(a,b)
   console.write(a,255,255,0) console.writeln(b,0,255,255)
   console.show()
   love.graphics.present()
end   


local startgame
local ljcr
local lpref

local function LoadGameData()
    Doing("= Retrieving: ","Game Data")
    local gd = JCR_B(ljcr,lpref.."gamedata.lua")
    local f = load(gd,"Game Data")
    return f()
end

local function LoadGameVars()
    Doing("= Retrieving: ","Game vars")
    local gd = JCR_B(ljcr,lpref.."gamevars.lua")
    local f = load(gd,"Game Vars")
    return f() 
end

local function LoadPlayerSprites()
    Doing("= Retrieving: ","Map data and player positions")
    local gd = JCR_B(ljcr,lpref.."playersprites.lua")
    local f = load(gd,"MapData")
    startgame.add({CSay,"Loading map and setting player positions"})
    startgame.add({f})
end

local function LoadRPGCharData()
   Doing("= Retrieving: ","Char Stats and data")
   RPGLoad('jcr',ljcr,lpref.."PARTY") 
end

local function ExtractSwapFiles(jcrfile)
    for k,e in spairs(ljcr.entries) do
        if prefixed(k:upper(),"SWAP/") then
           local ss = mysplit(e.entry,"/")
           local sf = ss[#ss]
           console.write("= Extracting Swap File: ",255,255,0)
           console.writeln(sf,0,255,255)
           console.show()
           love.graphics.present()
           JCR_Extract(love.filesystem.getSaveDirectory( ).."/savegames/"..jcrfile..".jcr",k,"swap/gameswap/"..sf)
        end
    end
    field:ReadMapChanges()
end

local function lg(file,nocrash)
      RPGJCRDIR=""
      flow.use('startgame','script/Flows/startgame')
      startgame=flow.get('startgame')
      startgame.starttype('loadgame')
      Doing("Loading: "..file)
      if love.filesystem.isFile("savegames/"..file..".jcr") then
         ljcr  = JCR_Dir(love.filesystem.getSaveDirectory( ).."/savegames/"..file..".jcr")
         lpref = ""
         Doing("= Type: ","Packed")
      elseif love.filesystem.isDirectory("savegames/"..file) then
         ljcr = jcr
         lpref = "savegames/"..file.."/"
         Doing("= Type: ","Crappy")
      elseif nocrash then
         console.write("ERROR! ",255,0,0)
         console.writeln("I can't find: "..file)
         return false
      else
         error("I can't find: "..file)
      end
      LoadGameData() 
      LoadGameVars() 
      LoadRPGCharData()
      LoadPlayerSprites()   
      startgame.add({CSay,"Extracting swap files"})
      startgame.add({ExtractSwapFiles,file}) 
      flow.set('startgame')
      --flow.undef('loadgame')
      return true      
end

return lg
