
-- $USE script/subs/screen.lua

local cent = math.floor(screen.w/2)
local font = GetBoxTextFont()
local tst = {}

tst.roll = {}

function tst:Txt(text,r,g,b)
    local y = screen.h + 100
    for r in each(self.roll) do if r.y>y-60 then y=y+60 end end
    self.roll[#self.roll+1] = {
        y = y,
        t = text,
        r = r or 255,
        g = g or 255,
        b = b or 255
    }
end

function tst:Show()
     for r in each(self.roll) do
         r.y = r.y - 1
         color(r.r,r.g,r.b)
         itext.write(r.t,cent,r.y,2,0)
     end
     if self.roll[1] and self.roll[1].y<-100 then
        CSay(serialize("Expiring Scrollthrough Item",self.roll[1])) 
        table.remove(self.roll,1) 
     end
end

return tst