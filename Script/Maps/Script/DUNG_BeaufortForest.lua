--[[
**********************************************
  
  DUNG_BeaufortForest.lua
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
 
version: 18.04.27
]]
local bos = {}

local function tut_Crystal()
    if Done("&DONE.TUTORIAL.CRYSTALS") or Var.G("%SKILL")>2 then return end
    MapText("TUT_CRYSTAL")
end     


field:ZA_Enter("Tut_Crystal",tut_Crystal)


function bos:NPC_FishingPole()
   CSay("Hoera! We hebben een hengel gevonden!")
   MapText("HENGEL")
   field:GiveTool('Ryanna',1)
   field:kill('NPC_FishingPole',true) 
end

local function PostBoss()
   field:GoToLayer('MEANWHILE','Start') -- Ryanna will spam, but things have been set up in a way that makes sure the player won't see her.
   -- $USE libs/klok
   local t = klok:CreateTimer(2.5)
   local map = field:getmap()
   repeat
     field:autoscroll()
     love.graphics.clear( )
     kthura.drawmap(map.map,map.layer,field.cam.x,field.cam.y)
     StatusBar(false,true)
     update_time()
     love.graphics.present()
   until t:enough()
   field:LoadMap('DUNG_BluePalace','Audience','HideRyanna')
   MapText('POSTBOSSFOREST')
   field:LoadMap('DUNG_BeaufortForest','#004','Resume')
   --error("Nothing next yet! Don't worry folks, it'll be there soon!")
end

field:ZA_Enter("Complete",function() 
    local skill=Var.G('%SKILL')
    if not(Done('&COMPLETE.DUNG.BEAUFORTFOREST')) then
           WorldMap_Unlock("C_WINDVILLE")
           rpg:DecStat('Ryanna','Experience',120/skill)
    end
    WorldMap("Beaufort")
end) -- The ) is needed... This function is directly tied to a ZA_Enter after all

function bos:Boss()
    if Done("&DONE.BOSS.ULTRABLOB") then return end
    MapText('PRE_BOSS')
    field:kill('BossActor',true)
    field:Schedule(PostBoss)
    BossFight("Very big slime","Ultra-Blob",
         {
           foes={'boss/ultraslime'},
           arena="forest_spar",
           postfoecompiler = function() rpg:Points('FOE_1','HP').Minimum=rpg:Points('FOE_1','HP').Maximum CSay('Invicibility turned on') end
    })
end


return bos
