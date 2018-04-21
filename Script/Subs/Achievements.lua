--[[
  Achievements.lua
  Version: 18.03.29
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
local prijs = {}

-- "prijs" means both 'price' and 'prize' in Dutch.

-- $USE Script/Data/General/Achievements.lua AS prijs.awards
-- That line is a clear "abuse" of pre-processors :P

function prijs:Award(id)
    -- Internal
    CSay("Awarding: "..id)
    TrickAssert(prijs.awards[id],"Award "..id.." doesn't exist!",prijs.awards)
    gamedata.achievements = gamedata.achievements or {}
    gamedata.achievements.achieved = gamedata.achievements.achieved or {}
    gamedata.achievements.achieved[id] = true
    -- CSay(serialize('mynet',mynet)) -- debug. Must be deactivated in true release
    -- Game Jolt
    if mynet.loggedin_gj then
       CSay("= Writing to Game Jolt")
       local trophy_id = mynet["GAMEJOLT.AWARDS"][id]
       gjapi:trophies_addAchieved(trophy_id)
    end
    -- Anna
    if mynet.loggedin_anna then
      CSay("= Writing to Anna")
      --local udata = gdata.annalogin
      --local login = udata --[nan.tab]
      local login = {id=Var.C('$ANNA.ID'),secu=Var.C("$ANNA.SECU")}
      local query = {HC='Game',A='Auth',Game=mynet.data['ANNA.ID'],GameSecu=mynet.data['ANNA.KEY'],id=login.id,secu=login.secu} -- ,Version=mkl.newestversion(), (no mkl yet, and it's not needed anyway)
      local awc   = mynet["ANNA.AWARDS"][id] --gdata.data['AWARD.ANNA.'..upper(ach)]
      if not awc then console.writeln("WARNING! No Anna code for award: "..id,255,180,0) end --return false,'No Anna code for award: '..ach end
      query.AwardNo = awc
      local s,r = Anna_Request(query)
      local reason = "OK"
      CSay("  = Anna responded with: "..sval(s)..","..sval(r))
      if not s then reason = r end
      if not s then print("WARNING! Anna achievement failed: "..reason) love.window.showMessageBox( RYANNA_TITLE, "WARNING! Anna achievement failed: "..reason, 'error', false ) end
    --return s,reason    
    end
    -- Creating scrollthrough message
    st_Txt("- Achievement earned -",255,180,0)
    st_Txt(prijs.awards[id].Title,0,180,255)
end





return prijs
