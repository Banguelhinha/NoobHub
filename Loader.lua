--[[
    Script GUI Multifuncional - Mobile friendly + Proteção por Gamepass
    Recursos: ESP com nome, Boosts com configuração, Infinity Jump SEGURO, menu pequeno/minimizável.
    By Banguelhinha
]]

local GAMEPASS_ID = 1446832551

local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Checagem de gamepass
local hasGamepass = false
pcall(function()
    hasGamepass = MarketplaceService:UserOwnsGamePassAsync(LocalPlayer.UserId, GAMEPASS_ID)
end)

if not hasGamepass then
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

-- Detecta se é mobile
local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

-- Interface Config
local GUI_SCALE = isMobile and 0.36 or 0.25
local BUTTON_HEIGHT = isMobile and 38 or 28

-- GUI principal
local screenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
screenGui.Name = "MelhorGUIMobile"
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.IgnoreGuiInset = true

-- Minimize Button
local minimized = false
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Parent = screenGui
minimizeBtn.Size = UDim2.new(0,32,0,32)
minimizeBtn.Position = UDim2.new(0,12,0,12)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(28,28,28)
minimizeBtn.TextColor3 = Color3.new(1,1,1)
minimizeBtn.Text = "-"
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextScaled = true
minimizeBtn.ZIndex = 99

local mainFrame = Instance.new("Frame")
mainFrame.Parent = screenGui
mainFrame.Name = "MainFrame"
mainFrame.BackgroundColor3 = Color3.fromRGB(28, 30, 39)
mainFrame.Size = UDim2.new(GUI_SCALE, 0, 0, BUTTON_HEIGHT*7+38)
mainFrame.Position = UDim2.new(0, 12, 0, 56)
mainFrame.AnchorPoint = Vector2.new(0,0)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Visible = true

minimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    mainFrame.Visible = not minimized
    minimizeBtn.Text = minimized and "+" or "-"
end)

-- Layout
local layout = Instance.new("UIListLayout", mainFrame)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 6)

local function createButton(name, text, callback)
    local btn = Instance.new("TextButton", mainFrame)
    btn.Name = name
    btn.Size = UDim2.new(0.94, 0, 0, BUTTON_HEIGHT)
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 90)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    btn.TextScaled = true
    btn.Text = text
    btn.AutoButtonColor = true
    btn.BorderSizePixel = 0
    btn.LayoutOrder = 2
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-----------------
-- INFINITY JUMP (SAFE)
-----------------
local infJumpEnabled = false
local infJumpBtn = createButton("InfJumpBtn", "INFINITY JUMP (OFF)", function()
    infJumpEnabled = not infJumpEnabled
    infJumpBtn.Text = "INFINITY JUMP ("..(infJumpEnabled and "ON" or "OFF")..")"
    infJumpBtn.BackgroundColor3 = infJumpEnabled and Color3.fromRGB(64,149,33) or Color3.fromRGB(60,60,90)
end)
local lastJump = 0
UserInputService.JumpRequest:Connect(function()
    if infJumpEnabled then
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") then
            -- Aplica impulso suave, não força estado!
            local hrp = char.HumanoidRootPart
            if tick() - lastJump > 0.13 then
                hrp.Velocity = Vector3.new(hrp.Velocity.X, 45, hrp.Velocity.Z)
                lastJump = tick()
            end
        end
    end
end)

-----------------
-- SPEED BOOST (COIL)
-----------------
local speedValue = 30
local speedEnabled = false
local speedBtn = createButton("SpeedBtn", "SPEED BOOST ("..speedValue..")", function()
    speedEnabled = not speedEnabled
    speedBtn.BackgroundColor3 = speedEnabled and Color3.fromRGB(64,149,33) or Color3.fromRGB(60,60,90)
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        if speedEnabled then
            char.Humanoid.WalkSpeed = speedValue
        else
            char.Humanoid.WalkSpeed = 16
        end
    end
end)
-- Slider para speed
local speedSlider = Instance.new("TextButton", mainFrame)
speedSlider.Size = UDim2.new(0.94,0,0,BUTTON_HEIGHT)
speedSlider.BackgroundColor3 = Color3.fromRGB(40,40,60)
speedSlider.TextColor3 = Color3.new(1,1,1)
speedSlider.Font = Enum.Font.Gotham
speedSlider.TextScaled = true
speedSlider.Text = "Velocidade: "..speedValue.." (toque para +5)"
speedSlider.LayoutOrder = 1
speedSlider.MouseButton1Click:Connect(function()
    speedValue = speedValue + 5
    if speedValue > 120 then speedValue = 10 end
    speedSlider.Text = "Velocidade: "..speedValue.." (toque para +5)"
    if speedEnabled then
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.WalkSpeed = speedValue
        end
    end
end)

-----------------
-- JUMP BOOST (COIL)
-----------------
local jumpValue = 80
local jumpEnabled = false
local jumpBtn = createButton("JumpBtn", "JUMP BOOST ("..jumpValue..")", function()
    jumpEnabled = not jumpEnabled
    jumpBtn.BackgroundColor3 = jumpEnabled and Color3.fromRGB(64,149,33) or Color3.fromRGB(60,60,90)
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        if jumpEnabled then
            char.Humanoid.JumpPower = jumpValue
        else
            char.Humanoid.JumpPower = 50
        end
    end
end)
-- Slider para jump
local jumpSlider = Instance.new("TextButton", mainFrame)
jumpSlider.Size = UDim2.new(0.94,0,0,BUTTON_HEIGHT)
jumpSlider.BackgroundColor3 = Color3.fromRGB(40,40,60)
jumpSlider.TextColor3 = Color3.new(1,1,1)
jumpSlider.Font = Enum.Font.Gotham
jumpSlider.TextScaled = true
jumpSlider.Text = "Pulo: "..jumpValue.." (toque para +5)"
jumpSlider.LayoutOrder = 1
jumpSlider.MouseButton1Click:Connect(function()
    jumpValue = jumpValue + 5
    if jumpValue > 150 then jumpValue = 40 end
    jumpSlider.Text = "Pulo: "..jumpValue.." (toque para +5)"
    if jumpEnabled then
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.JumpPower = jumpValue
        end
    end
end)

-----------------
-- NOCLIP FLY (VISUAL)
-----------------
local noclipFlyEnabled = false
local flyConnection = nil
local noclipFlyBtn = createButton("NoclipFlyBtn", "NOCLIP FLY (OFF)", function()
    noclipFlyEnabled = not noclipFlyEnabled
    noclipFlyBtn.Text = "NOCLIP FLY ("..(noclipFlyEnabled and "ON" or "OFF")..")"
    noclipFlyBtn.BackgroundColor3 = noclipFlyEnabled and Color3.fromRGB(64,149,33) or Color3.fromRGB(60,60,90)

    local char = LocalPlayer.Character
    if not char then return end

    local function setNoclip(state)
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = not state
            end
        end
    end

    if noclipFlyEnabled then
        setNoclip(true)
        flyConnection = RunService.RenderStepped:Connect(function()
            if not noclipFlyEnabled or not LocalPlayer.Character then return end
            local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if root then
                local moveVec = Vector3.new(0,0,0)
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveVec = moveVec + Vector3.new(0,0,-1) end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveVec = moveVec + Vector3.new(0,0,1) end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveVec = moveVec + Vector3.new(-1,0,0) end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveVec = moveVec + Vector3.new(1,0,0) end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveVec = moveVec + Vector3.new(0,1,0) end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveVec = moveVec + Vector3.new(0,-1,0) end

                if isMobile then
                    moveVec = Vector3.new(0,0,-1)
                end

                local SPEED = 4
                if moveVec.Magnitude > 0 then
                    moveVec = moveVec.Unit * SPEED
                    root.CFrame = root.CFrame + (root.CFrame.LookVector * moveVec.Z + root.CFrame.RightVector * moveVec.X + Vector3.new(0,moveVec.Y,0))
                end
            end
        end)
    else
        setNoclip(false)
        if flyConnection then flyConnection:Disconnect() flyConnection = nil end
    end
end)

-----------------
-- ESP (NOME EM CIMA)
-----------------
local espEnabled = false
local espBtn = createButton("ESPBtn", "ESP PLAYER (OFF)", function()
    espEnabled = not espEnabled
    espBtn.Text = "ESP PLAYER ("..(espEnabled and "ON" or "OFF")..")"
    espBtn.BackgroundColor3 = espEnabled and Color3.fromRGB(64,149,33) or Color3.fromRGB(60,60,90)

    -- Limpa todos os Billboards antes
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local bb = plr.Character:FindFirstChild("ESPName")
            if bb then bb:Destroy() end
        end
    end

    if espEnabled then
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") then
                local bb = Instance.new("BillboardGui", plr.Character.Head)
                bb.Name = "ESPName"
                bb.Size = UDim2.new(0,100,0,30)
                bb.AlwaysOnTop = true
                bb.StudsOffset = Vector3.new(0,2.5,0)
                local lbl = Instance.new("TextLabel", bb)
                lbl.Size = UDim2.new(1,0,1,0)
                lbl.BackgroundTransparency = 1
                lbl.TextColor3 = Color3.fromRGB(255,255,0)
                lbl.TextStrokeTransparency = 0.25
                lbl.Text = plr.Name
                lbl.TextScaled = true
                lbl.Font = Enum.Font.GothamBold
            end
        end
    end
end)
Players.PlayerAdded:Connect(function(plr)
    if espEnabled then
        plr.CharacterAdded:Connect(function(char)
            local head = char:WaitForChild("Head",5)
            if head then
                local bb = Instance.new("BillboardGui", head)
                bb.Name = "ESPName"
                bb.Size = UDim2.new(0,100,0,30)
                bb.AlwaysOnTop = true
                bb.StudsOffset = Vector3.new(0,2.5,0)
                local lbl = Instance.new("TextLabel", bb)
                lbl.Size = UDim2.new(1,0,1,0)
                lbl.BackgroundTransparency = 1
                lbl.TextColor3 = Color3.fromRGB(255,255,0)
                lbl.TextStrokeTransparency = 0.25
                lbl.Text = plr.Name
                lbl.TextScaled = true
                lbl.Font = Enum.Font.GothamBold
            end
        end)
    end
end)
Players.PlayerRemoving:Connect(function(plr)
    if plr.Character then
        local bb = plr.Character:FindFirstChild("ESPName", true)
        if bb then bb:Destroy() end
    end
end)

-----------------
-- DRAG (mobile)
-----------------
local dragging, dragInput, dragStart, startPos
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
-- FIM
