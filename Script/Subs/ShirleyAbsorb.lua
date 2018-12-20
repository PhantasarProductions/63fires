--[[
**********************************************
  
  ShirleyAbsorb.lua
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
 
version: 18.12.20
]]
local dontcallmeShirley = {} -- Yeah this is a referrence to Leslie Nielsen!

gamedata.xchardata.Shirley = gamedata.xchardata.Shirley or {}
gamedata.xchardata.Shirley.AbsorbList = gamedata.xchardata.Shirley.AbsorbList or {}
dontcallmeShirley.list = gamedata.xchardata.Shirley.AbsorbList

function dontcallmeShirley:Total()
    local list = self.list
    local total = 0
    for _,p in pairs(self.list) do total = total + p end
    return total
 end
 
 
 return dontcallmeShirley
