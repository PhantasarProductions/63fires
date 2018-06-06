local skill = Var.G("%SKILL")
local ijs = {
   StatMod= {
      Intelligence = 12/skill,
      Speed=math.ceil(2/skill)
   },
   StatRep={
      Power=5,
      Evasion=2,
      ER_Lightning=5,
      ER_Water=5,
      ER_Fire=0,
      ER_Frost=6
   }
}
return ijs