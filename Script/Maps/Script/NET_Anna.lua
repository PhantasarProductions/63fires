--[[
**********************************************
  
  NET_Anna.lua
  (c) Jeroen Broks, 2018, All Rights Reserved.
  
  This file contains material that is related 
  to a storyline that is which is strictly
  copyrighted to Jeroen Broks.
  
  This file may only be used in an unmodified
  form with an unmodified version of the 
  software this file belongs to.
  
  You may use this file for your study to see
  how I solved certain things in the creation
  of this project to see if you find valuable
  leads for the creation of your own.
  
  Mostly this file comes along with a project
  that is for most part released under an
  open source license and that means that if
  you use that code with this file removed
  from it, you can use it under that license.
  Please check out the other files to find out
  which license applies.
  This file comes 'as-is' and in no possible
  way the author can be held responsible of
  any form of damages that may occur due to 
  the usage of this file
  
  
 **********************************************
 
version: 18.06.07
]]
local fuckit={}
local http = require("socket.http")
local map = field:GetMap().map


local function AnnaReturn()
     field:LoadMap(mynet.templequery.returnmap,mynet.templequery.returnlayer,"ReturnAnna")
     mynet.templequery=nil -- No longer needed... Must be regenerated on the return to the temple, anyway.
end

local function AnnaError(er)
    -- $USE libs/notify
    throw("Anna has to deny you access to her temple due to an error\n\n"..er)
    AnnaReturn()
end

local function PrayToAnna()
      NowLoading()
      local url = "http://utbbs.tbbs.nl/Game.php?"
      local querystring = ""
      for qk,qv in spairs(mynet.templequery.query) do
          if querystring~="" then querystring = querystring .. "&" end
          querystring = querystring .. qk .. "="..qv
      end
      CSay(url..querystring)
      local cnt,stat,header = http.request(url..querystring)
      if not cnt then
         AnnaError("I could not properly contact Anna!\n\n"..stat)
         return
      end
      local AnnaScript,AnnaErrorMsg = load(cnt,"Anna's Reply Script")
      if not AnnaScript then
         for i,l in ipairs(mysplit(cnt,"\n")) do
             CSay(("%10d | %s"):format(i,l))
         end    
         AnnaError("Error during the parsing of the data Anna returns\n\n"..AnnaErrorMsg)
         return
      end
      local AZ,AZError = AnnaScript()
      if not AZ then
         AnnaError(AZError)
         return
      end
      CSay(serialize('AZ',AZ))
      map:showlabels(AZ)
      for killdoor in each(AZ) do
          CSay("Open sesame door: "..killdoor)
          field:kill(killdoor)
      end
      map:remapall()    
end


PrayToAnna()

function fuckit:NPC_BYE()
    -- $USE libs/nothing
    MapText("BYE")
    ;({
        AnnaReturn,
        nothing
    })[RunQuestion("MAP","BYEQ")]()
end


return fuckit
