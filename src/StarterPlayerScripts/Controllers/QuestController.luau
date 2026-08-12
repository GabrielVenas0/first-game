--!strict
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

local Remotes = ReplicatedStorage:WaitForChild("Remotes")

local UITemplates = ReplicatedStorage:WaitForChild("UITemplates")
local QuestTemplate = UITemplates:WaitForChild("Quest")

local RemoteManager = require(Remotes:WaitForChild("RemoteManager")) 

local StartQuest = RemoteManager.GetEvent("StartQuest")
local CompleteQuest = RemoteManager.GetEvent("CompleteQuest")


local MainHUD = PlayerGui:WaitForChild("MainHUD")
local QuestFrame = MainHUD:WaitForChild("QuestFrame")
local CloseableGroup = QuestFrame:WaitForChild("CloseableGroup")
local QuestList = CloseableGroup:WaitForChild("QuestList")


local Local = {}
local Public = {}


function Public.Init()
  
end

function Public.Start()
  StartQuest.OnClientEvent:Connect(Local.ActiveQuestUI)
  CompleteQuest.OnClientEvent:Connect(Public.CompleteQuest)
end

function Public.CompleteQuest(questId)
  for _, v in pairs(QuestList:GetChildren()) do
    if v.Name == questId then
      v:Destroy()
    end
  end
end

function Local.ActiveQuestUI(questId: string, q: {Title: string, Rewards: {}, Objectives: {}})
  local newQuest = QuestTemplate:Clone()
  newQuest.Name = questId

  local QuestName = newQuest:WaitForChild("QuestName")
  local QuestInfo = newQuest:WaitForChild("QuestInfo")

  local RewardsLabel = QuestInfo:WaitForChild("Rewards")
  local QuestSpec = QuestInfo:WaitForChild("QuestSpec")

  local QuestDesc = QuestSpec:WaitForChild("TextLabel")
  local ProgressBar = QuestSpec:WaitForChild("ProgressBar")

  QuestName.Text = q.Title
  RewardsLabel.Text = "Rewards: " .. q.Rewards["Cash"]

  QuestDesc.Text = q.Objectives

  newQuest.Parent = QuestList
end

return Public