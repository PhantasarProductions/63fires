--[[
  network.lua
  Version: 18.01.03
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
local net = { nomerge=true }

local w,h = love.graphics.getDimensions( )

local nw = {
      GJ = {
           name = 'Game Jolt',
           values = {'User Name','Token'},
           x = w/2
      },
      Anna = {
           name = 'Anna',
           values = {'Id Number','Secu Code'},
           x = 5
      }
}

local pxy = love.graphics.print -- LAZY!
local nsite,nfield

function net.draw()
   local x, y = love.mouse.getPosition( )
   local hit = mousehit(1)
   local cursor
   cls()
   white()
   console.sback()
   love.graphics.print("If you want you can use these network to record your achievements.",10,0)
   love.graphics.print("The Game Jolt network allows you to gain these as trophies and get extra experience",10,20)
   love.graphics.print("An Anna account ties most 'Phantasar Productions' games together. Scoring great here can get you presents in other games.",10,40)
   love.graphics.print("To let you inter a secret, in The Fairy Tale REVAMPED, you an rewards for your achievements in this game. You'd better believe it!",10,60)
   love.graphics.print("What you don't want these networks? It's your loss. You can then just leave the fields blank and press the arrow to continue into the game",10,100)
   for key,nd in pairs(nw) do
       white()
       nd.img = nd.img or LoadImage("GFX/Network/"..key..".png")
       DrawImage(nd.img,nd.x,150)
       nd.answers = nd.answers or {}           
       for i,n in ipairs(nd.values) do
           if hit and x>nd.x and x<nd.x+(w*.75) and y>150+(i*40)+ImageHeight(nd.img) and y<190+(i*40)+ImageHeight(nd.img) then nsite=key nfield=i end
           nd.answers[i] = nd.answers[i] or ''
           white()
           pxy(n..":",nd.x,150+(i*40)+ImageHeight(nd.img))
           if nsite==key and nfield==i then
              ember()
              cursor="_"
              if keyhit("backspace") and #nd.answers[i]>0 then nd.answers[i]=left(nd.answers[i],#nd.answers[i]-1) end
           else
              white()
              cursor="."
           end
           pxy(left(nd.answers[i]..cursor.."..........",10),nd.x+5,170+(i*40)+ImageHeight(nd.img)  ) 
       end
   end
end

function net.textinput( txt )
     if not(nsite and nfield) then return end
     local tx = replace(txt,'"',"")
     tx = replace(tx,"'","")
     local nd=nw[nsite]
     nd.answers[nfield] = nd.answers[nfield] .. tx
     if #nd.answers[nfield]>10 then nd.answers[nfield]=left(nd.answers[nfield],10) end
end  

return net
