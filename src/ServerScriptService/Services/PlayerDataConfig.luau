--!strict
local Public = {}

Public.DEFAULT_PLAYER_DATA = {
  leaderstats = {
    Cash = 0
  },
  -- Skills
  -- Items/Builds
  -- Tools
  -- Inventory
  -- GamePasses
  -- ...
}

export type PlayerData = typeof(Public.DEFAULT_PLAYER_DATA)

return Public
