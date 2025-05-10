local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local ToggleButton = Instance.new("TextButton")
local TitleLabel = Instance.new("TextLabel")
local DeleteButton = Instance.new("TextButton")

local FrameCorner = Instance.new("UICorner")
local ToggleCorner = Instance.new("UICorner")
local DeleteCorner = Instance.new("UICorner")

ScreenGui.Name = "PatchkatTouchGUI"
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 32, 64)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.35, 0, 0.35, 0)
MainFrame.Size = UDim2.new(0, 200, 0, 120)
MainFrame.Active = true
MainFrame.Draggable = true

FrameCorner.CornerRadius = UDim.new(0, 12)
FrameCorner.Parent = MainFrame

TitleLabel.Name = "TitleLabel"
TitleLabel.Parent = MainFrame
TitleLabel.BackgroundTransparency = 1
TitleLabel.Position = UDim2.new(0.05, 0, 0.05, 0)
TitleLabel.Size = UDim2.new(0, 150, 0, 25)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "Touch Fling"
TitleLabel.TextColor3 = Color3.fromRGB(235, 235, 235)
TitleLabel.TextSize = 24

ToggleButton.Name = "ToggleButton"
ToggleButton.Parent = MainFrame
ToggleButton.BackgroundColor3 = Color3.fromRGB(25, 50, 100)
ToggleButton.BorderSizePixel = 0
ToggleButton.Position = UDim2.new(0.05, 0, 0.4, 0)
ToggleButton.Size = UDim2.new(0, 180, 0, 40)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.Text = "OFF"
ToggleButton.TextColor3 = Color3.fromRGB(235, 235, 235)
ToggleButton.TextSize = 24

ToggleCorner.CornerRadius = UDim.new(0, 8)
ToggleCorner.Parent = ToggleButton

DeleteButton.Name = "DeleteButton"
DeleteButton.Parent = MainFrame
DeleteButton.BackgroundColor3 = Color3.fromRGB(100, 20, 20)
DeleteButton.BorderSizePixel = 0
DeleteButton.Position = UDim2.new(0.85, 0, 0.05, 0)
DeleteButton.Size = UDim2.new(0, 20, 0, 20)
DeleteButton.Font = Enum.Font.GothamBold
DeleteButton.Text = "X"
DeleteButton.TextColor3 = Color3.fromRGB(235, 235, 235)
DeleteButton.TextSize = 18

DeleteCorner.CornerRadius = UDim.new(0, 6)
DeleteCorner.Parent = DeleteButton

spawn(function()
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local RunService = game:GetService("RunService")
    local Players = game:GetService("Players")
    local hiddenFling = false

    if not ReplicatedStorage:FindFirstChild("juisdfj0i32i0eidsuf0iok") then
        local detection = Instance.new("Decal")
        detection.Name = "juisdfj0i32i0eidsuf0iok"
        detection.Parent = ReplicatedStorage
    end

    coroutine.wrap(function()
        local lp = Players.LocalPlayer
        local hrp, vel, movel = nil, nil, 0.1
        while true do
            RunService.Heartbeat:Wait()
            if hiddenFling then
                if not hrp or not hrp.Parent then
                    local char = lp.Character
                    hrp = char and char:FindFirstChild("HumanoidRootPart")
                end
                if hrp then
                    vel = hrp.Velocity
                    hrp.Velocity = vel * 10000 + Vector3.new(0, 10000, 0)
                    RunService.RenderStepped:Wait()
                    hrp.Velocity = vel
                    RunService.Stepped:Wait()
                    hrp.Velocity = vel + Vector3.new(0, movel, 0)
                    movel = movel * -1
                end
            end
        end
    end)()

    ToggleButton.MouseButton1Click:Connect(function()
        hiddenFling = not hiddenFling
        ToggleButton.Text = hiddenFling and "ON" or "OFF"
    end)
end)

DeleteButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)
