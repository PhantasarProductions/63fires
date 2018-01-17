--[[
  boxtest_headers.lua
  
  version: 18.01.17
  Copyright (C) 2018 Jeroen P. Broks
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
function LoadScenario(tag,file)
   -- $USE Libs/scenario
   assert(tag,"No tag for LoadScenario")
   assert(file,"No file for LoadScenario")
   return scenario.LoadData(file,tag)
end   

function SerialBoxText(file,ptag,boxback)
   -- $USE Script/Subs/boxtext
   boxtext.SerialBoxText(file,ptag,boxback)
end

function MapText(ptag,boxback)
   SerialBoxText("MAP",ptag,boxback)
end   

function GetBoxTextFont()
   -- $USE libs/itext
   BOXTEXTFONT_FONT_GLOBAL_VARIABLE = BOXTEXTFONT_FONT_GLOBAL_VARIABLE or itext.loadfont('GFX/StoryFont')
   return BOXTEXTFONT_FONT_GLOBAL_VARIABLE
end  

return true
