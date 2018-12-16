CSay("Welcome to the prairie!")

local prairie = {}

local map = field:getmap()
local tagmap = map.map.TagMap
local Shirley = tagmap.surface.NPC_Shirley

function prairie:overdraw()
    -- --[[ DEBUG: Shirley does not appear!
    -- $USE Script/Subs/Screen
    if Shirley then
       local line = love.graphics.line
       local sx = Shirley.COORD.x-field.cam.x
       local sy = Shirley.COORD.y-field.cam.y
       Color(math.random(0,255),math.random(0,255),math.random(0,255))
       line(0       ,       0,sx,sy)
       line(0       ,Screen.h,sx,sy)
       line(Screen.w,       0,sx,sy)
       line(Screen.w,Screen.h,sx,sy)       
    else
       -- CSay('No Shirley!')   
    end       
    -- ]]
end
    
return prairie