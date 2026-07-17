--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer 
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui") :: PlayerGui

local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local RemoteManager = require(Remotes:WaitForChild("RemoteManager"))

local NotificationEvent = RemoteManager.GetEvent("Notification")


local _Local = {}
local Public = {}

function Public.Init()
  
end

function Public.Start()
  NotificationEvent.OnClientEvent:Connect(Public.FireNotification)
end

export type notificationProperties = {
  DisplayName: string,
  ScreenTime: number,
  Type: "Alert" | "Popup",
  Position: Vector3?
}

function Public.FireNotification(n: notificationProperties)
  local NotificationUI = PlayerGui:WaitForChild("NotificationUI") :: ScreenGui
  local Frame = NotificationUI:WaitForChild("Frame") :: Frame
  local TextLabel = Frame:WaitForChild("TextLabel") :: TextLabel

  if n.Type == "Alert" then
    TextLabel.Text = n.DisplayName
    NotificationUI.Enabled = true
    
    task.delay(n.ScreenTime, function()
      NotificationUI.Enabled = false
    end)
  end

  if n.Type == "Popup" then
    if not n.Position then return end
    -- TO DO
  end
end



return Public