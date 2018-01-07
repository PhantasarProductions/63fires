-- $USE libs/omusic
-- $USE libs/console
-- $USE libs/qgfx

local iact = 0

local function iLoadImage(pic,tag)
    console.writeln("Load Image: "..pic,180,0,255)
    return LoadImage(pic,tag)
end

local function UseField()
   -- $USE Script/Flows/Field
end   

local function LoadMap(m,l)
      -- $USE Script/Flows/Field
      Field:LoadMap(m,l)
end      


local finit = {}

local iacts = {
            {CSay,"Compiling Field Flow"},
            {UseField}
         }
function finit.draw()
   console.show()
end

local stype
function finit.starttype(astype)
  stype=astype
  if stype=='newgame' then
     iacts[#iacts+1]={CSay,"Loading the graveyard map"}
     iacts[#iacts+1]={LoadMap,'DUNG_Graveyard',"#001"}
  end
end

function finit.arrive()
     laura.assert(stype,"And what kind of startup did we require, mr?","None has been received, you know!")
     console.writeln("Starting up game",180,255,0)
     if Var.C('$ANNA.ID')~="" then
        iacts[#iacts+1]={CSay,Var.S("Logging into Anna as #$ANNA.ID")}
        iacts[#iacts+1]={function()
             local gdata = mynet
             local query = {HC='Game',A='Auth',Game=gdata.data['ANNA.ID'],GameSecu=gdata.data['ANNA.KEY'],Version='0.0.0',id=Var.C('$ANNA.ID'),secu=Var.C('$ANNA.SECU')}
             gdata.annalogin = {id=query.id,secu=query.secu}
             retries = 0
             repeat
               local s,r = Anna_Request(query)
               local reason = "OK"
               local ok
               if not s then reason = r 
                   local p = love.window.showMessageBox("Anna Error", "Logging in to Anna failed!\n- Is your internet connection up?\n- Is the game not blocked by firewalls?\n- Any issues with Game Jolt itself?\n- Login data correct?\n- You did enter your TOKEN and not your password, right?\n- Login data changed?\n - "..reason,{"Ignore","Retry","Quit",escapebutton=3})
                   if p==1 then ok = 'true' end
                   if p==2 then retries=retries+1 laura.assert(retries<20,"Sorry, with this many retries I am not gonna continue anymore.") CSay("Retry attempt #"..retries) if retries>=20 then ok='true' end end 
                   if p==3 then ok = 'true' quitdontask=true love.event.quit() end
                else
                   mynet.loggedin_anna = true
                   ok='true'   
                end
              until ok=='true'

        end}
     end
     if Var.C('$GAMEJOLT.USER')~="" then
        iacts[#iacts+1]={CSay,Var.S("Logging into Game Jolt as $GAMEJOLT.USER")}
        iacts[#iacts+1]={function()
              gjapi:init(mynet.data['GAMEJOLT.ID'],mynet.data['GAMEJOLT.KEY'])
              local retries=0
              repeat 
                local user = Var.C("$GAMEJOLT.USER")
                local token = Var.C("$GAMEJOLT.TOKEN")
                laura.assert(token,"'nil' for token",VarList())
                print("GJ LOGIN:",user,token)
                local ok = gjapi:users_auth(user,token)                
                if ok~='true' then
                   local p = love.window.showMessageBox("Game Jolt Error", "Logging in to Game Jolt failed!\n- Is your internet connection up?\n- Is the game not blocked by firewalls?\n- Any issues with Game Jolt itself?\n- Login data correct?\n- You did enter your TOKEN and not your password, right?\n- Login data changed?",{"Ignore","Retry","Quit",escapebutton=3})
                   if p==1 then ok = 'true' end
                   if p==2 then retries=retries+1 laura.assert(retries<20,"Sorry, with this many retries I am not gonna continue anymore.") CSay("Retry attempt #"..retries) if retries>=20 then ok='true' end end 
                   if p==3 then ok = 'true' quitdontask=true love.event.quit() end
                else
                   mynet.loggedin_gj = true   
                end
              until ok=='true'
        end}
     end
     iacts[#iacts+1]={CSay,"Starting Clock"}
     iacts[#iacts+1]={addupdatefunc,update_time}
end

function finit.update()
   iact = iact + 1
   if not iacts[iact] then
      --flow.use("field","script/flows/field")
      flow.set(Field)
      flow.undef("startgame")
      return
   end
   local act = iacts[iact]
   local f = act[1]
   local p1 = act[2]
   local p2 = act[3]
   local p3 = act[4]
   if laura.assert(f,'No function',{actionnumber=iact,param1=p1,param2=p2,param3=p3}) then f(p1,p2,p3) end   
end



return finit
