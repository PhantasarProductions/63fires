
local HealByType={
    Absolute=function(item,exe,tar)
        return item.Heal or 0
    end,
    Percent=function(item,exe,tar)
        local hp = rpg:Points(tar,'HP').Maximum
        local pr = (hp/100)
        return math.floor(pr+.5)
    end,
    StatPercent=function(item,exe,tar)
        local sn = item.Heal_StatPercent
        local st = rpg:Stat(exe,"END_"..sn)
        local pr = (st/100)
        return math.floor(pr+.5)
    end
    
}


function HealCalc(aitem,executor,target)
   local item=aitem
   if type(item)=='string' then item=ItemGet(item) end
   return HealByType[item.Heal_Type](item,executor,target)
end


return HealCalc