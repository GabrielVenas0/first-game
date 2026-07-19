--!strict
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Bindables = ServerScriptService.Bindables
local BindableManager = require(Bindables.BindableManager) 

local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local RemoteManager = require(Remotes:WaitForChild("RemoteManager"))

local InteractionEvent = BindableManager.GetEvent("InteractionEvent")
local NotificationEvent = RemoteManager.GetEvent("Notification")

local DragService = require(script.Parent.DragService)
local GatheringService = require(script.Parent.GatheringService)

local Local = {}
local Public = {}

function Public.Init()

end

function Public.Start() 
  InteractionEvent.Event:Connect(Local.OnInteraction)
end

function Local.OnInteraction(player: Player, object: BasePart)
  local Ownable = object:GetAttribute("Ownable") == true
  local pOwner = object:GetAttribute("PlayerOwner")

  local character = player.Character
  if not character then return end

  local equippedTool = character:FindFirstChildOfClass("Tool")
  if not equippedTool then
    local msg = {
      DisplayName = "You need to equipe a tool.",
      ScreenTime = 3,
      Type = "Alert"
    }

    NotificationEvent:FireClient(player, msg)
    return 
  end

  if Ownable then
    if pOwner :: number ~= nil and pOwner >= 1 and player.UserId ~= pOwner then 
      local msg = {
        DisplayName = string.format("You need to be in %d's whitelist", Players:GetNameFromUserIdAsync(pOwner)),
        ScreenTime = 4,
        Type = "Alert"
      }
  
      NotificationEvent:FireClient(player, msg)
      return
    end

    if pOwner < 0 then
      object:SetAttribute("PlayerOwner", player.UserId)
    end
  else return end

  if (object:GetAttribute("Locked") :: any) == true then return end

  if (object:GetAttribute("Action") :: any) == "Gather" then
    GatheringService.Gather(player, object, equippedTool)    
  end

  if (object:GetAttribute("Action") :: any == "Drag") then
    DragService.DragObject(player, object)
  end
end


return Public