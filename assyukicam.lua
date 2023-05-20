--// OK SO THIS CAMLOCK IS REALLY SHITTY
--// its like really bad but wtv it has shake smoothenss and unlocks
--// dont bother skidding unless u want some of the unlocks
--// im pretty sure half of ts dont work but wtv shit was like my 2nd ever script

if nigger == true then
  print('urblack')

local nigger = true

getgenv().yuki = {
    ToggleKey = Enum.KeyCode.Q,
    AimPart = {"HumanoidRootPart"},
    Prediction = 0.119,
    FOV = {
        ShowFOV = true,
        Color = Color3.fromRGB(255, 255, 255),
        Radius = 100,
    },
    Smoothness = true,
    SmoothnessValue = 0.100,
    Shake = true,
    ShakeValue = 35,
    UnlockOnPlayerDeath = true,
    UnlockOnTargetDeath = true,
    UnlockWhenTyping = true,
}
  
if not game:IsLoaded() then
    game.Loaded:Wait()
  end
  

local LocalPlayer = game:GetService("Players").LocalPlayer
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Camera = game:GetService("Workspace").CurrentCamera

local function drawFOV()
    local yuki = getgenv().yuki
    if yuki.FOV.ShowFOV then
        local fovFrame = Instance.new("Frame")
        fovFrame.Name = "FOVFrame"
        fovFrame.Size = UDim2.new(0, yuki.FOV.Radius * 2, 0, yuki.FOV.Radius * 2)
        fovFrame.Position = UDim2.new(0.5, -yuki.FOV.Radius, 0.5, -yuki.FOV.Radius)
        fovFrame.BackgroundTransparency = 1
        fovFrame.Visible = false

        local fovCircle = Instance.new("ImageLabel")
        fovCircle.Name = "FOVCircle"
        -- Set up FOV circle properties (color, size, etc.)
        fovCircle.Parent = fovFrame
    end
end

local function main()
    local yuki = getgenv().yuki
    drawFOV()
    
    local toggleKeyPressed = false
    local locked = false
    local closestPart = nil
    local CTarget = nil
    local CPart = nil

    local function toggleLock()
        locked = not locked
        if locked then
            closestPart = uwuFindPart()
            if closestPart then
                CTarget = closestPart.Parent
            end
        else
            CTarget = nil
        end
    end

    local function unlock()
        CTarget = nil
        locked = false
    end

    local function aimAt(part, smoothness)
        local currentCF = Camera.CFrame
        local targetCF = CFrame.lookAt(currentCF.Position, part.Position)
        
        if smoothness then
            local tweenInfo = TweenInfo.new(smoothness, Enum.EasingStyle.Linear)
            local tween = TweenService:Create(Camera, tweenInfo, {CFrame = targetCF})
            tween:Play()
        else
            Camera.CFrame = targetCF
        end
    end

    local function InRadius(target, section, radius)
        if target then
            local targetPosition = section[1].Position
            local playerPosition = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character.HumanoidRootPart.Position
            
            if targetPosition and playerPosition then
                local distance = (targetPosition - playerPosition).Magnitude
                return distance <= radius
            end
        end
        return false
    end

    local function uwuCheckAnti(targ)
        if targ then
            local humanoidRootPart = targ.Character and targ.Character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                local velocity = humanoidRootPart.Velocity
                local humanoidState = targ.Character.Humanoid:GetState()
                if velocity.Y < -5 and humanoidState ~= Enum.HumanoidStateType.Freefall or velocity.Y < -50 then
                    return true
                elseif velocity.X > 35 or velocity.X < -35 then
                    return true
                elseif velocity.Y > 60 then
                    return true
                elseif velocity.Z > 35 or velocity.Z < -35 then
                    return true
                end
            end
        end
        return false
    end

    local function mainLoop()
        local c = Camera
        local m = UserInputService:GetMouseLocation()
        local yuki = getgenv().yuki
        local smoothness = yuki.Smoothness and yuki.SmoothnessValue or nil
        
        if yuki.UnlockOnPlayerDeath and (not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("Humanoid")) then
            unlock()
        end
        
        if CTarget then
            CPart = closestPart
            if CTarget and CTarget:FindFirstChild(CPart) then
                local targetPart = CTarget[CPart]
                if targetPart then
                    if not InRadius(CTarget, yuki.AimPart, yuki.FOV.Radius) then
                        unlock()
                    elseif uwuCheckAnti(CTarget) then
                        aimAt(targetPart, smoothness)
                    else
                        aimAt(targetPart.Position + targetPart.Velocity * yuki.Prediction, smoothness)
                    end
                else
                    unlock()
                end
            else
                unlock()
            end
        elseif locked then
            unlock()
        end
        
        if yuki.UnlockOnTargetDeath and CTarget and (not CTarget:FindFirstChild(CPart) or CTarget.Humanoid.Health <= 0) then
            unlock()
        end
        
        if yuki.UnlockWhenTyping and UserInputService:GetFocusedTextBox() then
            unlock()
        end
    end

    game:GetService("RunService").RenderStepped:Connect(function()
        mainLoop()
    end)

    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == yuki.ToggleKey then
            toggleKeyPressed = true
            toggleLock()
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.KeyCode == yuki.ToggleKey then
            toggleKeyPressed = false
        end
    end)
end

main()
