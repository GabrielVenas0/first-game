--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Configs = ReplicatedStorage:WaitForChild("Configs")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")

local GameUtils = require(Configs.GameUtils)
local DropService = require(script.Parent.DropService)
local RemoteManager = require(Remotes:WaitForChild("RemoteManager"))

local NotificationEvent = RemoteManager.GetEvent("Notification")

local NORMAL_DAMAGE = 10
local COEF_DAMAGE = 0.25

local Local = {}
local Public = {}

function Public.Init()

end

function Public.Start()
  
end

function Local.CalcuteDamage(player: Player, object: BasePart, tool: Tool)
  local health = object:GetAttribute("Health") :: number
  local power = tool:GetAttribute("Power") :: number

  local damage: number
  local newHealth: number

  damage = NORMAL_DAMAGE * (1 + COEF_DAMAGE)^power
  -- In future I will add:
  -- Enchantments
  -- Buffs ( Premium Players, Group Players, Gamepasses, F2P things )
  -- Special stats by forging
  -- Skill Level Rewards
  -- More or less? I will think about it later 

  local popup = {
    DisplayName = tostring(damage),
    ScreenTime = 2,
    Type = "Popup",
    Object = object
  }

  NotificationEvent:FireClient(player, popup)


  if health < damage then
    newHealth = 0
    return newHealth, true
  end

  newHealth = health - damage
  -- Maybe add NodeResistance or that's to much?
  
  return newHealth, false
end

function Public.Gather(player: Player, node: BasePart, tool: Tool)
  local toolId = tool:GetAttribute("ID") :: string
  local nodeId = node:GetAttribute("ID") :: string

  local toolProps = GameUtils.getToolProperties(toolId)
  local nodeProps = GameUtils.getNodeProperties(nodeId)

  if not toolProps or not nodeProps then return end

  if (toolProps.Type == "Axe" and nodeProps.Type ~= "Tree") or (toolProps.Type == "Pickaxe" and (nodeProps.Type ~= "Ore" :: any)) then return end

  if (toolProps.Power :: number) < nodeProps.RequiredToolPower then return end

  local health: number
  local broken: boolean
  health, broken = Local.CalcuteDamage(player, node, tool)

  node:SetAttribute("Health", health)

  if broken == true then 
    DropService.rawDrop(player.UserId, node)
    node:SetAttribute("Action", "Drag")
  end
end

return Public