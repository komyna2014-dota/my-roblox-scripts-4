--[[
    ULTIMATE MULTI-FUNCTIONAL HUB v2.0
    Разработано с разделением на вкладки, кастомным перетаскиванием и оптимизацией.
    Клавиша открытия/скрытия: DELETE
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Хранилище настроек и состояний
local State = {
    CurrentTab = "Movement",
    Speed = 16,
    JumpPower = 50,
    Gravity = workspace.Gravity,
    Fly = false,
    NoClip = false,
    InfiniteJump = false,
    ESP = false,
    HitboxSize = 2,
    Fullbright = false,
    AutoClicker = false
}

-- Создание основного интерфейса
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "UltimateAdminHub"
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 450, 0, 320)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -160)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true

-- Скругление углов UI
local UICorner = Instance.new("UICorner", MainFrame)
UICorner.CornerRadius = UDim.new(0, 8)

-- Панель заголовка (Топ-бар)
local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size = UDim2.new(1, 0, 0, 35)
TopBar.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
TopBar.BorderSizePixel = 0

local TopCorner = Instance.new("UICorner", TopBar)
TopCorner.CornerRadius = UDim.new(0, 8)

local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(1, -40, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Text = "ULTIMATE HUB v2.0"
Title.TextColor3 = Color3.fromRGB(240, 240, 240)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 16
Title.BackgroundTransparency = 1

local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.Size = UDim2.new(0, 35, 1, 0)
CloseBtn.Position = UDim2.new(1, -35, 0, 0)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.TextSize = 16
CloseBtn.BorderSizePixel = 0

local CloseCorner = Instance.new("UICorner", CloseBtn)
CloseCorner.CornerRadius = UDim.new(0, 8)

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui.Enabled = false
end)

-- Кастомный скрипт плавного перетаскивания (Drag)
local dragging, dragInput, dragStart, startPos
TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
TopBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
end)
UIS.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Боковое меню вкладок (Sidebar)
local Sidebar = Instance.new("Frame", MainFrame)
Sidebar.Size = UDim2.new(0, 120, 1, -35)
Sidebar.Position = UDim2.new(0, 0, 0, 35)
Sidebar.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
Sidebar.BorderSizePixel = 0

local SidebarCorner = Instance.new("UICorner", Sidebar)
SidebarCorner.CornerRadius = UDim.new(0, 8)

local SidebarList = Instance.new("UIListLayout", Sidebar)
SidebarList.Padding = UDim.new(0, 2)

-- Основной контейнер для контента
local ContentFrame = Instance.new("Frame", MainFrame)
ContentFrame.Size = UDim2.new(1, -125, 1, -45)
ContentFrame.Position = UDim2.new(0, 125, 0, 40)
ContentFrame.BackgroundTransparency = 1

local Tabs = {}
local function CreateTabContainer(name)
    local c = Instance.new("ScrollingFrame", ContentFrame)
    c.Size = UDim2.new(1, 0, 1, 0)
    c.BackgroundTransparency = 1
    c.Visible = false
    c.CanvasSize = UDim2.new(0, 0, 2, 0)
    c.ScrollBarThickness = 4
    local list = Instance.new("UIListLayout", c)
    list.Padding = UDim.new(0, 6)
    Tabs[name] = c
    return c
end

local TabContainers = {
    Movement = CreateTabContainer("Movement"),
    Combat = CreateTabContainer("Combat"),
    Visuals = CreateTabContainer("Visuals"),
    World = CreateTabContainer("World")
}
Tabs[State.CurrentTab].Visible = true

-- Функция создания кнопок вкладок
local function AddTabBtn(name)
    local b = Instance.new("TextButton", Sidebar)
    b.Size = UDim2.new(1, 0, 0, 35)
    b.Text = name
    b.TextColor3 = Color3.fromRGB(180, 180, 180)
    b.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    b.BorderSizePixel = 0
    b.Font = Enum.Font.SourceSans
    b.TextSize = 14

    b.MouseButton1Click:Connect(function()
        Tabs[State.CurrentTab].Visible = false
        State.CurrentTab = name
        Tabs[State.CurrentTab].Visible = true
    end)
end

AddTabBtn("Movement")
AddTabBtn("Combat")
AddTabBtn("Visuals")
AddTabBtn("World")

-- Конструкторы элементов управления (Интерфейс компонентов)
local function CreateToggle(parent, text, default, callback)
    local enabled = default
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, -10, 0, 35)
    btn.BackgroundColor3 = enabled and Color3.fromRGB(46, 117, 89) or Color3.fromRGB(50, 50, 50)
    btn.Text = text .. (enabled and ": ON" or ": OFF")
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 14
    
    local c = Instance.new("UICorner", btn)
    c.CornerRadius = UDim.new(0, 6)

    btn.MouseButton1Click:Connect(function()
        enabled = not enabled
        btn.BackgroundColor3 = enabled and Color3.fromRGB(46, 117, 89) or Color3.fromRGB(50, 50, 50)
        btn.Text = text .. (enabled and ": ON" or ": OFF")
        callback(enabled)
    end)
end

local function CreateSlider(parent, text, min, max, default, callback)
    local container = Instance.new("Frame", parent)
    container.Size = UDim2.new(1, -10, 0, 45)
    container.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    
    local c = Instance.new("UICorner", container)
    c.CornerRadius = UDim.new(0, 6)

    local lbl = Instance.new("TextLabel", container)
    lbl.Size = UDim2.new(1, 0, 0, 20)
    lbl.Text = text .. ": " .. default
    lbl.TextColor3 = Color3.new(1, 1, 1)
    lbl.BackgroundTransparency = 1
    lbl.TextSize = 12

    local trigger = Instance.new("TextButton", container)
    trigger.Size = UDim2.new(1, -20, 0, 15)
    trigger.Position = UDim2.new(0, 10, 0, 22)
    trigger.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    trigger.Text = ""

    local fill = Instance.new("Frame", trigger)
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 160, 255)
    fill.BorderSizePixel = 0

    local function update(input)
        local rel = math.clamp((input.Position.X - trigger.AbsolutePosition.X) / trigger.AbsoluteSize.X, 0, 1)
        fill.Size = UDim2.new(rel, 0, 1, 0)
        local val = math.floor(min + (rel * (max - min)))
        lbl.Text = text .. ": " .. val
        callback(val)
    end

    trigger.MouseButton1Down:Connect(function()
        local moveLoop; moveLoop = RunService.RenderStepped:Connect(function()
            update(UIS:GetMouseLocation())
            if not UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then moveLoop:Disconnect() end
        end)
    end)
end

-- ====================================================================
-- НАПОЛНЕНИЕ ВКЛАДОК И СИСТЕМНАЯ ЛОГИКА
-- ====================================================================

-- [Вкладка: Movement]
CreateSlider(TabContainers.Movement, "WalkSpeed", 16, 250, 16, function(v) State.Speed = v end)
CreateSlider(TabContainers.Movement, "JumpPower", 50, 350, 50, function(v) State.JumpPower = v end)
CreateToggle(TabContainers.Movement, "Noclip System", false, function(v) State.NoClip = v end)
CreateToggle(TabContainers.Movement, "Flight Mode", false, function(v) State.Fly = v end)
CreateToggle(TabContainers.Movement, "Infinite Jump", false, function(v) State.InfiniteJump = v end)

-- [Вкладка: Combat]
CreateToggle(TabContainers.Combat, "Auto Clicker", false, function(v) State.AutoClicker = v end)
CreateSlider(TabContainers.Combat, "Hitbox Multiplier", 2, 15, 2, function(v) State.HitboxSize = v end)
CreateToggle(TabContainers.Combat, "Expand Hitboxes", false, function(v) 
    _G.HitboxActive = v
end)

-- [Вкладка: Visuals]
CreateToggle(TabContainers.Visuals, "Player ESP (Chams)", false, function(v) State.ESP = v end)
CreateToggle(TabContainers.Visuals, "Fullbright", false, function(v) State.Fullbright = v end)
CreateSlider(TabContainers.Visuals, "Field Of View", 70, 120, 70, function(v) Camera.FieldOfView = v end)

-- [Вкладка: World]
CreateSlider(TabContainers.World, "World Gravity", 0, 196, 196, function(v) workspace.Gravity = v end)
CreateSlider(TabContainers.World, "Time Control", 0, 24, 12, function(v) Lighting.ClockTime = v end)

-- Основной рабочий цикл (Engine Loops)
RunService.Stepped:Connect(function()
    pcall(function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = State.Speed
            LocalPlayer.Character.Humanoid.JumpPower = State.JumpPower
        end
        
        -- Логика NoClip
        if State.NoClip and LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end

        -- Логика Полета (Fly)
        if State.Fly and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local root = LocalPlayer.Character.HumanoidRootPart
            root.Velocity = Camera.CFrame.LookVector * (State.Speed * 1.5)
        end
        
        -- Управление Хитбоксами
        if _G.HitboxActive then
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    plr.Character.HumanoidRootPart.Size = Vector3.new(State.HitboxSize, State.HitboxSize, State.HitboxSize)
                    plr.Character.HumanoidRootPart.Transparency = 0.7
                    plr.Character.HumanoidRootPart.Color = Color3.fromRGB(0, 120, 255)
                end
            end
        end
    end)
end)

-- Слушатель Бесконечного Прыжка
UIS.JumpRequest:Connect(function()
    if State.InfiniteJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- Цикл для обработки ESP и Освещения
RunService.RenderStepped:Connect(function()
    -- Fullbright
    if State.Fullbright then
        Lighting.Ambient = Color3.new(1, 1, 1)
        Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
    end

    -- ESP (Надежные Highlights)
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local hl = plr.Character:FindFirstChild("ESPHighlight")
            if State.ESP then
                if not hl then
                    hl = Instance.new("Highlight")
                    hl.Name = "ESPHighlight"
                    hl.Parent = plr.Character
                    hl.FillColor = Color3.fromRGB(255, 40, 40)
                    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                    hl.FillTransparency = 0.5
                end
            else
                if hl then hl:Destroy() end
            end
        end
    end
    
    -- AutoClicker execution
    if State.AutoClicker and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
        pcall(function()
            local virtualUser = game:GetService("VirtualUser")
            virtualUser:CaptureController()
            virtualUser:ClickButton1(Vector2.new(0,0))
        end)
    end
end)

-- Переключатель видимости меню на кнопку Delete
UIS.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.Delete then
        ScreenGui.Enabled = not ScreenGui.Enabled
    end
end)

print("Ultimate Modular Hub Successfully Initialized.")