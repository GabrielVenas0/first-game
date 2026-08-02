--!strict
local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local DataStoreManager = require(ServerScriptService.Services.DataStoreManager)

local Remotes = ReplicatedStorage:WaitForChild("Remotes")

local RemoteManager = require(Remotes:WaitForChild("RemoteManager")) 

local StartTutorial = RemoteManager.GetEvent("StartTutorial")
local EndTutorial = RemoteManager.GetEvent("EndTutorial")

local Local = {}
local Public = {}

function Public.Init()
  Players.PlayerAdded:Connect(Local.NeedTutorial)
  EndTutorial.OnServerEvent:Connect(Local.TutorialCompleted)
end

function Public.Start()
end

function Local.NeedTutorial(player: Player)
  task.wait(4)
  local data = DataStoreManager.GetData(player)
  if not data then return end

  if data.completedTutorial == false then
    StartTutorial:FireClient(player)
  end
end

function Local.TutorialCompleted(player: Player)
  local data = DataStoreManager.GetData(player)
  if not data then return end

  data.completedTutorial = true
end


return Public