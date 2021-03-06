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
 
version: 18.02.10
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

local function Tut_Chest()
    if not Done("&DONE.TUTORIAL.TREASURE_CHESTS") then
       MapText("TUT_CHEST")
       MapText("TUT_CHEST"..Var.C("$SKILLNAME"))
    end   
end

local function Tut_Goblin()
    if not Done("&DONE.TUTORIAL.GOBLIN.COMBAT") then
       local ryanna=field:getmap().map.TagMap['#005'].PLAYER1
       ryanna.walking=false
       ryanna.moving=false
       MapText("TUT_GOB")
    end   
end

local function Tut_Medal()
    if not Done("&DONE.TUTORIAL.TRAVELMEDAL") then
       local ryanna=field:getmap().map.TagMap['#005'].PLAYER1
       ryanna.walking=false
       ryanna.moving=false
       MapText("TUT_MEDAL")
       MapText("TUT_MEDAL"..Var.C("$SKILLNAME"))
    end   

end

local function FightGob()
    if Done("&DONE.THEVERYFIRSTENEMYOFTHEGAME") then return end
    field:kill('Gob',true)
    StartCombat({
           foes={'reg/goblin'},
           arena="forest_spar"
    })
end

field:ZA_Enter('OpeningZone',Opening)
field:ZA_Enter('Tutor_Chest',Tut_Chest)
field:ZA_Enter("Tutor_Gob",  Tut_Goblin)
field:ZA_Enter("FightGob"  ,FightGob)
field:ZA_Enter("TUT_Medal",Tut_Medal)


return graveyard
