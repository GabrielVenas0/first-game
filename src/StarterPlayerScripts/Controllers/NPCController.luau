--!strict
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")


local Remotes = ReplicatedStorage.Remotes
local UITemplates = ReplicatedStorage.UITemplates

local Option = UITemplates:WaitForChild("Option")

local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")


local MainHUD = PlayerGui:WaitForChild("MainHUD")
local OptionsGui = MainHUD:WaitForChild("OptionsGui")
local NPCTalkGui = MainHUD:WaitForChild("NPCTalkGui")


local RemoteManager = require(Remotes.RemoteManager) 
local DialogDefinitions = require(ReplicatedStorage.Configs.DialogDefinitions)


local StartTalkEvent = RemoteManager.GetEvent("StartTalkEvent")
local StartQuestTalk = RemoteManager.GetEvent("StartQuestTalk")
local StartQuestEvent = RemoteManager.GetEvent("StartQuest")

local buttonConnections = {}

local Local = {}
local Public = {}

function Public.Init()

end

function Public.Start()
  StartTalkEvent.OnClientEvent:Connect(Local.NPCDialog)
  StartQuestTalk.OnClientEvent:Connect(Local.QuestDialog)
end

function Local.renderPage(pages: {}, pageIndex: number, questId: string)

  local page = pages[pageIndex]
  if not page then return end

  NPCTalkGui:WaitForChild("TextLabel").Text = page.Text

  for _, connection in ipairs(buttonConnections) do
    connection:Disconnect()
  end
  table.clear(buttonConnections)

  for _, child in ipairs(OptionsGui:GetChildren()) do
		if child:IsA("TextButton") then
			child:Destroy()
		end
	end

  for optionIndex, optionText in ipairs(page.Options) do
    local opt = Option:Clone()
    local IndexLabel = opt:WaitForChild("Index")
    IndexLabel.Text = optionIndex
    local OptionLabel = opt:WaitForChild("Option")
    OptionLabel.Text = optionText
    opt.Parent = OptionsGui

    local conn = opt.MouseButton1Click:Connect(function()
      if optionText == "Continue" then
        Local.renderPage(pages, pageIndex + 1, questId)
    
      elseif optionText == "Accept Quest" then
        StartQuestEvent:FireServer(questId)
        pageIndex = 3
        Local.renderPage(pages, pageIndex, questId)
    
      elseif optionText == "Nevermind" then
        pageIndex = 4
        Local.renderPage(pages, pageIndex, questId)
    
      elseif optionText == "Bye" then
        NPCTalkGui.Enabled = false
        OptionsGui.Enabled = false
      end
    end)
      
    table.insert(buttonConnections, conn)
  end
end

function Local.QuestDialog(questId: string, object: BasePart)
  local def = DialogDefinitions.withQuest[questId]
  if not def then return end

  local pages = def.Pages

  NPCTalkGui.Enabled = true
  NPCTalkGui.Adornee = object:WaitForChild("Head")
  
  OptionsGui.Enabled = true
  OptionsGui.Adornee = player.Character:WaitForChild("Head")

  Local.renderPage(pages, 1, questId)
end

function Local.NPCDialog(object: BasePart)
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