--[[
  flw_playerinput.lua
  Version: 19.01.19
  Copyright (C) 2018, 2019 Jeroen Petrus Broks
  
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
local invoer = {}


local function letsguard(self)
        self.nextmove.targets={self.invoeren}
        self.nextmove.pose=true
        self.nextmove.act="ACT_Guard"
        self.flow='execution'
        self.invoeren=nil                
end


invoer.items = {
          { tit = "Attack",x=100,y=5, tut="Physically attack on enemy", fun=function(self) self.flow='heroselecttarget' self.selecttype="1F" flushkeys() self.nextmove.act='ACT_Attack' end},
          { tit = "Ability", x=300,y=5, tut="Use special skills, spells or other abilities", fun=function(self) self.flow='selectability' end},
          { tit = "Item",x=100,y=50, tut="Use an item from your inventory", fun=function(self) self.flow='selectitem' end},
          { tit = "Guard",x=300,y=50, tut="Take a defensive stand\nThis will half damage received and recover a few AP", fun=letsguard}
}

-- Hover click
function invoer:hc(x,y,w,h,clicked,item)
     -- $USE libs/nothing
     local mx,my=love.mouse.getPosition()
     local hover = mx>x and my>y and mx<x+w and my<y+h 
     return hover,click(x,y,w,h,clicked,item.tut,item.fun or nothing,self)
end



function invoer:CheckCanLearn(hero)
        local mydebug = true
        local mychat=function(m) if mydebug then CSay(m) end end 
        --data[ch] = data[ch] or Use("Script/Data/CharAbility/"..ch..".lua")
        local data = Use("Script/Data/CharAbility/"..hero..".lua")
        gamedata.learned = gamedata.learned or {}
        local learned = gamedata.learned
        learned[hero] = learned[hero] or {}
        local has = learned[hero]
        mychat(("Action is %s:"):format(self.nextmove.act))
        if self.nextmove.act:upper()=="ACT_ATTACK" then
           for a,_ in pairs(data.abl) do
               if (not has[a]) and (data:Teach(a)) then
                  local item = ItemGet('ABL_HERO_'..hero.."_"..a)
                  has[a]=true;
                  white()
                  LoadScenario("LEARN","Learn") -- ('Scenario/%s/Learn'):format(Var.C('$LANG')))                  
                  SerialBoxText("LEARN",string.upper(hero))
                  self:TagMessage(hero,("\"%s\" learned"):format(item.Title),123,0,255)
                  self.nextmove.act=('ABL_HERO_%s_%s'):format(hero,a)
                  if item.Target=="1A" or item.Target=="OS" then
                     self.nextmove.targets={hero}
                  elseif item.Target=="AA" then
                     self.nextmove.targets={}
                     for k,_ in pairs(self.hero) do self.nextmove.targets[#self.nextmove.targets+1]=k end 
                  elseif item.Target=="AF" then
                     self.nextmove.targets={}
                     for k,_ in pairs(self.foe) do self.nextmove.targets[#self.nextmove.targets+1]=k end
                  elseif item.Target=="EV" then
                     self.nextmove.targets={}
                     for k,_ in pairs(self.fighters) do self.nextmove.targets[#self.nextmove.targets+1]=k end                       
                  end
                  return
               end
           end
        end  
end

-- Target selector 
-- Set up to work with both multi-target as single target
local tcol = {Foe={255,180,180},Hero={180,255,180}}
function invoer:flow_heroselecttarget()
     if self.selecttype=="OS" then
        self.nextmove.targets={self.invoeren}
        self.nextmove.pose=true
        self.flow='execution'
        self.invoeren=nil             
        return
     end
     local mx,my=love.mouse.getPosition()     
     if mousehit(2) then self.flow='playerinput' self.selecttype=nil flushkeys() self.invoeren=nil return end
     white()
     love.graphics.setFont(console.font)
     love.graphics.print("Click your desired target",5,5)
     local wrong
     local seltag,seldata
     for tag,fdata in pairs(self.fighters) do
         local w,h = fdata.w or 32 , fdata.h or 64
         if mx>fdata.x-(w/2) and mx<fdata.x+(w/2) and my<fdata.y and my>fdata.y-h then seltag,seldata=tag,fdata end
         --[[ debug
         color(0,0,255,80)
         if seltag==tag then color(255,0,0,90) end
         Rect(fdata.x-(w/2),fdata.y-h,w,h)
         itext.write(sval(fdata.x-(w/2))..","..sval(fdata.y-h).."> "..w.."x"..h.." m:"..mx..","..my,fdata.x,fdata.y)
         -- ]] -- end debug
     end 
     --itext.write(seltag or "NO TARGET",0,300) -- debug
     if not seltag then return end -- Alright, move along! There's nothing to see here!
     wrong = ( right(self.selecttype,1)=='A' and seldata.group=='Foe') or ( right(self.selecttype,1)=='F' and seldata.group=='Hero')
     if rpg:Points(seltag,'HP').Have==0 and (not self.selectallowdead) then return end
     if rpg:Points(seltag,'HP').Have~=0 and (self.selectonlydead) then return end
     if wrong and self.selectdiscriminate then return end
     if wrong then
        red()    itext.write("WARNING!",20,20)
        yellow() itext.write("This action is not meant for this target!",20,70)
     end
     local infotags = {seltag}
     if self.selecttype=="EV" or left(self.selecttype,1)=="A" then 
        infotags={} 
        for tag,fdata in pairs(self.fighters) do 
            if self.selecttype=="EV" or (self.selecttype=="AF" and fdata.group=="Foe") or (self.selectype=="AA" and fdata.group=="Hero") then infotags[#infotags]=tag end 
        end 
     end
     for tag in each(infotags) do
         local d = self.fighters[tag]
         local sn = rpg:GetName(tag)
         if d.group=="Foe" then sn = d.letter .. ". "..sn end
         color(tcol[d.group][1],tcol[d.group][2],tcol[d.group][3])
         love.graphics.print(sn,d.x,d.y-32)
         --itext.write(tag,d.x,d.y-100) -- debug
         local hpbar
         local skill = Var.G("%SKILL")
         if skill==1 or d.group=="Hero" then
            hpbar='show'
         elseif skill==3 then
            hpbar='none'
         else
            gamedata.bestiary = gamedata.bestiary or {}
            if not gamedata.bestiary[d.ufil] then hpbar='vraagteken' else hpbar='show' end
         end
         if hpbar~='none' then
            black()
            Rect(d.x,d.y-12,100,12)
            if hpbar=='vraagteken' then
               color(math.random(0,255),math.random(0,255),math.random(0,255))
               itext.write("?",d.x+50,d.y-6,2,2)
            else
               color(180,255,0)
               local deel   = rpg:Points(seltag,'HP').Have 
               local geheel = rpg:Points(seltag,'HP').Maximum               
               local ratio  = deel/geheel
               local bar    = math.floor(ratio*98)
               --itext.write("DEBUG: "..deel.." of "..geheel.." ratio:"..ratio.." bar:"..bar,d.x,d.y) --> Debug Line!
               Rect(d.x+1,d.y-11,bar,10)
            end   
         end    
     end
     if mousehit(1) then -- No need for other checks. If they are false, this code isn't executed anyway! :P
        self.nextmove.targets=infotags
        self.nextmove.pose=true
        self.flow='execution'
        self:CheckCanLearn(self.invoeren)
        self.invoeren=nil
     end   
end

function invoer:flow_selectitem()
    -- $USE script/subs/screen
    local i,c,item
    local win = {x=math.floor(screen.w*.05), y=math.floor(screen.h*0.05),w=math.floor(screen.w*.90),h=math.floor(screen.h*70)}     
    Color(0,0,180,180)
    Rect(win.x,win.y,win.w,win.h)
    c = mousehit(1)
    i = ItemSelector('combat',win.x,win.y,c,win)
    if mousehit(2) then self.flow='playerinput' end
    -- Item selected, let's work it out!
    if i then
       item = ItemGet(i)
       self.flow='heroselecttarget' 
       self.selecttype=item.Target
       self.nextmove.act=i 
       self.nextmove.removeitem=i
       flushkeys() 
    end
end


function invoer:flow_selectability()
    -- $USE script/subs/screen
    local ch=self.invoeren
    local i,c,item
    local win = {x=math.floor(screen.w*.05), y=math.floor(screen.h*0.05),w=math.floor(screen.w*.90),h=math.floor(screen.h*70)}     
    Color(0,0,180,180)
    Rect(win.x,win.y,win.w,win.h)
    c = mousehit(1)
    i = SelectAbility('combat',ch,c,win)
    if mousehit(2) then self.flow='playerinput' end
    -- Item selected, let's work it out!
    if i then 
       item = ItemGet(i)
       if rpg:Points(ch,'AP').Have>=(item.ABL_APCost or 0) then
          self.flow='heroselecttarget' 
          self.selecttype=item.Target
          self.nextmove.act=i 
          self.nextmove.takeap=item.ABL_APCost
          self.nextmove.checksilence=item.ABL_silenceblock
          if item.InputXtraScript and item.InputXtraScript~="" then
             local ixs = Use("Script/Data/Combat/InputXtraScript/"..item.InputXtraScript..".lua")
             assert( ixs , "InputXtraScript not in order" )
             ixs(self,item.InputXtraScript_Arg)
          end   
       flushkeys() 
       end    
    end
end

function invoer:OutAPAutoRestore()
   --local item = ItemGet("ZPECIAL_REVERT")
   self.nextmove.targets = {self.invoeren}
   self.nextmove.act = "ZPECIAL_REVERT"
   self.flow='execution'
   self.invoeren=nil
end


-- Combat main menu
function invoer:flow_playerinput()   
   if not self.invoeren then
      QuickPlay("Audio/Combat/Ready.ogg")
      self.invoeren = self.Cards[1].data.tag
      local apb = self:StatusProperty(self.invoeren,'PreTurnAPDrain')
      if apb then for apd in self:StatusPropertyValues(self.invoeren,'PreTurnAPDrain') do         
         local a = rpg:Points(self.invoeren,"AP")
         a.Have = a.Have - apd
         self:TagMessage(self.invoeren,apd,200,100,150)
         if a.Have<=0 then
            if self.fighters[self.invoeren].statuschanges.Transformed then
               self.nextmove={executor=self.invoeren}
               return self:OutAPAutoRestore()
            end
         end
      end end   
      self.nextmove={executor=self.invoeren}      
   end
   -- $USE script/subs/screen
   local midx =  screen.w     /2
   local midy = (screen.h-120)/2
   local clicked = mousehit(1)
   local ihover,iclicked   
   Color(0,0,0,127)
   Rect(midx-250,midy-50,500,100)
   Color(255,255,255)
   DrawPortrait(self.invoeren,midx-250,midy+50)
   self.menufont = self.menufont or GetBoxTextFont()
   itext.setfont(self.menufont)
   for item in each(self.items) do
       ihover,iclicked = self:hc((midx-250)+item.x,(midy-50)+item.y,180,50,clicked,item)
       if ihover then Color(0,180,255) else Color(255,255,255) end
       itext.write(item.tit,(midx-250)+item.x,(midy-50)+item.y)
   end    
  
end






return invoer
