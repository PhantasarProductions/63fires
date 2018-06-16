local sta = {}

function sta:NPC_Gauntlet()
   CSay("Hoera! We hebben een gauntlet gevonden!")
   MapText("GAUNTLET")
   field:GiveTool('Nino',1)
   field:kill('NPC_Gauntlet',true)
   Award("TOOL_GAUNTLET") 
end

return sta