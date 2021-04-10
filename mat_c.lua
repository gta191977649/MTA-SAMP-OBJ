function findTxdFromModel(model_id,txd_name)
    -- deal with samp object
    if isSAMPObject(model_id) then
        if SAMPObjects[model_id].malloc_id ~= nil then 
            model_id = SAMPObjects[model_id].malloc_id
        end
    end

    local replace = engineGetModelTextures(model_id,txd_name)
    local txd = nil
    for name,texture in pairs(replace) do
        txd = texture
    end
    return txd
end
function findMaterialNameFromIndex(model_id,index)
    if ModelCache[model_id] ~= nil then 
        local m_name = ModelCache[model_id].dff

        local key = string.lower(string.format("%s.dff",m_name))
        if SA_IMG[key] ~= nil and SA_IMG[key][index] ~= nil then 
            return SA_IMG[key][index].name
        elseif SA_IMG[key] ~= nil and SA_IMG[key][1] ~= nil then
            return SA_IMG[key][1].name
        else
            outputConsole(string.format( "Error for material: %s, index: %d",key,index))
        end
    else
        local m_name = engineGetModelNameFromID (model_id)
        local key = string.lower(string.format("%s.dff",m_name))
  
        if SA_IMG[key] ~= nil and SA_IMG[key][index] ~= nil then 
            return SA_IMG[key][index].name
        elseif SA_IMG[key] ~= nil and SA_IMG[key][1] ~= nil then
            return SA_IMG[key][1].name
        else
            outputConsole(string.format( "Error for material: %s, index: %d",key,index))
        end
    end
    
    return false
end
function getColor(color)
    if color == "0" or color == 0 then
        return 1,1,1,1
    elseif #color == 8 then 
        local a = tonumber(string.sub(color,1,2), 16) / 255
        local r = tonumber(string.sub(color,3,4), 16) / 255
        local g = tonumber(string.sub(color,5,6), 16) / 255
        local b = tonumber(string.sub(color,7,8), 16) / 255
        return a,r,g,b
    else -- not hex, not number, return default material color
        return 1,1,1,1
    end 
end
function setObjectMaterial(objid,mat_index,model_id,txd_filename,txd_name,color)

    -- get target txd 
    local txd = findTxdFromModel(model_id,txd_name)
        if txd ~= nil then 
        -- create shader
        local matShader = dxCreateShader( "shader.fx" )
        local index = mat_index+1 -- due to lua start index from 1
        local matName = findMaterialNameFromIndex(getElementModel(objid),index)
        --print("Found mat_name: "..matName)
        if matName ~= false then
            local a,r,g,b = getColor(color)
            dxSetShaderValue ( matShader, "gColor", r,g,b,a);
            dxSetShaderValue ( matShader, "gTexture", txd );
            --setElementAlpha(objid,a*255)
            if a == 0 then
                outputConsole(string.format("RGBA IS: %f,%f,%f,%f",r,g,b,a))
            end
            
            engineApplyShaderToWorldTexture ( matShader,matName,objid)
        else 
            outputConsole(string.format( "Error Set Material Model: %d Mat_model %d",getElementModel(objid),model_id))
        end
    else
        outputConsole(string.format( "Error Obtain obj: %d, txd: %s",model_id,txd_name))
    end
    print("")
end

-- test code
--[[
local obj = createObject(2790,0,0, 6)
setObjectMaterial(obj,1,3881,"apsecurity_sfxrf","WIN_DESKTOP",-1)
--]]