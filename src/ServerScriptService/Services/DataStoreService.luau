--!strict
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ServerScriptService = game:GetService("ServerScriptService")

local ProfileStore = require(ServerScriptService.Packages.ProfileStore) 
local ProfileConfig = require(script.Parent.PlayerDataConfig)

local DATA_STORE_KEY = 'Tycoon_1'
if RunService:IsStudio() then
  DATA_STORE_KEY = 'development'
end

local PlayerStore = ProfileStore.New(DATA_STORE_KEY,ProfileConfig.DEFAULT_PLAYER_DATA)

local Local = {}
local Public = {}

local Profiles = {} :: ProfileStore.Profile<ProfileConfig.PlayerData>

function Public.Init()
  Players.PlayerAdded:Connect(Local.LoadProfile)
  Players.PlayerRemoving:Connect(Local.RemoveProfile)
end

function Public.Start()
  for _, player in Players:GetPlayers() do
		task.spawn(Local.LoadProfile, player)
	end
end

function Local.CreateLeaderstats(player: Player)
  local profile = Profiles[player]
  if not profile then return end

  local data = profile.Data
  if not data then return end

  local leaderstats = Instance.new("Folder")
  leaderstats.Name = "leaderstats"

  local cash = Instance.new("NumberValue")
  cash.Name = "Cash"
  cash.Value = data.leaderstats.Cash
  cash.Parent = leaderstats
  
  leaderstats.Parent = player
end

function Local.LoadProfile(player: Player)
  local profile = PlayerStore:StartSessionAsync(`Player_{player.UserId}`, {
    Cancel = function()
      return player.Parent ~= Players
    end
  })

  if profile == nil then
    return player:Kick('Profile failed to load. Please rejoin.')
  end

  profile:AddUserId(player.UserId)
  profile:Reconcile()

  profile.OnSessionEnd:Connect(function()
    Profiles[player] = nil
    player:Kick('Profile session ended. Please rejoin.')
  end)

  local isActive = player.Parent == Players
  if isActive then
    Profiles[player] = profile
  else
    profile:EndSession()
  end
  
  Local.CreateLeaderstats(player)

  if RunService:IsStudio() then
    print(Profiles[player].Data)
  end
end

function Local.RemoveProfile(player: Player)
  local profile = Profiles[player]
  if profile then
    profile:EndSession()
  end
end

function Public.GetData(player: Player)
  local profile = Profiles[player]
  if not profile then return end

  return profile.Data
end

return Public