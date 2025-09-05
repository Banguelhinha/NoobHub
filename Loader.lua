--[[
    Script GUI Multifuncional - Mobile + Proteção por Gamepass
    Recursos: ESP, Boost, Float, Compras, Tabs, Drag, etc.
    Mobile friendly. Proteção: só funciona para quem tem a Gamepass correta.
    By Banguelhinha
]]


local GAMEPASS_ID = 1446832551 -- 

local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Checagem de gamepass (proteção)
local hasGamepass = false
pcall(function()
    hasGamepass = MarketplaceService:UserOwnsGamePassAsync(LocalPlayer.UserId, GAMEPASS_ID)
end)

if not hasGamepass then
    -- Mensagem de bloqueio
    local sg = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
    sg.Name = "GamepassRequired"
    local label = Instance.new("TextLabel", sg)
    label.Size = UDim2.new(0.8,0,0.1,0)
    label.Position = UDim2.new(0.1,0,0.45,0)
    label.BackgroundColor3 = Color3.fromRGB(40,40,40)
    label.TextColor3 = Color3.new(1,0.2,0.2)
    label.TextScaled = true
    label.Text = "Você precisa da Gamepass para usar este script!"
    return
end

-- ==== INÍCIO DA INTERFACE E FUNÇÕES ====

-- Detecta se é mobile
local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

-- Cores & estilos
local tabNames = { "main", "visual", "misc" }
local tabColors = {
    main = Color3.fromRGB(37, 176, 37),
    visual = Color3.fromRGB(184, 187, 24),
    misc = Color3.fromRGB(70, 70, 255)
}
local FONT = Enum.Font.Gotham

-- Escalas mobile
local buttonHeight = isMobile and 60 or 34
local buttonWidth = isMobile and 0.9 or 0.6
local frameWidth = isMobile and 0.97 or 0.25
local frameHeight = isMobile and 0.93 or 0.45
local frameY = 0.5

-- GUI principal
local screenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
screenGui.Name = "MelhorGUIMobile"
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.IgnoreGuiInset = true

local function createButton(parent, props)
    local btn = Instance.new("TextButton", parent)
    for k, v in pairs(props) do btn[k] = v end
    local txtConstraint = Instance.new("UITextSizeConstraint", btn)
    txtConstraint.MaxTextSize = props.MaxTextSize or (isMobile and 32 or 22)
    return btn
end

local function createFrame(parent, props)
    local fr = Instance.new("Frame", parent)
    for k, v in pairs(props) do fr[k] = v end
    return fr
end

-- Tabs
local mainFrame = createFrame(screenGui, {
    Name = "MainFrame",
    BackgroundColor3 = Color3.fromRGB(28, 30, 39),
    Size = UDim2.new(frameWidth, 0, frameHeight, 0),
    Position = UDim2.new(0.5, 0, frameY, 0),
    AnchorPoint = Vector2.new(0.5, 0.5),
    BorderSizePixel = 0,
})

-- Tab buttons
local tabButtons = {}
local tabFrames = {}
for i, name in ipairs(tabNames) do
    tabButtons[name] = createButton(mainFrame, {
        Name = name.."Btn",
        Text = name:upper(),
        BackgroundColor3 = tabColors[name],
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.new((i-1)*(buttonWidth/2)+(buttonWidth/4), 0, 0.025, 0),
        Size = UDim2.new(buttonWidth/3, 0, 0.09, 0),
        TextScaled = true,
        TextColor3 = Color3.new(1,1,1),
        Font = FONT,
        BorderSizePixel = 0,
        AutoButtonColor = true,
    })
end

-- Conteúdo das tabs
for _, name in ipairs(tabNames) do
    local frame = Instance.new("ScrollingFrame", mainFrame)
    frame.Name = name.."Tab"
    frame.BackgroundTransparency = 1
    frame.Size = UDim2.new(1, 0, 0.83, 0)
    frame.Position = UDim2.new(0, 0, 0.13, 0)
    frame.Visible = (name == "main")
    frame.BorderSizePixel = 0
    frame.CanvasSize = UDim2.new(0, 0, 2, 0)
    frame.ScrollBarThickness = isMobile and 18 or 8

    local layout = Instance.new("UIListLayout", frame)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, isMobile and 12 or 4)
    tabFrames[name] = frame
end

-- Troca de tab
local function switchTab(tab)
    for _, name in ipairs(tabNames) do
        tabFrames[name].Visible = (name == tab)
    end
end
for _, name in ipairs(tabNames) do
    tabButtons[name].MouseButton1Click:Connect(function()
        switchTab(name)
    end)
end

----------------------
-- MAIN TAB BUTTONS --
----------------------

local function addMainTabButton(name, text, callback)
    return createButton(tabFrames.main, {
        Name = name,
        Text = text,
        BackgroundColor3 = Color3.fromRGB(174, 42, 42),
        Size = UDim2.new(0.93, 0, 0, buttonHeight),
        TextScaled = true,
        TextColor3 = Color3.new(1,1,1),
        Font = FONT,
        BorderSizePixel = 0,
        AutoButtonColor = true,
        [isMobile and "TextWrapped" or ""] = true,
    }).MouseButton1Click:Connect(callback)
end

-- FLOAT
addMainTabButton("FloatBtn", "FLOAT", function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame + Vector3.new(0, 50, 0)
    end
end)

-- INFINITY JUMP
local infJumpEnabled = false
local infJumpBtn = createButton(tabFrames.main, {
    Name = "InfJumpBtn",
    Text = "INFINITY JUMP",
    BackgroundColor3 = Color3.fromRGB(174, 42, 42),
    Size = UDim2.new(0.93, 0, 0, buttonHeight),
    TextScaled = true,
    TextColor3 = Color3.new(1,1,1),
    Font = FONT,
    BorderSizePixel = 0,
    AutoButtonColor = true,
})
infJumpBtn.MouseButton1Click:Connect(function()
    infJumpEnabled = not infJumpEnabled
    infJumpBtn.BackgroundColor3 = infJumpEnabled and Color3.fromRGB(64,149,33) or Color3.fromRGB(174,42,42)
end)
UserInputService.JumpRequest:Connect(function()
    if infJumpEnabled then
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then char.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

-- JUMP BOOST
local jumpBoostEnabled = false
local jumpBoostBtn = createButton(tabFrames.main, {
    Name = "JumpBoostBtn",
    Text = "JUMP BOOST",
    BackgroundColor3 = Color3.fromRGB(174, 42, 42),
    Size = UDim2.new(0.93, 0, 0, buttonHeight),
    TextScaled = true,
    TextColor3 = Color3.new(1,1,1),
    Font = FONT,
    BorderSizePixel = 0,
    AutoButtonColor = true,
})
jumpBoostBtn.MouseButton1Click:Connect(function()
    jumpBoostEnabled = not jumpBoostEnabled
    jumpBoostBtn.BackgroundColor3 = jumpBoostEnabled and Color3.fromRGB(64,149,33) or Color3.fromRGB(174,42,42)
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.JumpPower = jumpBoostEnabled and 120 or 50
    end
end)

-- SPEED BOOST
local speedBoostEnabled = false
local speedBoostBtn = createButton(tabFrames.main, {
    Name = "SpeedBoostBtn",
    Text = "SPEED BOOST",
    BackgroundColor3 = Color3.fromRGB(174, 42, 42),
    Size = UDim2.new(0.93, 0, 0, buttonHeight),
    TextScaled = true,
    TextColor3 = Color3.new(1,1,1),
    Font = FONT,
    BorderSizePixel = 0,
    AutoButtonColor = true,
})
speedBoostBtn.MouseButton1Click:Connect(function()
    speedBoostEnabled = not speedBoostEnabled
    speedBoostBtn.BackgroundColor3 = speedBoostEnabled and Color3.fromRGB(64,149,33) or Color3.fromRGB(174,42,42)
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = speedBoostEnabled and 50 or 16
    end
end)

-- STEAL
local stealUp = true
local stealBtn = createButton(tabFrames.main, {
    Name = "StealBtn",
    Text = "STEAL (UP/DOWN)",
    BackgroundColor3 = Color3.fromRGB(174, 42, 42),
    Size = UDim2.new(0.93, 0, 0, buttonHeight),
    TextScaled = true,
    TextColor3 = Color3.new(1,1,1),
    Font = FONT,
    BorderSizePixel = 0,
    AutoButtonColor = true,
})
stealBtn.MouseButton1Click:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        if stealUp then
            char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame + Vector3.new(0, 200, 0)
        else
            char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame - Vector3.new(0, 50, 0)
        end
        stealUp = not stealUp
    end
end)

----------------------
-- VISUAL TAB BUTTONS
----------------------

local espPlayerBtn = createButton(tabFrames.visual, {
    Name = "ESPPlayerBtn",
    Text = "ESP PLAYER",
    BackgroundColor3 = Color3.fromRGB(174, 42, 42),
    Size = UDim2.new(0.93, 0, 0, buttonHeight),
    TextScaled = true,
    TextColor3 = Color3.new(1,1,1),
    Font = FONT,
    BorderSizePixel = 0,
    AutoButtonColor = true,
})
local espEnabled = false
espPlayerBtn.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    espPlayerBtn.BackgroundColor3 = espEnabled and Color3.fromRGB(64,149,33) or Color3.fromRGB(174,42,42)
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            if espEnabled then
                if not p.Character:FindFirstChild("ESPHighlight") then
                    local h = Instance.new("Highlight", p.Character)
                    h.Name = "ESPHighlight"
                    h.FillTransparency = 1
                    h.OutlineColor = Color3.new(1,1,1)
                end
            else
                local h = p.Character:FindFirstChild("ESPHighlight")
                if h then h:Destroy() end
            end
        end
    end
end)

--------------------
-- MISC TAB BUTTONS
--------------------

local function addMiscTabButton(name, text, itemName)
    local btn = createButton(tabFrames.misc, {
        Name = name,
        Text = text,
        BackgroundColor3 = Color3.fromRGB(101,101,101),
        Size = UDim2.new(0.93, 0, 0, buttonHeight),
        TextScaled = true,
        TextColor3 = Color3.new(1,1,1),
        Font = FONT,
        BorderSizePixel = 0,
        AutoButtonColor = true,
    })
    btn.MouseButton1Click:Connect(function()
        local buyFunc = ReplicatedStorage:FindFirstChild("Packages") and ReplicatedStorage.Packages.Net:FindFirstChild("RF/CoinsShopService/RequestBuy")
        if buyFunc then
            buyFunc:InvokeServer(itemName)
        end
    end)
end

addMiscTabButton("QuantumClonerBtn", "Quantum Cloner", "Quantum Cloner")
addMiscTabButton("MedusaBtn", "Medusa's Head", "Medusa's Head")
addMiscTabButton("InvisBtn", "Invisibility Cloak", "Invisibility Cloak")

------------------------
-- DRAG MAIN FRAME MOBILE
------------------------
local dragging = false
local dragInput, dragStart, startPos

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)
mainFrame.InputChanged:Connect(function(input)
    if (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) and dragging then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- FIM DO SCRIPT INTEGRADO