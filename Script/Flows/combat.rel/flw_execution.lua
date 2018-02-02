--[[
  flw_execution.lua
  Version: 18.02.02
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
               pose.frame = pose.frame or 0
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
     end,
     Foe  = function(self) end
}        
        
function beul:esf_pose()
   local myexe = self.fighters[self.nextmove.executor]
   --itext.write("posing: "..sval(myexe.group),5,5) --- Debug line
   TrickAssert(poses[myexe.group],"I cannot pose non-existent group:"..sval(myexe.group),myexe)
   poses[myexe.group](self)
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
