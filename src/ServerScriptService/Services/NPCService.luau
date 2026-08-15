--!strict
local CollectionService = game:GetService("CollectionService")
local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")


local Bindables = ServerScriptService.Bindables
local Remotes = ReplicatedStorage:WaitForChild("Remotes")

local QuestService: ModuleScript
local _BindableManager = require(Bindables.BindableManager) 
local RemoteManager = require(Remotes:WaitForChild("RemoteManager")) 
local DialogDefinitions = require(ReplicatedStorage.Configs.DialogDefinitions)

local StartTalkEvent = RemoteManager.GetEvent("StartTalkEvent")
local StartQuestTalk = RemoteManager.GetEvent("StartQuestTalk")

local _Local = {}
local Public = {}

local TAG_NAME = "NPC"

local NPCS = CollectionService:GetTagged(TAG_NAME)

function Public.Init()
end

function Public.Start()
end

function Public.StartTalk(player: Player, NPC: BasePart)
  local NPC_ID = NPC:GetAttribute("NPC_ID") :: string
  local QuestService = require(script.Parent.QuestService)

  local questId = QuestService.GetAvaliableQuestForNPC(player, NPC_ID)
  if questId then
    StartQuestTalk:FireClient(player, questId, NPC)
    return
  end

  StartTalkEvent:FireClient(player, NPC)
end

return Public