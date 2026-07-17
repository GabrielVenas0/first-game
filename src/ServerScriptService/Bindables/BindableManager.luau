--!strict
local ServerStorage = game:GetService("ServerStorage")
local RunService = game:GetService("RunService")

local ServerBindableManager = {}

local bindablesFolder = ServerStorage:FindFirstChild("ServerBindables") or Instance.new("Folder")
if not ServerStorage:FindFirstChild("ServerBindables") then
	bindablesFolder.Name = "ServerBindables"
	bindablesFolder.Parent = ServerStorage
end

local BINDABLE_EVENTS = {
	"InteractionEvent"
}

function ServerBindableManager.Init()
	if not RunService:IsServer() then return end
	
	for _, name in ipairs(BINDABLE_EVENTS) do
		if not bindablesFolder:FindFirstChild(name) then
			local event = Instance.new("BindableEvent")
			event.Name = name
			event.Parent = bindablesFolder
		end
	end
end

-- Função para recuperar o Bindable
function ServerBindableManager.GetEvent(name: string): BindableEvent
	local event = bindablesFolder:WaitForChild(name, 5) :: BindableEvent
	if not event then
		error("BindableEvent interno não encontrado: " .. name)
	end
	return event
end

return ServerBindableManager