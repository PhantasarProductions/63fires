--[[
  flw_execution.lua
  Version: 18.11.06
  Copyright (C) 2018 Jeroen Petrus Broks
  
  ===========================
  This file is part of a project related to the Phantasar Chronicles or another
  series or saga which is property of Jeroen P. Broks.
  This means that it may contain references to a story-line plus characters
  which are property of Jeroen Broks. These references may only be distributed
  along with an unmodified version of the game. 
  
  As soon as you remove or replace ALL references to the storyline or character
  references, or any termology specifically set up for the Phantasar universe,
  or any other univers a story of Jeroen P. Broks is set up for,
  the restrictions of this file are removed and will automatically become
  zLib licensed (see below).
  
  Please note that doing so counts as a modification and must be marked as such
  in accordance to the zLib license.
  ===========================
  zLib license terms:
  This software is provided 'as-is', without any express or implied
  warranty.  In no event will the authors be held liable for any damages
  arising from the use of this software.
  Permission is granted to anyone to use this software for any purpose,
  including commercial applications, and to alter it and redistribute it
  freely, subject to the following restrictions:
  1. The origin of this software must not be misrepresented; you must not
     claim that you wrote the original software. If you use this software
     in a product, an acknowledgment in the product documentation would be
     appreciated but is not required.
  2. Altered source versions must be plainly marked as such, and must not be
     misrepresented as being the original software.
  3. This notice may not be removed or altered from any source distribution.
]]
local beul = {}
--[[ "Beul" is the Dutch word for "Exectioner" in the context of executing capital punishment. 
     Just allow me my dark side of humor, will ya :P ]]
     

-- esf = execution 'sub' flow....
-- Yeah, this the most complex part of the flows after all :P
-- local subflow



-- The move name as appeared on Screen, but let's wait a very short while before acting
local oldprewait
function beul:esf_prewait()
     --itext.write("prewait",6,6)
     oldprewait = oldprewait or love.timer.getTime()
     local newprewait = love.timer.getTime()
     if math.abs(newprewait-oldprewait)<.5 then -- ABS is used to prevent freezes if the timer suddenly turns 'minus' in the middle of a wait.        
        return
     end
     -- CSay("PreWait Ended!\n"..serialize("nextmove",self.nextmove))
     oldprewait=nil
     self.esf='pose'
     if self.nextmove.removeitem then RemoveItem(self.nextmove.removeitem) end
     if prefixed(self.nextmove.act:upper(),"ABL_HERO_RYANNA") then --and self.nextmove.executor=='Ryanna' then
        gamedata.xchardata = gamedata.xchardata or {}
        gamedata.xchardata.Ryanna = gamedata.xchardata.Ryanna or {} 
        gamedata.xchardata.Ryanna.AbilitiesUsed = (gamedata.xchardata.Ryanna.AbilitiesUsed or 0)+1;
     end
end

local poses = {
     Hero = function(self)
            local steps = 10
            local item = ItemGet(self.nextmove.act)
            local myhero = self.fighters[self.nextmove.executor]
            myhero.posestage = myhero.posestage or {stage=1, targets=self.nextmove.targets}
            local pose = myhero.posestage
            pose.oldtime = pose.oldtime or love.timer.getTime()
            local newtime = love.timer.getTime()
            if math.abs(newtime-pose.oldtime)<0.05 then return end
            pose.oldtime=newtime
            -- Stage one: Determine if we may jump and if so, jump to the enemy.
            if pose.stage==1 then
               myhero.rx = myhero.rx or myhero.x
               myhero.ry = myhero.ry or myhero.y
               if pose.allowjump == nil then
                  if not item.Stance_JumpToEnemy then
                     pose.allowjump = false
                     pose.stage = 2
                     return
                  end
               pose.allowjump=true    
               end
               if not pose.tx then
                  if #pose.targets==1 then
                     pose.tx = self.fighters[pose.targets[1]].x + 70
                     pose.ty = self.fighters[pose.targets[1]].y
                  else
                     -- $USE script/subs/screen                     
                     pose.tx =  screen.w     /2
                     pose.ty = (screen.h-120)/2
                  end                  
               end
               pose.frame = pose.frame or 1
               pose.dx = pose.dx or (myhero.rx - pose.tx)
               pose.dy = pose.dy or (myhero.ry - pose.ty)
               pose.sx = pose.sx or (pose.dx/steps)
               pose.sy = pose.sy or (pose.dy/steps) 
               pose.step = pose.step or 0
               myhero.x = myhero.rx - (pose.sx*pose.step)                              
               myhero.y = myhero.ry - (pose.sy*pose.step)
               pose.step = pose.step + 1
               if pose.step>steps then
                  pose.step = steps
                  pose.stage=2
               end
               return                           
            end
            if pose.stage==2 then
               pose.frame = pose.frame or 1
               pose.posetick = (pose.posetick or 0) + 1
               if pose.posetick<5 then return end
               pose.posetick=0
               self.inaction,self.acting,self.heroframe = myhero.tag,item.Stance,pose.frame 
               pose.frame = pose.frame + 1
               myhero.images[item.Stance] = myhero.images[item.Stance] or self:LoadHeroImage(myhero.tag,item.Stance)
               if pose.frame>#myhero.images[item.Stance].images then 
                  pose.frame=#myhero.images[item.Stance].images
                  self.esf="spellani"
               end
            return      
            end 
            if pose.stage==10 then
               self.inaction,self.acting,self.heroframe = myhero.tag,"IDLE",1
               if not pose.allowjump then
                  self.esf = "backtoidle"
                  return
               end
               myhero.x = myhero.rx - (pose.sx*pose.step)                              
               myhero.y = myhero.ry - (pose.sy*pose.step)
               pose.step = pose.step - 1
               if pose.step<0 then
                  myhero.x = myhero.rx
                  myhero.y = myhero.ry
                  --myhero.posestage = nil
                  --self.inaction = nil
                  self.esf = "backtoidle"
               end
               
            end
     end,
     Foe  = function(self) 
            local steps = 10
            local item = ItemGet(self.nextmove.act)
            local myfoe = self.fighters[self.nextmove.executor]
            myfoe.posestage = myfoe.posestage or {stage=1, targets=self.nextmove.targets}
            local pose = myfoe.posestage
            pose.oldtime = pose.oldtime or love.timer.getTime()
            local newtime = love.timer.getTime()
            if math.abs(newtime-pose.oldtime)<0.05 then return end
            pose.oldtime=newtime
            -- Stage one: Determine if we may jump and if so, jump to the enemy.
            if pose.stage==1 then
               myfoe.rx = myfoe.rx or myfoe.x
               myfoe.ry = myfoe.ry or myfoe.y
               if pose.allowjump == nil then
                  if not item.Stance_JumpToEnemy then
                     pose.allowjump = false
                     pose.stage = 2
                     return
                  end
               pose.allowjump=true    
               end
               if not pose.tx then
                  if #pose.targets==1 then
                     pose.tx = self.fighters[pose.targets[1]].x - 70
                     pose.ty = self.fighters[pose.targets[1]].y
                  else
                     -- $USE script/subs/screen                     
                     pose.tx =  screen.w     /2
                     pose.ty = (screen.h-120)/2
                  end                  
               end
               pose.frame = pose.frame or 1
               pose.dx = pose.dx or (myfoe.rx - pose.tx)
               pose.dy = pose.dy or (myfoe.ry - pose.ty)
               pose.sx = pose.sx or (pose.dx/steps)
               pose.sy = pose.sy or (pose.dy/steps) 
               pose.step = pose.step or 0
               myfoe.x = myfoe.rx - (pose.sx*pose.step)                              
               myfoe.y = myfoe.ry - (pose.sy*pose.step)
               pose.step = pose.step + 1
               if pose.step>steps then
                  pose.step = steps
                  pose.stage=2
               end
               return                           
            end
            if pose.stage==2 then
               local time = love.timer.getTime()
               pose.stage2timer = pose.stage2timer or time
               self.inaction = myfoe.tag
               if math.abs(pose.stage2timer-time)>1.5 then
                   self.esf="spellani"
                   self.inaction=nil
               end 
            return      
            end 
            if pose.stage==10 then
               --self.inaction,self.acting,self.foeframe = myfoe.tag,"IDLE",1
               self.inaction = nil
               if pose.sx then
                  myfoe.x = myfoe.rx - (pose.sx*pose.step)                              
                  myfoe.y = myfoe.ry - (pose.sy*pose.step)
               else
                  pose.step=0
               end   
               pose.step = pose.step - 1
               if pose.step<0 then
                  myfoe.x = myfoe.rx
                  myfoe.y = myfoe.ry
                  --myfoe.posestage = nil
                  --self.inaction = nil
                  self.esf = "backtoidle"
               end
               
            end
      
     end
}        
        
function beul:esf_pose()
   local myexe = self.fighters[self.nextmove.executor]
   --itext.write("posing: "..sval(myexe.group),5,5) --- Debug line
   if prefixed(self.nextmove.executor,"DEMON_RYANNA") and (not myexe) then self.esf='backtoidle' return end
   TrickAssert(myexe,"myexe is nil",{executor=self.nextmove.executor})
   TrickAssert(poses[myexe.group],"I cannot pose non-existent group:"..sval(myexe.group),myexe)
   poses[myexe.group](self)
end

function beul:esf_spellani()
   local item = ItemGet(self.nextmove.act)
   if item.SpellAni == "" then self.esf="perform" end
end

function beul:true_perform(tag,targettag)
   -- Pre-Performance configuration
   local item = ItemGet(self.nextmove.act)
   local warrior = self.fighters[tag]
   local target = self.fighters[targettag]
   local hit
   warrior.statuschanges = warrior.statuschanges or {} 
   -- Revive   
   if item.Revive then
      for st,stdat in pairs(warrior.statuschanges) do
          if stdat.undead then self:KillFighter(tag) return end
      end
      if rpg:Points(tag,'HP').Have==0 then
         rpg:Points(tag,'HP').Have=1
         ClearTable(warrior.statuschanges)
         self:TagMessage(tag,"Revive",180,255,0)
         TagMessage(tag,"DEATH",255,0,0)
         hit=true
      end   
   end
   -- Cure Status Changes (after revival one of the first things to do)
   local cure = {}
   for k,v in pairs(warrior.statuschanges) do
       if item['Cure'..k] then cure[#cure+1]=k end
   end
   for i,cs in ipairs(cure) do TagMessage(tag,"Cure: "..cs,180,255,0,-(i*20)) hit=true end   
   -- Heal
   -- $USE Script/Subs/HealCalc   
   local heal = 0 
   if (item.Heal or 0)>0 then heal = HealCalc(item,tag,targettag) end
   if heal>0 and (not self:StatusProperty(targettag,'blockhealing')) then
      if self:StatusProperty(targettag,'undead') then
         self:Hurt(targettag,heal)
         hit=true
      else
         self:TagMessage(targettag,heal,0,200,0)
         rpg:Points(targettag,"HP"):Inc(heal)
         hit=true
      end    
   end 
   -- Attack
   local attackhit = item.Attack>0
   if item.Attack_AllowAccuracy then attackhit=attackhit and math.random(0,99)<rpg:Stat(tag      ,"END_Accuracy") end
   if item.Attack_Dodge         then attackhit=attackhit and math.random(0,99)>rpg:Stat(targettag,"END_Evasion")  end
   if attackhit then
      hit=true
      self:Strike({exe=tag,tar=targettag,atk=rpg:Stat(tag,"END_"..item.Attack_AttackStat),def=rpg:SafeStat(tag,"END_"..item.Attack_DefenseStat),elem=item.Attack_Element,amd=item.Attack/100,allowcrit=item.Attack_AllowCritical})
   end   
   -- Add Fighter Cards
   -- Script 
   local effectscript
   if item.EffectScript and item.EffectScript~="" then
      effectscript = Use('Script/Data/Combat/ActEffect/'..item.EffectScript..".lua")
      assert(effectscript,"Error on loading "..item.EffectScript.." effect")
      assert(type(effectscript)=='function',"Effect "..item.EffectScript.." is not a function but a "..type(effectscript))
      hit = hit or effectscript(self,targettag,tag,item.EffectScript_Arg)
   end     
   -- Cause Status Changes (last thing to do before counter and miss message)
   for k,v in pairs(item) do if prefixed(k,"Cause") and v then
       local mystatus = Right(k,#k-5)
       self.statusdata[mystatus] = self.statusdata[mystatus] or Use('script/data/combat/statuschanges/'..mystatus..'.lua')
       local r=rpg:SafeStat(tag,"END_SR_"..mystatus)
       local die = math.random(0,99)
       if die>r then
          self.fighters[targettag].statuschanges = self.fighters[targettag].statuschanges or {}
          self.fighters[targettag].statuschanges[mystatus] = self.statusdata[mystatus]
          self:TagMessage(targettag,mystatus,180,0,0,-20)
       end
   end end
   -- Allowing counter attack
   -- Not miss?
   if not hit then self:TagMessage(tag,"Miss") end
end

function beul:esf_backtoidle()
   for _,v in pairs(self.fighters) do v.posestage=nil end
   self:RemoveFirstCard()
   -- if self.noidle and self.noidle>0 then
   --    self.noidle = self.noidle - 1
   --else
      self.flow='idle'
   --end   
   self.esf = nil
end

function beul:esf_perform()
   local item = ItemGet(self.nextmove.act)
   local warrior = self.fighters[self.nextmove.executor]
   for tag in each(self.nextmove.targets) do self:true_perform(self.nextmove.executor,tag) end
   if warrior.posestage then
      warrior.posestage.stage=10
      self.esf='pose'
   else
      self.esf='backtoidle'   
   end
   
end



-- Let's display the name of the move and the card of the executor
function beul:movename()
   self.menufont = self.menufont or GetBoxTextFont()
   itext.setfont(self.menufont)
   local item = ItemGet(self.nextmove.act)
   local tw = itext.width(item.Title)
   -- $USE script/subs/screen
   white()
   --self:DrawCard({tag=self.nextmove.exectioner},screen.w-(tw/2)-60,68)
   color(0,180,255)
   itext.write("> "..item.Title.." <",screen.w/2,100,2,2)
end



-- And the main execution manager
function beul:flow_execution()
    self:movename()
    self.esf = self.esf or 'prewait'
    self['esf_'..self.esf](self)
    
end





return beul
