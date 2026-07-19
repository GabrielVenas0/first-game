--!strict
local _ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local _Local = {}
local Public = {}

function Public.Init()

end

function Public.Start()
  
end

--[[
TO DO
- Improve drop animation
- Drop ID
- Improve Security
]]
function Public.rawDrop(pOwner: number, object: BasePart)
  local cframeValue = Instance.new("CFrameValue")
  cframeValue.Value = object:GetPivot()

  cframeValue.Changed:Connect(function(novoCFrame)
    object:PivotTo(novoCFrame)
  end)

  local infoTween = TweenInfo.new(2, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out)

  local relative = CFrame.Angles(math.rad(90), 0, 0)
  local finalCFrame = object:GetPivot() * relative
  
  local tween = TweenService:Create(object, infoTween, {CFrame = finalCFrame})
  
  tween:Play()
  tween.Completed:Connect(function()
    object.Anchored = false
	  cframeValue:Destroy()
    object:SetAttribute("Action", "Drag")
  end)
end

return Public