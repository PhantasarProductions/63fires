--[[
**********************************************
  
  DUNG_Starrow.lua
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
 
version: 18.07.13
]]

local skill=Var.G("%SKILL")
local sta = {}
local primes = {
  2,
  3,
  5,
  7,
  11,
  13,
  17,
  19,
  23,
  29,
  31,
  37,
  41,
  43,
  47,
  53,
  59,
  61,
  67,
  71,
  73,
  79,
  83,
  89,
  97,
}

local puzmaxanswer=(skill*2)+1
if skill<3 then
   for i=puzmaxanswer+1,7 do
      field:laykill('#005','PUZ_SIGN'..i,false)
      field:laykill('#005','PUZ_BUT' ..i,false)
   end
end

local puzgens = {}
local puzseq
math.randomseed(os.time())
local rnd = math.random

function puzgens:add()
   puzseq = {}
   local av = rnd(1,10)
   for i=1,5 do puzseq[i]=i*av end
end

function puzgens:sub()
   puzseq = {}
   local av = rnd(1,10)
   for i=1,5 do puzseq[6-i]=i*av end
end

function puzgens:mul()
   puzseq = {}
   local av = rnd(1,10)
   local vv = rnd(1,10)
   for i=1,5 do vv=vv*av puzseq[i]=v end
end

function puzgens:prime()
   puzseq = {}
   local sp = rnd(1,#primes-5)
   for i=1,5 do puzseq[i]=primes[i+sp] end
end

function puzgens:addsub()
   local a1=rnd(3,20)
   local b1=rnd(1,a1-1)
   local v=rnd(5,25)
   puzseq = {}
   for i=1,5 do 
       if i==1 or i==3 or i==3 then v = v + a1 else v = v - b1 end
       puzseq[i]=v
   end
end   
        

local puzskill = {
     {"add","sub"},
     {"add","sub","mul","prime"},
     {"add","sub","mul","prime","addsub"}
}

local puzzlesolved="&DONE.CAVESOFSTARROW.SEQUENCEPUZZLE.SOLVED"
local skill = Var.G("%SKILL")
local goed

field:ZA_Enter("PUZZLE_GEN",function()
   if Var.C(puzzlesolved)=="TRUE" then return end
   if puzseq then return end
   local ps = puzskill[skill]
   puzgens[ps[rnd(1,#puzgens)]](puzgens)
   goed=rnd(1,puzmaxanswer)
   for i=1,puzmaxanswer do
       if i~=goed then
          local r
          repeat
             r = rnd(math.ceil(puzseq[3]/2),puzseq[3]*5)
             Var.D("$STARROW_ANSWER"..i,""..r)
          until r~=puzseq[3]   
       else
          Var.D("$STARROW_ANSWER"..i,puzseq[3].."")
       end       
   end
   local q=""
   for i=1,5 do
       if i==3 then q = q .. "..." else q = q .. puzseq[i] end
       if i<5 then q=q..", " end
   end
   Var.D("$STARROW_SEQUENCE",q)
end)

field:ZA_Enter("PUZZLE_FORGET",function()
  if Var.C(puzzlesolved)=='TRUE' then return end
  puzseq=nil
end)

function sta:NPC_Gauntlet()
   CSay("Hoera! We hebben een gauntlet gevonden!")
   MapText("GAUNTLET")
   field:GiveTool('Nino',1)
   field:kill('NPC_Gauntlet',true)
   Award("TOOL_GAUNTLET") 
end

local function sign(i)
   MapText("SIGN_ANSWER"..i)
end

local function qdraw()
    local map=field:GetMap()
    kthura.drawmap(map.map,map.layer,field.cam.x,field.cam.y)
    StatusBar(false,false)
end    


local function plate(i)
   if Var.C(puzzlesolved)=='TRUE' then return end
   local tex="GFX/Textures/PressurePlates/Circular/Pressed.png"
   local map=field:GetMap().map
   local obj=map.TagMap["#005"]["PUZ_BUT"..i]
   local otx=obj.TEXTURE
   local bar=map.TagMap["#005"]["PUZ_BARRIER"]
   obj.TEXTURE=tex
   qdraw(map)
   love.graphics.present()
   love.timer.sleep(5)
   if i==goed then
      for y=0,-100,-1 do
          bar.COORD.y=y
          bar.ALPHA=bar.ALPHA-.01
          bar.IMPASSIBLE=false
          qdraw(map)
          love.graphics.present()
          Done(puzzlesolved)
      end
      map:remapall()
   else
       obj.TEXTURE=otx
       field:GoToLayer("#004",'Einde')
       MapText("PUZFAIL")  
   end
end

for i=1,puzmaxanswer do
    CSay("Linking stuff for puzzle slot: "..i)
    field:CA_Click("PUZ_SIGN"..i,sign,i)
    field:ZA_Enter("PUZ_BUT" ..i,plate,i)
end

return sta
