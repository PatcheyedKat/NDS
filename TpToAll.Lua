-- LoopTp by PatchEyedkat
-- Great for using with Infinite Yield FlyFling, Make sure you have a Godmode Script unless you want to constantly keep dying

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local teleporting = false
local healConnection

-- GUI Setup
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TPGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 100)
frame.Position = UDim2.new(0, 10, 0, 10)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.BorderSizePixel = 0
frame.Active = true  -- Needed for drag
frame.Parent = screenGui

-- Dragging variables
local dragging = false
local dragInput, dragStart, startPos

-- Drag functions
frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or
       input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or
       input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

-- Label
local label = Instance.new("TextLabel")
label.Size = UDim2.new(1, 0, 0.5, 0)
label.Position = UDim2.new(0, 0, 0, 0)
label.BackgroundTransparency = 1
label.Text = "TP To All"
label.TextColor3 = Color3.fromRGB(255, 255, 255)
label.TextScaled = true
label.Font = Enum.Font.SourceSansBold
label.Parent = frame

-- Toggle Button
local button = Instance.new("TextButton")
button.Size = UDim2.new(1, 0, 0.5, 0)
button.Position = UDim2.new(0, 0, 0.5, 0)
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.Text = "OFF"
button.TextScaled = true
button.Font = Enum.Font.SourceSansBold
button.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- Red when off
button.Parent = frame

-- Setup invincibility
local function enableInvincibility()
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        -- Restore health on damage
        healConnection = humanoid.HealthChanged:Connect(function()
            if teleporting and humanoid.Health < humanoid.MaxHealth then
                humanoid.Health = humanoid.MaxHealth
            end
        end)
        humanoid.Health = humanoid.MaxHealth
    end
end

local function disableInvincibility()
    if healConnection then
        healConnection:Disconnect()
        healConnection = nil
    end
end

-- Toggle teleporting and update button color
button.MouseButton1Click:Connect(function()
    teleporting = not teleporting
    if teleporting then
        button.Text = "ON"
        button.BackgroundColor3 = Color3.fromRGB(0, 255, 0) -- Green when on
        enableInvincibility()
	    SendChatMessage("GET READY TO GET ANNIAHLATED")
    else
        button.Text = "OFF"
        button.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- Red when off
        disableInvincibility()
    end
end)

-- Teleport function (to exact center)
local function teleportToPlayer(targetPlayer)
    if targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") and
       LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame
    end
end

-- Looping teleport
task.spawn(function()
    while true do
        if teleporting then
            for _, player in pairs(Players:GetPlayers()) do
                if not teleporting then break end
                if player ~= LocalPlayer then
                    -- Teleport to this player every 100ms for 1 second
                    local elapsed = 0
                    while teleporting and elapsed < 0.5 do
                        teleportToPlayer(player)
                        task.wait(0.1)
                        elapsed = elapsed + 0.1
                    end
                end
            end
        end
        task.wait(0.1)
    end
end)

SendChatMessage("TPFLING script by PatchEyedKat")
