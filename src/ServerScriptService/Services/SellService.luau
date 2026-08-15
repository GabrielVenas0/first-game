--!strict
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local RemoteManager = require(Remotes:WaitForChild("RemoteManager")) 

local Players = game:GetService("Players")
local SellPart = Workspace:WaitForChild("Temp"):WaitForChild("SellPart") :: Part
local StopDragEvent = RemoteManager.GetEvent("StopDrag")
local PoolingService = require(script.Parent.PoolingService)

-- I've created this script fully alone, writing down things that popped into my head
-- This code is only for test, Ik I've to improve security, formula, logic, i.e.

local Local = {}
local Public = {}

function Public.Init()

end

function Public.Start()
  SellPart.Touched:Connect(Public.Sell)
end

function Local.calculateGain(object: BasePart)
  local volume = object:GetMass() / 0.7
  -- I need to create a formula and use hardcoded values
  -- Get GameConfig Node's BaseValue
  return (volume)^0.6
end

function Public.Sell(object: BasePart)
  local props = object:GetAttributes()
  if not props then return end

  if props.Action :: string ~= "Drag" then return end

  if (props.PlayerOwner :: number) < 0 then return end
  
  
   StopDragEvent:FireClient(Players:GetPlayerByUserId(props.PlayerOwner), object)
    PoolingService.Free(object, object.Name)
  local gain = Local.calculateGain(object)
  print(tostring(props.PlayerOwner) .. " Just Sell " .. tostring(object) .. " And make " .. tostring(gain))
end



return Public