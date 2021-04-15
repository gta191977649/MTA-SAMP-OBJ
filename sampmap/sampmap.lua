--[[
    SAMP MAP Loader
    By Nurupo
    -----------------
    Put your samp map in here
]]

loadTextureStudioMap("map/test.pwn",1,2) 

addCommandHandler("maptest",function() 
    setElementPosition(getLocalPlayer(),1395.462891,-17.192383,1000.917358)
    setElementDimension(getLocalPlayer(),2)
    setElementInterior(getLocalPlayer(),1 )
end)