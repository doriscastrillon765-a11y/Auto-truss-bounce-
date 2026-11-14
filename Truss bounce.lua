
-- AUTO TRUSS BOUNCE
-- LocalScript en StarterPlayerScripts

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

local enabled = false
local lastJump = 0
local cooldown = 0.7

-- Interfaz
local gui = Instance.new("ScreenGui")
gui.Name = "AutoTrussBounce"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 220, 0, 110)
frame.Position = UDim2.new(0.5, -110, 0.5, -55)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
frame.BorderSizePixel = 0
frame.Active = true
frame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 38)
title.BackgroundTransparency = 1
title.Text = "AUTO TRUSS BOUNCE"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.TextSize = 16
title.Font = Enum.Font.GothamBold
title.Parent = frame

local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 180, 0, 40)
button.Position = UDim2.new(0.5, -90, 0, 55)
button.BackgroundColor3 = Color3.fromRGB(180, 45, 45)
button.Text = "OFF"
button.TextColor3 = Color3.new(1,1,1)
button.TextSize = 18
button.Font = Enum.Font.GothamBold
button.Parent = frame

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 8)
btnCorner.Parent = button

-- Activar / desactivar
button.MouseButton1Click:Connect(function()
    enabled = not enabled

    if enabled then
        button.Text = "ON"
        button.BackgroundColor3 = Color3.fromRGB(35, 170, 85)
    else
        button.Text = "OFF"
        button.BackgroundColor3 = Color3.fromRGB(180, 45, 45)
    end
end)

-- Movimiento de ventana
local dragging = false
local dragStart
local startPos
local dragInput

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and (
        input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch
    ) then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- Auto Truss Bounce
RunService.Heartbeat:Connect(function()
    if not enabled then return end

    local character = player.Character
    if not character then return end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end

    if humanoid:GetState() == Enum.HumanoidStateType.Climbing then
        if os.clock() - lastJump >= cooldown then
            lastJump = os.clock()
            humanoid.Jump = true
        end
    end
end)
