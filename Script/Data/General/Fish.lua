--[[
**********************************************
  
  Fish.lua
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
 
version: 18.03.08
]]
-- This file has be generated by Tricky's MyData
-- 08 Mar 2018; 12:47:49



local ret = {
	["PIRANHA"] = {
		["Fish"] = "FISH_PIRANHA.lua",
		["MaxLen"] = 26,
		["MinLen"] = 14,
		["Name"] = "Piranha",
		["Rate"] = 0,
		["ScoreByDm"] = 4},
	["ZZZ_OLDSHOE"] = {
		["Fish"] = "FISH_SHOE.lua",
		["MaxLen"] = 10,
		["MinLen"] = 5,
		["Name"] = "Old Shoe",
		["Rate"] = 0,
		["ScoreByDm"] = 2},
	["ZZZ_RUSTYCAN"] = {
		["Fish"] = "FISH_RUSTYCAN.lua",
		["MaxLen"] = 4,
		["MinLen"] = 3,
		["Name"] = "Rusty Can",
		["Rate"] = 0,
		["ScoreByDm"] = 3}}



-- Got all data, let's now return it!
return ret