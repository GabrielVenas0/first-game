--!strict
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")

local CYCLE_SPEED= 0.075

local Local = {}
local Public = {}

function Public.Init()

end

function Public.Start()
	RunService.Heartbeat:Connect(function(deltaTime: number)
		Lighting.ClockTime = (Lighting.ClockTime + deltaTime * CYCLE_SPEED) % 24
	end)
end

return Public