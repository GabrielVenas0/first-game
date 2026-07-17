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
Muito a se fazer aqui ainda:
codigo cheira mal
a fisica de queda bem feia
ID do drop do node etc
]]
function Public.rawDrop(pOwner, node)
  local object = node :: Part
  if not object then return end

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
	  cframeValue:Destroy()
    object.Anchored = false
    object:SetAttribute("Action", "Drag")
  end)
end

return Public