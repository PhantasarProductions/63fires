local haken = {}

-- "haken" means "hooks" in Dutch.

local searchdebug = false -- Must be "false" in the release!


function haken:initHookSpots()
    local spots = {}
    local map = self:getmap()
    local total=0
    map.hookspots = spots -- They their their pointers, so whatever changes in the one directly affects the other... Or basically, they are both just pointers pointing the area were stuff changes :P
    for obj,lay in self:getmap().map:allobjects() do
        if obj.KIND=="Exit" and obj.DATA and obj.DATA.HOOK then
           assert(obj.TAG,"Tagless Hook Exit Point!")
           assert(map.map.TagMap[lay][obj.DATA.HOOK],"Hook exit pointing to non-existent hook spot! "..obj.DATA.HOOK)
           local target=map.map.TagMap[lay][obj.DATA.HOOK]
           spots[lay] = spots[lay] or {}
           spots[lay][obj.TAG]={ GOTOT = obj.DATA.HOOK, GOTOC = target.COORD, FROM=obj.COORD }
           total = total + 1 
        end
    end    
    return total
end

local function HookCross(self,coords)
    CSay("Jumping not yet done! Please come back later!")
end

function haken:findClosestHookSpot()
   local map = self:getmap()
   local spots = map.hookspots
   local lay = map.layer
   if not spots[lay] then CSay(("Ignored! No hookspots on this layer >> %s"):format(lay)) end
   local player = map.map:obj(map.layer,"PLAYER1")
   local px,py = player.COORD.x,player.COORD.y
   local available = {}
   -- Hoe ver zijn alle punten verwijderd van Ryanna?
   -- Dit kunnen me in 2D zo makkelijk checken dankzij de stelling van Pythagoras.
   for k,spot in pairs(spots[lay]) do
       local sx,sy = spot.FROM.x,spot.FROM.y
       local rechthoekszijde1 = math.abs(px-sx)
       local rechthoekszijde2 = math.abs(py-sy)
       local totaal = (rechthoekszijde1^2) + (rechthoekszijde2^2)
       local hypotenusa = math.sqrt(totaal)
       available[hypotenusa] = k
   end
   -- Dat hebben we nu!
   -- En welke is het dichsta bij?
   for distance,spotkey in spairs(available,function(available,k1,k2) return k1<k2 end) do
       -- CSay(serialize('spots',spots).. "\nfrom\nSpotkey = "..spotkey.." distance: "..distance)   
       local stx,sty = math.floor(spots[lay][spotkey].FROM.x/32),math.floor(spots[lay][spotkey].FROM.y/32)
       console.write("Can I go to? ",255,255,0)
       console.writeln(("(%d,%d)"):format(stx,sty),0,255,255)
       if player:WalkTo(stx,sty) then
          self:SetArrival({HookCross,self,spots[lay][spotkey].GOTOC})
          CSay("Going!") 
          return
       end
   end
   CSay("No suitable hookspot found, so let's cut it!")
end

return haken