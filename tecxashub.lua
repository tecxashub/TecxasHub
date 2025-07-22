-- Tecxas Hub completo com UI própria para Xeno
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Cria a GUI principal
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TecxasHubGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Função para criar um botão
local function createButton(text, pos, parent)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 140, 0, 35)
    btn.Position = pos
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.BorderColor3 = Color3.new(0,0,0)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 16
    btn.Text = text
    btn.Parent = parent
    btn.AutoButtonColor = true
    return btn
end

-- Função para criar um texto de status
local function createStatusText(text, pos, parent)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 120, 0, 25)
    label.Position = pos
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(150, 150, 150)
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.Text = text
    label.Parent = parent
    return label
end

-- Cria painel lateral para categorias
local panel = Instance.new("Frame")
panel.Size = UDim2.new(0, 160, 0, 300)
panel.Position = UDim2.new(0, 10, 0, 50)
panel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
panel.BorderSizePixel = 0
panel.Parent = screenGui

-- Título
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
title.BorderSizePixel = 0
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.Text = "Tecxas Hub"
title.Parent = panel

-- Container para os conteúdos de cada categoria
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(0, 400, 0, 300)
contentFrame.Position = UDim2.new(0, 180, 0, 50)
contentFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
contentFrame.BorderSizePixel = 0
contentFrame.Parent = screenGui

-- Função para limpar contentFrame
local function clearContent()
    for _,v in pairs(contentFrame:GetChildren()) do
        if not v:IsA("UIListLayout") then
            v:Destroy()
        end
    end
end

-- Layout para organizar botões verticalmente
local listLayout = Instance.new("UIListLayout")
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Padding = UDim.new(0, 6)
listLayout.Parent = contentFrame

-- === Variables for states ===

local states = {
    AutoJump = false,
    WalkSpeed = 16,
    JumpPower = 50,
    SpeedBoost = false,
    Brilho = false,
    ESPBrainots = false,
    InfiniteJump = false,
    TeleportToBrainot = false,
}

-- === Player Category UI & Functions ===

local function setupPlayerUI()
    clearContent()
    local header = Instance.new("TextLabel")
    header.Size = UDim2.new(1, 0, 0, 30)
    header.BackgroundTransparency = 1
    header.TextColor3 = Color3.new(1,1,1)
    header.Font = Enum.Font.GothamBold
    header.TextSize = 18
    header.Text = "Player"
    header.Parent = contentFrame

    -- Auto Jump
    local btnAutoJump = createButton("Toggle AutoJump", UDim2.new(0, 0, 0, 0), contentFrame)
    local statusAutoJump = createStatusText("Status: Off", UDim2.new(0, 150, 0, 5), contentFrame)

    btnAutoJump.MouseButton1Click:Connect(function()
        states.AutoJump = not states.AutoJump
        statusAutoJump.Text = "Status: " .. (states.AutoJump and "On" or "Off")

        if states.AutoJump then
            spawn(function()
                while states.AutoJump do
                    wait(0.7)
                    local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        humanoid.Jump = true
                    end
                end
            end)
        end
    end)

    -- WalkSpeed Slider
    local speedLabel = Instance.new("TextLabel")
    speedLabel.Size = UDim2.new(0, 250, 0, 25)
    speedLabel.BackgroundTransparency = 1
    speedLabel.TextColor3 = Color3.new(1,1,1)
    speedLabel.Font = Enum.Font.Gotham
    speedLabel.TextSize = 16
    speedLabel.Text = "WalkSpeed: " .. states.WalkSpeed
    speedLabel.Parent = contentFrame

    local speedSlider = Instance.new("TextBox")
    speedSlider.Size = UDim2.new(0, 250, 0, 30)
    speedSlider.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    speedSlider.TextColor3 = Color3.new(1,1,1)
    speedSlider.Font = Enum.Font.Gotham
    speedSlider.TextSize = 18
    speedSlider.Text = tostring(states.WalkSpeed)
    speedSlider.ClearTextOnFocus = false
    speedSlider.Parent = contentFrame

    speedSlider.FocusLost:Connect(function(enterPressed)
        local num = tonumber(speedSlider.Text)
        if num and num >= 16 and num <= 100 then
            states.WalkSpeed = num
            speedLabel.Text = "WalkSpeed: " .. num
            local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = num
            end
        else
            speedSlider.Text = tostring(states.WalkSpeed)
        end
    end)

    -- JumpPower Slider
    local jumpLabel = Instance.new("TextLabel")
    jumpLabel.Size = UDim2.new(0, 250, 0, 25)
    jumpLabel.BackgroundTransparency = 1
    jumpLabel.TextColor3 = Color3.new(1,1,1)
    jumpLabel.Font = Enum.Font.Gotham
    jumpLabel.TextSize = 16
    jumpLabel.Text = "JumpPower: " .. states.JumpPower
    jumpLabel.Parent = contentFrame

    local jumpSlider = Instance.new("TextBox")
    jumpSlider.Size = UDim2.new(0, 250, 0, 30)
    jumpSlider.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    jumpSlider.TextColor3 = Color3.new(1,1,1)
    jumpSlider.Font = Enum.Font.Gotham
    jumpSlider.TextSize = 18
    jumpSlider.Text = tostring(states.JumpPower)
    jumpSlider.ClearTextOnFocus = false
    jumpSlider.Parent = contentFrame

    jumpSlider.FocusLost:Connect(function(enterPressed)
        local num = tonumber(jumpSlider.Text)
        if num and num >= 50 and num <= 200 then
            states.JumpPower = num
            jumpLabel.Text = "JumpPower: " .. num
            local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.JumpPower = num
            end
        else
            jumpSlider.Text = tostring(states.JumpPower)
        end
    end)

    -- SpeedBoost toggle
    local btnSpeedBoost = createButton("Toggle SpeedBoost (x2)", UDim2.new(0, 0, 0, 0), contentFrame)
    local statusSpeedBoost = createStatusText("Status: Off", UDim2.new(0, 150, 0, 5), contentFrame)

    btnSpeedBoost.MouseButton1Click:Connect(function()
        states.SpeedBoost = not states.SpeedBoost
        statusSpeedBoost.Text = "Status: " .. (states.SpeedBoost and "On" or "Off")
        local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            if states.SpeedBoost then
                humanoid.WalkSpeed = states.WalkSpeed * 2
            else
                humanoid.WalkSpeed = states.WalkSpeed
            end
        end
    end)
end

-- === Visual Category UI & Functions ===

local function setupVisualUI()
    clearContent()
    local header = Instance.new("TextLabel")
    header.Size = UDim2.new(1, 0, 0, 30)
    header.BackgroundTransparency = 1
    header.TextColor3 = Color3.new(1,1,1)
    header.Font = Enum.Font.GothamBold
    header.TextSize = 18
    header.Text = "Visual"
    header.Parent = contentFrame

    -- Toggle Brilho (neon material)
    local btnBrilho = createButton("Toggle Brilho (Neon)", UDim2.new(0,0,0,0), contentFrame)
    local statusBrilho = createStatusText("Status: Off", UDim2.new(0,150,0,5), contentFrame)

    btnBrilho.MouseButton1Click:Connect(function()
        states.Brilho = not states.Brilho
        statusBrilho.Text = "Status: " .. (states.Brilho and "On" or "Off")
        local char = LocalPlayer.Character
        if char then
            for _, part in pairs(char:GetChildren()) do
                if part:IsA("BasePart") then
                    part.Material = states.Brilho and Enum.Material.Neon or Enum.Material.Plastic
                end
            end
        end
    end)
end

-- === Brainot Category UI & Functions ===

local brainotHighlights = {}

local function createESPForBrainots()
    local brainotsFolder = workspace:FindFirstChild("Brainots")
    if not brainotsFolder then return end

    -- Limpa ESP antigo
    for _, highlight in pairs(brainotHighlights) do
        highlight:Destroy()
    end
    brainotHighlights = {}

    for _, brainot in pairs(brainotsFolder:GetChildren()) do
        if brainot:IsA("BasePart") then
            local hl = Instance.new("Highlight")
            hl.Adornee = brainot
            hl.FillColor = Color3.fromRGB(255, 0, 0)
            hl.OutlineColor = Color3.fromRGB(255, 255, 255)
            hl.Parent = workspace
            table.insert(brainotHighlights, hl)
        end
    end
end

local function clearESP()
    for _, hl in pairs(brainotHighlights) do
        hl:Destroy()
    end
    brainotHighlights = {}
end

local function setupBrainotUI()
    clearContent()
    local header = Instance.new("TextLabel")
    header.Size = UDim2.new(1,0,0,30)
    header.BackgroundTransparency = 1
    header.TextColor3 = Color3.new(1,1,1)
    header.Font = Enum.Font.GothamBold
    header.TextSize = 18
    header.Text = "Brainot"
    header.Parent = contentFrame

    -- Toggle ESP Brainots
    local btnESP = createButton("Toggle ESP Brainots", UDim2.new(0,0,0,0), contentFrame)
    local statusESP = createStatusText("Status: Off", UDim2.new(0,150,0,5), contentFrame)

    btnESP.MouseButton1Click:Connect(function()
        states.ESPBrainots = not states.ESPBrainots
        statusESP.Text = "Status: " .. (states.ESPBrainots and "On" or "Off")
        if states.ESPBrainots then
            createESPForBrainots()
        else
            clearESP()
        end
    end)

    -- Teleport para Brainot (exemplo: teleporta para o primeiro Brainot)
    local btnTeleport = createButton("Teleport p/ Brainot", UDim2.new(0,0,0,0), contentFrame)

    btnTeleport.MouseButton1Click:Connect(function()
        local brainotsFolder = workspace:FindFirstChild("Brainots")
        if brainotsFolder and brainotsFolder:GetChildren()[1] then
            local target = brainotsFolder:GetChildren()[1]
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.CFrame = target.CFrame + Vector3.new(0, 5, 0)
            end
        end
    end)
end

-- === Script Category UI & Functions ===

local function setupScriptUI()
    clearContent()
    local header = Instance.new("TextLabel")
    header.Size = UDim2.new(1,0,0,30)
    header.BackgroundTransparency = 1
    header.TextColor3 = Color3.new(1,1,1)
    header.Font = Enum.Font.GothamBold
    header.TextSize = 18
    header.Text = "Script"
    header.Parent = contentFrame

    -- Infinite Jump toggle
    local btnInfJump = createButton("Toggle Infinite Jump", UDim2.new(0,0,0,0), contentFrame)
    local statusInfJump = createStatusText("Status: Off", UDim2.new(0,150,0,5), contentFrame)

    local infJumpConn

    btnInfJump.MouseButton1Click:Connect(function()
        if states.InfiniteJump then
            states.InfiniteJump = false
            statusInfJump.Text = "Status: Off"
            if infJumpConn then
                infJumpConn:Disconnect()
                infJumpConn = nil
            end
        else
            states.InfiniteJump = true
            statusInfJump.Text = "Status: On"
            infJumpConn = game:GetService("UserInputService").JumpRequest:Connect(function()
                local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.Jump = true
                end
            end)
        end
    end)

    -- Botão para rodar todas as funções (exemplo)
    local btnAll = createButton("Ativar Todas Funções", UDim2.new(0,0,0,0), contentFrame)
    btnAll.MouseButton1Click:Connect(function()
        -- Ativa AutoJump
        if not states.AutoJump then
            states.AutoJump = true
            spawn(function()
                while states.AutoJump do
                    wait(0.7)
                    local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        humanoid.Jump = true
                    end
                end
            end)
        end
        -- Ativa brilho
        states.Brilho = true
        local char = LocalPlayer.Character
        if char then
            for _, part in pairs(char:GetChildren()) do
                if part:IsA("BasePart") then
                    part.Material = Enum.Material.Neon
                end
            end
        end
        -- Ativa ESP Brainots
        if not states.ESPBrainots then
            states.ESPBrainots = true
            createESPForBrainots()
        end
        -- Ativa Infinite Jump
        if not states.InfiniteJump then
            states.InfiniteJump = true
            infJumpConn = game:GetService("UserInputService").JumpRequest:Connect(function()
                local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.Jump = true
                end
            end)
        end
        Notify("Script", "Todas as funções ativadas!")
    end)
end

-- === Menu lateral botões ===

local btnPlayer = createButton("Player", UDim2.new(0, 10, 0, 50), panel)
local btnVisual = createButton("Visual", UDim2.new(0, 10, 0, 95), panel)
local btnBrainot = createButton("Brainot", UDim2.new(0, 10, 0, 140), panel)
local btnScript = createButton("Script", UDim2.new(0, 10, 0, 185), panel)

btnPlayer.MouseButton1Click:Connect(setupPlayerUI)
btnVisual.MouseButton1Click:Connect(setupVisualUI)
btnBrainot.MouseButton1Click:Connect(setupBrainotUI)
btnScript.MouseButton1Click:Connect(setupScriptUI)

-- Inicializa com Player
setupPlayerUI()

-- Função para notificações rápidas
function Notify(title,text)
    pcall(function()
        game.StarterGui:SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = 4,
        })
    end)
end
