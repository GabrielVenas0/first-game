--!strict
local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Bindables = ServerScriptService.Bindables
local Remotes = ReplicatedStorage:WaitForChild("Remotes")

local _BindableManager = require(Bindables.BindableManager) 
local _RemoteManager = require(Remotes:WaitForChild("RemoteManager")) 

local _Local = {}
local Public = {}

function Public.DeepFreeze(t)
  if type(t) ~= 'table' then return t end
  for _, v in pairs(t) do Public.DeepFreeze(v) end
  table.freeze(t)
  return t
end

function Public.DeepCopy(v)
  if type(v) ~= 'table' then return v end
  local t = {}
  for k, val in pairs(v) do
    t[Public.DeepCopy(k)] = Public.DeepCopy(val)
  end
  return t
end

return Public