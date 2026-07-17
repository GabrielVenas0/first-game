--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local RemoteManager = require(Remotes:WaitForChild("RemoteManager")) 

local DragStartEvent = RemoteManager.GetEvent("DragStart")

local Public = {}

function Public.Init()
  DragStartEvent.OnServerEvent:Connect(function(player, worldPosition)
    print(player.Name, worldPosition)
  end)
end

function Public.Start()
end

function Public.DragObject(player: Player, object: BasePart)
  if player.UserId ~= object:GetAttribute("PlayerOwner") then return end
  if object.Anchored == true then return end

  object:SetNetworkOwner(player)
  DragStartEvent:FireClient(player, object)
end

return Public
