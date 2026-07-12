--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Configs = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Configs")
local Events = ReplicatedStorage:WaitForChild("Events")
local InteractionEvent = Events.InteractionEvent
local GatheringService = require(script.Parent.GatheringService)

local Local = {}
local Public = {}

function Public.Init()

end

function Public.Start() 
  InteractionEvent.Event:Connect(Local.OnInteraction)
end

function Local.OnInteraction(player, object)
  local Ownable = object:GetAttribute("Ownable") == true
  local pOwner = object:GetAttribute("PlayerOwner")

  local character = player.Character
  if not character then return end

  local equippedTool = character:FindFirstChildOfClass("Tool")

  if Ownable then
    if pOwner >= 1 and player.UserId ~= pOwner then return end

    if pOwner < 1 then
      object:SetAttribute("PlayerOwner", player.UserId)
    end
  else            
    return
  end

  if (object:GetAttribute("Locked") :: any) == true then return end

  if (object:GetAttribute("Action") :: any) == "Gather" then
    GatheringService.Gather(object, equippedTool)    
  end
end





return Public