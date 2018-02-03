--[[
  com_init.lua
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
local cinit = {}


function cinit:HaveTags()
   self.ftags = {}
   local ftags = self.ftags
   for _,party in ipairs(RPGParty) do ftags[#ftags+1]=party end
   for k,_ in pairs(RPGChars) do
       if prefixed(k,"FOE_") then ftags[#ftags+1]=k end
   end 
end

function cinit:CombatMusic(data)
    omusic.push()
    data.music = data.music or "Music/Combat"
    if JCR_HasDir(data.music) then omusic.random(data.music) else omusic.play(data.music) end
end    

function cinit:CombatStartEvent(data)
    -- $USE libs/nothing
    -- $IF IGNORE
    nothing()
    -- $FI
    ;(data.startevent or nothing)(data.startparameter)
end    

function cinit:Init(data)
   ResetMiniMsg()   
   Var.Kill("$SELECTEDABILITY") -- Prevent conflicts with looking to the abilities in the field
   self.combatdata = data -- Var2Table("COMBAT.",true)
   self:SetUpCards()
   self:YCards()
   self:SetUpArena(data.arena)
   self:LoadHeros()
   self:LoadFoes()
   self:HaveTags()
   self:SetupInitialCards(data)
   self:CombatMusic(data)
   self:CombatStartEvent(data)
end





return cinit
