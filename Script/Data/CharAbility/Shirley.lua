--[[
**********************************************
  
  Shirley.lua
  (c) Jeroen Broks, 2018, 2019, All Rights Reserved.
  
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
 
version: 19.02.08
]]
local skill = Var.G("%SKILL")
local chShirley = {

   abl = {
   
       Absorb = { start=true },
       PS2X = { need = 200 },
       PS3X = { need = 400 },
       War_Shout = { need = 800 },
       Cut_Down = { need = 1600 },
       Earth_Crack = { need = 3200 },
       PS5X = { need = 6400 },
       Shield = { need = 12800 },
       Mayhem = { need = 25600 }
       
   },
   
   TutTeach = function(self,abl)
       -- $USE Script/Subs/ShirleyAbsorb
       local t = ShirleyAbsorb:Total()
       local n = self.abl[abl].need * skill
       local a = ("You have %d and need %d monster points to unlock this ability"):format(
            t,
            n)
       if t>=n then a = "Just attack a random enemy to learn this ability!" end            
       return a     
   end,
   
   Teach = function(self,abl)
       -- $USE Script/Subs/ShirleyAbsorb
       if self.abl[abl].start then return false end
       local t = ShirleyAbsorb:Total()
       local n = self.abl[abl].need * skill
       return t>=n
   end  

}

return chShirley
