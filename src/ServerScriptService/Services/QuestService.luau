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
local ProgressQuest = RemoteManager.GetEvent("ProgressQuest")

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

function Local.alreadyHave(player: Player, questId: string): boolean
  local data = DataStoreManager.GetData(player)
  if not data then return false end

  return data.ActiveQuests[questId] == true or false
end

function Public.LoadQuests(player: Player)
  task.wait(4)
  local data = DataStoreManager.GetData(player)
  if not data then return end

  for questId, _ in pairs(data.ActiveQuests) do
    StartQuest:FireClient(player, questId, QuestsDefinitions[questId])
  end
end


function Local.canAcceptQuest(player: Player, questId: string): boolean
  local config = QuestsDefinitions[questId]
  if not config then return false end

  if Local.hasCompleted(player, questId) or Local.alreadyHave(player, questId) then return false end

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


function Public.trackQuestProgress(player: Player, node: BasePart)
  local data = DataStoreManager.GetData(player)
  if not data then return end

  local list = data.ActiveRequirements[node] :: {{current: number, target: number}}
  if list then
    for _, req in ipairs(list) do
      req.current += 1
      ProgressQuest:FireClient(player, req)
    end
  end
end


function Public.GetAvaliableQuestForNPC(player: Player, NPCID: string)
  local avaliableQuest: string

  for questId, config in pairs(QuestsDefinitions) do
    if config.NPC_ID == NPCID and Local.canAcceptQuest(player, questId) then 
      avaliableQuest = questId
      continue
    end
  end

  return avaliableQuest
end


function Public.OnQuestAccepted(player: Player, questId: string)
  local data = DataStoreManager.GetData(player)
  if not data then return end

  data.ActiveQuests[questId] = true

  local activeObj = data.ActiveObjectives :: {}
  
  local config = QuestsDefinitions[questId]
	if config and config.Objectives then
		for _, reqConfig in ipairs(config.Objectives) do
			local targetPart = reqConfig.Target
      
			if targetPart then
        if not activeObj[targetPart] then
          activeObj[targetPart] = {}
        end

				activeObj[targetPart][questId] = {
          type = reqConfig.Type,
					current = 0,
					target = reqConfig.Amount
        } 
			end
		end
	end

  Public.LoadQuests(player)
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