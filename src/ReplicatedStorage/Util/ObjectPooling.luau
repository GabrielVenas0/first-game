--!nonstrict
local ObjectPool = {}
ObjectPool.__index = ObjectPool 

type ObjectPoolCallBack = (object: Instance) -> ()

export type ObjectPool = typeof(setmetatable({}::{
  _objects:{},
  _object:Instance,
  _onGet:ObjectPoolCallBack,
  _onFree:ObjectPoolCallBack,
}, ObjectPool))

local function DefaultOnCreate(o:Instance)
  o.Parent = workspace
  if o:IsA("Part") then
      o.CanCollide = false
      o.CanTouch = false
      o.CFrame = CFrame.new(0, 100000, 0)
  end
end

local function DefaultOnFree(o:Instance)
  if o then
    print(o.Name)
    if o:IsA("Part") then
      o.CanCollide = false
      o.CanTouch = false
      o.CFrame = CFrame.new(0, 100000, 0)
    end
  end
end

local function DefaultOnGet(o:Instance)
  if o:IsA("Part") then
      o.CanCollide = true
      o.CanTouch = true
    end
end


function ObjectPool.new(object:Instance, size:number, onCreate:ObjectPoolCallBack?, onGet:ObjectPoolCallBack?, onFree:ObjectPoolCallBack?):ObjectPool
  local self = setmetatable({}, ObjectPool)
  self._objects = {}
  self._object = object
  self._onGet = onGet or DefaultOnGet
  self._onFree = onFree or DefaultOnFree
  
  onCreate = onCreate or DefaultOnCreate

  for i = 1, size do
    local o = object:Clone()
    table.insert(self._objects, o)
    if onCreate then
      onCreate(o)
    end   
  end
  return self
end

function ObjectPool:get()
  if #self._objects == 0 then
    local newpart = self._object:Clone()
    newpart.Parent = workspace
    
    self._onGet(newpart)   
    return newpart
  end
   local object = table.remove(self._objects, 1)
   self._onGet(object)
   return object
end

function ObjectPool:free(object:Instance)
  self._onFree(object)
  table.insert(self._objects, object)
end

function ObjectPool:clear()
    for _, object in ipairs(self._objects) do
      object:Destroy()
    end
    self._objects = {}
end

return ObjectPool