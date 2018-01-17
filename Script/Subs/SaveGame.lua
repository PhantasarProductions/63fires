--[[
  SaveGame.lua
  Version: 18.01.17
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

-- This function has been copied from the Love2D Wiki
local function recursivelyDelete( item )
        if love.filesystem.isDirectory( item ) then
            for _, child in pairs( love.filesystem.getDirectoryItems( item )) do
                recursivelyDelete( item .. '/' .. child )
                love.filesystem.remove( item .. '/' .. child )
            end
        elseif love.filesystem.isFile( item ) then
            love.filesystem.remove( item )
        end
        love.filesystem.remove( item )
    end
--    recursivelyDelete( 'a' )

local function qwrite(str,file)
    local s,m=love.filesystem.write(file,str.."\n\n")
    assert(s,"SAVEGAME.QWRITE(<data>,\""..file.."\"",m)            
end

local function SaveVars(file)
    Doing("= Gathering: ","GameVars")
    local vars=Vars()
    local ret="-- Var dump"
    for vr in each(vars) do
        local v=Var.TV(vr)
        print(type(v),vr,"=",v)
        ret=ret.."\nVar.D(\""..vr.."\","
        if     type(v)=='string' then ret=ret.."\""..v.."\"" 
        elseif type(v)=='number' then ret=ret..v
        elseif v==true           then ret=ret.."true" else ret=ret.."false" end
        ret=ret..")"
    end
    print("end result:\n",ret)
    local s,m=love.filesystem.write(file.."/gamevars.lua",ret.."\n\n")
    assert(s,m)            
end

local function SaveGameData(file)
    Doing("= Gathering: ","Game Data")
    qwrite(serialize('gamedata',gamedata),file.."/gamedata.lua")
end    

local function SavePlayerActors(file)
    local M=field.map
    local A=M.map.TagMap[M.layer].PLAYER1    
    local ret
    Doing("= Gathering: ","player sprites data")
    ret = "-- Player dump\n"
    ret = ret .. "field:LoadMap('"..M.file.."','"..M.layer.."')\n"
    ret = ret .."field:SpawnPlayer({ COORDS= {x="..A.COORD.x..", y="..A.COORD.y.."}, WIND='"..A.WIND.."'})\n"        
    qwrite(ret,file.."/playersprites.lua")
end

local function SaveSwap(file)
    local swaps = love.filesystem.getDirectoryItems("swap/gameswap")
    assert(love.filesystem.createDirectory(file.."/swap"),"I could not create swap directory in savegame dir")
    for sf in each(swaps) do
        if love.filesystem.isDirectory("swap/gameswap/"..sf) then
           console.write("ERROR! ",255,0,0) console.writeln("No sub-directories allowed in swap!",255,255,0)
        else
           Doing("= Getting swap: ",sf)
           qwrite(love.filesystem.read("swap/gameswap/"..sf),file.."/Swap/"..sf)
        end
    end          
end

local function SaveRPGData(file)
    Doing("= Gathering: ","Character stats and data")
    RPGSave(file.."/PARTY")
end 

local function SavePack(file)
   if RYANNA_LOAD_JCR then
      Doing("Packing: ",file)
      print("Packing:",love.filesystem.getSaveDirectory( ).."/"..file)
      local s,e=Dir2JCR(love.filesystem.getSaveDirectory( ).."/"..file)
      if not s then
         console.writeln("Packing Failed")
         CSay(e)
      else
         print(e)   
      end
   end         
end
      

return function(afile,meta)
 local file="savegames/"..afile
 if love.filesystem.isDirectory(file) or love.filesystem.isFile(file) then
    Doing("Deleting old: ",file)
    recursivelyDelete(file)
 end   
 if love.filesystem.isDirectory(file..".jcr") or love.filesystem.isFile(file..".jcr") then
    Doing("Deleting old: ",file..".jcr")
    recursivelyDelete(file..".jcr")
 end   
 Doing("Saving: ",file)
 love.filesystem.createDirectory(file)
 SaveVars(file)
 SaveGameData(file)
 SavePlayerActors(file)
 SaveRPGData(file)
 SaveSwap(file)
 SavePack(file)
end
