local Tree = {}

Tree.__index = Tree
local DEFAULT_H = 10
local DEFAULT_NODES = 5
local DEFAULT_TWIST = 10
local DEFAULT_ANGLE = math.pi / 2

type GetPart = () -> BasePart

function Tree.new(GetPart:GetPart, maxH:number?, maxNodes:number?, maxTwist:number?, maxAngleCurve:number?)
  local self = setmetatable({}, Tree)
  
  self._part = GetPart
  self._maxH = maxH or DEFAULT_H
  self._maxNodes = maxNodes or DEFAULT_NODES
  self._maxTwist = maxTwist or DEFAULT_TWIST
  self._maxAnglesCurve = maxAngleCurve or DEFAULT_ANGLE

  return self
end

function Tree:RecursiveGen(parentBranch:Part, iter:number)
  if iter == self._maxNodes then 
    parentBranch:AddTag("Leaf")
    return 
  end
  
  local pivot = parentBranch:GetPivot()
  local origin = CFrame.new(Vector3.yAxis * parentBranch.Size.Y)

  local progress = iter / self._maxNodes
  local baseAngle = math.lerp(25, self._maxAnglesCurve, progress)
  local variation = 20 * (1 - progress * 0.5)
  local droopAngle = baseAngle + math.random(-variation, variation)
  
  local rotation = CFrame.Angles(
    0, 
    (math.pi/3) * math.random(), 
    math.rad(droopAngle)
  )
  
  local newBranch:Part = self._part()
  local newBranch2:Part = self._part()

  -- newBranch.Color = Color3.fromRGB(255, 0, 0)
  -- newBranch2.Color = Color3.fromRGB(0, 0, 255)


  if parentBranch.Parent then
    newBranch.Parent = parentBranch.Parent
    newBranch2.Parent = parentBranch.Parent
  end
  local newW = parentBranch.Size.X * 0.7
  local newH = parentBranch.Size.Y * 0.9

  if iter > 1 then
      newBranch.CanCollide = false
      newBranch2.CanCollide = false
  end

  newBranch.Size = Vector3.new(newW, newH, newW)
  newBranch.PivotOffset = CFrame.new(Vector3.new(0, -newH/2, 0 ))
  newBranch:PivotTo(pivot * origin * rotation)

  newBranch2.Size = newBranch.Size
  newBranch2.PivotOffset = CFrame.new(Vector3.new(0, -newH/2, 0 ))
  newBranch2:PivotTo(pivot * origin * rotation.Rotation:Inverse())

  self:RecursiveGen(newBranch, iter+1)
  self:RecursiveGen(newBranch2, iter+1)
end

return Tree