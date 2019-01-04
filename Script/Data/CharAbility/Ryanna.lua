--[[
**********************************************
  
  Ryanna.lua
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
 
version: 18.12.29
]]
local chryanna = {

  abl = {
               Mystic = { start=true },
               Access = { scenario=true},
               Pickpocket = { start=true },
               ParalysingStab = { points=5 },
               PoisonStab = { points=7 },
               BackStab = { points=20 },
               FollowMe = { points=40},
               DarkMatter = { points=10 },
               PhantomHazard = {points=15 },
               ThePowerOfEvil = {points=35 }                               
        },
  TutTeach = function (self,abl)
               if self.abl[abl].scenario then return "???" end
               gamedata.xchardata = gamedata.xchardata or {}
               gamedata.xchardata.Ryanna = gamedata.xchardata.Ryanna or {}                
               -- local ra = Var.G("%RYANNA.ABILITYUSED") * Var.G("%SKILL")
               local ra = gamedata.xchardata.Ryanna.AbilitiesUsed or 0               
               local na = (self.abl[abl].points or 0) * Var.G("%SKILL")
               local za = na - ra
               if za<=0 then return "Attack a random target to obtain this ability" end
               return "Rynna needs to perform "..za.." special abilities in order to learn this one"      
             end,
  Teach = function(self,abl)
               if self.abl[abl].scenario then return false end
               gamedata.xchardata = gamedata.xchardata or {}
               gamedata.xchardata.Ryanna = gamedata.xchardata.Ryanna or {}                
               --local ra = Var.G("%RYANNA.ABILITYUSED") -- * Var.G("%SKILL")
               local ra = gamedata.xchardata.Ryanna.AbilitiesUsed or 0               
               local na = (self.abl[abl].points or 0) * Var.G("%SKILL")
               local za = na - ra
               return za<=0
          end           
}



return chryanna
