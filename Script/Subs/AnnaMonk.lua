--[[
**********************************************
  
  AnnaMonk.lua
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
 
version: 18.05.30
]]
-- $USE libs/nothing

local m = field:GetMap()
local map = m.map
local tm  = map.TagMap
local gdata=mynet

local function TiLT () error("You should NOT be able to find an Anna monk under the current circumstances") end
 
local function NPC()
      LoadScenario('ANNAMONK','ANNAMONK')
      SerialBoxText("ANNAMONK",'HELLO')
end

local qopt = {
     function() -- let's go to Anna's temple
        CSay("Let's enter the temple!")
        field:LoadMap("NET_Anna","Anna","Start")
     end,
     nothing, -- 
     function() -- let's go the internet to explain what Anna's temple does
        CSay("Let's go to the internet with the technobabble about Anna for data: "..mynet.templequery.query.DB)
        love.system.openURL("http://tricky1975.github.io/Anna_Info/"..mynet.templequery.query.DB..".html")
     end,
}

function m.script:NPC_Anna()
     mynet.templequery.NPC()
     qopt[RunQuestion('ANNAMONK','ENTER')]()
end
m.script.NPC_ANNA=m.script.NPC_Anna

--CSay(serialize("mynet",mynet))
if mynet.loggedin_anna then
   CSay("Use is on Anna, yay!")
   mynet.templequery = { status="Anna",query={HC='Game',A='Anna63',DB="Anna",Game=gdata.data['ANNA.ID'],GameSecu=gdata.data['ANNA.KEY'],Version='0.0.0',id=Var.C('$ANNA.ID'),secu=Var.C('$ANNA.SECU'),Request='Temple'},NPC=NPC,returnmap=m.file,returnlayer=m.layer}
   -- CSay(serialize('mynet',mynet))
   return mynet.templequery
end
CSay("User not logged in on Anna")
if mynet.loggedin_gj then
   CSay("Not on Anna, but we do have Game Jolt!")
   mynet.templequery = { status="GameJolt",query={HC='Game',A='Anna63',DB="GameJolt",user=Var.C('$GAMEJOLT.USER'),token=Var.C('$GAMEJOLT.TOKEN'),Game=gdata.data['ANNA.ID'],GameSecu=gdata.data['ANNA.KEY'],Request='Temple'},NPC=NPC,returnmap=m.file,returnlayer=m.layer}
   return mynet.templequery
end
CSay("User also not logged in on Game Jolt")

   


for layname,layer in pairs(tm) do
    CSay("Anna check: "..layname)
    if layer.NPC_ANNA then 
       field:laykill(layname,'NPC_ANNA')
       CSay("= Anna monk removed!") 
    end
end    

mynet.templequery = {status="Nothing",NPC=TiLT}    
return mynet.templequery
