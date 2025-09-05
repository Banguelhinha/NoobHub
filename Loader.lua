-- Script VIP com Menu Delta Style
-- Substitua GAMEPASS_ID pelo ID da sua gamepass
local GAMEPASS_ID = 1446832551 -- ID da sua gamepass

local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Variáveis de controle
local hasGamepass = false
local isFloating = false
local floatHeight = 50
local floatConnection = nil
local speedBoost = 16
local jumpBoost = 50
local originalSpeed = 16
local originalJump = 50
local savedPosition = nil
local gui = nil

-- Verificar gamepass
local function checkGamepass()
    local success, owns = pcall(function()
        return MarketplaceService:UserOwnsGamePassAsync(player.UserId, GAMEPASS_ID)
    end)
    
    if success and owns then
        hasGamepass = true
        return true
    else
        return false
    end
end

-- Criar notificação
local function createNotification(text, color)
    local notification = Instance.new("ScreenGui")
    notification.Name = "VIPNotification"
    notification.Parent = playerGui
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 300, 0, 60)
    frame.Position = UDim2.new(1, -320, 0, 20)
    frame.BackgroundColor3 = color or Color3.fromRGB(40, 40, 40)
    frame.BorderSizePixel = 0
    frame.Parent = notification
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, -20, 1, 0)
    textLabel.Position = UDim2.new(0, 10, 0, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = text
    textLabel.TextColor3 = Color3.new(1, 1, 1)
    textLabel.TextScaled = true
    textLabel.Font = Enum.Font.GothamBold
    textLabel.Parent = frame
    
    -- Animação
    frame:TweenPosition(UDim2.new(1, -320, 0, 20), "Out", "Quad", 0.5, true)
    wait(3)
    frame:TweenPosition(UDim2.new(1, 0, 0, 20), "In", "Quad", 0.5, true)
    wait(0.5)
    notification:Destroy()
end

-- Criar GUI principal
local function createGUI()
    gui = Instance.new("ScreenGui")
    gui.Name = "VIPScript"
    gui.Parent = playerGui
    gui.ResetOnSpawn = false
    
    -- Frame principal
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 400, 0, 500)
    mainFrame.Position = UDim2.new(0.5, -200, 0.5, -250)
    mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = gui
    mainFrame.Active = true
    mainFrame.Draggable = true
    
    -- Corner radius
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 12)
    mainCorner.Parent = mainFrame
    
    -- Barra superior
    local topBar = Instance.new("Frame")
    topBar.Size = UDim2.new(1, 0, 0, 40)
    topBar.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    topBar.BorderSizePixel = 0
    topBar.Parent = mainFrame
    
    local topCorner = Instance.new("UICorner")
    topCorner.CornerRadius = UDim.new(0, 12)
    topCorner.Parent = topBar
    
    -- Título
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -80, 1, 0)
    title.Position = UDim2.new(0, 15, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "VIP SCRIPT v1.0"
    title.TextColor3 = Color3.fromRGB(120, 180, 255)
    title.TextSize = 16
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = topBar
    
    -- Botão fechar
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -35, 0, 5)
    closeBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
    closeBtn.Text = "×"
    closeBtn.TextColor3 = Color3.new(1, 1, 1)
    closeBtn.TextSize = 18
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.BorderSizePixel = 0
    closeBtn.Parent = topBar
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 6)
    closeCorner.Parent = closeBtn
    
    closeBtn.MouseButton1Click:Connect(function()
        gui:Destroy()
    end)
    
    -- Container de conteúdo
    local contentFrame = Instance.new("Frame")
    contentFrame.Size = UDim2.new(1, -20, 1, -60)
    contentFrame.Position = UDim2.new(0, 10, 0, 50)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Parent = mainFrame
    
    -- Função para criar botão
    local function createButton(text, position, callback, color)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -20, 0, 35)
        btn.Position = position
        btn.BackgroundColor3 = color or Color3.fromRGB(45, 45, 60)
        btn.Text = text
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.TextSize = 14
        btn.Font = Enum.Font.Gotham
        btn.BorderSizePixel = 0
        btn.Parent = contentFrame
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 6)
        btnCorner.Parent = btn
        
        -- Efeito hover
        btn.MouseEnter:Connect(function()
            btn:TweenSize(UDim2.new(1, -15, 0, 35), "Out", "Quad", 0.2, true)
        end)
        
        btn.MouseLeave:Connect(function()
            btn:TweenSize(UDim2.new(1, -20, 0, 35), "Out", "Quad", 0.2, true)
        end)
        
        btn.MouseButton1Click:Connect(callback)
        return btn
    end
    
    -- Função para criar slider
    local function createSlider(text, min, max, default, position, callback)
        local sliderFrame = Instance.new("Frame")
        sliderFrame.Size = UDim2.new(1, -20, 0, 60)
        sliderFrame.Position = position
        sliderFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
        sliderFrame.BorderSizePixel = 0
        sliderFrame.Parent = contentFrame
        
        local sliderCorner = Instance.new("UICorner")
        sliderCorner.CornerRadius = UDim.new(0, 8)
        sliderCorner.Parent = sliderFrame
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -10, 0, 25)
        label.Position = UDim2.new(0, 5, 0, 5)
        label.BackgroundTransparency = 1
        label.Text = text .. ": " .. default
        label.TextColor3 = Color3.new(1, 1, 1)
        label.TextSize = 12
        label.Font = Enum.Font.Gotham
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = sliderFrame
        
        local sliderBg = Instance.new("Frame")
        sliderBg.Size = UDim2.new(1, -20, 0, 20)
        sliderBg.Position = UDim2.new(0, 10, 0, 30)
        sliderBg.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
        sliderBg.BorderSizePixel = 0
        sliderBg.Parent = sliderFrame
        
        local bgCorner = Instance.new("UICorner")
        bgCorner.CornerRadius = UDim.new(0, 10)
        bgCorner.Parent = sliderBg
        
        local sliderBtn = Instance.new("TextButton")
        sliderBtn.Size = UDim2.new(0, 20, 1, 0)
        sliderBtn.Position = UDim2.new((default - min) / (max - min), -10, 0, 0)
        sliderBtn.BackgroundColor3 = Color3.fromRGB(120, 180, 255)
        sliderBtn.Text = ""
        sliderBtn.BorderSizePixel = 0
        sliderBtn.Parent = sliderBg
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 10)
        btnCorner.Parent = sliderBtn
        
        local dragging = false
        
        sliderBtn.MouseButton1Down:Connect(function()
            dragging = true
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local mouse = Players.LocalPlayer:GetMouse()
                local percent = math.clamp((mouse.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
                sliderBtn.Position = UDim2.new(percent, -10, 0, 0)
                local value = math.floor(min + (max - min) * percent)
                label.Text = text .. ": " .. value
                callback(value)
            end
        end)
    end
    
    -- Botões principais
    createButton("🌟 FLOAT", UDim2.new(0, 10, 0, 10), function()
        toggleFloat()
    end, Color3.fromRGB(70, 130, 255))
    
    createButton("📍 SAVE POSITION", UDim2.new(0, 10, 0, 55), function()
        savePosition()
    end, Color3.fromRGB(50, 200, 100))
    
    createButton("🚀 TELEPORT TO SAVED", UDim2.new(0, 10, 0, 100), function()
        teleportToSaved()
    end, Color3.fromRGB(255, 150, 50))
    
    -- Sliders
    createSlider("Speed", 16, 100, speedBoost, UDim2.new(0, 10, 0, 150), function(value)
        speedBoost = value
        updateSpeed()
    end)
    
    createSlider("Jump Power", 50, 200, jumpBoost, UDim2.new(0, 10, 0, 220), function(value)
        jumpBoost = value
        updateJump()
    end)
    
    createSlider("Float Height", 10, 100, floatHeight, UDim2.new(0, 10, 0, 290), function(value)
        floatHeight = value
    end)
    
    -- Info
    local infoLabel = Instance.new("TextLabel")
    infoLabel.Size = UDim2.new(1, -20, 0, 80)
    infoLabel.Position = UDim2.new(0, 10, 0, 360)
    infoLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    infoLabel.Text = "VIP SCRIPT ATIVO\n\nFloat: Flutua na altura configurada\nSave/TP: Salva e teleporta posições\nSliders: Configure velocidade e pulo"
    infoLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    infoLabel.TextSize = 10
    infoLabel.Font = Enum.Font.Gotham
    infoLabel.TextYAlignment = Enum.TextYAlignment.Top
    infoLabel.BorderSizePixel = 0
    infoLabel.Parent = contentFrame
    
    local infoCorner = Instance.new("UICorner")
    infoCorner.CornerRadius = UDim.new(0, 8)
    infoCorner.Parent = infoLabel
end

-- Funções do script
function toggleFloat()
    if not hasGamepass then
        createNotification("❌ Você precisa da Gamepass VIP!", Color3.fromRGB(220, 50, 50))
        return
    end
    
    isFloating = not isFloating
    
    if isFloating then
        local character = player.Character
        if character then
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            if rootPart then
                local bodyVelocity = Instance.new("BodyVelocity")
                bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
                bodyVelocity.Velocity = Vector3.new(0, 0, 0)
                bodyVelocity.Parent = rootPart
                
                local bodyPosition = Instance.new("BodyPosition")
                bodyPosition.MaxForce = Vector3.new(4000, 4000, 4000)
                bodyPosition.Position = rootPart.Position + Vector3.new(0, floatHeight, 0)
                bodyPosition.Parent = rootPart
                
                floatConnection = RunService.Heartbeat:Connect(function()
                    if rootPart and bodyPosition then
                        bodyPosition.Position = Vector3.new(rootPart.Position.X, rootPart.Position.Y, rootPart.Position.Z)
                    end
                end)
                
                createNotification("🌟 Float ativado!", Color3.fromRGB(70, 130, 255))
            end
        end
    else
        if floatConnection then
            floatConnection:Disconnect()
            floatConnection = nil
        end
        
        local character = player.Character
        if character then
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            if rootPart then
                for _, obj in pairs(rootPart:GetChildren()) do
                    if obj:IsA("BodyVelocity") or obj:IsA("BodyPosition") then
                        obj:Destroy()
                    end
                end
            end
        end
        
        createNotification("🌟 Float desativado!", Color3.fromRGB(255, 100, 100))
    end
end

function savePosition()
    if not hasGamepass then
        createNotification("❌ Você precisa da Gamepass VIP!", Color3.fromRGB(220, 50, 50))
        return
    end
    
    local character = player.Character
    if character then
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        if rootPart then
            savedPosition = rootPart.Position
            createNotification("📍 Posição salva!", Color3.fromRGB(50, 200, 100))
        end
    end
end

function teleportToSaved()
    if not hasGamepass then
        createNotification("❌ Você precisa da Gamepass VIP!", Color3.fromRGB(220, 50, 50))
        return
    end
    
    if not savedPosition then
        createNotification("❌ Nenhuma posição salva!", Color3.fromRGB(220, 50, 50))
        return
    end
    
    local character = player.Character
    if character then
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        if rootPart then
            rootPart.CFrame = CFrame.new(savedPosition)
            createNotification("🚀 Teleportado!", Color3.fromRGB(255, 150, 50))
        end
    end
end

function updateSpeed()
    if not hasGamepass then return end
    
    local character = player.Character
    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = speedBoost
        end
    end
end

function updateJump()
    if not hasGamepass then return end
    
    local character = player.Character
    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            if humanoid.JumpPower then
                humanoid.JumpPower = jumpBoost
            elseif humanoid.JumpHeight then
                humanoid.JumpHeight = jumpBoost
            end
        end
    end
end

-- Atualizar quando respawnar
player.CharacterAdded:Connect(function(character)
    wait(1)
    updateSpeed()
    updateJump()
end)

-- Inicializar
if checkGamepass() then
    createGUI()
    createNotification("✅ VIP Script carregado com sucesso!", Color3.fromRGB(50, 200, 100))
    
    -- Aplicar configurações iniciais
    wait(2)
    updateSpeed()
    updateJump()
else
    createNotification("❌ Gamepass VIP necessária! ID: " .. GAMEPASS_ID, Color3.fromRGB(220, 50, 50))
end

-- Keybind para abrir/fechar (Insert)
UserInputService.InputBegan:Connect(function(key, gameProcessed)
    if gameProcessed then return end
    
    if key.KeyCode == Enum.KeyCode.Insert then
        if hasGamepass then
            if gui and gui.Parent then
                if gui.MainFrame.Visible then
                    gui.MainFrame.Visible = false
                else
                    gui.MainFrame.Visible = true
                end
            else
                createGUI()
            end
        else
            -- Se não tem gamepass, mostrar GUI de compra
            createPurchaseGUI()
        end
    end
end)

-- Função para re-verificar gamepass (caso compre durante o jogo)
local function recheckGamepass()
    if checkGamepass() and not hasGamepass then
        hasGamepass = true
        
        -- Fechar GUI de compra se estiver aberta
        local purchaseGui = playerGui:FindFirstChild("GamepassPurchase")
        if purchaseGui then
            purchaseGui:Destroy()
        end
        
        -- Abrir GUI principal
        createGUI()
        createNotification("🎉 Gamepass detectada! Bem-vindo ao VIP!", Color3.fromRGB(50, 200, 100))
    end
end

-- Verificar gamepass a cada 30 segundos
spawn(function()
    while true do
        wait(30)
        recheckGamepass()
    end
end)
