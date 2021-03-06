--[[
**********************************************
  
  TOWN_Windville.lua
  (c) Jeroen Broks, 2018, 2019, All Rights Reserved.
  
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
 
version: 19.02.10
]]

--[[

   Now this particular script is very poorly organized.
   City map scripts often tend to be that way, tbh.
   I've done this the dirty way for starters, 
   and I apologize for the lack of order.
   Not gonna change that.
   It works this way, and THAT is the only thing that matters :P
   
   This is the city of Windville.
   This script makes the mills turn
   Unlocks several new missions
   And this is where Ryanna meets Nino and where Nino also joins the party.
   
   And that covers it up, I guess...
   
]]


local ANNAMONK
-- $USE libs/klok


-- CSay("Anna scanup result:"..sval(ANNAMONK.status))


-- Basic data crap
local windville = {}
local map=field:GetMap().map
local mills = {}
local rand=love.math.random
local millclock = klok:CreateTimer(.005)
local vault



-- Let the mills turn and turn and turn
function windville:oncycle()
    -- $USE script/subs/ANNAMONK
    if millclock:enough() then
       for mill in each (mills) do
           mill.deg = mill.deg + mill.spd
           if mill.deg>360 then mill.deg = mill.deg - 360 end
           mill.obj.ROTATION=mill.deg
        end
        millclock:reset()
    end
end    

-- Scan the map for all maps, so they they turn
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

-- Ryanna meets Nino for the first time
local function IntroNino()
      local RYANNA = map.TagMap.Outside.PLAYER1
      MapText("ENTER1")
      RYANNA:WalkTo('NinoSpot')
      MapText("ENTER2")
      field:kill('IntroNino',true)      
end
field:ZA_Enter("IntroNino",IntroNino)


-- A few area linkups
-- Since the areas are not numbered here, this needs to be done manually.
field:ZA_Enter("ToStatue",function() field:GoToLayer('Square','StartS') map.TagMap.Square.BackNino.VISIBLE=false end)
field:ZA_Enter("ToOutside",function() field:GoToLayer('Outside','StartN') end)
field:ZA_Enter("ToPalace",function()
    field:GoToLayer('Palace Entrance','StartS')
    omusic.play("Music/Town/Tower Defense.ogg")
end)
field:ZA_Enter("ToSquareFromPalace",function()
    field:GoToLayer("Square","StartN")
    omusic.play("Music/Town/Vivacity.mp3") 
end)
field:ZA_Enter("ToHall",function()
    field:GoToLayer("Palace Interior","StartS")
end)
field:ZA_Enter("BackEntrance",function()
    field:GoToLayer("Palace Entrance","StartN")
end)  

-- Conversation with Nino when Ryanna sees the statue
-- This is also where Nino joins the party
local function StatueNino()
    if Done("&DONE.WINDVILLE.NINOJOIN") then return end
    -- Pre-Join
    local RYANNA = map.TagMap.Square.PLAYER1
    local BNINO  = map.TagMap.Square.BackNino
    RYANNA:WalkTo('StatueSpot')
    RYANNA.WIND='North'
    MapText("STATUE1")
    BNINO.VISIBLE=true
    RYANNA.WIND='South'
    MapText("STATUE2")
    BNINO.VISIBLE=false
    -- Nino joins the party
    laura.makechar("Nino",5)
    rpg:SetParty(2,"Nino")
    -- Remove Nino from downtown area
    field:GoToLayer('Outside','StartN')
    field:kill('NPC_MT_NINO',true)
    field:kill('NINOGIRL1',true)
    field:kill('NINOGIRL2',true)
    -- Reset actors
    field:GoToLayer('Square','StatueSpot') 
end
field:ZA_Enter("LookStatue",StatueNino)

-- Make sure the Nino actors does not appear while Ryanna is not watching the statue
local HideNino = function()  map.TagMap.Square.BackNino.VISIBLE=false end    
field:ZA_Enter("HideNino"  ,HideNino)
field:ZA_Enter("BegoneNino",HideNino)

--[[
function windville:OpenVault()
   error("Opening the vault is not yet implemented!")
end 
]]

-- Activate the vault lock
function windville:NPC_VAULT()
   -- $USE libs/nothing
   MapText('VAULT')
   vault = Use('Script/Flows/PUZ_WindvilleVault.lua')
   vault.good = function(s)
       -- self.OpenVault
       field:GoToLayer("Palace Vault","Start","North")
       Award('BONUS_CHEAT')
       --error("No opening sequence yet")
   end    
   vault.mapscript = self
   vault.bad  = nothing
   flow.set(vault)
end

-- Leaving the vault
field:ZA_Enter('Leave',function()
    field:GoToLayer("Palace Interior","FromVault") 
end)


-- The king
function windville:NPC_King()
   ChMapText('KING')
end   

-- Marrilona cameo
-- She'll also unlock Freddy's
function windville:NPC_MARRILONA()
   MapText("CAMEO_MARRILONA")
   WorldMap_Unlock("D_FREDDY")
end   

-- Unlock the next dungeons once Nino joined the party
field:ZA_Enter('UnlockStarrow',function()
     --if not Var.G("&DONE.WINDVILLE.NINOJOIN") then return end
     if not rpg:IsInParty("Nino") then return end
     if Done("&DONE.WINDVILLE.UNLOCK.STARROW") then return end
     MapText("UNLOCKSTARROW")
     WorldMap_Unlock("D_STARROW")
     WorldMap_Unlock("D_PRIMOSTUNNEL")
     field:kill("UnlockStarrow",true)
end)
--[[
Notes:
   == Vault has two objects to kill if the vault door is succesfully opened!
      = NPC_VAULT
      = Vault
   Don't forget!!!
]]   

-- Enter the store
field:ZA_Enter('EnterStore',function()
    field:GoToLayer('Stores','Start')
end)

-- Leave the store
field:ZA_Enter('LeaveStore',function()
    field:GoToLayer('Outside','FromStore')
end)

-- Cameo Irravonia
-- She also offers an item shop
function windville:NPC_Irravonia()
    MapText("CAMEO_IRRAVONIA")
    Shop("IRRAVONIA")
end

-- Salvio's upgrade shop
function windville:NPC_UPGRADE()
    MapText("UPGRADER")
    UpgradeShop()
end


return startmills() -- will return the entire module in the process and start the mills. Yup, this is what we call dirty code.





--[[

    I don't need to script Aziella and Merya.
    Both have their speech text DIRECTLY linked to their personas in the city
    Yeah yeah, we got need for speed in our coding.
    Oh man, now I named a game in the source code....
    
    
    Oh wait, this was a parody to gemes.
    Then let's not worry about it :P
    
    ]]
