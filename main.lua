local socket = require "socket"
local address,port="127.0.0.1",1897
local updaterate=5
local t=0
local udp
local text=""
local stage=1 -- 1 = turn not yet begun, 2 = turn begun, 3 = invaded poland
function love.load()
  socket = require "socket"
  address,port="127.0.0.1",1897
  udp = socket.udp()
  udp:settimeout(0.1)
  udp:setpeername(address, port)
  udp:send("CONNECT")
end

function love.update(deltatime)
    t = t + deltatime -- increase t by the deltatime

    if t > updaterate then
      t=t-updaterate -- set t for the next round
    end
    local data=udp:receive()
    if data then
      data=require "pl.pretty".read(data)
      if stage==1 then
        require "pl.pretty".dump(data)
        stage=stage+1
      elseif stage==2 then
        require "pl.pretty".dump(data)
        local unpack=unpack or table.unpack -- For compatibility
        local invade,reason,dieroll=unpack(data)
        if invade then
          text="Invasion successful!\n"
          stage=stage+1
        else
          text="Invasion not successful for reason "..reason..".\n"
        end
        if dieroll then
          text=text.."Die rolled: "..dieroll.."\n"
        end
      end
    end
end

function love.mousepressed(x, y, button)
  if button=="l" and x>20 and x<70 and y>20 and y<70 then
    if stage==1 then
      print("SENDING turninit")
      udp:send("turninit")
    elseif stage==2 then
      print("SENDING invade poland 1")
      udp:send("invade poland 1")
    end
  end
end
local _font = {

}
local function font(size)
  if _font[size] then return _font[size] end
  _font[size] = love.graphics.newFont(size)
  return _font[size]
end

function love.draw()
  love.graphics.setBackgroundColor(255,255,255)
  love.graphics.setColor(0, 0, 0)
  love.graphics.setFont(font(16))
  if stage<3 then
    love.graphics.rectangle("line",20,20,50,50)
  end
  love.graphics.printf(text,0,80,800)
  if stage==1 then
    love.graphics.printf("Begin",25,25,45)
    love.graphics.printf("turn",30,45,35)
  elseif stage==2 then
    love.graphics.setFont(font(14))
    love.graphics.printf("Invade",20,25,45)
    love.graphics.printf("Poland",20,45,35)
  end
end
