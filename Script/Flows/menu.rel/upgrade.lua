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
 
version: 18.06.10
]]
local width, height = love.graphics.getDimensions(  )
local upg = { nomerge=true }
--local stats = {"Power","Defense","Intelligence","Resistance","Speed","Accuracy","Evasion"} --,"HP","AP","Awareness"}

local upgrades = Use("Script/Data/General/UpgradeData.lua")
local skill = Var.G("%SKILL")

upg.mode = 'upgrade'

upg.modes = {}

-- $USE libs/nothing
upg.iconstrip = {
     {icon='upgrade',tut='Upgrade your gear',cb=nothing},
     {icon='help',tut="How does it all work!",cb=iconstriphelp}
}

upg.eq={'Weapon','Armor'}

local function total(s) 
   local r=0
   for k,v in pairs(s) do
       if type(v)=='number' then r=r+v end
   end
   return r
end

local function cost(ch,eq)
   local r=1
   local max=128000000
   local u = gamedata.upgrades[ch][eq]
   if u==0 then return 1 end
   for i=1,u do
       r = r + r
       if r>max then return max end
   end
   return r
end

local function doupgrade(ch,eq)
    -- $USE libs/audio
    local u = gamedata.upgrades[ch][eq]
    local maxupdates = math.floor(Var.G("%LEVELCAP")/skill)
    if maxupdates<=0 then maxupdates=1 end
    local price = cost(ch,eq)
    local cash = Var.G("%CASH")
    if total(gamedata.upgrades[ch])>=maxupdates or cash<price then
       QuickPlay("Audio/Gen/NoWay.mp3")
       return
    end
    Var.D("%CASH",cash-price)
    QuickPlay("Audio/Gen/ChaChing.ogg")
    gamedata.upgrades[ch][eq] = u + 1
    for k,v in spairs(upgrades[ch][eq]['u'..skill]) do
        rpg:IncStat(ch,"EQP_"..k,v)
    end
end   


local tabupgrade = {Weapon=function(ch) doupgrade(ch,'Weapon') end, Armor=function(ch) doupgrade(ch,'Armor') end}

function upg.modes.upgrade( x,w,ch,clicked )
  local font = GetBoxTextFont()
  local maxupdates = math.floor(Var.G("%LEVELCAP")/skill)
  if maxupdates<=0 then maxupdates=1 end -- Should never be needed, but just in case!
  itext.setfont(font)
  gamedata.upgrades = gamedata.upgrades or {}
  gamedata.upgrades[ch] = gamedata.upgrades[ch] or {Weapon=0,Armor=0}
  local u = gamedata.upgrades[ch]
  for i,e in ipairs(upg.eq) do
      white()
      itext.write(e..":",x,i*80)
      color(0,180,255)
      itext.write(upgrades[ch][e].name,x+20,(i*80)+40)
      if total(u)<maxupdates then
         color(180,255,0)
         itext.write(DumpCash(cost(ch,e)),(x+w)-20,i*80,1,0)
      end   
      ember()
      itext.write(u[e],x+(w-20),(i*80)+40,1,0)
      local tut = "Upgrade "..ch.."'s "..e:lower().."\n\nEffects:"
      for k,v in spairs(upgrades[ch][e]['u'..skill]) do
          tut = tut .. "\n= "..k..": "
          if v>=0 then tut=tut.."+" end
          tut = tut .. v
      end
      click(x,(i*80),w,80,clicked,tut,tabupgrade[e],ch)    
  end
  white()
  itext.write("Cash:  "..DumpCash(Var.G("%CASH")),x,260)
  itext.write("Total: "..total(u),x,300)
  itext.write("Max:   "..maxupdates,x,380)
end

return upg
