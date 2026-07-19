--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local RemoteManager = require(Remotes:WaitForChild("RemoteManager")) 

local StartDragEvent = RemoteManager.GetEvent("StartDrag")
local StopDragEvent = RemoteManager.GetEvent("StopDrag")

local Public = {}

function Public.Init()
  StartDragEvent.OnServerEvent:Connect(function(player, worldPosition)
	end)

	StopDragEvent.OnServerEvent:Connect(function(player: Player)
		
	end)
end

function Public.Start()
end

function Public.DragObject(player: Player, object: BasePart)
  if player.UserId ~= object:GetAttribute("PlayerOwner") then return end
  if object.Anchored == true then return end

  object:SetNetworkOwner(player)
  StartDragEvent:FireClient(player, object)
end

function Public.StopDragObject(player: Player, object: BasePart)
  if object:GetNetworkOwner() == player then
    object:SetNetworkOwner(nil)
  end

  StopDragEvent:FireClient(player, object)
end

return Public
