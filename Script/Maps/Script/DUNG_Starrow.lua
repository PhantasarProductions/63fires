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
 
version: 18.07.05
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

field:ZA_Enter("PUZZLE_GEN",function()
   if Var.C(puzzlesolved)=="TRUE" then return end
   if puzseq then return end
   local ps = puzskill[skill]
   puzgens[ps[rnd(1,#1)]](puzgens)
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

return sta
