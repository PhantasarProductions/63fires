--[[
  com_cards.lua
  Version: 18.04.11
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
local ccards = {}

local Cards
local CardImg = {}



function ccards:SetUpCards()
    self.Cards = {}
    self.cards = self.Cards
    Cards = self.Cards
end    


function ccards:RemoveFirstCard()
    local max = 0
    local cards=self.Cards
    for i,_ in pairs(cards) do if i>max then max=i end end
    for i=1,max do cards[i] = cards[i] or {} end
    table.remove(cards,1)
    --BuffCountDown() -- This comes later!
    -- $USE Libs/audio
    QuickPlay('Audio/Combat/CardSlide.ogg')
end

function ccards:RemoveCharCards(ch,pref)
   local remove = {}
   for i,card in pairs(self.Cards) do
       if card.data and (card.data.tag==ch or (pref and prefixed(card.data.tag,ch))) then remove[#remove+1]=i end 
       --[[
       CSay(serialize('Card #'..i,card))
       CSay(serialize('remove',remove))
       -- ]]
   end
   CSay("All cards for character "..ch.." will be removed")
   for ci in each(remove) do
       CSay("= Removing card #"..ci)
       self.Cards[ci]={}
   end
end

function ccards:YCards()
    -- $USE script/subs/screen
    local SH = screen.h
    for i=1,50 do
        Cards[i] = Cards[i] or {}
        Cards[i].x=-25
        Cards[i].y=SH+((50-i)*100)        
    end
end

function ccards:CreateOrder()
     self.order = { speedtable = {}, tagorder = {}, iorder = {} }
     local order=self.order
     local sid,strid,group
     local RPG = rpg
     -- first set up a table easily usable by spairs.
     -- for group,groupdata in pairs(Fighters) do -- No longer needed
         --for tag,data in pairs(groupdata) do
         for tag,_ in pairs(self.fighters) do--pairs(RPGChars) do
             if prefixed(tag,"FOE_") then group="Foe" else group="Hero" end
             sid = 10000 - RPG:Stat(tag,"END_Speed")
             strid = right("00000"..sid,5)
             while order.speedtable[strid] do
                sid = sid + 1 
                strid = right("00000"..sid,5)
             end
             order.speedtable[strid] = {group=group,tag=tag}
         end
     --end
     -- And let us now set up the actual work order
     local oid = 0
     for key,fid in spairs(order.speedtable) do
         oid = oid + 1
         order.tagorder[fid.tag]=oid
         order.iorder[oid] = fid
         if fid.group=="Foe" then fid.letter=self.foes[fid.tag].letter end
     end
end

function ccards:SetupInitialCards(adata,empty)
   local cdata = adata or {} 
   self:CreateOrder()
   Cards = Cards or {}
   if empty then ClearTable(Cards) end
   local card,cidx,pi
   pi   = 0
   for i,data in pairs(self.order.iorder) do
       local goed = true
       goed = goed and not(cdata.initiative and data.group=='Foe')
       goed = goed and not(cdata.ambush     and data.group=='Hero')
       if goed then
          pi = pi + 1
          cidx=pi*3
          Cards[cidx] = Cards[cidx] or {}
          card = Cards[cidx]
          card.data=data
          CSay("Defining card: "..cidx) 
          CSay(serialize("card["..cidx.."]",card))
        end
   end
   --CSay(serialize('Cards',Cards))
end

function ccards:ResetCards() ccards:SetupInitialCards({},true) end

function ccards:CardTag(data)
      local ret = "BACK"
      -- If card's really empty!
      if not data then return "BACK" end
      if not data.tag then return "BACK" end
      -- If a foe
      if prefixed(data.tag,"FOE_") then
         if not self.foes then for k,v in spairs(self) do CSay("COMBAT MODULE:  "..type(v).." "..k) end end
         local myfoe=self.foes[data.tag]
         if not myfoe then return "BACK" end
         if myfoe.Boss then return "BOSS_"..(myfoe.letterfiletag or "Unknown") else return "FOE_"..(myfoe.letterfiletag or "Unknown") end
      end   
      -- If a hero in general
      if data.tag and rpg:Points(data.tag,"HP").Have>0 then
          -- If Ryanna while transformed
          if prefixed(data.tag,"DEMON_RYANNA_") then return "HERO_Ryanna" end 
          return "HERO_"..data.tag
      end
      -- If not anything else
      return "BACK"
end

function ccards:AddCard(data,aspot)
    local order = self.order
    local cards = self.cards
    local rand = love.math.random
    local hadtomove 
    local card = { data=data }
    local ch   = data.tag    
    local spot = aspot or ( 25 + (order.tagorder[ch] * 2)+ (math.floor(rand(1,order.tagorder[ch])/2)) )
    while cards[spot] and cards[spot].data do spot=spot+1 hadtomove=true end -- If the spot is taken, move to the next one, and keep doing this until an empty spot has been found.
    if cards[spot] then card.x,card.y=cards[spot].x,cards[spot].y end
    cards[spot] = card
    if card.data.nextact and card.data.nextact.executor then card.data.tag = card.data.nextact.executor.tag end
end

function ccards:AutoAddFighterCard()
    local k    
--    for group,grouparray in pairs(Fighters) do
        for tag,data in pairs(self.fighters) do
            k = nil
            for _,crd in pairs(self.cards) do -- Looking for the card
                k = k or (crd.data and crd.data.tag==tag and (not crd.data.nextact)) 
            end 
            if not k then self:AddCard({group=data.group,tag=data.tag, letter=data.letter}) end
        end
--    end
end



function ccards:DrawCard(data,x,y)
      -- Initial
      local ctg = self:CardTag(data) 
      
      -- Loading
      CardImg[ctg] = CardImg[ctg] or LoadImage("GFX/Combat/Cards/"..ctg..".png")
      -- Drawing
      DrawImage(CardImg[ctg],x,y)       
end

function ccards:ShowCard(card)
       self:DrawCard(card.data,card.x,card.y)
end

function ccards:DrawCards()
    -- $USE script/subs/screen
    local waitx = screen.w-180
    local actx  = screen.w-64
    local acty  = 32
    local maxshow = 25
    if screen.w>1000 then maxshow=50 end
    for i=maxshow,1,-1 do
        Cards[i] = Cards[i] or {x=-(screen.w+i*40),y=acty}
        self:ShowCard(Cards[i])
        local wantx=waitx-(i*16)
        if i==1 then wantx=actx end
        Cards[i].x = Cards[i].x or (i*-100)
        Cards[i].y = Cards[i].y or acty
        if Cards[i].x<wantx     then Cards[i].x = Cards[i].x + 2 end
        if Cards[i].x<wantx*.85 then Cards[i].x = Cards[i].x + 4 end
        if Cards[i].x<wantx*.75 then Cards[i].x = Cards[i].x + 2 end
        if Cards[i].x<wantx*.50 then Cards[i].x = Cards[i].x + 2 end
        if Cards[i].x<wantx*.25 then Cards[i].x = Cards[i].x + 2 end
        if Cards[i].y>acty      then Cards[i].y = Cards[i].y - 6 end
        if Cards[i].y<acty      then Cards[i].y = Cards[i].y + 1 end        
    end    
    self:AutoAddFighterCard()
end


return ccards
