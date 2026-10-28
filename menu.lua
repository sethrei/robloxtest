-- Menu de ajustes locais para um ambiente com as APIs do Roblox.
-- Tambem pode ser colocado em um LocalScript no Roblox Studio.
-- Nao usa os offsets enviados e nao cria uma integracao externa.
if game == nil then
    error("Este menu usa as APIs do Roblox. O interpretador Lua local nao possui game, Instance ou PlayerGui.", 0)
end

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local Input = game:GetService("UserInputService")
local player = Players.LocalPlayer
if not player then
    error("Execute este menu no contexto do cliente/jogador.", 0)
end
local playerGui = player:WaitForChild("PlayerGui")
local existing = playerGui:FindFirstChild("AjustesMenu")
if existing then
    existing:Destroy()
end

local originalShadows = Lighting.GlobalShadows
local camera = workspace.CurrentCamera
local originalFov = camera and camera.FieldOfView or 70
local selectedFov = originalFov
local connections = {}
local gui = Instance.new("ScreenGui")
gui.Name = "AjustesMenu"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = playerGui

local function rounded(object)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = object
end

local launcher = Instance.new("TextButton")
launcher.Name = "AbrirMenu"
launcher.Size = UDim2.fromOffset(100, 40)
launcher.Position = UDim2.new(0, 16, 0.5, -20)
launcher.BackgroundColor3 = Color3.fromRGB(79, 70, 229)
launcher.TextColor3 = Color3.new(1, 1, 1)
launcher.Font = Enum.Font.GothamBold
launcher.TextSize = 15
launcher.Text = "MENU"
launcher.Parent = gui
rounded(launcher)

local panel = Instance.new("Frame")
panel.Name = "Painel"
panel.AnchorPoint = Vector2.new(0.5, 0.5)
panel.Position = UDim2.fromScale(0.5, 0.5)
panel.Size = UDim2.new(0.88, 0, 0, 320)
panel.BackgroundColor3 = Color3.fromRGB(17, 24, 39)
panel.Parent = gui
rounded(panel)
local bounds = Instance.new("UISizeConstraint")
bounds.MaxSize = Vector2.new(340, 320)
bounds.Parent = panel
local padding = Instance.new("UIPadding")
padding.PaddingLeft = UDim.new(0, 16)
padding.PaddingRight = UDim.new(0, 16)
padding.PaddingTop = UDim.new(0, 16)
padding.Parent = panel
local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 10)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = panel
local title = Instance.new("TextLabel")
title.LayoutOrder = 0
title.Size = UDim2.new(1, 0, 0, 34)
title.BackgroundTransparency = 1
title.Text = "MENU · AJUSTES LOCAIS"
title.Font = Enum.Font.GothamBold
title.TextSize = 17
title.TextColor3 = Color3.fromRGB(165, 180, 252)
title.Parent = panel

local order = 0
local function button(text, action)
    order = order + 1
    local control = Instance.new("TextButton")
    control.LayoutOrder = order
    control.Size = UDim2.new(1, 0, 0, 40)
    control.BackgroundColor3 = Color3.fromRGB(37, 48, 71)
    control.TextColor3 = Color3.new(1, 1, 1)
    control.Font = Enum.Font.Gotham
    control.TextSize = 14
    control.Text = text
    control.Parent = panel
    rounded(control)
    table.insert(connections, control.Activated:Connect(action))
    return control
end

local fovButton
fovButton = button("Campo de visao: " .. math.floor(selectedFov), function()
    selectedFov = selectedFov >= 100 and 60 or math.min(100, selectedFov + 10)
    if workspace.CurrentCamera then
        workspace.CurrentCamera.FieldOfView = selectedFov
    end
    fovButton.Text = "Campo de visao: " .. math.floor(selectedFov)
end)
local shadowsButton
local function updateShadows()
    shadowsButton.Text = "Sombras: " .. (Lighting.GlobalShadows and "ligadas" or "desligadas")
end
shadowsButton = button("Sombras", function()
    Lighting.GlobalShadows = not Lighting.GlobalShadows
    updateShadows()
end)
updateShadows()

local function restore()
    Lighting.GlobalShadows = originalShadows
    if camera and camera.Parent then
        camera.FieldOfView = originalFov
    end
end
button("Restaurar ajustes", function()
    restore()
    selectedFov = originalFov
    fovButton.Text = "Campo de visao: " .. math.floor(selectedFov)
    updateShadows()
end)
button("Ocultar · Shift direito", function() panel.Visible = false end)
button("Encerrar menu", function() gui:Destroy() end)

table.insert(connections, launcher.Activated:Connect(function()
    panel.Visible = not panel.Visible
end))
table.insert(connections, Input.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.RightShift then
        panel.Visible = not panel.Visible
    end
end))
table.insert(connections, workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
    if camera and camera.Parent then camera.FieldOfView = originalFov end
    camera = workspace.CurrentCamera
    if camera then
        originalFov = camera.FieldOfView
        camera.FieldOfView = selectedFov
    end
end))
gui.Destroying:Connect(function()
    for _, connection in ipairs(connections) do connection:Disconnect() end
    restore()
end)
