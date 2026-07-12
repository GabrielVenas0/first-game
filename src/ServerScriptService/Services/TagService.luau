local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Events = ReplicatedStorage:WaitForChild("Events")
local InteractionEvent = Events.InteractionEvent

local Local = {}
local Public = {}

local TAG_NAME = "Interactable"

function Public.Init() end

function Public.Start()
  for _, object in ipairs(CollectionService:GetTagged(TAG_NAME)) do
    Local.setupPrompt(object)
  end

  CollectionService:GetInstanceAddedSignal(TAG_NAME):Connect(Local.setupPrompt)
end

function Public.SetupTag(object)
  if not object:IsA("BasePart") then return end
  if CollectionService:HasTag(object, TAG_NAME) then return end

  CollectionService:AddTag(object, TAG_NAME)
  Local.setupPrompt(object)
end

function Local.setupPrompt(object)
  if not CollectionService:HasTag(object, TAG_NAME) then return end

  local prompt = object:FindFirstChildOfClass("ProximityPrompt")
  if not prompt then
    prompt = Instance.new("ProximityPrompt")
    prompt.Parent = object
  end

  prompt.Triggered:Connect(function(player)
    InteractionEvent:Fire(player, object)
  end)
end

return Public

