recording = require "recording"

local recordData = recording.newRecordData()
local keys = {a = false, s = false, d = false, w = false, 
  left = false, down = false, right = false, up = false}

-- Check if the keys are pressed according to record data.
function checkKeys(keys, recordData)
  local time = recording.getTime(recordData)
  for key, isDown in pairs(keys) do
    keys[key] = recording.isKeyPressed(recordData, key, time)
  end
end

-- Draw the state of the keys.
function drawKeys(keys)
  local height = 20
  local y = 0
  love.graphics.setColor(255, 255, 255, 255)
  for key, isDown in pairs(keys) do
    local isDownStr = "false"
    if keys[key] then
      isDownStr = "true"
    end
    love.graphics.print(key .. ": " .. isDownStr, 0, y)
    y = y + height
  end
end

function love.load()
  recording.start(recordData)
end

function love.keypressed(key, unicode)
  recording.pressKey(recordData, key)
end

function love.keyreleased(key)
  recording.releaseKey(recordData, key)
end

function love.quit()
  recording.save(recordData, "recorded-data.lua")
end

function love.update()
  checkKeys(keys, recordData)
end

function love.draw()
  love.graphics.setBackgroundColor(0, 0, 0, 255)
  drawKeys(keys)
end

