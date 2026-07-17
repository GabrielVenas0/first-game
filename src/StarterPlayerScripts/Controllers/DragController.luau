--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")

local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local RemoteManager = require(Remotes:WaitForChild("RemoteManager")) 

local DragStartEvent = RemoteManager.GetEvent("DragStart")

local Public = {}

local lastSentPosition = Vector3.zero
local POSITION_THRESHOLD = 0.1 
local MAX_RANGE = 50 
local LERP_SPEED = 0.25

function Public.Init()
end

function Public.Start()
	DragStartEvent.OnClientEvent:Connect(Public.startMouse)
end

function Public.startMouse(targetObject: BasePart)
	if not targetObject then return end
	
	local localPlayer = Players.LocalPlayer
	if not localPlayer then return end
	
	local _mouse = localPlayer:GetMouse()
	local camera = Workspace.CurrentCamera
	if not camera then return end

	local raycastParams = RaycastParams.new()
	raycastParams.FilterType = Enum.RaycastFilterType.Exclude
	raycastParams.FilterDescendantsInstances = {localPlayer.Character, targetObject}

	local connection: RBXScriptConnection
	
	connection = RunService.Heartbeat:Connect(function()
		if not targetObject or not targetObject.Parent then
			connection:Disconnect()
			return
		end

		local mousePosition = UserInputService:GetMouseLocation()
		local unitRay = camera:ScreenPointToRay(mousePosition.X, mousePosition.Y)
		local raycastResult = Workspace:Raycast(unitRay.Origin, unitRay.Direction * MAX_RANGE, raycastParams)
		
		local targetPosition: Vector3

		if raycastResult then
			local offset = Vector3.new(0, targetObject.Size.Y / 2, 0)
			targetPosition = raycastResult.Position + offset
		else
			targetPosition = unitRay.Origin + (unitRay.Direction * MAX_RANGE)
		end

		targetObject.Position = targetObject.Position:Lerp(targetPosition, LERP_SPEED)

		if (targetObject.Position - lastSentPosition).Magnitude > POSITION_THRESHOLD then
			lastSentPosition = targetObject.Position
			DragStartEvent:FireServer(targetObject, targetObject.Position)
		end
	end)
end

return Public
