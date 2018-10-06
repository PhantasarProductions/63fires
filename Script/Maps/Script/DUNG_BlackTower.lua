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
 
version: 18.10.06
]]

-- $USE script/subs/screen

local blackie = {} -- Named after my ex-wife's cat. I guess you can guess the color of her fur... :-/
local gates
local skill=Var.G("%SKILL")
local bosses = {
      ['#010'] = {"Very very big slime","SupaSlime"}
}


local function gatetag(l,o)
   return l..";"..o.COORD.x..","..o.COORD.y
end

local function showgate(l,o)
    o.VISIBLE=true
    o.FRAMESPEED = math.random(1,4)-1
    gates[gatetag(l,o)]=true
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
end        


local function InitGates()
   local g=0
   local map = field:getmap().map
   gamedata.BlackTowerGates = gamedata.BlackTowerGates or {}; gates=gamedata.BlackTowerGates
   gates.terug = gates.terug or "#000"
   local old
   for o,l in map:allobjects() do
       if l~=old then
          old=l
          CSay("Analying:"..l)
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

field:ZA_Enter("vijf",function() if skill==1 then gates.terug=field:getmap().layer end end)
field:ZA_Enter("tien",function() if skill~=3 then gates.terug=field:getmap().layer end end)

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
    BossFight(boss[1],boss[2],{foes={"Boss/"..boss[2]},arena='Black_Tower'})
end

return blackie
