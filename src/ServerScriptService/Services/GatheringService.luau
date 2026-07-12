--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Configs = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Configs")
local Utils = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Utils")
local Events = ReplicatedStorage:WaitForChild("Events")

local GameConfig = require(Configs.GameConfig)

local NORMAL_DAMAGE = 10
local COEF_DAMAGE = 0.25

local Local = {}
local Public = {}

function Public.Init()

end

function Public.Start()
  
end

function Local.CalcuteDamage(node: GameConfig.NodeProperties, tool: GameConfig.ToolProperties)
  local damage: number
  local newHealth: number

  damage = NORMAL_DAMAGE * (1 + COEF_DAMAGE)^tool.Power
  -- In future I will add:
  -- Enchantments
  -- Buffs ( Premium Players, Group Players, Gamepasses, F2P things )
  -- Special stats by forging
  -- Skill Level Rewards
  -- More or less? I will think about it later 

  if node.Health < damage then
    newHealth = 0
    Local.loot(node)
  end

  newHealth = node.Health - damage
  -- Maybe add NodeResistance or that's to much?

  return newHealth
end

function Local.loot(node)

end

function Public.Gather(node, tool)
  local toolId = tool:GetAttribute("ID") :: string
  local nodeId = node:GetAttributes("ID") :: string

  local toolProps = GameConfig.Tools.Axes[toolId]
  local nodeProps = GameConfig.Nodes.Trees[nodeId]

  if (toolProps.Power :: number) < nodeProps.RequiredToolPower then return end

  nodeProps.Health = Local.CalcuteDamage(nodeProps, toolProps)
end





return Public