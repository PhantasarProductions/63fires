--[[
**********************************************
  
  TRUE_Prairie.lua
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
 
version: 18.12.19
]]
CSay("Welcome to the prairie!")

local prairie = {}

local map = field:getmap()
local tagmap = map.map.TagMap
local Shirley = tagmap.surface.NPC_Shirley

function prairie:overdraw()
    -- --[[ DEBUG: Shirley does not appear!
    -- $USE Script/Subs/Screen
    if Shirley then
       local line = love.graphics.line
       local sx = Shirley.COORD.x-field.cam.x
       local sy = Shirley.COORD.y-field.cam.y
       Color(math.random(0,255),math.random(0,255),math.random(0,255))
       line(0       ,       0,sx,sy)
       line(0       ,Screen.h,sx,sy)
       line(Screen.w,       0,sx,sy)
       line(Screen.w,Screen.h,sx,sy)       
    else
       -- CSay('No Shirley!')   
    end       
    -- ]]
end

local function PostShirley()
    local shirleylevel = Var.G('%LEVELCAP') or 0 -- Shirley's level equal to the current level cap 
    if shirleylevel<1 then shirleylevel=1 end -- If some players are trying to do a "no travel medal" challenge (fools) the game could crash when the cap is 0, so this should make sure Shirley's level is always 1 at least!
    MapText("SHIRLEY2")
    field:kill('NPC_Shirley',true)
    Done("&DONE.SHIRLEY.JOINED")
    -- Shirley joins the party
    laura.makechar("Shirley",shirleylevel)
    rpg:SetParty(3,"Shirley")
    -- All done, back the the world map
    WorldMap("PrimosRegion")
end

function prairie:NPC_Shirley()
    MapText("SHIRLEY1") 
    field:Schedule(PostShirley)
    BossFight("Pretty Little Girl with a Pretty Big Sword","Shirley",
         {
           foes={'boss/Shirley'},
           arena="prairie",
           music="Music/BossSpecial/Dee_Yan-Key_-_03_-_A_Childrens_Song.mp3"
    })
end
    
return prairie
