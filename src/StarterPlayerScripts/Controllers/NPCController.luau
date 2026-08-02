--!strict
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")


local Remotes = ReplicatedStorage.Remotes
local UITemplates = ReplicatedStorage.UITemplates


local TalkGui = UITemplates.TalkGui
local NPCTalkGui = UITemplates.NPCTalkGui

local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")


local MainHUD = PlayerGui:WaitForChild("MainHUD")


local RemoteManager = require(Remotes.RemoteManager) 
local DialogDefinitions = require(ReplicatedStorage.Configs.DialogDefinitions)


local StartTalkEvent = RemoteManager.GetEvent("StartTalkEvent")
local StartQuestEvent = RemoteManager.GetEvent("StartQuest")
local CompleteQuest = RemoteManager.GetEvent("CompleteQuest")



local _Local = {}
local Public = {}

function Public.Init()

end

function Public.Start()
  StartTalkEvent.OnClientEvent:Connect(Public.NPCDialog)
end

function Public.QuestDialog(questId: string, object: BasePart)
  local dialogs = DialogDefinitions.withQuest[questId].Dialogs
  local options = DialogDefinitions.withQuest[questId].Options

  local npcTalk = NPCTalkGui:Clone()
  npcTalk.Adornee = object:WaitForChild("Head")
  
  local playerTalk = TalkGui:Clone()
  playerTalk.Adornee = player.Character:WaitForChild("Head")

  npcTalk.Parent = MainHUD
  playerTalk.Parent = MainHUD
end

function Public.NPCDialog(object: BasePart)
  local NPC_ID = object:GetAttribute("NPC_ID")

  local dialogs = DialogDefinitions.withoutQuest[NPC_ID].Dialogs
  local randomIndex = math.random(1, #dialogs)

  local npcTalk = NPCTalkGui:Clone()
  npcTalk.Adornee = object:WaitForChild("Head")

  npcTalk.TextLabel.Text = dialogs[randomIndex]
  npcTalk.Parent = MainHUD

  task.wait(3)
  npcTalk:Destroy()
end

return Public