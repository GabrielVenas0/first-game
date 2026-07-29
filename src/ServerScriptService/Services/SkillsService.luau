--!strict
local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local DataStoreManager = require(script.Parent.DataStoreManager)

local Bindables = ServerScriptService.Bindables
local Remotes = ReplicatedStorage:WaitForChild("Remotes")


local _BindableManager = require(Bindables.BindableManager) 
local RemoteManager = require(Remotes:WaitForChild("RemoteManager")) 

local NotificationEvent = RemoteManager.GetEvent("Notification")

local DEFAULT_XP_GAIN = 2

local _Local = {}
local Public = {}

function Public.Init()

end

function Public.Start()
  
end

function Public.GiveXP(player: Player, class: string)
  local data = DataStoreManager.GetData(player)
  if not data then return end

  local currentClassXp = data.Skills[class] :: number
  local newClassXp = currentClassXp + DEFAULT_XP_GAIN -- in v2 XP BUFFED BY OBJECT SIZE, OBJECT TIER
  data.Skills[class] = newClassXp

  local notification = {
    DisplayName = tostring('Gained ' .. class .. ' ' ..  newClassXp .. ' Exp '),
    ScreenTime = 4, -- ScreenTime most be determinated by Type
    Type = "Alert" -- Need other type
  }

  NotificationEvent:FireClient(player, notification)
end

return Public