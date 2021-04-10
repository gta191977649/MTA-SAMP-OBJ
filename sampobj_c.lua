
--[[
    local img = engineLoadIMGContainer("gta3.img")
    txd = engineLoadTXD(img:getFile("banshee.txd"))
    dff = engineLoadDFF(img:getFile("banshee.dff"))
    engineImportTXD(txd,411)
    engineReplaceModel(dff,411)
]]
-- load & import samp objects
SAMPObjects = {}
ModelCache = {}
local total = 0
function loadSAMPIPL(path)
    if fileExists(path) then 
        local f = fileOpen(path)
        local str = fileRead(f,fileGetSize(f))
        fileClose(f)
        Lines = split(str,'\n' )
        for i = 1, #Lines do
            local s = split(Lines[i],",")
            if #s == 5 then -- read ide lines
                local model_id = s[1]
                local dff = string.gsub(s[2], '%s+', '')
                local txd = string.gsub(s[3], '%s+', '')
                SAMPObjects[model_id] = { malloc_id = nil , dff=dff,txd=txd, }
                --table.insert( SAMPObjects,{ id =model_id, dff=dff,txd=txd,internal_id = nil })
            end
        end
    end
end

Async:setPriority("high")
function loadSAMPIMG(path,path_col)
    print("load samp img...")
    local img = engineLoadIMGContainer(path)
    print("load samp col...")
    local cols = engineGetCOLsFromLibrary(path_col)
    --print(cols)
    --[[
    for name,_ in pairs(img.directoryNameToIndex) do 
        if name == "UFO" then
            outputConsole(name)
        end
    end
    --]]

    if img then 
        for model_id,v in pairs(SAMPObjects) do 
            local txd_name = string.format( "%s.txd",v.txd)
            local dff_name = string.format( "%s.dff",v.dff)
            
            local file_txd = img:getFile(string.lower(txd_name))
            local file_dff = img:getFile(string.lower(dff_name))
            local file_col = cols[v.dff]
            --local file_col = "samp/col/"..string.lower(v.dff)..".col"

            if file_dff ~= false then
                local id = engineRequestModel("object")
                local dff = engineLoadDFF(file_dff)
                ModelCache[id] = {}
                ModelCache[id].dff = v.dff
                ModelCache[id].txd = v.txd
                if file_txd then
                    local txd = engineLoadTXD(file_txd)
                    if engineImportTXD(txd, id) == false then 
                        outputConsole("Error Load TXD: "..txd_name)
                    end

                else
                    outputConsole("Error Load TXD: "..txd_name)
                end

                
                engineReplaceModel(dff, id)
                engineSetModelLODDistance(id, 1000) 
                if file_col then 
                    local col = engineLoadCOL(file_col)
                    engineReplaceCOL(col,id)
                else
                    outputConsole(string.lower(v.dff))
                end
                SAMPObjects[model_id].malloc_id = id

                total = total + 1
            else
                print("[SAMPOBJ]: Load Error: "..dff_name)
            end
        end
    end
    print("SBMP Model Loaded, Total: "..total)
end

function isSAMPObject(model)
    model = tonumber(model)
    return model >= 18631 and model <= 19999 or model >= 11682 and model <= 12799
end
loadSAMPIPL("samp/samp.ide")
loadSAMPIMG("samp/samp.img","samp/samp.col")

function createSAMPObject(model,x,y,z,rx,ry,rz)
    if isSAMPObject(model) then 
        if SAMPObjects[model].malloc_id ~= nil then 
            local samp_obj = createObject(SAMPObjects[model].malloc_id,x,y,z,rx,ry,rz)
            setElementDoubleSided(samp_obj,true)
            return samp_obj
        else
            print("[SAMPOBJ]: Faild to create model: "..model)
            return false
        end
    else
        return createObject(model,x,y,z,rx,ry,rz)
    end
end