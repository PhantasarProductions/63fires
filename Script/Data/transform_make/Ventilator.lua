local skill = Var.G("%SKILL")
local Ventilator={
         StatMod = {
              Speed = 24/skill,
              Power = 1/skill,
              Accuracy = 20,
              Evasion = 6/skill
         },
         StatRep = {
              ER_Wind = 6,
              ER_Lightning = 5,
              ER_Earth = 0
         }

}



return Ventilator
