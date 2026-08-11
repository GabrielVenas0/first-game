export type Reward = {
  Cash: number?,
  ItemID: string?
}

export type Objective = {
  Type: string, -- Gather/Give/Get
  Target: string, -- Tree/Ore/Item/NPC
  -- What's happen if Target is a specific Tree like Oak Tree?
  Amount: number,

  -- Client side maybe use patterns for different objective types and replace like: {Type} {Target} {Amount}
}

export type QuestType = {
  Title: string,
  Description: string,
  NPC_ID: string,
  Prerequisites: {string},
  Objectives: {Objective},
  Rewards: Reward,
  -- Repeatable: boolean?
}

export type QuestProps = { 
  [string]: QuestType
}


local Public: QuestProps = {
  Quest_1 = {
    Title = "Learning basics",
    Description = "Gather wood and give it to Old Forge to craft a wooden pickaxe.",
    NPC_ID = "OldForger",
    Prerequisites = {},
    Objectives = {
      { Type = "Gather", Target = "Tree", Amount = 1 },
      { Type = "Give", Target = "OldForger", Amount = 1 },
      { Type = "Get", Target = "WoodenPickaxe", Amount = 1 }
      -- Maybe use only get tartget woodenpickaxe?
    },
    Rewards = {
      Cash = 50
    }
  },

  Quest_2 = {
    Title = "New generation",
    Description = "Gather wood and cobblestone and get your first set of stone tools",
    NPC_ID = "OldForger",
    Prerequisites = {"Quest_1"},
    Objectives = {
      { Type = "Get", Target = "StoneAxe", Amount = 1 },
      { Type = "Get", Target = "StonePickaxe", Amount = 1 }
    },
    Rewards = {
      ItemID = "BasicForge"
      -- Cash Reward by Tutorial
      -- that rewards logic is good at all?
    }
  }
}

return Public