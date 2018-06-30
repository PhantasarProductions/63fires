local crack = {}

--[[

    Sorry folks, this is only an handler for cracked walls, which Nino can break with his gauntlet.
    This is not a script to crack the game or anything else.
    :P
    
]]

function crack:InitCracks()
   local add = {}
   local hide = {}
   for obj,lay in self:getmap().map:allobjects() do
       if prefixed(obj.TAG,"CRACK") then
          local nob = {}
          CSay(" = Crack found: "..obj.TAG.." on layer: "..lay)
          for k,v in pairs(obj) do
              if k=="TAG" then nob.TAG="P_"..v
              elseif k=="TEXTURE" then nob.TEXTURE="GFX/Textures/Special/Crack.png"
              elseif k=="DOMINANCE" then nob.DOMINANCE=v  obj.DOMINANCE=obj.DOMINANCE-1 
              elseif k=="IMPASSIBLE" or k=="FORCEPASSIBLE" then nob[k]=false -- These "fake" objects may NOT influence the blockmap at all, and this measure guarantees that won't happen!
              else nob[k]=v end
          end
          add[lay]=add[lay] or {}
          local a=add[lay]
          a[#a+1]=nob
          hide[#hide+1]=obj.TAG
       end 
   end
   -- Add it in
   for lay,cracklist in pairs(add) do for obj in each(cracklist) do
       local MO = self:getmap().map.MapObjects[lay]
       MO[#MO+1]=obj
   end end -- 2x for => 2x end
   -- The reason why I made a for-loop check first, and another for-loop do the actual additions is to make sure the addtions would not spookup the analysis results, as Lua can be a bit nasty when arrays/tables are changed during iteration.
   self.getmap().map:hidelabels(hide,true)
end

local function BreakTheWall(s,tag)
   local map=s:getmap()
   local m = map.map
   s:kill(tag,true)
   s:kill("S_"..tag,true)
   s:kill("P_"..tag) -- Permanence not needed, as the object won't be regenerated without the original object
   m:showlabels(tag,true)
   m:remapall()   
end

function crack:DoCrack()
   local map=self:getmap()
   local m = map.map
   local l = m.MapObjects[map.layer]
   local Pythagoras
   -- $USE libs/Pythagoras
   local ctag,cdist
   local p =  map.map.TagMap[map.layer]['PLAYER'..self.leader]
   for tag,obj in pairs(m.TagMap[map.layer]) do
       if prefixed(tag,"CRACK") then
          local spot = m.TagMap[map.layer]["S_"..tag]
          assert(spot,"SPOT for "..tag.." not found => S_"..tag)
          local tdist = Pythagoras(p.COORD.x,p.COORD.y,spot.COORD.x,spot.COORD.y)
          if (not cdist) or (cdist<tdist) then
          cdist=tdist
          ctag=tag
          end
       end
   end
   if not ctag then return end
   local obj=m.TagMap[map.layer]["S_"..ctag]
   local tstx=obj.COORD.x
   local tsty=obj.COORD.y+32
   local stx = math.floor(tstx/32)
   local sty = math.floor(tsty/32)
   local act = map.map.TagMap[map.layer]['PLAYER'..self.leader]
   if act:WalkTo(stx,sty) then 
      self:SetArrival({BreakTheWall,self,ctag})
   end    
end



return crack