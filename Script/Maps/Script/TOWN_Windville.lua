--[[
**********************************************
  
  TOWN_Windville.lua
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
 
version: 18.05.01
]]

-- $USE libs/klok

local windville = {}
local map=field:GetMap().map
local mills = {}
local rand=love.math.random
local millclock = klok:CreateTimer(.005)


function windville:oncycle()
    if millclock:enough() then
       for mill in each (mills) do
           mill.deg = mill.deg + mill.spd
           if mill.deg>360 then mill.deg = mill.deg - 360 end
           mill.obj.ROTATION=mill.deg
        end
        millclock:reset()
    end
end    


local function startmills()
   CSay("= Award achievement if you didn't already have it")
   Award("ARRIVE_WINDVILLE")
   CSay("= Starting all the windmills")
   for o,l in map:allobjects() do
       if o.TEXTURE=="GFX/TEXTURES/WINDVILLE/MOLEN/WIEKEN.JPBF" then
          CSay("  = Found a mill blade on layer "..l)
          local mill = {}
          mills[#mills+1]=mill
          mill.obj=o
          mill.layer=l
          mill.deg=rand(0,360)
          mill.spd=rand(50,110)/1000
          o.ROTATION=mill.deg
       end   
   end
   return windville
end





return startmills() -- will return the entire module in the process and start the mills. Yup, this is what we call dirty code.




