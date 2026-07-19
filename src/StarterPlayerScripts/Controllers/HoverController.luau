--!strict
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

local UITemplates = ReplicatedStorage:WaitForChild("UITemplates")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")

local HighlightTemplate = UITemplates:WaitForChild("Highlight") :: Highlight

local GameUtils = require(ReplicatedStorage.Configs.GameUtils)
local RemoteManager = require(Remotes:WaitForChild("RemoteManager")) 

local startHoverEvent = RemoteManager.GetEvent("startHover")
local endHoverEvent = RemoteManager.GetEvent("endHover")

local Local = {}
local Public = {}

function Public.Init()

end

function Public.Start()
  startHoverEvent.OnClientEvent:Connect(Local.startHover)
  endHoverEvent.OnClientEvent:Connect(Local.endHover)
end

function Local.startHover(object: BasePart)
  local nodeProps = GameUtils.getNodeProperties(object:GetAttribute("ID") :: string)
  if not nodeProps then return end

  local mainHUD = PlayerGui:WaitForChild("MainHUD")
  local HoverFrame = mainHUD:WaitForChild("HoverFrame") :: Frame

  local Name = HoverFrame:WaitForChild("Name") :: TextLabel
  Name.Text = nodeProps.DisplayName
  
  local Info = HoverFrame:WaitForChild("Info") :: TextLabel
  Info.Text = string.format("You need a %d tool", nodeProps.RequiredToolPower)

  HoverFrame.Visible = true
  local highlight = HighlightTemplate:Clone()
  highlight.Adornee = object
  highlight.Parent = object
end

function Local.endHover(object: BasePart)
  local mainHUD = PlayerGui:WaitForChild("MainHUD")
  local HoverFrame = mainHUD:WaitForChild("HoverFrame") :: Frame

  HoverFrame.Visible = false

  local highlight = object:FindFirstChildOfClass("Highlight") :: Highlight
  highlight:Destroy()
end

return Public