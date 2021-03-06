--[[
**********************************************
  
  DUNG_Freddy.lua
  (c) Jeroen Broks, 2019, All Rights Reserved.
  
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
 
version: 19.01.20
]]

-- $IF IGNORE
local field
-- $FI

local Freddy = {}


local schuifdeuren = {}
for deur in each({field:getmap().map.TagMap['#004'].Deur_Links,field:getmap().map.TagMap['#004'].Deur_Rechts}) do
    schuifdeuren[#schuifdeuren+1] = {
         deur = deur,
         x    = deur.COORD.x,
         m    = 0
    }
end
schuifdeuren[1].d = -1
schuifdeuren[2].d =  1

field:ZA_Enter("OperateDoor",function()    
    for deur in each(schuifdeuren) do deur.m=30-math.abs(deur.deur.COORD.x-deur.x)  end
    CSay("Sesam open u!")
end)

field:ZA_Leave("OperateDoor",function()
    CSay("Sesam sluit u!")
    for deur in each(schuifdeuren) do deur.m=-math.abs(deur.deur.COORD.x-deur.x) end
end)

function Freddy:oncycle()
    for deur in each(schuifdeuren) do
        if     deur.m>0 then deur.deur.COORD.x = deur.deur.COORD.x + deur.d deur.m=deur.m-1
        elseif deur.m<0 then deur.deur.COORD.x = deur.deur.COORD.x - deur.d deur.m=deur.m+1 end
    end
end    


field:ZA_Enter("Entrance",function()
    if not Done("&DONE.FREDDY.ENTER") then
       MapText("ENTRANCE")
    end
 end       
)

field:ZA_Enter("Hide_Einde", function()
      field:getmap().map:hidelabels('Einde',true) 
  end
)

field:ZA_Enter("Show_Einde", function()
      field:getmap().map:showlabels('Einde',true) 
      Award("SIDEQUEST_FREDDY")
  end
)



field:ZA_Enter("Activate_Scotty",function()
     -- error("The boss is not yet present! Please wait another five nights or so and he'll be implemented... I hope :P")
     if Done("&DONE.FREDDY.SCOTTY") then return end
     MapText("SCOTTY")
     BossFight("Specialized technician","Scott",
         {
           foes={'boss/scott'},
           arena="ss_facility",           
    })
    field:kill("Scott",true)
end)


return Freddy
