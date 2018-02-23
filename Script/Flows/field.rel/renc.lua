--[[
  renc.lua
  Version: 18.02.23
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
local renc = {
   -- base values
   rennumtable=nil,
   rencstep=1,
   rencstepleft=1,
   rencstepchange=({250,150,50})[Var.G('%SKILL') or 2],
   rencmaxnum=5,
   rencgaugecol = {{0,0,255},{0,255,0},{255,180,0},{255,0,0}},
   rencon = true,
   monstertable = {},
   rencchance = {0,10000,5000,100,1},
    
   
   gauge=LoadImage("GFX/Combat/RENC/Gauge.png")
}

QHot(renc.gauge,'lb')


function renc:SetUpRencTable(pnum)
    -- Info
       -- Renc = Random Encounter. 
       -- Unless specifically stated otherwise in some definition files all layers will have 5 encounters.
       -- Leaving the dungeon or using savespots will reset this.
    -- Init
    local num = tonumber(pnum) or 5; if num<=0 then num=5 end 
    --local altnum = num -- tonumber(Maps.GetData('MaxEnc'))
    local map = self.getmap()
    local Maps = map.map
    --if altnum>5 then num=altnum end
    self.rencnumtable = {}
    if not Maps.Meta.Foes1 then return nil end -- If no enemies are set, then let's ignore this entire shit!
    local nolaystring = Maps.Meta.NoEncZones
    local nolay = {}
    if nolaystring~="" then nolay = mysplit(nolaystring,",") end
    local layers,orilayer = {},map.layer -- = ({ [0]=function() return {'SL:MAP'},nil end, [1]=function () return mysplit(Maps.Layers(),";"),Maps.LayerCodeName end})[Maps.Multi()]()
    for a,_ in spairs(map.map.MapObjects) do layers[#layers+1]=a end    
    -- Num Tables
    self.rencmaxnum = num -- ({[0]=-1,[1]=num})[Maps.Multi()]
    for layer in each(layers) do
        self.rencnumtable[layer] = num
    end
    for layer in each(nolay) do -- No encounters in these layers
        self.rencnumtable[trim(layer)] = nil 
        CSay("There should be no random encounters in layer: "..sval(layer))
    end
    self.rencstep = 1   
    self.rencstepleft = self.recstepchange 
end


function renc:SetUpRandomEncounters()
    self.monstertable = {}
    local map = self.getmap()
    local Maps = map.map
    local gst = {}
    local skill = Var.G('%SKILL')
    for s=1,skill do    
        local gs = Maps.Meta['Foes'..s]
        gst [ #gst + 1 ] = gs
    end
    -- if newgameplus then gst[ #gst + 1 ] = Maps.GetData('Foes_NG+') end
    for gs in each(gst) do
        local ga = mysplit(gs,";")
        for m in each(ga) do
            local ma = mysplit(m,",")
            ma[2]=ma[2] or 1 -- If not properly set 1 will be added.
            for ak=1,ma[2] do self.monstertable[#self.monstertable+1]=ma[1] end
        end    
    end    
end



function renc:RandomEncounter()
   local map = self.getmap()
   local Maps = map.map
   local skill = Var.G('%SKILL')
   local countparty = #RPGParty --CountPartyMembers()
   local rand = love.math.random
   local max = ({{1,2,3,4},{2,3,6,9},{3,6,9,9}})[skill][countparty]
   local tab = ({{1,1,1,2,2,3,1,1,2,3,4},{3,3,3,1,3,3,2,2,3,3,4,4,3,6,3,3,1,1,9},{3,3,3,6,6,9}})[skill]
   local num = tab[rand(1,#tab)]
   local arena = Maps.Meta.Arena or ""; if not suffixed(arena:lower(),".png") then arena = arena..".png" end
   local combatdata = {foes={}}
   if num>max then num=max end
   --ClearCombatData()
   combatdata.arena=arena --Var.D("$COMBAT.ARENA",arena)
   -- Var.D("$COMBAT.LOSE","Respawn") -- Not applicable
   local aet = Maps.Meta.AltEncounterTune
   if aet and aet~="" then
      if not suffixed(lower(aet),".ogg") then aet = aet .. ".ogg" end 
      combatdata.music = aet --Var.D('$COMBAT.MUSIC',aet)
   end   
   assert(#self.monstertable>0,"I cannot run a Random Encounter without any monsters set")   
   for i=1,num do
       combatdata.foes[#combatdata.foes+1]='Reg/'..self.monstertable[rand(1,#self.monstertable)] --Var.D("$COMBAT.FOE_"..i,monstertable[rand(1,#monstertable)]) 
   end
   --[[
   Actors.Actor("PLAYER").Walking=false
   Actors.Actor("PLAYER").Moving=false
   ]]
   self:StopPlayer()
   --WalkArrival=nil
   self:KillArrival()
   StartCombat(combatdata)
end
  
function renc:MustRenc()
    -- $USE Script/Subs/screen
    local SW=screen.w
    local SH=screen.H
    -- Data we need from the start
    local map = self.getmap()
    local Maps = map.map
    local skill = Var.G('%SKILL')
    local rencgaugey = 150
    local rand=love.math.random

    self.rencgaugex = self.rencgaugex or (SW+200)
    -- If the Renc table was not loaded (mostly because of coming in from a saved game), let's force our way in.
    if not self.rencnumtable then self:SetUpRencTable() end
    -- Get layer information
    local layer = map.layer
    --if Maps.Multi()==0 then layer='SL:MAP' else layer=Maps.LayerCodeName end -- no longer needed
    local encnum = self.rencnumtable[layer]
    -- Set x position
    if (not self.monstertable) or #self.monstertable<=0 then encnum=nil end
    if encnum and self.rencgaugex>SW-50  then self.rencgaugex = self.rencgaugex - 1 elseif (not encnum) and self.rencgaugex<SW+150 then self.rencgaugex=self.rencgaugex + 1 end
    -- Bar length
    local bar = 100
    if encnum and self.rencmaxnum then
       bar = math.ceil((encnum/self.rencmaxnum)*100)
    end 
    local col = self.rencgaugecol[self.rencstep]
    black()
    love.graphics.rectangle('fill',self.rencgaugex-5,rencgaugey-100,10,100)
    if self.rencon then
       for x=self.rencgaugex-5,self.rencgaugex+5 do
           local cmod = math.abs(math.sin((love.timer.getTime())+(x*10)))
           color(round(col[1]*cmod),round(col[2]*cmod),round(col[3]*cmod))
           love.graphics.line(x,rencgaugey,x,rencgaugey-bar)
           -- CSay("Image.Line("..x..","..tonumber((SH-1)-200)..","..x..","..tonumber(((SH-1)-200)-bar)..")  -- "..cmod.." -- "..round(col[1]*cmod)..","..round(col[2]*cmod)..","..round(col[3]*cmod))
       end 
       white() 
    else color(50,50,50) end
    DrawImage(self.gauge,self.rencgaugex-16,rencgaugey+2)--Image.Show('RENCGAUGE',rencgaugex,SH-200)
    
    ---[[
    
    --Image.NoFont()
    love.graphics.print('rencon = '..sval(self.rencon),5,20)
    love.graphics.print('encnum = '..sval(encnum),5,40)
    -- @FI ]]
    
    -- When no encounters are possible, let's get out of here.
    if not self.monstertable then self:SetUpRandomEncounters() end
    if not self.rencon then return end
    if not encnum then return end
    if encnum<=0 then return end
    if #self.monstertable<=0 then return end
    -- player data
    local player = self:GetActiveActor() -- Actors.Actor('PLAYER')
    local walking = player.walking or player.moving
    --[[ @IF RENCDEBUG
    DarkText('walking = '..sval(walking),5,60)
    DarkText('rencstep = '..sval(rencstep),5,80)
    DarkText('rencstepchange = '..sval(rencstepchange),5,100)
    DarkText('rencstepleft = '..sval(rencstepleft),5,120)
    -- @FI]]
    
    -- Change chance for encounter while walking and call the encounter routine when an encounter takes place.
    if walking then
       if self.rencstep<4 then
          self.rencstepleft = (self.rencstepleft or 150) - 1
          if self.rencstepleft <= 0 then
             self.rencstepleft = self.recstepchange
             self.rencstep = self.rencstep + 1
          end
       end
       if self.rencstep>1 and rand(1,self.rencchance[self.rencstep])==1 then -- In renc level 1 NEVER any encounters, on any higher level, let's come up with it.
          self:RandomEncounter()
          self.rencstep=1
          self.rencnumtable[layer] = self.rencnumtable[layer] - 1
          self.rencstepleft = self.recstepchange
       end
    end
end  








return renc


