-- $USE Script/Subs/IconStrip

local width, height = love.graphics.getDimensions(  )
local tw = width-60
local cols = {{x=60,w=tw/2},{x=60+(tw/2),w=tw/2}}
local mod = {}

mod.menutype = "field"

function mod:cometome(mentype,character)
     local mt = mentype or "field"
     -- for k,_ in spairs(self) do CSay("MENU HAS FIELD: "..k) end -- debug field
     self[mt].parent=self
     self.menutype = mt
     self.iconstrip=self[mt].iconstrip
     self.active=self[mt]     
     self.char=character
     -- for k,_ in spairs(self.active) do CSay("ACTIVE MENU TYPE HAS SUBFIELD: "..k) end
     flow.set(self)
end

function mod:odraw()
    self.clicked = mousehit(1)
    white()
    console.sback()
    self.active.modes[self.active.mode]()    
    StatusBar(self.char,true)
    showstrip()
end



return mod