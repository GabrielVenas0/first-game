--!strict
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

local Remotes = ReplicatedStorage:WaitForChild("Remotes")

local UITemplates = ReplicatedStorage:WaitForChild("UITemplates")
local QuestTemplate = UITemplates:WaitForChild("Quest")
local QuestSpecTemplate = UITemplates:WaitForChild("QuestSpec")

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

function Local.ActiveQuestUI(questId: string, q: {Title: string, Description: string, Rewards: {}, Objectives: {}})
  local newQuest = QuestTemplate:Clone()
  local QuestSpec = QuestSpecTemplate:Clone() 
  newQuest.Name = questId

  local QuestName = newQuest:WaitForChild("QuestName")
  local QuestInfo = newQuest:WaitForChild("QuestInfo")

  local Description = QuestInfo:WaitForChild("Description")
  local Rewards = QuestInfo:WaitForChild("Rewards")

  QuestName.Text = q.Title
  Description.Text = q.Description

  local rewards = {}

  for rewardName: string, rewardValue in pairs(q.Rewards) do
    table.insert(rewards, rewardName .. ": " .. tostring(rewardValue))
  end

  for objectiveIndex, objectiveValue: {Type: string, Target: string, Amount: number} in ipairs(q.Objectives) do
    local questSpec = QuestSpec:Clone()

    local Objective = questSpec:WaitForChild("Objective")
    Objective.Text = objectiveValue.Type .. objectiveValue.Target .. " 0/" .. tostring(objectiveValue.Amount)

    questSpec.Parent = QuestInfo
  end

  Rewards.Text = "Rewards: " .. table.concat(rewards, ", ")

  newQuest.Parent = QuestList
end

return Public