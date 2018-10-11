--[[
  com_transform.lua
  Version: 18.10.11
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

-- This code has been specifically set up to only make Ryanna transform. If you really need to use this code in your own game
-- you MUST change it to make it compatible with your characters!!!


local trans = {}


local function trans_do(self,form)
       TransMake(form)    
       local tag = 'DEMON_RYANNA_'..form
       local mytrans = {}
       local myhero = self.fighters.Ryanna
       self.fighters[tag]=mytrans
       self.RyannaHuman=myhero
       self.fighters.Ryanna=nil
       mytrans.tag=tag
       mytrans.group='Hero'       
       mytrans.images = {}
       mytrans.x=myhero.x -- math.floor(midx + ((midx/(#RPGParty+1))*i) )
       mytrans.y=myhero.y -- math.floor(midy + ((midy/(#RPGParty+1))*i) )
       mytrans.statuschanges = {Transformed=Use('Script/Data/Combat/StatusChanges/Transformed.lua')}
       mytrans.statuschanges.Transformed.PreTurnAPDrain = Var.G("%TRANSMAINTAIN")              
       self.hero.Ryanna=nil
       self.hero[tag]=mytrans
       rpg:SetParty(1,tag)
       CSay("Cards redo!")
       self:RemoveCharCards('Ryanna')
       self:CreateOrder()
end

local function trans_ani(self,form)
     -- $USE libs/klok
     local dbg=true
     local timer = klok:CreateTimer(.005)
     local FLIP = function() love.graphics.present() update_time() timer:wait() end
     local animate = function(stage,f) self:basedraw() StatusBar(false,true) if dbg then itext.write(sval(stage),5,5) end if not f then FLIP() end end
     local myhero = self.fighters.Ryanna
     -- Stage #1: To trans
     local action = 'TransStage1'
     myhero.images[action] = myhero.images[action] or self:LoadHeroImage(myhero.tag,action)
     for i=1,ImgFrames(myhero.images[action]) do
         self.inaction,self.acting,self.heroframe = myhero.tag,action,i
         animate(1)
     end 
     -- Stage #2: Ryanna flicker
     local action = 'TransStage2'
     myhero.images[action] = myhero.images[action] or self:LoadHeroImage(myhero.tag,action)
     local boolfool = {[true]=1, [false]=2}
     local t2 = klok:CreateTimer(4)
     local boolframe
     repeat
         boolframe = not boolframe
         self.inaction,self.acting,self.heroframe = myhero.tag,action,boolfool[boolframe]
         animate(2)
     until t2:enough() 
     -- Stage #3: Ryanna disappear
     local action = 'TransStage3'
     myhero.images[action] = myhero.images[action] or self:LoadHeroImage(myhero.tag,action)
     for i=1,ImgFrames(myhero.images[action]) do
         self.inaction,self.acting,self.heroframe = myhero.tag,action,i
         animate(3)
     end 
     -- Stage #4: Ryanna in sphere (transforming)
     TransImg = TransImg or {}
     local t3 = klok:CreateTimer(5)
     local straal
     local i = 0
     repeat
         i = i + .4
         straal = math.abs(math.floor(math.sin(i)*37))+38
         if not TransImg[straal] then CSay("Need to load for radius "..straal) end
         TransImg[straal] = TransImg[straal] or LoadImage("GFX/Combat/TransformSphere.jpbf/Trans_rad_"..straal..".png")
         HotCenter(TransImg[straal])
         animate(4,true)
         DrawImage(TransImg[straal],myhero.x,myhero.y)
         FLIP()
     until t3:enough()     
     trans_do(self,form) 
end


function trans:RyannaTransform(form) 
  trans_ani(self,form)
end

function trans:RyannaRestore(ch)       
       self.hero.Ryanna     = self.RyannaHuman
       self.fighters.Ryanna = self.RyannaHuman
       local nilit
       for ch,_ in pairs(self.hero) do
           if prefixed(ch,"DEMON_RYANNA_") then nilit=ch end
       end
       self.hero[nilit]=nil            
       --self.hero[ch]=nil
       self.fighters[nilit]=nil
       rpg:SetParty(1,'Ryanna')
       --self:RemoveCharCards('DEMON_RYANNA',true)
       local level = rpg:Stat('Ryanna','Level')
       local ap = rpg:Points(ch,'AP').Have
       local hp = 1 -- default and also the value for the hard mode.
       local skill=Var.G("%SKILL")
       if     skill==1 then hp = rpg:Points('Ryanna','HP').Maximum 
       elseif skill==2 then
          local p = rpg:Points(ch,'HP').Have/rpg:Points(ch,'HP').Maximum
          hp = math.ceil(rpg:Points("Ryanna","HP").Maximum*p)
          if hp<=0 then hp=1 end
       end
       laura.setlevel('Ryanna',level,true)
       rpg:Points('Ryanna','AP').Have=ap
       rpg:Points('Ryanna','HP').Have=hp 
       self:RemoveCharCards(ch,true)
       self:CreateOrder()
       rpg:DelCharacter(ch) -- Prevent messed up transformation forms (and saves savegame space too).
       self.fighters[ch]=nil
end


return trans
