--!strict
export type ToolProperties = {
	DisplayName: string,
	Type: "Axe" | "Pickaxe",
	Power: number,
	Speed: number,
}

export type NodeProperties = {
	DisplayName: string,
	Type: "Tree" | "Ore",
	MaxHealth: number,
	Health: number,
	RequiredToolPower: number,
	RegenTime: number,
	RawDropId: string,
	-- MinSize: number,
	-- MaxSize: number,
}

export type RefineRecipe = {
	ResultItemId: string,
	Refiner: {
		RefinerType: string,
		RefinerLevel: number,
	},
}

export type ItemProperties = {
	DisplayName: string,
	Type: "RawTree" | "RawOre" | "RefinedWood" | "RefinedOre",
	BaseValue: number,
	CanTrade: boolean?,
	CanBuild: boolean?,
	CanForge: boolean,
	RefineRecipe: RefineRecipe?,
}

export type ConfigType = {
	Tools: {
		Axes: { [string]: ToolProperties },
		Pickaxes: { [string]: ToolProperties },
	},
	Nodes: {
		Trees: { [string]: NodeProperties },
		Ores: { [string]: NodeProperties },
	},
	Items: { [string]: ItemProperties },
}

local Public: ConfigType = {
	Tools = {
		Axes = {
			RustyAxe = {
				DisplayName = "Rusty Axe",
				Type = "Axe",
				Power = 1,
				Speed = 2,
			},
		},
		Pickaxes = {
			RustyPickaxe = {
				DisplayName = "Rusty Pickaxe",
				Type = "Pickaxe",
				Power = 1,
				Speed = 2,
			},
		},
	},

	Nodes = {
		Trees = {
			Oak = {
				DisplayName = "Oak Tree",
				Type = "Tree",
				MaxHealth = 100,
				Health = 100,
				RequiredToolPower = 1,
				RegenTime = 10,
				RawDropId = "OakLog",
				MinSize = 0.8,
				MaxSize = 1.5,
			},
		},
		Ores = {
			Stone = {
				DisplayName = "Stone",
				Type = "Ore",
				MaxHealth = 100,
				Health = 100,
				RequiredToolPower = 1,
				RegenTime = 10,
				RawDropId = "Cobblestone",
				MinSize = 0.5,
				MaxSize = 1.2,
			},
		},
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
					RefinerLevel = 1,
				},
			},
		},
		OakPlank = {
			DisplayName = "Oak Plank",
			Type = "RefinedWood",
			BaseValue = 10,
			CanForge = true,
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
					RefinerLevel = 1,
				},
			},
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