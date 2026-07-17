--!strict
local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")


local Bindables = ServerScriptService.Bindables
local Remotes = ReplicatedStorage:WaitForChild("Remotes")


local _BindableManager = require(Bindables.BindableManager) 
local _RemoteManager = require(Remotes:WaitForChild("RemoteManager")) 



local _Local = {}
local Public = {}

function Public.Init()

end

function Public.Start()
  
end

return Public