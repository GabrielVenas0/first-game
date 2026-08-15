
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local CollectionService = game:GetService("CollectionService")
local ServerStorage = game:GetService("ServerStorage")
local Workspace = game:GetService("Workspace")

local Configs = ReplicatedStorage:WaitForChild("Configs")
local Util = ReplicatedStorage:WaitForChild("Util")

local GameConfig = require(ReplicatedStorage.Configs.GameConfig)
local RecursiveTree = require(Util.RecursiveTree)
local LeafPlacer = require(Util.LeafPlacer)


local PoolingSerivce = require(script.Parent.PoolingService)
local GameUtils = require(Configs.GameUtils)


local Assets = ServerStorage:WaitForChild("Assets")
local NodesAssets:Instance = Assets.Nodes
local Tree = NodesAssets:WaitForChild("Tree")
local Tim = Tree:WaitForChild("Tim")

local SPAWN_INTERVAL = 0.2
local MAX_ATTEMPT = 20
local RecursiveObject = nil

local Public = {}
local TerrainMap:{[string]:BasePart} = {}

local function PivotToSurface(part:BasePart, normal:Vector3, pos:Vector3)
    local arbitraryLook = Vector3.new(0, 0, -1)
     if math.abs(normal:Dot(arbitraryLook)) > 0.99 then
        arbitraryLook = Vector3.new(1, 0, 0)
    end
    
    local rightVector = normal:Cross(arbitraryLook)
    local lookVector = rightVector:Cross(normal).Unit
      part:PivotTo(CFrame.fromMatrix(pos, rightVector, normal, lookVector))
end

local function ThrowRayCast(pos:Vector3, direction:Vector3):RaycastResult
  local params = RaycastParams.new()
  params.CollisionGroup = "Default"
	params.FilterDescendantsInstances = {workspace.Terrain}
  params.FilterType = Enum.RaycastFilterType.Include
  params.IgnoreWater = true
  local raycastResult = workspace:Raycast(pos, direction, params)
  return raycastResult
end

local function CheckConditions(rayCastResult:RaycastResult, base:Vector3):boolean
  local cframe = CFrame.new(rayCastResult.Position)
  local parts = workspace:GetPartBoundsInBox(cframe, base)
  if #parts > 0 then
    -- print("Sem espaço")
    return false
  end
  if rayCastResult.Material ~= Enum.Material.Grass then
    return false
  end
  return true
end

local function GenTree(treetype:unknown, rayCast:RaycastResult, terrain:BasePart)

    local _baseTree = PoolingSerivce.Get("BaseTree")::Part
    local _bodyTree = PoolingSerivce.Get("BodyTree")::Part

    local terrainID = terrain:GetAttribute("ID")

    PivotToSurface(_baseTree, rayCast.Normal, rayCast.Position)
    
    local pasta = Instance.new("Folder")

    pasta.Name = "Tree"
    pasta.Parent = workspace

    _baseTree.Parent = pasta
    _bodyTree.Parent = pasta

    local oakProps = GameConfig.Nodes.Trees.Oak

    local randValue = math.random(oakProps.MinSize, oakProps.MaxSize)
    _bodyTree.Size += Vector3.new(0, randValue * 0.5, 0)

    _bodyTree.PivotOffset = CFrame.new(Vector3.new(0, -_bodyTree.Size.Y/2, 0 ))
    local inclination = _baseTree.CFrame.Rotation:Inverse()
    local origin = _baseTree:GetPivot()
  
    local tortion = CFrame.Angles(math.pi * math.random()/6, math.pi * math.random() * 2, 0)

    _bodyTree:PivotTo(origin * CFrame.new( Vector3.yAxis * _baseTree.Size.Y) * inclination * tortion)
    

    if RecursiveObject then
      RecursiveObject:RecursiveGen(_bodyTree, 0)  
    end

    LeafPlacer.PlaceLeaf(CollectionService:GetTagged("Leaf"), Tree:FindFirstChild("Bush")::MeshPart)
    _bodyTree:SetAttribute("TerrainID", terrainID)
    
    local count = terrain:GetAttribute("TreeCount")::number
    terrain:SetAttribute("TreeCount", count + 1)
    -- print("Plantou")
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
        if count == treeMaxCount or temp == MAX_ATTEMPT then
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
          task.wait(SPAWN_INTERVAL)
          continue  
        end
        local qualified = CheckConditions(rayCastResult, baseSize)
        if qualified == true then
            GenTree(treetype, rayCastResult, terrain)
            temp = 0
        else 
          temp += 1
        end
          task.wait(SPAWN_INTERVAL)
    end
end

function Public.Discount(node:BasePart)
  local terrainID = node:GetAttribute("TerrainID")::string
  local terrain = TerrainMap[terrainID]
  local count = terrain:GetAttribute("TreeCount")::number
  terrain:SetAttribute("TreeCount", count - 1)
end

function Public.WipeNodes(node:Instance)
  local parent = nil  
  if node then
    parent = node.Parent
  else
    return
  end
    if parent and parent.Name ~= "workspace" then
        local children = parent:GetChildren()
        for _, a in ipairs(children) do
            local _name = a.Name
            if a.Name == node.Name then
              node.Parent = workspace
              continue
            end
            PoolingSerivce.Free(a, _name)
        end
        parent:Destroy()
        return 
    end
end

local function BodyTreeFree(part:Instance)
  (part :: BasePart).CFrame = CFrame.new(0, 10000, 0);
  (part :: BasePart).Anchored = true
  part:SetAttribute("Action", "Gather")
  

end 

function Public.Init()
  local BaseTree = Tim:WaitForChild("BaseTree")
  local BodyTree = Tim:WaitForChild("BodyTree")
  local NodeTree = Tim:WaitForChild("NodeTree")

  PoolingSerivce.New(BaseTree, BaseTree.Name, 1000)
  PoolingSerivce.New(BodyTree, BodyTree.Name, 1000, BodyTreeFree)
  PoolingSerivce.New(NodeTree, NodeTree.Name, 20000)

  RecursiveObject = RecursiveTree.new(function() 
      return PoolingSerivce.Get("NodeTree")::Part 
  end
)

  for _, terrain:BasePart in ipairs(CollectionService:GetTagged("Terrain")) do
    task.spawn(ForestGeneration, terrain)
  end
end

return Public
