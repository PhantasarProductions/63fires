--[[
 **********************************************
  
  This file is part of a closed-source 
  project by Jeroen Petrus Broks and should
  therefore not be in your pocession without
  his permission which should be obtained 
  PRIOR to obtaining this file.
  
  You may not distribute this file under 
  any circumstances or distribute the 
  binary file it procudes by the use of 
  compiler software without PRIOR written
  permission from Jeroen P. Broks.
  
  If you did obtain this file in any way
  please remove it from your system and 
  notify Jeroen Broks you got it somehow. If
  you have downloaded it from a website 
  please notify the webmaster to remove it
  IMMEDIATELY!
  
  Thank you for your cooperation!
  
  
 **********************************************
Stopcontact.lua
(c) 2018 Jeroen Petrus Broks
Version: 18.07.03
]]

local skill = Var.G("%SKILL")
local stopcontact={
         StatMod = {
              Power = 3/skill,
              Defense = 1/skill,
              Resistance = 2/skill,
              Speed = 24/skill
         },
         StatRep = {
              ER_Lightning = 6,
              ER_Water     = 0,
              ER_Wind      = 4,
              ER_Darkness  = 1
         }

}



return stopcontact
