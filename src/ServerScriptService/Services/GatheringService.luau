--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Configs = ReplicatedStorage:WaitForChild("Configs")

local GameConfig = require(Configs.GameConfig)
local DropService = require(script.Parent.DropService)

local NORMAL_DAMAGE = 10
local COEF_DAMAGE = 0.25

local Local = {}
local Public = {}

function Public.Init()

end

function Public.Start()
  
end

-- deveria colocar essa function no GameConfig.luau
function Local.getToolProperties(toolId: string): GameConfig.ToolProperties?
  local toolProps = GameConfig.Tools.Axes[toolId]
  if toolProps then return toolProps end

  toolProps = GameConfig.Tools.Pickaxes[toolId]
  if toolProps then return toolProps end

  return nil
end

function Local.getNodeProperties(nodeId: string): GameConfig.NodeProperties?
  -- deveria colocar essa function no GameConfig.luau?
  local nodeProps = GameConfig.Nodes.Trees[nodeId]
  if nodeProps then return nodeProps end

  nodeProps = GameConfig.Nodes.Ores[nodeId]
  if nodeProps then return nodeProps end

  return nil
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
    return newHealth, true
  end

  newHealth = node.Health - damage
  -- Maybe add NodeResistance or that's to much?
  
  return newHealth, false
end

function Public.Gather(player: Player, node: BasePart, tool: Tool)
  local toolId = tool:GetAttribute("ID") :: string
  local nodeId = node:GetAttribute("ID") :: string

  local toolProps = Local.getToolProperties(toolId)
  local nodeProps = Local.getNodeProperties(nodeId)

  if not toolProps or not nodeProps then return end

  if (toolProps.Type == "Axe" and nodeProps.Type ~= "Tree") or (toolProps.Type == "Pickaxe" and (nodeProps.Type ~= "Ore" :: any)) then return end

  if (toolProps.Power :: number) < nodeProps.RequiredToolPower then return end

  local broken: boolean

  -- Fix that, I was changing Health of Node in GameConfig not Object Health
  nodeProps.Health, broken = Local.CalcuteDamage(nodeProps, toolProps)

  if broken == true then 
    DropService.rawDrop(player, node)
    node:SetAttribute("Action", "Drag")
  end
end

return Public