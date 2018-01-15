--[[
**********************************************
  
  DUNG_Graveyard.lua
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
 
version: 18.01.15
]]
local graveyard = {}


console.write("  Welcome to:",255,255,0); console.writeln("The Forgotten Graveyard",0,255,255)

local function Opening()
   if Done("&DONE.GAMEHASBEGUN") then
      console.writeln("Already begun so no need to do this again!",180,0,255)
      return
   end
   console.writeln("Let the game begin!",255,0,255)
   -- $IF $MAC
   Var.D("$PCTYPE","Mac")
   -- $FI
   -- $IF $WINDOWS
   Var.D("$PCTYPE","Windows PC")
   -- $FI
   -- $IF $LINUX
   Var.D("$PCTYPE","Linux PC")
   -- $FI
   MapText("INTRO")
end

field:ZA_Enter('OpeningZone',Opening)


return graveyard
