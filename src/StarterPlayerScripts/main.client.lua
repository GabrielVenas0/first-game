local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local StarterPlayerScripts = LocalPlayer:WaitForChild("PlayerScripts")
local ControllersFolder = StarterPlayerScripts:WaitForChild("Controllers") -- Crie esta pasta

-- Aguarda o jogo carregar o básico do mapa antes de iniciar a lógica do cliente
if not game:IsLoaded() then
    game.Loaded:Wait()
end

local LoadedControllers = {}

-- 1. Carrega todos os módulos da pasta de Controllers
for _, moduleScript in ipairs(ControllersFolder:GetChildren()) do
    if moduleScript:IsA("ModuleScript") then
        local success, controller = pcall(require, moduleScript)
        if success then
            LoadedControllers[moduleScript.Name] = controller
        else
            warn("Falha ao carregar Controller: " .. moduleScript.Name .. " | Erro: " .. tostring(controller))
        end
    end
end

-- 2. Roda as inicializações (Init) sequencialmente
for name, controller in pairs(LoadedControllers) do
    if type(controller) == "table" and type(controller.Init) == "function" then
        local success, err = pcall(function()
            controller:Init()
        end)
        if not success then warn("Erro no Init do Controller " .. name .. ": " .. tostring(err)) end
    end
end

-- 3. Roda os loops e conexões de eventos (Start) de forma paralela/assíncrona
for name, controller in pairs(LoadedControllers) do
    if type(controller) == "table" and type(controller.Start) == "function" then
        task.spawn(function()
            local success, err = pcall(function()
                controller:Start()
            end)
            if not success then warn("Erro no Start do Controller " .. name .. ": " .. tostring(err)) end
        end)
    end
end

print("Todos os Controllers do Cliente foram carregados com sucesso!")
