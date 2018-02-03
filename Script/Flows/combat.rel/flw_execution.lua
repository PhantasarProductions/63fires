--[[
  flw_execution.lua
  Version: 18.02.03
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
     oldprewait=nil
     self.esf='pose'
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
               pose.posetick = (pose.posetick or 0) + 1
               if pose.posetick<5 then return end
               pose.posetick=0
               self.inaction,self.acting,self.heroframe = myhero.tag,"Attack",pose.frame
               pose.frame = pose.frame + 1
               myhero.images.Attack = myhero.images.Attack or self:LoadHeroImage(myhero.tag,'Attack')
               if pose.frame>#myhero.images.Attack.images then 
                  pose.frame=#myhero.images.Attack.images
                  self.esf="spellani"
               end
            return      
            end 
            if pose.stage==10 then
               self.inaction,self.acting,self.heroframe = myhero.tag,"IDLE",1
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
     Foe  = function(self) end
}        
        
function beul:esf_pose()
   local myexe = self.fighters[self.nextmove.executor]
   --itext.write("posing: "..sval(myexe.group),5,5) --- Debug line
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
          if heal.Reverse then self:KillFighter(tag) return end
      end
      if rpg:Points(tag,'HP').Have==0 then
         rpg:Points(tag,'HP').Have=1
         ClearTable(warrior.statuschanges)
         self:TagMessage(tag,"Revive",180,255,0)
         TagMessage(tag,"DEATH",255,0,0)
         hit=true
      end   
   end
   -- Cure Status Changes
   local cure = {}
   for k,v in pairs(warrior.statuschanges) do
       if item['Cure'..k] then cure[#cure+1]=k end
   end
   for i,cs in ipairs(cure) do TagMessage(tag,"Cure: "..cs,180,255,0,-(i*20)) hit=true end
   -- Heal
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
   -- Cause Status Changes
   -- Allowing counter attack
   -- Not miss?
   if not hit then self:TagMessage(tag,"Miss") end
end

function beul:esf_backtoidle()
   for _,v in pairs(self.fighters) do v.posestage=nil end
   self:RemoveFirstCard()
   self.flow='idle'
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
