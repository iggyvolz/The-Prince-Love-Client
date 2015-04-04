local socket = require "socket"
local address,port="127.0.0.1",1897
local updaterate=5
local t=0
local udp
local text=""
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
      print(data)
      text=text..data
    end
end

function love.mousepressed(x, y, button)
  if button=="l" and x>20 and x<70 and y>20 and y<70 then
    print("X")
    udp:send("invade poland 1")
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
  love.graphics.setFont(font(36))
  love.graphics.rectangle("line",20,20,50,50)
  love.graphics.printf(text,0,80,800)
end
