--[[
  flw_playerinput.lua
  Version: 18.01.29
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
local invoer = {}


invoer.items = {
          { tit = "Attack",x=100,y=5, tut="Physically attack on enemy", fun=function(self) self.flow='heroselecttarget' self.selecttype="1F" end},
          { tit = "Ability", x=300,y=5, tut="Use special skills, spells or other abilities"},
          { tit = "Item",x=100,y=50, tut="Use an item from your inventory"},
          { tit = "Guard",x=300,y=50, tut="Take a defensive stand\nThis will half damage received and recover a few AP"}
}


function invoer:hc(x,y,w,h,clicked,item)
     -- $USE libs/nothing
     local mx,my=love.mouse.getPosition()
     local hover = mx>x and my>y and mx<x+w and my<y+h 
     return hover,click(x,y,w,h,clicked,item.tut,item.fun or nothing,self)
end

local tcol = {Foe={255,180,180},Hero={180,255,180}}
function invoer:flow_heroselecttarget()
     local mx,my=love.mouse.getPosition()
     white()
     love.graphics.setFont(console.font)
     love.graphics.print("Click your desired target",5,5)
     local wrong
     local seltag,seldata
     for tag,fdata in pairs(self.fighters) do
         local w,h = fdata.w or 32 , fdata.h or 64
         if mx>fdata.x-(w/2) and mx<fdata.x+(w/2) and my<fdata.y and my>fdata.y-h then seltag,seldata=tag,fdata end
         -- --[[ debug
         color(0,0,255,80)
         Rect(fdata.x-(w/2),fdata.y-h,w,h)
         itext.write(sval(fdata.x-(w/2))..","..sval(my>fdata.y-h).."> "..w.."x"..h.." m:"..mx..","..my,fdata.x,fdata.y)
         -- ]] -- end debug
     end 
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
         if d.group=="foe" then sn = d.letter .. ". "..sn end
         color(tcol[d.group][1],tcol[d.group][2],tcol[d.group][3])
         love.graphics.print(sn,d.x,d.y-32)
     end
end

function invoer:flow_playerinput()   
   if not self.invoeren then
      QuickPlay("Audio/Combat/Ready.ogg")
      self.invoeren = self.Cards[1].data.tag
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
