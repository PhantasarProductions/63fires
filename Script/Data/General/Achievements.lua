--[[
  Achievements.lua
  Version: 18.04.21
  Copyright (C) 2018 Jeroen Petrus Broks
  
  ===========================
  This file is part of a project related to the Phantasar Chronicles or another
  series or saga which is property of Jeroen P. Broks.
  This means that it may contain references to a story-line plus characters
  which are property of Jeroen Broks. These references may only be distributed
  along with an unmodified version of the game. 
  
  As soon as you remove or replace ALL references to the storyline or character
  references, or any termology specifically set up for the Phantasar universe,
  or any other univers a story of Jeroen P. Broks is set up for,
  the restrictions of this file are removed and will automatically become
  zLib licensed (see below).
  
  Please note that doing so counts as a modification and must be marked as such
  in accordance to the zLib license.
  ===========================
  zLib license terms:
  This software is provided 'as-is', without any express or implied
  warranty.  In no event will the authors be held liable for any damages
  arising from the use of this software.
  Permission is granted to anyone to use this software for any purpose,
  including commercial applications, and to alter it and redistribute it
  freely, subject to the following restrictions:
  1. The origin of this software must not be misrepresented; you must not
     claim that you wrote the original software. If you use this software
     in a product, an acknowledgment in the product documentation would be
     appreciated but is not required.
  2. Altered source versions must be plainly marked as such, and must not be
     misrepresented as being the original software.
  3. This notice may not be removed or altered from any source distribution.
]]
-- This file has be generated by Tricky's MyData
-- 21 Apr 2018; 19:34:39
-- License: This file is property of Jeroen Broks and may NOT be used for your own ends.



local ret = {
	["FISH_5"] = {
		["Description"] = "Catch 5 different kinds of fish (trash included, monsters are not).",
		["Icon"] = "*DEFAULT*",
		["NewGamePlus"] = true,
		["NormalGame"] = true,
		["Show"] = "Always",
		["Title"] = "Rock and pool, it's nice and cool, so juicy sweet.",
		["Type"] = "Gold",
		["skill1"] = true,
		["skill2"] = true,
		["skill3"] = true},
	["FISH_ALL"] = {
		["Description"] = "Catch at least 1 of every kind of fish (this includes trash, but excludes monsters)",
		["Icon"] = "*DEFAULT*",
		["NewGamePlus"] = true,
		["NormalGame"] = true,
		["Show"] = "Always",
		["Title"] = "I only wish to catch fish, so juicy sweet",
		["Type"] = "Platinum",
		["skill1"] = true,
		["skill2"] = true,
		["skill3"] = true},
	["GAMECOMPLETESKILL1"] = {
		["Description"] = "Complete the game in easy mode",
		["Icon"] = "*DEFAULT*",
		["NewGamePlus"] = true,
		["NormalGame"] = true,
		["Show"] = "Always",
		["Title"] = "Get away from me, creep!",
		["Type"] = "Bronze",
		["skill1"] = true,
		["skill2"] = false,
		["skill3"] = false},
	["GAMECOMPLETESKILL2"] = {
		["Description"] = "Complete the game in casual mode",
		["Icon"] = "*DEFAULT*",
		["NewGamePlus"] = true,
		["NormalGame"] = true,
		["Show"] = "Always",
		["Title"] = "I beat this game, and all I got was this lousy T-shirt",
		["Type"] = "Silver",
		["skill1"] = false,
		["skill2"] = true,
		["skill3"] = false},
	["GAMECOMPLETESKILL3"] = {
		["Description"] = "Complete the game in the hard mode",
		["Icon"] = "*DEFAULT*",
		["NewGamePlus"] = true,
		["NormalGame"] = true,
		["Show"] = "Always",
		["Title"] = "Tod ist mein leben",
		["Type"] = "Platinum",
		["skill1"] = false,
		["skill2"] = false,
		["skill3"] = true},
	["SCEN_TRANSFORM1"] = {
		["Description"] = "Unlock Ryanna's first transformation",
		["Icon"] = "*DEFAULT*",
		["NewGamePlus"] = true,
		["NormalGame"] = true,
		["Show"] = "Always",
		["Title"] = "Transformer! Ryanna in disguise",
		["Type"] = "Bronze",
		["skill1"] = true,
		["skill2"] = true,
		["skill3"] = true}}



-- Got all data, let's now return it!
return ret
