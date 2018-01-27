local cmain = {}



function cmain:odraw()
      self:DrawArena()
      self:DrawCards()
      StatusBar(false,true)
      dbgcon()    
      ShowMiniMSG()
end















return cmain

