--[[
**********************************************
  
  upgrade.lua
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
 
version: 18.06.09
]]
local width, height = love.graphics.getDimensions(  )
local upg = { nomerge=true }
--local stats = {"Power","Defense","Intelligence","Resistance","Speed","Accuracy","Evasion"} --,"HP","AP","Awareness"}

local upgrades = Use("Script/Data/General/UpgradeData.lua")

upg.mode = 'upgrade'

upg.modes = {}

-- $USE libs/nothing
upg.iconstrip = {
     {icon='upgrade',tut='Upgrade your gear',cb=nothing},
     {icon='help',tut="How does it all work!",cb=iconstriphelp}
}



function upg.modes.upgrade( x,w,ch,click )
end

return upg
