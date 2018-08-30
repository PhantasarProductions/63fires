local AliceCooper = {}

function AliceCooper:predraw()
     Color(0,255,0)
end

AliceCooper.postdraw=white

AliceCooper.Damage = {
     {.01,.250},
     {.10,.100},
     {.25,.005} 
}

function AliceCooper:startturn(chtag)
     local fof = 1
     if prefixed(chtag,"FOE_") then fof=2 end
     -- fof => Friend(1) or Foe(2)
     local skill = Var.G("%SKILL")
     local damrate = AliceCooper.Damage[skill][fof]
     local maxhp = rpg:Points(chtag,"HP").Maximum
     local damage = math.ceil(maxhp*damrate)
     self:TagMessage(chtag,"Poison: "..damage,0,100,0,20)
     rpg:Points(chtag,"HP").Dec (damage)          
end

return AliceCooper