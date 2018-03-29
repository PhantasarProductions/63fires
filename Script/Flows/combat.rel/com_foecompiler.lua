--[[
  com_foecompiler.lua
  Version: 18.03.29
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
local foecom = {}


local function fUl(a)
   return left(a,1):upper()..right(a,#a-1):lower()
end

function foecom:FreeLetter()
    local lettersused = {}
    --local r1,r2="?","Unknown"
    for k,v in pairs(self.foes) do
        if v.letter and v.letter~="?" then lettersused[v.letter]=true end
    end
    for i=65,90 do
        if not lettersused[string.char(i)] then return string.char(i),string.char(i) end
    end
    return "?","Unknown"
end    
       
   
function foecom:CompileFoe(i,foefile)
    -- $USE Libs/gini
    local skill = Var.G("%SKILL")
    local tag = "FOE_"..i   
    self.foes[tag] = { drops = {}, steals={}, actions={} }    
    local acttag = ({'EASY','CASL','HARD'})[skill]
    local myfoe=self.foes[tag]
    myfoe.deathscale = 1
    myfoe.letter,myfoe.letterfiletag=self:FreeLetter()
    myfoe.ufil = foefile:upper()
    console.write("Reading: ",255,255,0) console.writeln('Data/Foes/'..foefile..".gini",0,255,255)
    local actions=myfoe.actions
    local gfoe = ReadIni('Data/Foes/'..foefile..".gini")
    console.write("= Compiling for to: ",255,255,0) console.writeln(tag,0,255,255)
    if rpg:CharExists(tag) then CSay("WARNING! Overwriting existing character: "..tag) end
    rpg:CreateChar(tag)
    for vr in gfoe:EachVar() do
        CSay(vr.."="..gfoe:C(vr))
        if     vr=='STAT.CASH'  then rpg:DefStat(tag,"Cash" ,tonumber(gfoe:C(vr)) or 0)
        elseif vr=='STAT.LEVEL' then rpg:DefStat(tag,"Level",tonumber(gfoe:C(vr)) or 0)
        elseif vr=='STAT.EXPERIENCE' then rpg:DefStat(tag,"EXP",tonumber(gfoe:C(vr)) or 0)
        elseif vr=="DATA.NAME"  then rpg:SetName(tag,gfoe:C(vr))
        elseif vr=="DATA.DESC"  then -- we just need to ignore this field
        elseif vr=="DATA.IMAGE" then myfoe.image = FoeImage(gfoe:C(vr)) myfoe.frame=love.math.random(1,#myfoe.image.images) QHot(myfoe.image,"cb")
        elseif prefixed(vr,"STAT.") then
            local stat = fUl(right(vr,#vr-5))
            if stat=="Hp" then stat='HP' end
            rpg:DefStat(tag,"BASE_"..stat,gfoe:C(vr) or 0)
            rpg:DefStat(tag,"BUFF_"..stat,0)
            rpg:DefStat(tag,"END_"..stat,0)
            rpg:ScriptStat(tag,"END_"..stat,"libs/laura.rel/chars__ignore.lua","Enemy")
        elseif prefixed(vr,"ER.") then
            local stat = fUl(right(vr,#vr-3))
            rpg:DefStat(tag,"BASE_"..stat,gfoe:C(vr) or 0)
            rpg:DefStat(tag,"BUFF_"..stat,0)
            rpg:DefStat(tag,"END_"..stat,0)
            rpg:ScriptStat(tag,"END_"..stat,"libs/laura.rel/chars__ignore.lua","Enemy")            
        elseif prefixed(vr,"DATA.") then
            local dta = fUl(right(vr,#vr-5))
            rpg:DefData(tag,dta,gfoe:C(vr))   
        elseif prefixed(vr,"ACTION_"..acttag) then
            local val = tonumber(gfoe:C(vr))
            if val and val>0 then
               for i=1,val do
                   actions[#actions+1]=right(vr,#vr-#("ACTION_"..acttag.."."))
               end
            end               
        end
    end
    for k,tabel in pairs({DROP=myfoe.drops,STEAL=myfoe.steals}) do
        for i=1,5 do
            local rate = gfoe:C(k.."_RATE"..i) rate=tonumber(rate) or 0
            local item = gfoe:C(k.."_ITEM"..i)
            if suffixed(item,".lua") then item = left(item,#item-4) end
            if item and item~="" and rate>0 then
               for j=1,rate do tabel[#tabel+1]=item end
            end
        end
    end
    rpg:Points(tag,"HP",1).MaxCopy="END_HP"
    rpg:Points(tag,"HP").Have=rpg:Points(tag,"HP").Maximum
    myfoe.Boss = gfoe:C("BOOL.BOSS")=="TRUE"
    return tag
end

function foecom:LoadFoes()
  -- $USE libs/nothing
  self.fighters = self.fighters or {}
  self.foes={}
  self.foe=self.foes
  self.foedrawordertag = {}
  self.foedraworder = {}
  local rows = math.floor((#self.combatdata.foes-1)/3)
  -- Compile the foe data into game usable data
  for i,foefile in ipairs(self.combatdata.foes) do
      local tag = self:CompileFoe(i,foefile)
      local myfoe = self.foes[tag]
      self.fighters[tag] = myfoe
      local xpos = math.floor((i-1)/3)
      local ypos = i - (xpos*3)
      -- $USE script/subs/screen
      local midx = screen.w/2
      local midy = (screen.h-120)/2
      myfoe.x = math.floor(rows*xpos)+100
      myfoe.y = math.floor((midy/4)*ypos) + midy
      myfoe.dominance = 20
      myfoe.tag = tag
      myfoe.group="Foe"
      self.foedrawordertag [ right("00000"..myfoe.dominance,5).."."..right("00000"..myfoe.y,5).."."..right("00000"..myfoe.x,5) ] = myfoe      
  end
  for k,myfoe in spairs(self.foedrawordertag) do self.foedraworder[#self.foedraworder+1]=myfoe end
  (self.combatdata.postfoecompiler or nothing)()
end

function foecom:DrawFoe(myfoe,targeted,acting)
    -- targeted shit
    
    -- acting shit
    local scale=1
    if acting then
       local gt = math.floor(love.timer.getTime()*17)
       local gtt = right(gt,1)
       local gtv = tonumber(gtt) or 0
       if gtv<5 then scale=-1 end
    end    
    -- Drawing
    DrawImage(myfoe.image,myfoe.x,myfoe.y,myfoe.frame,0,scale,myfoe.deathscale or 1)
end


function foecom:DrawFoes(targeted,acting)
     for myfoe in each(self.foedraworder) do
         self:DrawFoe(myfoe,targeted==myfoe.tag or targeted=="ALLFOES" or targeted=="ALL",acting==myfoe.tag)         
     end
end





return foecom
