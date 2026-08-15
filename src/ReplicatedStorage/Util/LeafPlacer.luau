local Public = {}

type Collection = {BasePart}

function Public.PlaceLeaf(TargetParts:Collection, Bush:Instance)
  local temp = 0
  for _, part in TargetParts do
    part:RemoveTag("Leaf")
    temp += 1
    if temp < 4 then
      continue
    end
    temp = 0
    local origin = part.Position
    local newBush = Bush:Clone();


    (newBush::Part).Position = origin;
    newBush.Parent = part.Parent
    -- for _, part in newBush:GetChildren() do
    --   (part::Part).Position = origin
    -- end
  end
end
return Public 