-- LoopTp by PatchEyedKat
-- Great for using with Infinite Yield FlyFling

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local teleporting = false
local healConnection

-- Sound function
local function playSound(soundId)
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://" .. tostring(soundId)
    sound.Volume = 1
    sound.PlayOnRemove = true
    sound.Parent = workspace
    sound:Destroy()
end

-- GUI Setup
playSound(18892783765) -- Creation sound

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TPGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 220, 0, 130)
frame.Position = UDim2.new(0.5, -110, 0.5, -65) -- Center of the screen
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

-- Round corners
local uicorner = Instance.new("UICorner")
uicorner.CornerRadius = UDim.new(0, 10)
uicorner.Parent = frame

-- Title Label
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "TP To All"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = frame

-- Delete (Close) Button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 20, 0, 20)
closeBtn.Position = UDim2.new(1, -25, 0, 5)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
closeBtn.BackgroundTransparency = 1
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.TextScaled = true
closeBtn.Parent = frame

-- Toggle Button
local button = Instance.new("TextButton")
button.Size = UDim2.new(1, -20, 0, 40)
button.Position = UDim2.new(0, 10, 0, 70)
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.Text = "OFF"
button.TextScaled = true
button.Font = Enum.Font.GothamBold
button.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
button.BorderSizePixel = 0
button.Parent = frame

-- Round corners for button
local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 8)
btnCorner.Parent = button

-- Toggle invincibility
local function enableInvincibility()
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
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

-- Toggle teleporting and update button
button.MouseButton1Click:Connect(function()
    teleporting = not teleporting
    if teleporting then
        button.Text = "ON"
        button.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        enableInvincibility()
        -- Optional chat message, uncomment if desired
        -- game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer("GET READY TO GET ANNIAHLATED", "All")
    else
        button.Text = "OFF"
        button.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        disableInvincibility()
    end
end)

-- Close button functionality: disable and cleanup
closeBtn.MouseButton1Click:Connect(function()
    teleporting = false
    disableInvincibility()
    playSound(9066167010) -- Deletion sound
    screenGui:Destroy()
end)

-- Teleport function
local function teleportToPlayer(targetPlayer)
    if targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") and
       LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame
    end
end

-- Main loop
spawn(function()
    while true do
        if teleporting then
            for _, player in pairs(Players:GetPlayers()) do
                if not teleporting then break end
                if player ~= LocalPlayer then
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
