function getTxdNameFromIndex(object,mat_index)
    local mta_id = getElementModel(object)
    local dff = nil
    if MTAIDMapSAMPModel[tostring(mta_id)] ~= nil then -- if samp model
        if MTAIDMapSAMPModel[tostring(mta_id)] ~= nil then 
            local model = MTAIDMapSAMPModel[tostring(mta_id)].dff
            if SA_MATLIB[model..".dff"] ~= nil then
                for idx,val in ipairs(SA_MATLIB[model..".dff"]) do
                    if val.index == mat_index then --
                        dff = val.name
                    end
                end
            end
            
        end
    else -- normal SA object
        local model = string.lower(engineGetModelNameFromID(mta_id))
        if SA_MATLIB[model..".dff"] ~= nil then
            for idx,val in ipairs(SA_MATLIB[model..".dff"]) do
                if val.index == mat_index then --
                    dff = val.name
                end
            end
        end
    end
    return dff
end
function getTextureFromTxdName(model_id,txdName)
    if isSampObject(model_id) then -- if is samp model, we need to obtain the id allcated by the MTA
        model_id = SAMPObjects[tostring(model_id)].malloc_id
    end
    local txds = engineGetModelTextures(model_id,txdName)
    for name,texture in pairs(txds) do
        return texture
    end
    return nil
end

function getColor(color)
    if color == "0" or color == 0 then
        return 1,1,1,1
    elseif #color == 8 then 
        local a = tonumber(string.sub(color,1,2), 16) /255
        local r = tonumber(string.sub(color,3,4), 16) /255
        local g = tonumber(string.sub(color,5,6), 16) /255
        local b = tonumber(string.sub(color,7,8), 16) /255
        return a,r,g,b
    else -- not hex, not number, return default material color
        return 1,1,1,1
    end 
end

function setObjectMaterial(object,mat_index,model_id,lib_name,txd_name,color)
    if model_id ~= -1 then -- dealing replaced mat objects
        local target_txd = getTxdNameFromIndex(object,mat_index)
        if target_txd ~= nil then 
            -- find the txd name we want to replaced
            local matShader = dxCreateShader( "shader.fx" )
            local matTexture = getTextureFromTxdName(model_id,txd_name)
            if matTexture ~= nil then
                -- apply shader attributes
                --local a,r,g,b = getColor(color)
                --a = a == 0 and 1 or a
                --alpha disabled due to bug
                dxSetShaderValue ( matShader, "gColor", 1,1,1,1);
                dxSetShaderValue ( matShader, "gTexture", matTexture);
            else
                outputConsole(string.format( "[OBJ_MAT]: Error on model %d, req txd: %s,model_id: %d, mat_index: %d",getElementModel(object),txd_name,model_id,mat_index))
            end
            engineApplyShaderToWorldTexture (matShader,target_txd,object)
        else
            outputConsole(string.format( "[OBJ_MAT]: Error on model %d, req txd: %s,model_id: %d, mat_index: %d",getElementModel(object),txd_name,model_id,mat_index))
        end
    end
end