--!strict
local RunService = game:GetService("RunService")

local RemoteManager = {}
local remotesFolder = script.Parent

local REMOTE_EVENTS = {
  "StartDrag",
  "StopDrag",
	"Notification",
	"startHover",
	"endHover"
}

local REMOTE_FUNCTIONS = {}

function RemoteManager.InitServer()
	if not RunService:IsServer() then return end
	
	for _, name in ipairs(REMOTE_EVENTS) do
		if not remotesFolder:FindFirstChild(name) then
			local event = Instance.new("RemoteEvent")
			event.Name = name
			event.Parent = remotesFolder
		end
	end

	for _, name in ipairs(REMOTE_FUNCTIONS) do
		if not remotesFolder:FindFirstChild(name) then
			local func = Instance.new("RemoteFunction")
			func.Name = name
			func.Parent = remotesFolder
		end
	end
end

function RemoteManager.GetEvent(name: string): RemoteEvent
	local event = remotesFolder:WaitForChild(name, 5) :: RemoteEvent
	if not event then
		error("RemoteEvent não encontrado: " .. name)
	end
	return event
end

function RemoteManager.GetFunction(name: string): RemoteFunction
	local func = remotesFolder:WaitForChild(name, 5) :: RemoteFunction
	if not func then
		error("RemoteFunction não encontrada: " .. name)
	end
	return func
end

return RemoteManager