--[[
**********************************************
  
  Absorb.lua
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
 
version: 18.12.28
]]
local penalty = {.5,1,5}
local failpc  = {0,1,10} -- Penalty count on failed absorbs
local skill   = Var.G("%SKILL")

return function(combat,targettag,shirleytag,params)

   -- Checkups and predefinitions
   local head = ("Combat.Hero.Shirley.Absorb(combat,%s,%s,<params>): "):format(targettag,shirleytag)
   assert(shirleytag=="Shirley",head.."Only Shirley can use the Absorb skill.")
   assert(prefixed(targettag,"FOE_"),head.."Only enemies can be absorbed")
   local target = combat.fighters[targettag]
   assert(target,head.."Target is nil!")
   local shirley=combat.fighters.Shirley
   assert(shirley,"Shirley is nil")
   
   -- Calling the absorb sub
   -- $USE Script/Subs/ShirleyAbsorb
   local absorb = ShirleyAbsorb -- LAAAAZY!
   
   -- Data shorcuts
   local sal = gamedata.xchardata.Shirley.AbsorbList    sal[target.ufil] = sal[target.ufil] or 0
   local sac = gamedata.xchardata.Shirley.AbsorbCount   sac[target.ufil] = sac[target.ufil] or 0
   local ufil = target.ufil   
   
   -- HP
   local shp = rpg:Points('Shirley','HP').Have
   local fhp = rpg:Points(targettag,'HP').Have
   
   -- Roll
   local srol = math.random(0,shp)
   local frol = math.random(0,fhp)
   
   -- success check
   local success = (not target.Boss) and ((shp==rpg:Points('Shirley','HP').Maximum and srol==shp) or srol>frol+math.floor(sac[ufil]*penalty[skill]))
   
   -- Absorb
   if success then
      sac[ufil] = sac[ufil] + 1
      if sal[ufil]<fhp then sal[ufil]=fhp end
      combat:TagMessage(targettag,"Absorbed!",255,36,0)
      combat.fighters[targettag]=nil
      combat.foes[targettag]=nil
      combat.foedraworder={}
      local orderkill={}
      for k,myfoe in spairs(combat.foedrawordertag) do
          if myfoe.tag==targettag then 
             orderkill[#orderkill+1]=k
          else   
             combat.foedraworder[#combat.foedraworder+1]=myfoe
          end    
      end
      for k in each(orderkill) do combat.foedrawordertag[k]=nil end                       
      return true
   end   
   
   -- Fail
   if math.random(1,10)<=failpc[skill] then sac[ufil] = sac[ufil] + 1 end
   local verschil = srol-frol
   combat:Hurt("Shirley",verschil)
   combat.TagMessage(targettag,"Absorb Resisted!",255,34,0)
   return true
   
end
