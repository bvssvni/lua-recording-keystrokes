lua-recording-keystrokes
========================

Record key press and key releases.  
BSD license.  
For version log, view the individual files.  

In order to run this example, you need to install LÖVE game engine.  
https://love2d.org/

##About Recording Keystrokes  

When making a game, it might be a good idea to consider recording AI bot actions rather than hard coding.  
An obvious motivation for this is that fine-tuning AI is hard.  
A more efficient use of time could be to combine a set of actions.  
Alternatively, the recorded data could be used for training neural networks or similar.  

One can record keystrokes to "play" a set of actions relative to a point in time.  
This type of recording simply saves in Lua script.  
To use the data you need to do the following:  

    local data = require "my-recorded-data"
    
