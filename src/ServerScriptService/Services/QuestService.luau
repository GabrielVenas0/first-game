--!strict
local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")


local DataStoreManager = require(script.Parent.DataStoreManager)
local QuestsDefinitions = require(ReplicatedStorage:WaitForChild("Configs"):WaitForChild("QuestsDefinitions"))

local Bindables = ServerScriptService.Bindables
local Remotes = ReplicatedStorage:WaitForChild("Remotes")


local _BindableManager = require(Bindables.BindableManager) 
local RemoteManager = require(Remotes:WaitForChild("RemoteManager")) 

local StartQuest = RemoteManager.GetEvent("StartQuest")
local CompleteQuest = RemoteManager.GetEvent("CompleteQuest")

local Local = {}
local Public = {}

function Public.Init()
  Players.PlayerAdded:Connect(Public.LoadQuests)
end

function Public.Start()
  StartQuest.OnServerEvent:Connect(Public.OnQuestAccepted)
  CompleteQuest.OnServerEvent:Connect(Public.OnQuestCompleted)
end

function Local.hasCompleted(player: Player, questId: string): boolean
  local data = DataStoreManager.GetData(player)
  if not data then return false end

  return data.CompletedQuests[questId] == true or false
end

function Public.LoadQuests(player: Player)
  task.wait(4)
  local data = DataStoreManager.GetData(player)
  if not data then return end

  for questId, _ in pairs(data.ActiveQuests) do
    StartQuest:FireClient(player, questId, QuestsDefinitions[questId])
  end
end

function Public.GetQuestState(player: Player, questId: string): string
  local data = DataStoreManager.GetData(player)
  if not data then return "NOT_STARTED" end

  if data.CompletedQuests[questId] then
    return "COMPLETED"
  elseif data.ActiveQuests[questId] then
    return "IN_PROGRESS"
  end
  return "NOT_STARTED"
end

function Public.CanAcceptQuest(player: Player, questId: string): boolean
  local config = QuestsDefinitions[questId]
  if not config then return false end

  if Public.GetQuestState(player, questId) ~= "NOT_STARTED" then 
    -- NOTIFICATION ALERT
    return false
  end

  local toClient = {

  }

  StartQuest:FireClient(player, questId, toClient)

  if config.Prerequisites then
    for _, prereqID in ipairs(config.Prerequisites) do
      if Local.hasCompleted then
        return false
      end
    end
  end
  
  return true
end

function Public.GetAvaliableQuestForNPC(player: Player, NPCID: string)
  for questId, config in pairs(QuestsDefinitions) do
    if config.NPC_ID ~= NPCID and not Public.CanAcceptQuest(player, questId) then return end

    return questId
  end
end

function Public.OnQuestAccepted(player: Player, questId: string)
  Public.CanAcceptQuest(player, questId)

  local data = DataStoreManager.GetData(player)
  if not data then return end

  data.ActiveQuests[questId] = 0
end

function Public.OnQuestCompleted(player: Player, questId: string)
  local data = DataStoreManager.GetData(player)
  if not data then return end

  if not data.ActiveQuests[questId] then return end

  data.CompletedQuests[questId] = 0
  data.ActiveQuests[questId] = nil

  CompleteQuest:FireClient(player, questId)
  -- if Public.GetQuestState(player, questId) ~= "COMPLETED" then return end
end

return Public