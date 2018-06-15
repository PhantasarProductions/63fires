--[[
**********************************************
  
  upgradedata.lua
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
 
version: 18.06.14
]]
local ugd = {
     Ryanna = {
         Weapon = { name='Kick shoes',
                    u1 = { Power=4, Accuracy=3, Speed=3 },
                    u2 = { Power=3, Accuracy=2, Speed=1 },
                    u3 = { Power=1, Accuracy=1, Speed=1 } 
                  },
         Armor = { name="Thief's cloak",
                   u1 = {Defense=5,Evasion=3, Speed=2 },
                   u2 = {Defense=3,Evasion=2, Speed=1 },
                   u3 = {Defense=1,Evasion=1, Speed=1 }
                 }         
     },
     Nino = {
         Weapon = { name="Fencing Rapier",
                    u1 = {Power=8, Accuracy=1, Intelligence=1},
                    u2 = {Power=4, Accuracy=1, Intelligence=1},
                    u3 = {Power=3}
         } ,
         Armor  = { name = "Chainmail",
                    u1 = {Defense=7, Evasion=3},
                    u2 = {Defense=5, Evasion=1},
                    u3 = {Defense=3}
         },
     },
     Shirley = {
        Weapon  = { name="Goliath",
                    u1={Power=9,Speed=1},
                    u2={Power=5,Speed=1},
                    u3={Power=3},
                  },  
        Armor   = { name='Little Dress',
                    u1={Speed=5,Evasion=5},
                    u2={Speed=2,Evasion=4},
                    u3={Speed=1,Evasion=2},                    
                  }
     },
     Lirmen = {
         Weapon = { name = "Wizard's Staff",
                    u1 = {Power=1, Intelligence=7, Speed=2},
                    u2 = {Power=1, Intelligence=4, Speed=1},
                    u3 = {Power=1, Intelligence=2}
                  },
         Armor  = { name="Mage's Robe",
                    u1 = {Resistance=8, Defense=1, Speed=1},
                    u2 = {Resistance=4, Defense=1, Speed=1},
                    u3 = {Resistance=2, Defense=1}
                  }         
     }
}


return ugd
