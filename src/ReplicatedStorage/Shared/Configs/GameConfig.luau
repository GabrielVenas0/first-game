--!strict
export type ToolProperties = {
  DisplayName: string,
  Power: number,
  Speed: number,
}

export type NodeProperties = {
  DisplayName: string,
  MaxHealth: number,
  Health: number,
  RequiredToolPower: number,
  RegenTime: number, -- I interact with this node and become Owner, after X owner = -1
  RawDropId: string
}

export type ItemProperties = {
  DisplayName: string,
  Type: "RawTree" | "RawOre" | "RefinedWood" | "RefinedOre",
  BaseValue: number, -- Value = BaseValue * NodeSize
  -- Size: number, Really dont know, MinSize and MaxSize or only Size? Size is buffed by something?
  CanTrade: boolean?,
  CanBuild: boolean?,
  CanForge: boolean,

  -- I don't know what this will be and don't know if I will implement this or not.
  RefineRecipe: {
    ResultItemId: string,
    Refiner: {
      RefinerType: string,
      RefinerLevel: number
    }
  }?
}

export type ConfigType = {
  Tools: {
    Axes: { [string]: ToolProperties },
    Pickaxes: { [string]: ToolProperties }
  },

  Nodes: {
    Trees: { [string]: NodeProperties },
    Ores: { [string]: NodeProperties }
  },
  
  Items: { [string]: ItemProperties }
}

local Public: ConfigType = {
  Tools = {
    Axes = {
      RustyAxe = {
        DisplayName = "Rusty Axe",
        Power = 1,
        Speed = 2
      }
    },

    Pickaxes = {
      RustyPickaxe = {
        DisplayName = "Rusty Pickaxe",
        Power = 1,
        Speed = 2
      }
    }
  },

  Nodes = {
    Trees = {
      Oak = {
        DisplayName = "Oak Tree",
        MaxHealth = 100,
        Health = 100,
        RequiredToolPower = 1,
        RegenTime = 10,
        RawDropId = "OakLog"
      }
    },

    Ores = {
      Stone = {
        DisplayName = "Stone",
        MaxHealth = 100,
        Health = 100,
        RequiredToolPower = 1,
        RegenTime = 10,
        RawDropId = "Cobblestone"
      }
    }
  },

  Items = {
    OakLog = {
      DisplayName = "Oak Log",
      Type = "RawTree",
      BaseValue = 5,
      CanForge = false,
      RefineRecipe = {
        ResultItemId = "OakPlank",
        Refiner = {
          RefinerType = "TreeRefiner",
          RefinerLevel = 1
        }
      }
    },

    OakPlank = {
      DisplayName = "Oak Plank",
      Type = "RefinedWood",
      BaseValue = 10,
      CanForge = true
    },

    Cobblestone = {
      DisplayName = "Cobblestone",
      Type = "RawOre",
      BaseValue = 8,
      CanForge = true,
      RefineRecipe = {
        ResultItemId = "Stone",
        Refiner = {
          RefinerType = "OreRefiner",
          RefinerLevel = 1
        }
      }
    },

    Stone = {
      DisplayName = "Stone",
      Type = "RefinedOre",
      BaseValue = 16,
      CanForge = false,
    },
  },
}

return Public