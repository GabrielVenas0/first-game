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


function Local.getQuestState(player: Player, questId: string): string
  local data = DataStoreManager.GetData(player)
  if not data then return "NOT_STARTED" end

  if data.CompletedQuests[questId] then
    return "COMPLETED"
  elseif data.ActiveQuests[questId] then
    return "IN_PROGRESS"
  end
  return "NOT_STARTED"
end


function Local.canAcceptQuest(player: Player, questId: string): boolean
  local config = QuestsDefinitions[questId]
  if not config then return false end

  if Local.hasCompleted(player, questId) then
    return false
  end

  if Local.getQuestState(player, questId) ~= "NOT_STARTED" then 
    -- NOTIFICATION ALERT
    return false
  end

  if not config.Prerequisites or next(config.Prerequisites) == nil then return true end

  local prereqAmount = #config.Prerequisites
  local completedCount = 0

  for _, prereqID in ipairs(config.Prerequisites) do
    if Local.hasCompleted(player, prereqID) then
      completedCount += 1
    end

    if prereqAmount <= completedCount then
      return true
    end
  end
  
  return false
end


function Local.trackQuestProgress()

end


function Public.GetAvaliableQuestForNPC(player: Player, NPCID: string)
  local avaliableQuests = {}

  for questId, config in pairs(QuestsDefinitions) do
    if config.NPC_ID == NPCID and Local.canAcceptQuest(player, questId) then 
      avaliableQuests[questId] = true
      continue
    end
  end

  return avaliableQuests
end


function Public.OnQuestAccepted(player: Player, questId: string)
  if not Local.canAcceptQuest(player, questId) then return end

  local data = DataStoreManager.GetData(player)
  if not data then return end

  data.ActiveQuests[questId] = false
end


function Public.OnQuestCompleted(player: Player, questId: string)
  local data = DataStoreManager.GetData(player)
  if not data then return end

  if not data.ActiveQuests[questId] then return end

  data.CompletedQuests[questId] = true
  data.ActiveQuests[questId] = nil

  CompleteQuest:FireClient(player, questId)
  -- if Public.GetQuestState(player, questId) ~= "COMPLETED" then return end
end

return Public