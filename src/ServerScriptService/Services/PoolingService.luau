local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ObjectPooling = require(ReplicatedStorage.Util.ObjectPooling)

local Public = {}
local NodesPoolingTable:{[string]:ObjectPooling.ObjectPool} = {}

type FreeCallBack = (o:Instance) -> ()

function Public.New(instance:Instance, nodeName:string, quant:number, FreeCallback:FreeCallBack?)
    if NodesPoolingTable[nodeName] then
      error("Pooling table already exists")  
      return
    end
    NodesPoolingTable[nodeName] = ObjectPooling.new(instance, quant, nil, nil, FreeCallback)
end

function Public.Get(nodeName:string):Instance?
  if NodesPoolingTable[nodeName] then
    return  NodesPoolingTable[nodeName]:get()
  end
  return nil
end

function Public.Free(object:Instance, nodeName:string)
  if NodesPoolingTable[nodeName] then
    NodesPoolingTable[nodeName]:free(object)
  end
end


return Public