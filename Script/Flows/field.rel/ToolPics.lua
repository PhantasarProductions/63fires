--[[
**********************************************
  
  ToolPics.lua
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
 
version: 18.06.30
]]

local function fish(spot)
   -- $USE Script/Flows/Fishing.lua
   CSay("Ryanna arrived at the fishing spot, so let's throw out a line, shall we?")
   Fishing:LoadSpot(spot)
   flow.set(Fishing)
end   
   

return {
   ToolPics={
       Ryanna={'Hengel','Grijphhaak','Scanner'},  -- Double h typo required or CRASH!
       Nino={'Gauntlet','Springschoen','Gitaar'},
       Shirley={'Dolly','Mistmantel','Onzichtbaarheidsmantel'},
       Lirmen={'Vlamstaff','Vriesstaf','Donderstaf'}  
   },
   ToolFuncs={
       Ryanna={       
            function() -- fish
                CSay("User requested Ryanna to fish")
                -- Is there a fishing spot? If not, let's ignore the request!
                local map = field:GetMap()
                if not map.map.TagMap[map.layer].Fish then return end
                local act = field:GetActiveActor()
                local fisha = map.map.TagMap[map.layer].Fish
                local Fishx,Fishy=math.floor(fisha.COORD.x/32),math.floor(fisha.COORD.y/32)
                if act:WalkTo(Fishx,Fishy) then field:SetArrival({fish,fisha.DATA.SPOT}) end
            end
       },
       Nino={
           function() -- Gauntlet
              CSay("Nino will smash the closest wall")
              field:DoCrack()
           end
       },
       Shirley={},
       Lirmen={}
   },
   ToolTut={
       Ryanna={'Send Ryanna out fishing if there\'s a fishing spot nearby','Throw out your grappling hook to find places\nyou cannot reach otherwise','Scan the area for secret passages'},
       Nino={'Destroy weak walls','Kris Kros will make you ...','Summon monsters'},
       Shirley={'Maybe Dolly can reach stuff you otherwise can\'t reach','Pass through certain obstacles','Turn off random encounters'},
       Lirmen={'Burn baby burn','Ice ice baby','State of shock!'}
   }
}
