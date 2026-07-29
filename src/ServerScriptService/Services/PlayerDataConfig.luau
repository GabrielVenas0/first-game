--!strict
local Public = {}

Public.DEFAULT_PLAYER_DATA = {
  leaderstats = {
    Cash = 0
  },
  Skills = {
    Lumber = 0,
    Miner = 0
  },
  Quests = {

  },
  completedTutorial = false
  -- Everthing in Player's Plot
  -- Inventory
  -- GamePasses
  -- ...
}

export type PlayerData = typeof(Public.DEFAULT_PLAYER_DATA)

return Public
