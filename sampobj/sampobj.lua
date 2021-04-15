
function createSAMPObject(model_id,x,y,z,rx,ry,rz)
    if isSampObject(model_id) then 
        if SAMPObjects[tostring(model_id)].malloc_id ~= nil then 
            --local lod = createObject(SAMPObjects[tostring(model_id)].malloc_id,x,y,z,rx,ry,rz,true)
            local samp_obj = createObject(SAMPObjects[tostring(model_id)].malloc_id,x,y,z,rx,ry,rz)
            setElementDoubleSided(samp_obj,true)
            return samp_obj
        else
            outputConsole("[SAMPOBJ]: Faild to create model: "..model_id)
            return false
        end
    else -- none SAMP Object
        return createObject(model_id,x,y,z,rx,ry,rz)
    end
end