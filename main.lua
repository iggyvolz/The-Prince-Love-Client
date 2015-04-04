local function explode(div,str) -- credit: http://richard.warburton.it
  if (div=='') then return false end
  local pos,arr = 0,{}
  -- for each divider found
  for st,sp in function() return string.find(str,div,pos,true) end do
    table.insert(arr,string.sub(str,pos,st-1)) -- Attach chars left of current divider
    pos = sp + 1 -- Jump past current divider
  end
  table.insert(arr,string.sub(str,pos)) -- Attach chars right of last divider
  return arr
end
local socket = require "socket"
local address,port="127.0.0.1",1897
local updaterate=5
local t=0
local udp
function love.load()
    udp = socket.udp()
    udp:settimeout(0)
    udp:setpeername(address, port)
    math.randomseed(os.time())
    udp:send("invade poland 1")
end

function love.update(deltatime)
    t = t + deltatime -- increase t by the deltatime

    if t > updaterate then
      t=t-updaterate -- set t for the next round
    end
    local data=udp:receive()
    if data then
      print(data)
    end
end
