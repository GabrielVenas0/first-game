local ServerScriptService = game:GetService("ServerScriptService")
local ServicesFolder = ServerScriptService:WaitForChild("Services")

local LoadedServices = {}

for _, moduleScript in ipairs(ServicesFolder:GetChildren()) do
    if moduleScript:IsA("ModuleScript") then
        local success, service = pcall(require, moduleScript)
        if success then
            LoadedServices[moduleScript.name] = service
        else
            warn("Failed to load service: " .. moduleScript.name .. " | Error: " .. tostring(service))
        end
    end
end

for name, service in pairs(LoadedServices) do
    if type(service.Init) == "function" then
        local success, err = pcall(function()
            service:Init()
        end)
        if not success then
            warn("Error initializing " .. name .. ": " .. tostring(err))
        end
    end
end

for name, service in pairs(LoadedServices) do
    if type(service.Start) == "function" then
        task.spawn(function()
            local success, err = pcall(function()
                service:Start()
            end)
            if not success then
                warn("Error starting " .. name .. ": " .. tostring(err))
            end
        end)
    end
end

print("Server Service Loader successfully started!")
