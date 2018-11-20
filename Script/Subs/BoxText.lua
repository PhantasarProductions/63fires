--[[
  BoxText.lua
  Version: 18.11.20
  Copyright (C) 2016, 2018 Jeroen Petrus Broks
  
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

-- -- @USEDIR Script/use/Scenario -- old GALE directive
-- $USE Libs/scenario 
-- $USE Libs/itext

local MouseCoords=love.mouse.getPosition

local SW,SH = love.graphics.getDimensions( )
local me= {}
local portret = scenario.portret
local boxtextitextfont
local btdata = scenario.btdata
local BOXTEXTAUDIO

local boxtextroutine = true -- needed?

--[[ will be replaced with alternat system
Backgrounds = {

       FLOW_FIELD = function() Cls() Maps.Draw() end,
       FLOW_COMBAT = function() Cls() MS.Run('COMBAT','DrawScreen') end,
       FLOW_WORLDMAP = function() MS.Run("WORLD","WorldBackFlow") end
}
]]


local altbackground = nil

function me.SetBoxTextAlt(a)
  if a == 'nil' then altbackground=nil else  altbackground = a end 
  end


--[[ No longer needed
function GALE_OnLoad()
   CSay("BoxText found screen sizes "..SW.."x"..SH)
end
]]

----

local function Flip()
   love.graphics.present()
   love.update()
   love.timer.sleep(.001)
end   

function me.ShowBox(data,boxback,highlight)
 -- local bb = boxback or "BOXTEXT.KTHURA" -- "BOXTEXT"
 local ret
 --[[
 ---- @IF BOXTEXTDEBUG
 -- CSay("Calling BoxTextBackGround from MS script: "..bb)
 -- @FI
 -- MS.Run(bb,"BoxTextBackGround")

 ---- @IF BOXTEXTDEBUG
  --DarkText("background: "..bb,10,400,2,0)
  ---- @FI
 ]]
 -- GALE stuff for LAURA II;(Backgrounds[boxback or altbackground or "FLOW_"..upper(LAURA.GetFlow())] or function() error("BoxText Background error","B,"..boxback or altbackground or "FLOW_"..upper(LAURA.GetFlow()))end)()
 local cflow = flow.get()
 ;(cflow.BoxTextBack or function() error("There is no BoxTextBack set for the current flow") end)(cflow)
 -- $USE libs/itext
 boxtextitextfont = boxtextitextfont or GetBoxTextFont()
 -- setfont("BoxText")
 local fh = itext.height("TEST")+12 -- Image.TextHeight("TEST")
 local bh = (fh * #data.Lines) + (fh)
 local startx = SW-data.width
 local starty = SH-bh
 local bstarty = (starty - 20) -- Image.Height(piccorner)
 local bottom = SH
 local bheight = bottom-bstarty -- 25
 local ak,av,ac
 local mx,my = MouseCoords()
 local bstartx,bwidth = 0,SW
 -- margin shit
 --[[ sorry, too much trouble to worry with! Buy a decent screen if this is an issue for you!
    if tonumber(LC('screen.margin.left')  )~=0 then startx = startx + 25; bstartx = bstartx + 25; bwidth = bwidth - 25 end
    if tonumber(LC('screen.margin.right') )~=0 then bwidth = bwidth - 25 end
    if tonumber(LC('screen.margin.bottom'))~=0 then starty = starty - 25; bottom=bottom-25 end
 ]]
 -- $IF BOXTEXTDEBUG
 white()
 --Image.NoFont()
 love.graphics.print("startxy = ("..startx..","..starty..")",0,0)
 love.graphics.print("bstarty = "..bstarty,0,fh)
 love.graphics.print("showtext = ("..data.SL..","..data.SP.."); total lines = "..#data.Lines,0,fh*2)
 love.graphics.print("picref = "..sval(data.PicRef),0,fh*3)
 local dbg_py = -999
 if data.PicRef then dbg_py = 600-Image.Height(data.PicRef) end
 love.graphics.print("pic-y = "..dbg_py,0,fh*4)
 love.graphics.print("boxback = "..bb,0,fh*5)
 ac=0
 for ak,av in pairs(data) do
     ac = ac + 1
     love.graphics.print(ak.." = "..sval(av),700,fh*ac,1,0)
     end
 -- $FI
 --[[
 Image.Color(0,0,0)
 Image.Rect(0,bstarty,800,600-bstarty)
 White()
 Image.Draw(piccorner,0,bstarty)
 Image.Color(255,255,255)
 Image.ViewPort(40,bstarty,800,3)
 Image.Tile(picup,40,0)
 Image.ViewPort(0,bstarty+19,19,600-bstarty)
 Image.Tile(picside,0,0)
 Image.ViewPort(0,0,800,600)
 ]]
 --DarkText('Box('..bstartx..','..math.ceil(bstarty-25)..','..bwidth..','..bheight..')',0,0)
 -- not used in this game Box(bstartx,bstarty-25,bwidth,bheight+25)
 love.graphics.draw(console.background,console.backquad,0,bstarty-fh)
 -- Portrait
 white()
 if data.PicRef and ImageLoaded(data.PicRef) then
   -- $IF BOXTEXTDEBUG
   Image.DText(data.PicRef,bstartx,bottom-Image.Height(data.PicRef))
   -- $FI
   DrawImage(data.PicRef,bstartx,bottom-ImageHeight(data.PicRef))
   end
 -- Header
 -- Ember() -- Red()
 itext.setfont(boxtextitextfont)
 --DarkText (Var.S(data.Header),startx,starty-20,0,0,255,180,0)-- Image.DText(Var.S(data.Header),startx,starty-20)
 color(0,180,255) itext.write(Var.S(data.Header),startx,starty-fh)
 --print(serialize("boxtext",data))
 -- Text itself
 local ax,ay,y
 if false and data.AltTxtFont then
   -- $IF BOXTEXTDEBUG
   CSay("Wanting font: "..data.AltTxtFont,fonts.BoxText[2])
   -- $FI
   -- let's force this error for now... I've no plans for alt fonts now.
   Image.Font(data.AltTxtFont,fonts.BoxTextContent[2])
 else
   itext.setfont(boxtextitextfont)
  end
  local br,bg,bb   
  for ay=1,#data.Lines do
    y = (ay-1)*fh
    if highlight and my>starty+y and my<starty+y+fh then 
      ret=ay
       br,bg,bb= 255,255,255 --LightBlue()
    elseif highlight then
       br,bg,bb= 180,180,180
      -- Image.Color(0,0,180)
    else 
       -- LightBlue()
       br,bg,bb = 255,255,255
    end
    if ay<data.SL then
       --Image.DText(data.Lines[ay],startx,starty+y)
       --DarkText(data.Lines[ay],startx,starty+y,0,0,br,bg,bb)
       color(br,bg,bb) itext.write(data.Lines[ay],startx,starty+y)
    elseif ay==data.SL then
       --Image.DText(left(data.Lines[ay],data.SP),startx,starty+y)
       color(br,bg,bb) itext.write(left(data.Lines[ay],data.SP),startx,starty+y) --DarkText(left(data.Lines[ay],data.SP),startx,starty+y,0,0,br,bg,bb)
       end
    end
if data.SL<=#data.Lines then
   data.SP = data.SP + 1
   if data.SP>string.len(data.Lines[data.SL]) then data.SP=1 data.SL=data.SL+1 end
   -- print(serialize("data",data)) -- Debug only!!!
   end    
return ret   
end
local ShowBox = me.ShowBox


function me.RunBoxText(file,tag,idx,boxback)
  --[[ If replacement is needed we'll sort that out.
  if not ReInit then 
     --Graphics_Init()  
     ReInit = true
    -- This prevents the Text Box to be drawn based on wrong settings.
  end 
  ]] 
  boxtextitextfont = boxtextitextfont or itext.loadfont('GFX/StoryFont')
  itext.setfont(boxtextitextfont) -- setfont("BoxTextContent")
  local f = btdata[file]
  if not f then error("Boxtext file "..file.." has not yet been loaded!") end
  local t = f[tag]
  if not t then error("Boxtext file "..file.." has no tag called "..tag) end
  local rec = t[idx]
  if not rec then error("Boxtext file "..file.." tag "..tag.." does not have a record #"..idx.." (max is "..#t..")") end
  local sb_data = { Header = rec.Header, PicDir = rec.PicDir, PicSpc = rec.PicSpc, Lines = {}, SL = 1, SP=1, AltTxtFont = rec.AltTxtFont, Voice = rec.SoundFile   }
  local width=SW-100 -- standard width, this can be shortened by the portraits popping with the textbox. SW is the screen width, this need to be taken in order.
  local ak,txt,cline,spline
  local aw,word
  local continue
  if rec.PicRef and ImageLoaded(rec.PicRef) then
   width = width - ImageWidth(rec.PicRef)   
  end
  if false and rec.AltTxtFont and rec.AltTxtFont~="" and rec.AltTxtFont~="%" then -- CRASH!
   CSay("Setting font: "..rec.AltTxtFont) --,fonts.BoxText[2])
   Image.Font(rec.AltTxtFont,fonts.BoxText[2])
  else
   itext.setfont(boxtextitextfont) -- setfont("BoxTextContent")
  end   
  for ak,txt in ipairs(rec.Lines) do
    cline = ""
    spline = mysplit(Var.S(txt)," ")
    for aw,word in ipairs(spline) do
        if itext.width(cline..word)>width then
           table.insert(sb_data.Lines,cline)
           cline = ""
        end
        cline = cline .. word .. " "   
    end
    if cline~="" then table.insert(sb_data.Lines,cline) end    
  end
  sb_data.width=width    
  sb_data.PicRef=rec.PicRef
  -- if tonumber(LC('screen.margin.top')   )~=0 then origin[2] = 25; totalwidth=totalheight-25 end
  -- if tonumber(LC('screen.margin.right') )~=0 then sb_data.width=sb_data.width-25 end
  -- if tonumber(LC('screen.margin.left') )~=0 then sb_data.width=sb_data.width-25 end
  -- Voice acting, if available
  if sb_data.Voice and sb_data.Voice~="" and JCR_Exists(sb_data.Voice)~=0 then
   if BOXTEXTAUDIO and BOXTEXTAUDIO:isPlaying() then love.audio.stop(BOXTEXTAUDIO) end -- if Audio.Playing('BOXTEXTCHANNEL')~=0 then Audio.Stop('BOXTEXTCHANNEL') end
   BOXTEXTAUDIO = love.audio.newSource(JCR_D(sb_data.Voice)) -- Audio.Load(sb_data.Voice,'BOXTEXTVOICE')
   love.audio.play(BOXTEXTAUDIO) -- Audio.Play("BOXTEXTVOICE","BOXTEXTCHANNEL")
  else
   sb_data.Voice=nil
  end
  -- Wait for input
  -- $USE libs/killcallback
  manualevent() -- INP.Grab()
  repeat
  manualevent() -- INP.Grab()
  ShowBox(sb_data,boxback)
  Flip()
  if sb_data.Voice then
     continue = not( BOXTEXTAUDIO and BOXTEXTAUDIO:isPlaying()) --Audio.Playing('BOXTEXTCHANNEL')==0
  end   
  if mousehit(1) then --or INP.KeyH(KEY_SPACE)==1 or INP.KeyH(KEY_RETURN)==1 or INP.KeyH(KEY_ENTER)==1 or joyhit('CONFIRM') then
     if sb_data.SL>#sb_data.Lines then 
        continue=true
     else
         sb_data.SL=#sb_data.Lines+1
     end
  end     
  until continue -- mousehit(1)
end
local RunBoxText = me.RunBoxText

function me.SerialBoxText(file,ptag,boxback)
  boxtextitextfont = boxtextitextfont or itext.loadfont('GFX/StoryFont')
  -- $IF BOXTEXTDEBUG
  CSay('SerialBoxText("'..file..'","'..ptag..'","'..sval(boxback)..'");')
  -- $FI
  local a = field:GetActive()
  if a and a~="" and rpg.CharExists(a) then Var.D("$CURRENTCHARNAME",rpg.GetName(a)) end
  local tag = upper(ptag or '*TAGLESS*')
  local f = btdata[file]
  if not f then error("Boxtext file "..file.." has not yet been loaded!") end
  local t = f[tag]
  if not t then error("Boxtext file "..file.." has no tag called "..tag) end
  local ak
  for ak=1,#t do RunBoxText(file,tag,ak,boxback) end
end
local SerialBoxText = me.SerialBoxText

function me.RunQuestion(file,tag,pidx,boxback)
  -- $USE subs/script/screen
  boxtextitextfont = boxtextitextfont or itext.loadfont('GFX/StoryFont')
  local chosen=nil
  local idx=tonumber(pidx or 1)
  local f = btdata[file]
  local width = math.ceil(screen.w*.8) --700
  if not f then error("Boxtext file "..file.." has not yet been loaded!") end
  local t = f[tag]
  if not t then error("Boxtext file "..file.." has no tag called "..tag) end
  local rec = t[idx]
  if not rec then
     CSay(serialize("(non-exisent) rec",rec))
     CSay(serialize("t",t)) 
     error("Boxtext file "..file.." tag "..tag.." does not have a record #"..idx.." (max is "..#t..")") 
  end
  local sb_data = { Header = rec.Header, PicDir = rec.PicDir, PicSpc = rec.PicSpc, Lines = rec.Lines, SL = 1, SP=1, AltTxtFont = rec.AltTxtFont }
  if rec.AltTxtFont then
   CSay("Setting font: "..rec.AltTxtFont..","..fonts.BoxText[2])
   Image.Font(rec.AltTxtFont,fonts.BoxText[2])
  else
   itext.setfont(boxtextitextfont) --setfont("BoxText")
  end   
  if rec.PicRef then
   width = width - Image.Width(rec.PicRef)   
  end
  sb_data.width=width    
  sb_data.PicRef=rec.PicRef
  manualevent() -- INP.Grab()
  repeat
   manualevent() -- INP.Grab()
   chosen = ShowBox(sb_data,boxback or "FLOW_FIELD",true)
   -- ShowMouse()
   Flip()
  until mousehit(1) and chosen
  Var.D("%RET",chosen)
  CSay("Chosen: "..sval(chosen))
  return chosen
end
local RunQuestion=me.RunQuestion

return me
