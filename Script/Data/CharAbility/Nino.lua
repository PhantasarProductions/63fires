--[[
**********************************************
  
  Nino.lua
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
local chnino = {
    abl = { heal = {start=true},
            curepd = {lv=7},
            rejuvenate = {lv=11},
            feroslash = {lv=14},
            vitalize = {lv=19},
            esuna = {lv=20},
            holystrike = {lv=25},
            sanctify = {lv=27},
            firestorm = {lv=30},
            resurrection = {lv=40}
          },
    TutTeach = function(self,abl)
        local lv = rpg:Stat('Nino','Level')
        if lv>=(self.abl[abl].lv or 1) then
           return "Nino has the required level. Attack a random enemy to learn this ability!"
        end
        return ("Nino will learn this ability once he has reached level %2d"):format(self.abl[abl].lv or 1)   
    end,
    Teach = function(self,abl)
        local lv = rpg:Stat('Nino','Level')
        return lv>=(self.abl[abl].lv or 1)
    end 
    

}

return chnino
