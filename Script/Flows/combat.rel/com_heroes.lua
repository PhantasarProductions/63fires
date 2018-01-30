--[[
  com_heroes.lua
  Version: 18.01.28
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
local hero = {}

function hero:LoadHeros()
   self.hero={}
   -- $USE script/subs/screen
   local midx = screen.w/2
   local midy = (screen.h-120)/2
   self.fighters = self.fighters or {}
   for i,ch in ipairs(RPGParty) do
       self.hero[ch] = self.hero[ch] or {}
       local myhero = self.hero[ch]
       self.fighters[ch]=myhero
       myhero.tag=ch
       myhero.group='Hero'       
       myhero.images = {}
       myhero.x=math.floor(midx + ((midx/(#RPGParty+1))*i) )
       myhero.y=math.floor(midy + ((midy/(#RPGParty+1))*i) )
   end
end

function hero:LoadHeroImage(tag,act)
    local basefile = 'GFX/Combat/Fighters/Hero/'..tag.."_"..act
    for try in each({'.png',".jpbf"}) do
        CSay("Trying to load: "..basefile..try)
        if JCR_Exists(basefile..try) or JCR_HasDir(basefile..try) then return LoadImage(basefile..try) end
    end
    error("No image data found for: "..basefile)    
end

function hero:DrawHero(myhero,targeted,action,actionframe)
     myhero.images[action] = myhero.images[action] or self:LoadHeroImage(myhero.tag,action)
     local f = actionframe
     if f>#myhero.images[action].images then f=1 end
     DrawImage(myhero.images[action],myhero.x,myhero.y,f)     
end

function hero:DrawHeroes(targeted,inaction,action,actionframe)
     for k,v in pairs(self.hero) do
         local paction='IDLE'
         local f = 1
         if inaction==k or inaction=='ALL' or inaction=='ALLHEROES' then paction=action f=actionframe end
         --CSay(serialize(k..', my hero',v))
         self:DrawHero(v,targeted,paction,f)
     end
end     

return hero
