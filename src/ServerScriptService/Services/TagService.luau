local ServerScriptService = game:GetService("ServerScriptService")
local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Bindables = ServerScriptService.Bindables
local Remotes = ReplicatedStorage:WaitForChild("Remotes")

local BindableManager = require(Bindables.BindableManager) 
local RemoteManager = require(Remotes:WaitForChild("RemoteManager")) 

local InteractionEvent = BindableManager.GetEvent("InteractionEvent")
local startHoverEvent = RemoteManager.GetEvent("startHover")
local endHoverEvent = RemoteManager.GetEvent("endHover")

local Local = {}
local Public = {}

local TAG_NAME = "Interactable"

function Public.Init() end

function Public.Start()
  for _, object: BasePart in ipairs(CollectionService:GetTagged(TAG_NAME)) do
    Local.setupPrompt(object)
    Local.setupClick(object)
  end

  CollectionService:GetInstanceAddedSignal(TAG_NAME):Connect(Local.setupPrompt)
  CollectionService:GetInstanceAddedSignal(TAG_NAME):Connect(Local.setupClick)
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

function Local.setupClick(object)
  if not CollectionService:HasTag(object, TAG_NAME) then return end

  local click = object:FindFirstChildOfClass("ClickDetector")
  if not click then
    click = Instance.new("ClickDetector")
    click.MaxActivationDistance = 32
    click.Parent = object
  end

  click.MouseHoverEnter:Connect(function(player: Player)
    startHoverEvent:FireClient(player, object)
  end)
  
  click.MouseHoverLeave:Connect(function(player: Player)
    endHoverEvent:FireClient(player, object)
  end)
end

return Public

