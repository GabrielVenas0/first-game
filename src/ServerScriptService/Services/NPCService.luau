--!strict
local CollectionService = game:GetService("CollectionService")
local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")


local Bindables = ServerScriptService.Bindables
local Remotes = ReplicatedStorage:WaitForChild("Remotes")


local QuestService = require(script.Parent.QuestService)
local _BindableManager = require(Bindables.BindableManager) 
local RemoteManager = require(Remotes:WaitForChild("RemoteManager")) 
local DialogDefinitions = require(ReplicatedStorage.Configs.DialogDefinitions)

local StartTalkEvent = RemoteManager.GetEvent("StartTalkEvent")
local StartQuest = RemoteManager.GetEvent("StartQuest")

local _Local = {}
local Public = {}

local TAG_NAME = "NPC"

local NPCS = CollectionService:GetTagged(TAG_NAME)

function Public.Init()

end

function Public.Start()

end

function Public.StartTalk(player: Player, object: BasePart)
  StartTalkEvent:FireClient(player, object)
end

return Public