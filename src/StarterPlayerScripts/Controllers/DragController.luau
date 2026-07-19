--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")

local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local RemoteManager = require(Remotes:WaitForChild("RemoteManager")) 

local StartDragEvent = RemoteManager.GetEvent("StartDrag")
local StopDragEvent = RemoteManager.GetEvent("StopDrag")

local Public = {}

--[[
I need to study more to improve Drag System (physics/math) --> Smooth, Precise and better object move

TODO: 
KeyBind for change orientation
]]

local lastSentPosition = Vector3.zero
local POSITION_THRESHOLD = 0.1 
local MAX_RANGE = 20
local LERP_SPEED = 0.05

local dragConnection: RBXScriptConnection? = nil
local inputConnection: RBXScriptConnection? = nil

function Public.Init()
end

function Public.Start()
	StartDragEvent.OnClientEvent:Connect(Public.startMouse)
	StopDragEvent.OnClientEvent:Connect(Public.stopMouse)
end

function Public.startMouse(targetObject: BasePart)
	if not targetObject then return end
	
	local localPlayer = Players.LocalPlayer
	if not localPlayer then return end
	
	local camera = Workspace.CurrentCamera
	if not camera then return end

	Public.stopMouse(targetObject)

	local raycastParams = RaycastParams.new()
	raycastParams.FilterType = Enum.RaycastFilterType.Exclude
	raycastParams.FilterDescendantsInstances = {localPlayer.Character, targetObject}
	
	dragConnection = RunService.Heartbeat:Connect(function()
		if not targetObject or not targetObject.Parent then
			Public.stopMouse(targetObject :: BasePart)
			return
		end

		local character = localPlayer.Character
		if not character or not character:FindFirstChild("HumanoidRootPart") then return end
		local playerOrigin = character.HumanoidRootPart.Position

		local mousePosition = UserInputService:GetMouseLocation()
		local unitRay = camera:ScreenPointToRay(mousePosition.X, mousePosition.Y)

		local raycastResult = Workspace:Raycast(unitRay.Origin, unitRay.Direction * 100, raycastParams)
		
		local targetPosition: Vector3
		local offset = Vector3.new(0, targetObject.Size.Y / 2, 0)

		if raycastResult then
			targetPosition = raycastResult.Position + offset
		else
			targetPosition = unitRay.Origin + (unitRay.Direction * MAX_RANGE)
		end

		local directionFromPlayer = (targetPosition - playerOrigin)
		if directionFromPlayer.Magnitude > MAX_RANGE then
			targetPosition = playerOrigin + (directionFromPlayer.Unit * MAX_RANGE)
		end

		targetObject.Position = targetObject.Position:Lerp(targetPosition, LERP_SPEED)

		if (targetObject.Position - lastSentPosition).Magnitude > POSITION_THRESHOLD then
			lastSentPosition = targetObject.Position
			StartDragEvent:FireServer(targetObject, targetObject.Position)
		end
	end)

	inputConnection = UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
		if gameProcessedEvent then return end
		
		if input.KeyCode == Enum.KeyCode.F then
			Public.stopMouse(targetObject)
		end
	end)
end

function Public.stopMouse(targetObject: BasePart)
	if dragConnection then
		dragConnection:Disconnect()
		dragConnection = nil
	end

	if inputConnection then
		inputConnection:Disconnect()
		inputConnection = nil
	end

	if StopDragEvent and targetObject then
		StopDragEvent:FireServer(targetObject)
	end
end

return Public
