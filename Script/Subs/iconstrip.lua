-- $USE libs/nothing

local width, height = love.graphics.getDimensions( )
local isquad
local isback
local icons={}
local helpmode --= "craq"

function iconstriphelp() 
   helpmode=not helpmode
   CSay("Help mode is now: "..sval(helpmode))
   --error("WERKT HET NU WEL OF NIET?") 
end
--function cancelhelp() helpmode=false end


function click(x,y,w,h,hit,help,callback)
     local mx,my=love.mouse.getPosition()
     --love.graphics.print(x..","..y.."   "..mx..","..my.."  "..sval(hit).." "..sval(helpmode),x,y) -- debug line
     --if hit and helpmode and callback==iconstriphelp then helpmode=false return end     
     if mx>x and mx<x+w and my>y and my<y+h then
        if helpmode then
           love.graphics.setFont(console.font)
           color(0,0,0,150)
           local ht=mysplit(help,"\n")
           Rect(0,0,width,(#ht*20)+10)
           color(255,255,255,255)
           for i,hl in ipairs(ht) do
               love.graphics.print(hl,5,((i-1)*20)+5)
           end
        end
        if hit then
           if not callback then CSay("WARNING! No callback set for this action") end
           (callback or nothing)()   
           return true
        end
     end 
end



function showstrip()
     white()
     local f = flow.get()
     assert(f.iconstrip,"Hey? There is no iconstrop set for this flow!")
     local is=f.iconstrip
     local x,y=love.mouse.getPosition()
     is.x = is.x or 100
     if x>50 and is.hide and is.x<60 then
        is.x = is.x + 1
     elseif (x<50 or (not is.hide)) and is.x>0  then is.x=is.x-1 end
     isback = isback or LoadImage(console.background)
     isquad = isquad or love.graphics.newQuad(0,0,45,height-120,ImageWidth(isback),ImageHeight(isback))
     if is.back then QuadImage(isback,isquad,0-is.x,0) end
     for i,icon in ipairs(is) do
        local iy = math.floor((i/(#is+2)) * (height-120))
        icons[icon.icon]=icons[icon.icon] or LoadImage('GFX/Buttons/'..icon.icon..'.png')
        DrawImage(icons[icon.icon],2-is.x,iy)
        click(2,iy,40,40,f.clicked,icon.tut,icon.cb)
     end
end     



return true