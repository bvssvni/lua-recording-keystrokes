--[[

recording - Record key press and key releases.
BSD license.
by Sven Nilsen, 2012
http://www.cutoutpro.com

Version: 0.000 in angular degrees version notation
http://isprogrammingeasy.blogspot.no/2012/08/angular-degrees-versioning-notation.html

Functions for recording keystrokes and storing them to a file.
One can also check if a key is pressed according to the recorded data.

--]]

--[[

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:
1. Redistributions of source code must retain the above copyright notice, this
list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright notice,
this list of conditions and the following disclaimer in the documentation
and/or other materials provided with the distribution.
THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
The views and conclusions contained in the software and documentation are those
of the authors and should not be interpreted as representing official policies,
either expressed or implied, of the FreeBSD Project.

--]]

local recording = {}

-- Record data contains the key presses done by the user.
function recording.newRecordData()
  return {time = nil}
end

-- Start recording data.
-- This sets the time when to current time.
-- The time is used to calculate the relative keypress or release.
function recording.start(recordData)
  recordData.time = love.timer.getTime()
end

-- Creates a new record with key (string), time (number) and idDown (boolean).
function recording.newRecord(key, time, isDown)
  return {key, time, isDown}
end

function recording.getTime(recordData)
  return love.timer.getTime() - recordData.time
end

-- Registers a key press.
function recording.pressKey(recordData, key)
  local dt = recording.getTime(recordData)
  recordData[#recordData + 1] = recording.newRecord(key, dt, true)
end

-- Registers a key release.
function recording.releaseKey(recordData, key)
  local dt = recording.getTime(recordData)
  recordData[#recordData + 1] = recording.newRecord(key, dt, false)
end

-- Returns a record as a string.
function recording.recordToString(record)
  local isDownStr = "false"
  if record[3] then
    isDownStr = "true"
  end
  
  return record[1] .. "," .. record[2] .. "," .. isDownStr
end

-- Returns record data as a string.
function recording.recordDataToString(recordData)
  local str = ""
  for i = 1, #recordData do
    str = str .. "{" .. recording.recordToString(recordData[i]) .. "},\r\n"
  end
  return str
end

-- Saves data to a file.
-- This is saved in the love.filesystem.getSaveDirectory().
function recording.save(recordData, file)
  local str = "return {\r\n" .. recording.recordDataToString(recordData) .. "}"
  if love.filesystem.write(file, str, string.len(str)) then
    print("Data recorded to: " .. love.filesystem.getSaveDirectory())
  end
end

-- Finds out whether a key is pressed or not according to record data.
function recording.isKeyPressed(recordData, key, time)
  local n = #recordData
  for i = n, 1, -1 do
    local record = recordData[i]
    local recordKey, recordTime, isDown = record[1], record[2], record[3]
    if recordTime > time then
      return false
    end
    if recordKey == key then
      return isDown
    end
  end
  
  return false
end

return recording
