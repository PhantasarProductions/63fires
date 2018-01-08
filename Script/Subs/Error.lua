--[[

 This is a modified version of the original error handler provided in LOVE2D.
 This one will use my own console for error handling, and can be used to provide me 
 more debug information, as some errors can be too specific! 

]]

-- $USE libs/console

local xtra_info

local function error_printer(msg, layer)
  print((debug.traceback("Error: " .. tostring(msg), 1+(layer or 1)):gsub("\n[^\n]+$", "")))
  -- <Tricky>
  if type(xtra_info)=="table" then
     for k,v in spairs(xtra_info) do print(k.." = "..v) end
  elseif xtra_info then
     print("Extra info "..xtra_info)
  end  
  -- </Tricky> 
end
 
function love.errhand(msg)
  msg = tostring(msg)
 
  error_printer(msg, 2)
 
  if not love.window or not love.graphics or not love.event then
    return
  end
 
  if not love.graphics.isCreated() or not love.window.isOpen() then
    local success, status = pcall(love.window.setMode, 800, 600)
    if not success or not status then
      return
    end
  end
 
  -- Reset state.
  if love.mouse then
    love.mouse.setVisible(true)
    love.mouse.setGrabbed(false)
    love.mouse.setRelativeMode(false)
  end
  if love.joystick then
    -- Stop all joystick vibrations.
    for i,v in ipairs(love.joystick.getJoysticks()) do
      v:setVibration()
    end
  end
  if love.audio then love.audio.stop() end
  love.graphics.reset()
  local font = love.graphics.setNewFont(math.floor(love.window.toPixels(14)))
 
  love.graphics.setBackgroundColor(89, 157, 220)
  love.graphics.setColor(255, 255, 255, 255)
 
  local trace = debug.traceback()
 
  love.graphics.clear(love.graphics.getBackgroundColor())
  love.graphics.origin()
 
  local err = {}
 
  table.insert(err, "Error\n")
  table.insert(err, msg.."\n\n")
 
  for l in string.gmatch(trace, "(.-)\n") do
    if not string.match(l, "boot.lua") then
      l = string.gsub(l, "stack traceback:", "Traceback\n")
      table.insert(err, l)
    end
  end
 
  local p = table.concat(err, "\n")
 
  p = string.gsub(p, "\t", "")
  p = string.gsub(p, "%[string \"(.-)\"%]", "%1")
  
  -- <Tricky>
  console.writeln("!!FATAL ERROR!!!",255,0,0)
  for i,m in ipairs(err) do
      console.writeln(m,255,100+math.ceil((i/#err)*155),0)
  end
  if type(xtra_info)=="table" then
     for k,v in spairs(xtra_info) do console.write(k,180,0,255) console.write(" = ",255,180,0) console.writeln(v,0,180,255) end
  elseif xtra_info then
     console.write("Extra info: "..xtra_info,255,0,255)
  end  
  CSay("")
  CSay("Press escape to exit this program!")
  -- </Tricky>
  
     
  
 
  local function draw()
  -- <Tricky>
  --[[
    local pos = love.window.toPixels(70)
    love.graphics.clear(love.graphics.getBackgroundColor())
    love.graphics.printf(p, pos, pos, love.graphics.getWidth() - pos)
    love.graphics.present()
    ]]
    console.show()
    love.graphics.present()
  -- </Tricky>
  end
 
  while true do
    love.event.pump()
 
    for e, a, b, c in love.event.poll() do
      if e == "quit" then
        return
      elseif e == "keypressed" and a == "escape" then
        return
      elseif e == "touchpressed" then
        local name = love.window.getTitle()
        if #name == 0 or name == "Untitled" then name = "Game" end
        local buttons = {"OK", "Cancel"}
        local pressed = love.window.showMessageBox("Quit "..name.."?", "", buttons)
        if pressed == 1 then
          return
        end
      end
    end
 
    draw()
 
    if love.timer then
      love.timer.sleep(0.1)
    end
  end
 
end

--<TRICKY>
function TrickAssert(condition,errmsg,xtra)
    if not condition then
       xtra_data=xtra
       error(errmsg)
    end
end 
function TrickCrash(errmsg,xtra)
   xtra_data=xtra
   error(errmsg)
end
          


return true
--</TRICKY>