export type RewardsType = {
  Cash: number?,
  ItemID: string?
}

export type QuestType = {
  NPC_ID: string,
  Prerequisites: {},
  Title: string,
  Objective: string,
  Rewards: RewardsType,
  Active: boolean,
  State: "NOT_STARTED" | "IN_PROGRESS" | "COMPLETED"
}

export type QuestProps = { 
  [string]: QuestType
}


local Public: QuestProps = {
  Quest_1 = {
    NPC_ID = "OldForger",
    Prerequisites = {},
    Title = "The voice of experience",
    Objective = "Talk to Old Forger",
    Rewards = {
      Cash = 50
    },
    Active = true,
    State = "NOT_STARTED"
  }

  -- Quest_2 = {
  --   Name = "Learning basics",
  --   NPC = "Old Forger",
  --   Quest = "Make a wooden pickaxe",
  --   Rewards = {
  --     Cash = 50
  --   },
  --   Active = true,  
  --   State = "Track"
  -- },

  -- Quest_3 = {
  --   Name = "New generation",
  --   NPC = "Old Forger",
  --   Quest = "Make your first Stone Tool",
  --   Rewards = {
  --     ItemID = "BasicForge"
  --   },
  --   Active = true,
  --   State = "Track"
  -- }
}

return Public