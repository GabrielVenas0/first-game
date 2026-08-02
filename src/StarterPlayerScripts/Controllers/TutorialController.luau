--!strict
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Remotes = ReplicatedStorage:WaitForChild("Remotes")

local RemoteManager = require(Remotes:WaitForChild("RemoteManager")) 

local StartTutorial = RemoteManager.GetEvent("StartTutorial")
local EndTutorial = RemoteManager.GetEvent("EndTutorial")

local Local = {}
local Public = {}

function Public.Init()

end

function Public.Start()
  StartTutorial.OnClientEvent:Connect(Local.StartTutorial)
end

function Local.StartTutorial()  
  local player = Players.LocalPlayer
  print('sdjfgnsdjfgnsdjfnjs ' .. player.Name)

  EndTutorial:FireServer()
end

return Public