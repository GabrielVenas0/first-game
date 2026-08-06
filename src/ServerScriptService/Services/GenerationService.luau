
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local ServerStorage = game:GetService("ServerStorage")

local Configs = ReplicatedStorage:WaitForChild("Configs")

local GameUtils = require(Configs.GameUtils)
local Biomes = Configs:WaitForChild("Biomes")
local Assets = ServerStorage:WaitForChild("Assets")
local TreeAssets = Assets:WaitForChild("Tree")

local SPAWN_INTERVAL = 0.2


local Public = {}
local TerrainMap:{[string]:BasePart} = {}


function Public.Discount(node:BasePart)
  local terrainID = node:GetAttribute("TerrainID")
  if typeof(terrainID) ~= "string" then
    return
  end
  local terrain = TerrainMap[terrainID]
  local count = terrain:GetAttribute("TreeCount")
  if typeof(count) == "number" then
    terrain:SetAttribute("TreeCount", count - 1)
  end
end

local function CheckConditions(pos:Vector3, size:Vector3):boolean
  local c = CFrame.new(pos)

  local parts = workspace:GetPartBoundsInBox(c, size)
  if #parts > 0 then
    return false
  end

  return true
end

local function GenTree(treetype:unknown, pos:Vector3, terrain:BasePart)
    local tree = TreeAssets:Clone()
    local terrainID = terrain:GetAttribute("ID")

    tree.Parent = workspace
    tree.Position = pos
    tree:SetAttribute("TerrainID", terrainID)

    local count = terrain:GetAttribute("TreeCount")

    if typeof(count) == "number" then
      terrain:SetAttribute("TreeCount", count + 1)
      print("Plantou")
    end
end

local function ForestGeneration(terrain:BasePart)

      local pos = terrain.Position
      local treetype = terrain:GetAttribute("Tree")
      local treeMaxCount = terrain:GetAttribute("MaxTreeCount")
      local id = terrain:GetAttribute("ID")
      
      if typeof(treetype) ~= "string" then
        return
      end
      if typeof(id) ~= "string" then
        return
      end

      TerrainMap[id] = terrain
      local treeObj = GameUtils.getNodeProperties(treetype)
      
      if treeObj == nil then
        return
      end
      
      local baseSize = Vector3.new(treeObj.BaseSize, treeObj.MaxSize, treeObj.BaseSize)
      
      while true do
        local temp = 0
        local count = terrain:GetAttribute("TreeCount")
        if typeof(count) ~= "number" then
            continue
        end
        if count == treeMaxCount then
          terrain:GetAttributeChangedSignal("TreeCount"):Wait()
        end

        local x = (math.random() - 0.5) * terrain.Size.X
        local z = (math.random() - 0.5) * terrain.Size.Z  
        local randPos = pos + Vector3.new(x, terrain.Size.Y + (treeObj.MaxSize/2), z)


        if CheckConditions(randPos, baseSize) == true then
            GenTree(treetype, randPos, terrain)
          end
          task.wait(SPAWN_INTERVAL)
        end
      end

function Public.Init()
  for _, terrain:BasePart in ipairs(CollectionService:GetTagged("Terrain")) do
    task.spawn(ForestGeneration, terrain)
  end
end

return Public
