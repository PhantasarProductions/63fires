--[[
**********************************************
  
  Transform.lua
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
 
version: 18.07.06
]]
local megatron={}

local function makehp(tag,data,skill)
    data.HPMod = data.HPMod or 6
    rpg:Points(tag,"HP",1).Maximum = rpg:Points('Ryanna','HP').Maximum * (data.HPMod / skill)  
    rpg:Points(tag,'HP').Have = rpg:Points(tag,"HP").Maximum
    rpg:DefStat(tag,"BASE_HP",rpg:Points(tag,"HP").Maximum)  
    rpg:DefStat(tag,"END_HP",rpg:Points(tag,"HP").Maximum)  
end

function megatron.make(form)
    local skill = Var.G('%SKILL')
    local data = Use("script/data/transform_make/"..form..".lua")
    local tag = 'DEMON_RYANNA_'..form
    local already = rpg:CharExists(tag) 
    if not already then
       CSay("Creating: "..tag)
       rpg:CreateChar(tag)
    else
       CSay("Updating: "..tag)
    end      
    rpg:SetName(tag,"Ryanna")
    -- These three must always be linked to the human tag
    rpg:LinkPoints('Ryanna',tag,"AP")
    rpg:LinkStat('Ryanna',tag,'Level')
    rpg:LinkStat('Ryanna',tag,'Experience')
    -- HP
    makehp(tag,data,skill)
    
    -- VIT (not needed)
    rpg:Points(tag,'VIT',1).Maximum=100
    rpg:Points(tag,'VIT'  ).Have=100
    
    -- Stat altering
    for s,v in pairs(data.StatMod or {}) do
        rpg:DefStat(tag,'BASE_'..s,math.ceil(v*rpg:Stat('Ryanna','BASE_'..s)))
        rpg:DefStat(tag, 'END_'..s,math.ceil(v*rpg:Stat('Ryanna', 'END_'..s)))
        CSay("Defined:  "..s.." = "..v.." (TransMod)")
    end

    for s,v in pairs(data.StatRep or {}) do
        rpg:DefStat(tag,'BASE_'..s,v)
        rpg:DefStat(tag, 'END_'..s,v)
        CSay("Defined:  "..s.." = "..v.." (TransRep)")
    end
    
    -- Linking not needed when we are already transformed
    if already then return end
    -- Create all stats and link all stats not altered by the specific transtagation tag
    for s,v,d in rpg:iStat('Ryanna') do
        if not rpg:StatExists(tag) then
           if prefixed(s,"END_") then
              rpg:DefStat(tag,s,v)
              CSay("Defined:  "..s.." = "..v)
           else
              rpg:LinkStat('Ryanna',tag,s)
              CSay(" Linked:  "..s.." = "..v)
           end
        end
    end
end

local posx,posy
local font = GetBoxTextFont()
local portret = {}

function megatron.list(x,y,w,h,clicked)
   -- -- $USE script/subs/screen
   posx = posx or {x,x+math.ceil(w*.33),x+math.ceil(w*.66)}
   posy = posy or {y,y+120,y+240,y+360}
   local dems = gamedata.transform
   if (not dems) or #dems==0 then
      red()
      itext.write("You don't have any transfomations yet",w/2,h/2,2,2)
      return
   end
   local maxrows = math.ceil(#dems/3)
   local row,col=1,1
   for demon in each(dems) do
       white()
       portret[demon]=portret[demon] or LoadImage('GFX/Portret/Demon_Ryanna_'..demon..'/General.png')
       DrawImage(portret[demon],posx[col],posy[row])
       if mousex()>posx[col] and mousex()<(posx[col+1] or w) and mousey()>posy[row] and mousey()<posy[row]+120 then
          color(0,180,255)
          if clicked then return demon end
       end
       itext.write(demon,posx[col]+x+100,posy[row]+y)
       row=row+1
       if row>maxrows then row=1 col=col+1 end
   end  
   
end


return megatron
