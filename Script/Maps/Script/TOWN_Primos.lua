--[[
**********************************************
  
  TOWN_Primos.lua
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
 
version: 18.12.22
]]



--[[

  This script will be for the village of Primos.
  
  
  As some scenario parts can take place here, you may expect a rather messy script.
  

]]


-- Start Module
local Primos={}

-- Anna
local ANNAMONK


-- Scyndi
function Primos:NPC_Scyndi()
         MapText("CAMEO_SCYNDI")
         Shop("SCYNDI")     
end

function Primos:Welcome()
  
end

function Primos:NPC_Guyapi()
     MapText("GUYAPI")
     WorldMap_Unlock("D_ODDMAZE")
end     

function Primos:NPC_UPGRADE()
    MapText("UPGRADER")
    UpgradeShop()
end


function Primos:NPC_Chief()
    -- Activating the quest to find Shirley
    if (not Done("&DONE.PRIMOS.CHIEF")) then
       MapText("PHILIP1")
       WorldMap_Unlock("D_PRAIRIE")
       return
    end
    -- Shirley quest started, but Shirley not yet found
    if (not BoolVar("&DONE.SHIRLEY.JOINED")) then
       MapText("PHILIP2")
       return
    end   
    if (not Done("&DONE.PRIMOS.SHRILEYJOINED.CHIEF")) then
       MapText("PHILIP3")
       WorldMap_Unlock('D_HAUNTEDTUNNEL')
       Var.D("$WMCHAT","HAUNTED")
    end
    MapText("PHILIP4")    
    --error("This part has not yet been scripted.\nRest awhile in the Y.M.C.A while I take care of that!")
end

function Primos:oncycle()
    math.random(1,5)
end    


function Primos:NPC_Rose()
    -- Must talk to Philip to start Shirley quest
    if (not BoolVar("&DONE.PRIMOS.CHIEF")) then
       MapText("ROSE1")
       return
    end
    -- Shirley quest started, but Shirley not yet found
    if (not BoolVar("&DONE.SHIRLEY.JOINED")) then
       MapText("ROSE2")
       return
    end   
    MapText("ROSE2")
    --error("This part has not yet been scripted.\nThey may call her the wild Rose, while her name is Eleisa Day, but that doesn't make me work faster!")
end

    

field:ZA_Enter("Welcome",Primos.Welcome,Primos)
field:ZA_Enter("I_WANT_ANNA",function()
  -- $USE script/subs/ANNAMONK
end)

-- Return Module
return Primos
