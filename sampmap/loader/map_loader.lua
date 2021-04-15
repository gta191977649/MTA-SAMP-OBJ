SAMP = exports.sampobj

local total = 0
function loadSAMPMap(filename,int)
    int = int or 0
    if fileExists(filename) then 
        local f = fileOpen(filename)
        local str = fileRead(f,fileGetSize(f))
        fileClose(f)
        Lines = split(str,'\n' )
        for i = 1, #Lines do
            --print(Lines[i])
            local p = split(Lines[i],",")
            local model = tonumber(p[1])
            local x = tonumber(p[2])
            local y = tonumber(p[3])
            local z = tonumber(p[4])
            local rx = tonumber(p[5])
            local ry = tonumber(p[6])
            local rz = tonumber(p[7])
            local mat_id = tonumber(p[8])
            local mat_model = tonumber(p[9])
            local libName = p[10]
            local txdName = p[11]
            local color = p[12]
            
            
            --local obj = createObject(model,x,y,z,rx,ry,rz)
            local obj = SAMP:createSAMPObject(model,x,y,z,rx,ry,rz)
            if obj then
                setElementInterior(obj,int)
                if txdName ~= "nill" or txdName ~= "none" then -- material objects
                    SAMP:setObjectMaterial(obj,mat_id,mat_model,libName,txdName,0)
                end
                total = total + 1
            end
        end

    end
end

function loadSAMPMapv2(filename,int,dim)
    int = int or 0
    dim = dim or 0
    if fileExists(filename) then 
        local f = fileOpen(filename)
        local str = fileRead(f,fileGetSize(f))
        fileClose(f)
        Lines = split(str,'\n' )
        local lastObjid = -1
        local obj = nil
        for i = 1, #Lines do
            --print(Lines[i])
            local p = split(Lines[i],",")
            local objid = p[1]
            local model = tonumber(p[2])
            local x = tonumber(p[3])
            local y = tonumber(p[4])
            local z = tonumber(p[5])
            local rx = tonumber(p[6])
            local ry = tonumber(p[7])
            local rz = tonumber(p[8])
            local mat_id = tonumber(p[9])
            local mat_model = tonumber(p[10])
            local libName = p[11]
            local txdName = p[12]
            local color = p[13]
        
            if objid ~= lastObjid then --set 
                obj = SAMP:createSAMPObject(model,x,y,z,rx,ry,rz)
                setElementInterior(obj,int)
                setElementDimension(obj,dim)
                lastObjid = objid
            end
            if txdName ~= "nil" then -- material objects
                SAMP:setObjectMaterial(obj,mat_id,mat_model,libName,txdName,color)
            end
            total = total + 1
        
        end

    end
end