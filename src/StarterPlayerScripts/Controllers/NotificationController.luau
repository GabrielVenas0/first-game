--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer 
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui") :: PlayerGui

local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local UITemplates = ReplicatedStorage:WaitForChild("UITemplates")

local RemoteManager = require(Remotes:WaitForChild("RemoteManager"))

local NotificationEvent = RemoteManager.GetEvent("Notification")
local AlertFrame = UITemplates:WaitForChild("AlertFrame")
local PopupUI = UITemplates:WaitForChild("PopupUI")


local Local = {}
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
  Object: BasePart?
}

function Local.randomLocation()
  local gen = Random.new()

  local randomX = gen:NextNumber(0,4) - 3
  if randomX >= -1 then
    randomX = randomX + 2
  end
  local randomY= gen:NextNumber(0,4) - 3
  if randomY >= -1 then
    randomY = randomY + 2
  end

  -- randomZ value be handle by Position Z Value of Object Pivot or Location where player hit in GatheringMinigame
  local randomZ = gen:NextNumber(-4,4)

  return Vector3.new(randomX, randomY, randomZ)
end

function Public.FireNotification(n: notificationProperties)
  local NotificationUI = PlayerGui:WaitForChild("NotificationUI") :: ScreenGui
  local AlertList = NotificationUI:WaitForChild("AlertList") :: Frame

  -- In future maybe I do a stackable alert. Like if two alerts have the same DisplayName that will show "DisplayName (x2)" in one frame not create other frame
  -- AlertList have a 3 Alerts limit. I need to create a FIFO here
  if #AlertList:GetChildren() > 3 then return end

  if n.Type == "Alert" then
    local alert = AlertFrame:Clone()
    local targetSize = AlertFrame.Size
    local startSize = targetSize - UDim2.new(0.05, 0, 0.05, 0)

    alert.Size = startSize

    local alertText = alert:WaitForChild("TextLabel") :: TextLabel
    alertText.Text = n.DisplayName
    
    alert.Parent = AlertList
    NotificationUI.Enabled = true

    local openTween = TweenService:Create(alert, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = targetSize})
    openTween:Play()

    task.delay(n.ScreenTime, function()
      if not alert and alert.Parent then return end
      
      local closeTween = TweenService:Create(alert, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = startSize})
      closeTween:Play()
      closeTween.Completed:Wait()

      alert:Destroy()

      if #AlertList:GetChildren() == 1 then
        NotificationUI.Enabled = false
      end
    end)

  end

  if n.Type == "Popup" then
    if not n.Object then return end

    -- Same thing of Alert, I need to implement a Limit and a FIFO system

    local popupUI = PopupUI:Clone()
    popupUI.Adornee = n.Object

    local popupText = popupUI:WaitForChild("TextLabel") :: TextLabel
    popupText.Text = n.DisplayName

    popupUI.StudsOffset = Local.randomLocation()

    popupUI.Parent = PlayerGui

    task.delay(n.ScreenTime, function()
      popupUI:Destroy()
    end)
  end
end



return Public