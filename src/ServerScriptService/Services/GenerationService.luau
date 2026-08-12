
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local CollectionService = game:GetService("CollectionService")
local ServerStorage = game:GetService("ServerStorage")

local Configs = ReplicatedStorage:WaitForChild("Configs")

local GameUtils = require(Configs.GameUtils)
local Assets = ServerStorage:WaitForChild("Assets")
local TreeAssets = Assets:WaitForChild("Tree")

local SPAWN_INTERVAL = 0.2


local Public = {}
local TerrainMap:{[string]:BasePart} = {}


function Public.Discount(node:BasePart)
  local terrainID = node:GetAttribute("TerrainID")::string
  local terrain = TerrainMap[terrainID]
  local count = terrain:GetAttribute("TreeCount")::number
  terrain:SetAttribute("TreeCount", count - 1)
end

local function ThrowRayCast(pos:Vector3, direction:Vector3):RaycastResult
  local params = RaycastParams.new()
  params.CollisionGroup = "Default"
	params.FilterDescendantsInstances = {workspace.Terrain}
  params.FilterType = Enum.RaycastFilterType.Include
  params.IgnoreWater = false
  local raycastResult = workspace:Raycast(pos, direction, params)
  return raycastResult
end

-- returns a boolean and a position to the tree(return 0 if the position isn't qualified)
local function CheckConditions(position:Vector3, base:Vector3):boolean
  local cframe = CFrame.new(position)
  local parts = workspace:GetPartBoundsInBox(cframe, base)
  if #parts > 0 then
    print("Sem espaço")
    return false
  end
  return true
end

local function GenTree(treetype:unknown, rayCast:RaycastResult, terrain:BasePart)
    local tree = TreeAssets:Clone()::Part
    local terrainID = terrain:GetAttribute("ID")
    local pos = rayCast.Position
    local surface = rayCast.Normal
    local arbitraryLook = Vector3.new(0, 0, -1)

    tree.Parent = workspace

    if math.abs(surface:Dot(arbitraryLook)) > 0.99 then
        arbitraryLook = Vector3.new(1, 0, 0)
    end
    local rightVector = surface:Cross(arbitraryLook)
    local lookVector = rightVector:Cross(surface).Unit
    
    -- tree.CFrame = CFrame.fromMatrix(pos, rightVector, surface, lookVector)
    tree:PivotTo(CFrame.fromMatrix(pos, rightVector, surface, lookVector))
    
    tree:SetAttribute("TerrainID", terrainID)
    
    local count = terrain:GetAttribute("TreeCount")::number
    terrain:SetAttribute("TreeCount", count + 1)
    print("Plantou")
end

local function ForestGeneration(terrain:BasePart)
      local temp = 0
      local pos = terrain.Position
      local treetype = terrain:GetAttribute("Tree")::string
      local treeMaxCount = terrain:GetAttribute("MaxTreeCount")::number
      local id = terrain:GetAttribute("ID")::string
      
      TerrainMap[id] = terrain
      local treeObj = GameUtils.getNodeProperties(treetype)
      
      if treeObj == nil then
        return
      end
    
      local baseSize = Vector3.new(treeObj.BaseSize, treeObj.MaxSize, treeObj.BaseSize)
      
      while true do
        local count = terrain:GetAttribute("TreeCount")
        if count == treeMaxCount or temp == 10 then
          terrain:GetAttributeChangedSignal("TreeCount"):Wait()
        end
        
        local x = (math.random() - 0.5) * terrain.Size.X
        local z = (math.random() - 0.5) * terrain.Size.Z  
        
        local terrainh = terrain.Position.Y

        local randPos = pos + Vector3.new(x, 0, z)
        local direction = Vector3.new(0, -terrainh, 0)
        
        local rayCastResult = ThrowRayCast(randPos, direction)
        if rayCastResult == nil then
          temp += 1
          continue  
        end
        local qualified = CheckConditions(rayCastResult.Position, baseSize)
        if qualified == true then
            GenTree(treetype, rayCastResult, terrain)
            temp = 0
        else 
          temp += 1
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
