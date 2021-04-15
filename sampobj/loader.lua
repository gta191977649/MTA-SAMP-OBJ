SAMPObjects = {}
MTAIDMapSAMPModel = {}
local total = 0
function loadSAMPObjects()
    print("load samp.img...")
    local img = engineLoadIMGContainer("samp/samp.img")
    print("loaded samp.col...")
    local cols = engineGetCOLsFromLibrary("samp/samp.col")


    if fileExists("samp/samp.ide") then 
        local f = fileOpen("samp/samp.ide")
        local str = fileRead(f,fileGetSize(f))
        fileClose(f)
        Lines = split(str,'\n' )
        for i = 1, #Lines do
            local s = split(Lines[i],",")
            if #s == 5 then -- read ide lines
                local samp_modelid = s[1]
                local dff = string.gsub(s[2], '%s+', '')
                local txd = string.gsub(s[3], '%s+', '')
                --load files
                local loadCol = cols[string.lower(dff)]
                local loadDff = img:getFile(string.lower(dff..".dff"))
                local loadTxd = img:getFile(string.lower(txd..".txd"))


                
                -- replace
                if loadCol ~= nil and loadDff ~= false and loadTxd ~= false then 
                    -- load file
                    local file_txd = engineLoadTXD(loadTxd)
                    local file_dff = engineLoadDFF(loadDff)
                    local file_col = engineLoadCOL(loadCol)
                    -- malloc & replace object
                    local id = engineRequestModel("object")
                    engineImportTXD(file_txd, id)
                    engineReplaceModel(file_dff, id)
                    engineReplaceCOL(file_col,id)
                    
                    SAMPObjects[samp_modelid] = { malloc_id = id , dff=string.lower(dff),txd=string.lower(txd) }

                    -- for the snake of saving speed of finding the id from set material
                    MTAIDMapSAMPModel[tostring(id)] = SAMPObjects[samp_modelid]

                    total = total + 1
                else
                    outputConsole(string.format("[SAMPOBJ]: dff %s load error.",string.lower(dff)))
                end
                --print(txd)
            end
        end
    end
    print("[SAMP OBJECT] Total load: ",total)
end
loadSAMPObjects()
