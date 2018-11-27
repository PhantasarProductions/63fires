--[[
**********************************************
  
  DUNG_BlackTower.lua
  (c) Jeroen Broks, 2018, All Rights Reserved.
  
  This file contains material that is related 
  to a storyline that is which is strictly
  copyrighted to Jeroen Broks.
  
  This file may only be used in an unmodified
  form with an unmodified version of the 
  software this file belongs to.
  
  You may use this file for your study to see
  how I solved certain things in the creation
  of this project to see if you find valuable
  leads for the creation of your own.
  
  Mostly this file comes along with a project
  that is for most part released under an
  open source license and that means that if
  you use that code with this file removed
  from it, you can use it under that license.
  Please check out the other files to find out
  which license applies.
  This file comes 'as-is' and in no possible
  way the author can be held responsible of
  any form of damages that may occur due to 
  the usage of this file
  
  
 **********************************************
 
version: 18.11.26
]]

-- $USE script/subs/screen

local blackie = {} -- Named after my ex-wife's cat. I guess you can guess the color of her fur... :-/
local gates
local skill=Var.G("%SKILL")
local bosses = {
      ['#010'] = {"Very very big slime","SupaSlime"},
      ['#030'] = {"Dump stinking idiot","Troll"},
      ['#050'] = {"Lord of the mountains","MountainKing",tname="Mountain King",music="Music/BossSpecial/Hall of the Mountain King.ogg"},
      ['#060'] = {"Gigantic bird of prey","GiantEagle",tname="Giant Eagle"}
}


local keyfloors = {"#040","#060","#090"}

local function gatetag(l,o)
   return l..";"..o.COORD.x..","..o.COORD.y
end

local function showgate(l,o)
    o.VISIBLE=true
    o.FRAMESPEED = math.random(1,4)-1
    gates[gatetag(l,o)]=true
    o.IMPASSIBLE=true
end       

local function qdraw()
    local map=field:GetMap()
    kthura.drawmap(map.map,map.layer,field.cam.x,field.cam.y)
    StatusBar(false,false)
end    
 

local function gate_out(ol)
      showgate(ol[1],ol[2])
      field:StopPlayer(true)
      for i=0,255 do
          love.graphics.clear()
          qdraw()
          color(0,0,0,i)
          love.graphics.rectangle("fill",0,0,screen.w,screen.h)
          love.graphics.present()
      end
      field:GoToLayer(gamedata.BlackTowerGates.terug or "#000",'Start')
      if not Done("&DONE.BLACKTOWER.STEPONGATE") then
         MapText("STEPONGATE")
         AwardEXP(nil,250)
      end
      field:getmap().map:remapall()
end        

field:ZA_Enter("vijf",function() if skill==1 then gates.terug=field:getmap().layer end end)
field:ZA_Enter("tien",function() if skill~=3 then gates.terug=field:getmap().layer end end)

-- Dirty scripting!
field:ZA_Enter("Leeroy",function()
    local globmap = field:getmap()
    local map = globmap.map    
    local leeroy = map.TagMap["#020"]["LeeroyJenkins"]
    local leeroyspot = map.TagMap['#020']["LeeroySpot"] 
    if (Done("&DONE.LEEROY.JENKINS")) then return end
    for i=1,9 do
        map.TagMap["#020"]["whelp"..i] = i <= Var.G("%SKILL")
    end
    field:PartyPop("Leeroy","South")
    MapText("LEEROY1")
    -- Leeroy enters
    for alpha=0,255,5 do    
        cls()
        leeroy.ALPHA=alpha/255
        kthura.drawmap(globmap.map,globmap.layer,field.cam.x,field.cam.y)
        StatusBar(false,true)
        love.graphics.present()
    end
    MapText("LEEROY2")
    -- Leeroy throws himself in
    repeat
        cls()
        if leeroy.COORD.x>leeroyspot.COORD.x then leeroy.COORD.x=leeroy.COORD.x-1 end
        leeroy.COORD.y=leeroy.COORD.y+2
        kthura.drawmap(globmap.map,globmap.layer,field.cam.x,field.cam.y)
        StatusBar(false,true)
        love.graphics.present()
    until leeroy.COORD.y>leeroyspot.COORD.y
    MapText("LEEROY3")
    local b={foes={},arena="Black_Tower"}
    for i=1,3*Var.G("%SKILL") do b.foes[#b.foes+1]="BOSS/DRAGONWHELP" end
    field:Schedule(function() 
          cls()
          field:kill("BossBarrier",true)
          field:kill("LeeroyJenkins",true)
          for i=1,9 do
              field:kill("whelp"..i,true)
          end 
          MapText("LEEROY4")
           
    end)
    BossFight("LEEROOOOOOOOY JENNKINS","Dragon Whelps",b) 
end)

field:ZA_Enter("LeeroyAchievement",function() Award("SCEN_LEEROY") end)

local function InitGates()
   local g=0
   local map = field:getmap().map
   gamedata.BlackTowerGates = gamedata.BlackTowerGates or {}; gates=gamedata.BlackTowerGates
   gates.terug = gates.terug or "#000"
   local old
   for o,l in map:allobjects() do
       if l~=old then
          old=l
          CSay("Analysing:"..l)
          console.show()
          love.graphics.present()
       end   
       if o.TEXTURE=="GFX/TEXTURES/DUNGEON/BLACK/WARDINGGATES.JPBF" then
          if gates[gatetag(l,o)] then 
             showgate(l,o)
          else
              o.VISIBLE=false
          end
          o.TAG="WGATE"..g
          field:ZA_Enter(o.TAG,gate_out,{l,o})
          g=g+1              
       end
   end
   map:remapall()    
end InitGates()

local function InitKeys()
    for iskill,ifloor in ipairs(keyfloors) do
        if iskill~=skill then
           field:laykill(ifloor,"NPC_Key")
           field:laykill(ifloor,"KEY_Barrier")
           console.Write("Key on floor ",255,255,0)
           console.Write(ifloor,0,255,255)
           console.Write(" has been removed because the skill is not ",255,255,0)
           console.Write(iskill,255,0,0)
           console.WriteLn("!",255,255,0)                      
        end
    end
end InitKeys()

function blackie:NPC_Yirl()
     MapText("YIRL") 
end

local function removebossbarrier()
   field:kill("NPC_Boss",true)
   field:kill("BossBarrier",true)
end

function blackie:NPC_Boss()
    local boss = bosses[field:getmap().layer]
    assert(boss,"No boss was for this floor, yet an NPC was tagged as one!")
    field:Schedule(removebossbarrier)
    BossFight(boss[1],boss.tname or boss[2],{foes={"Boss/"..boss[2]},arena='Black_Tower', music=boss.music})
end

function blackie:NPC_KRINKEL()
    local obj = field:getmap().map.TagMap["#029"].NPC_KRINKEL
    MapText("KRINKEL")
    obj.TEXTURE = "GFX/Actors/Black Tower/Krinkel_Faint.png"    
    MapText("KRINKEL2")
    field:kill("NPC_KRINKEL",true)
    field:kill("KRINKZONE",true)    
end

function blackie:NPC_Exodus()
    if not Done("&TUTORIAL.BLACKTOWER.EXODUSORB") then MapText("EXODUS") end
    if RunQuestion('MAP','EXQUESTION')==1 then
       field:GoToLayer("#000",'Start')
    end   
end

function blackie:NPC_Key()
    MapText("KEY")
    ItemGive("ITM_BLACKTOWER_KEY")
    Done("&KEY.TO_PRIMOSTUNNEL")
    field:kill("NPC_Key",true)
    field:kill("KEY_Barrier",true)
end

field:ZA_Enter("RyannaWardWhine",function() if not Done("&DONE.BLACKTOWER.RYANNAWARDWHINE") then MapText("RYANNAWARDWHINE") end end)
field:ZA_Enter("RyannaForgot",function() if not Done("&DONE.BLACKTOWER.RYANNAFORGOT") then MapText("RYANNAFORGOT") end end)
field:ZA_Enter("HardForceBoss",function()
      if skill==3 and (not Done(("&DONE.HARDMODEONLY.BLACKTOWER.BOSS%s"):format(field:getmap().layer))) then blackie:NPC_Boss() end
end)

return blackie
