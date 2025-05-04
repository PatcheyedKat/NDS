-- --------------------------------------------------------
-- LoopTp by PatchEyedKat V2
-- V2 Added: TP by player name via TextBox and button
-- Demo: https://imgur.com/a/SxI36M3
-- --------------------------------------------------------

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local teleporting = false
local healConnection

local function playSound(soundId)
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://" .. tostring(soundId)
    sound.Volume = 1
    sound.PlayOnRemove = true
    sound.Parent = workspace
    sound:Destroy()
end

playSound(18892783765) -- Creation sound

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TPGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 260, 0, 180)
frame.Position = UDim2.new(0.5, -130, 0.5, -90)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local uicorner = Instance.new("UICorner")
uicorner.CornerRadius = UDim.new(0, 10)
uicorner.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "TP To All"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = frame

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 20, 0, 20)
closeBtn.Position = UDim2.new(1, -25, 0, 5)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
closeBtn.BackgroundTransparency = 1
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.TextScaled = true
closeBtn.Parent = frame

local allBtn = Instance.new("TextButton")
allBtn.Size = UDim2.new(1, -20, 0, 40)
allBtn.Position = UDim2.new(0, 10, 0, 40)
allBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
allBtn.Text = "OFF"
allBtn.TextScaled = true
allBtn.Font = Enum.Font.GothamBold
allBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
allBtn.BorderSizePixel = 0
allBtn.Parent = frame

local allCorner = Instance.new("UICorner")
allCorner.CornerRadius = UDim.new(0, 8)
allCorner.Parent = allBtn

local nameBox = Instance.new("TextBox")
nameBox.Size = UDim2.new(1, -20, 0, 30)
nameBox.Position = UDim2.new(0, 10, 0, 90)
nameBox.PlaceholderText = "Enter player name"
nameBox.Text = ""
nameBox.TextColor3 = Color3.fromRGB(255,255,255)
nameBox.TextScaled = true
nameBox.Font = Enum.Font.Gotham
nameBox.BackgroundColor3 = Color3.fromRGB(50,50,50)
nameBox.BorderSizePixel = 0
nameBox.Parent = frame

local nameCorner = Instance.new("UICorner")
nameCorner.CornerRadius = UDim.new(0, 6)
nameCorner.Parent = nameBox

local nameBtn = Instance.new("TextButton")
nameBtn.Size = UDim2.new(1, -20, 0, 30)
nameBtn.Position = UDim2.new(0, 10, 0, 130)
nameBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
nameBtn.Text = "TP To Name"
nameBtn.TextScaled = true
nameBtn.Font = Enum.Font.GothamBold
nameBtn.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
nameBtn.BorderSizePixel = 0
nameBtn.Parent = frame

local nameBtnCorner = Instance.new("UICorner")
nameBtnCorner.CornerRadius = UDim.new(0, 8)
nameBtnCorner.Parent = nameBtn

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

allBtn.MouseButton1Click:Connect(function()
    teleporting = not teleporting
    if teleporting then
        allBtn.Text = "ON"
        allBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        enableInvincibility()
    else
        allBtn.Text = "OFF"
        allBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        disableInvincibility()
    end
end)

closeBtn.MouseButton1Click:Connect(function()
    teleporting = false
    disableInvincibility()
    playSound(9066167010)
    screenGui:Destroy()
end)

local function teleportToPlayer(targetPlayer)
    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart")
       and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame
    end
end

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

nameBtn.MouseButton1Click:Connect(function()
    local targetName = nameBox.Text:match("^%s*(.-)%s*$")
    if targetName and #targetName > 0 then
        local target = Players:FindFirstChild(targetName)
        if target then
            teleportToPlayer(target)
            playSound(18892783765) -- feedback sound
        else
            -- optional: display message
            warn("Player '" .. targetName .. "' not found.")
        end
    end
end)
