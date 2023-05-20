--// xolium i think its a old ver tho

getgenv().Feds = { 
   Silent = {
     ["Enabled"] = true, --// enables silentaim
     ["KeybindEnabled"] = true, --// enables keybind for silentaim
     ["Keybind"] = "M", --// yeha
     ["Part"] = "UpperTorso", --// leave as is unless yk what ur doing
     ["ClosestPart"] = true, --// gets closest aimpart to ur mouse instead of using 1 part
	 ["PredictionEnabled"] = true, --// enables prediction
     ["Prediction"] = 0.129, --// obv..
     ["AutoPrediction"] = true, --// makes it so everytime ur ping changes it changes ur prediction value
     ["WallCheck"] = true, --// makes it so u cant lock onto ppl who are behind walls
     ["CheckForTargetDeath"] = true, --// unlocks when target dies
     ["DontShootGround"] = true, --// makes it so the silent doesnt shoot the ground
 },
   SilentFOV = {
     ["Visible"] = true, --// makes silent fov visible
     ["Radius"] = 17.5, --// i mean cmon its obvious what this does..
 },
   GunFOV =  {
     ["Enabled"] = true, --// when u change weapons it will change ur silent fov to the desired value
     ["Double-Barrel SG"] = {["FOV"] = 30}, --// DB
     ["Revolver"] = {["FOV"] = 25}, --// Rev
     ["SMG"] = {["FOV"] = 20}, --// Uzi/Smg
     ["Shotgun"] = { ["FOV"] = 20}, --// SG
     ["Rifle"] = { ["FOV"] = 15}, --// Rifle
     ["TacticalShotgun"] = {["FOV"] = 20}, --// Tac
     ["Silencer"] = {["FOV"] = 20}, --// Silencer
     ["AK47"] = { ["FOV"] = 12.5}, --// AK
     ["AR"] = { ["FOV"] = 12.5}, --// AR
 },
   Camlock = {
     ["Enabled"] = true, --// enables camlock
     ["Keybind"] = "Q", --// camlock keybind when pressed locks onto ppl
     ["Aimpart"] = "UpperTorso", --// yeha
     ["ClosestPart"] = true, --// gets closest aimpart to ur mouse instead of using 1 part
     ["Smoothness"] = 0.150, --// changes the smoothness of the camlock for more humanized movement
     ["PredictionEnabled"] = false, --// enables prediction
     ["Prediction"] = 0.129, --// obv..
     ["WallCheck"] = true, --// checks if player is behind wall if so it wont lock on
     ["CheckForTargetDeath"] = false, --// unlocks when target is dead/dies
     ["DisableOnTargetDeath"] = true, --// disables when target is dead/dies
     ["DisableOnPlayerDeath"] = true, --// disables when u die
     ["DisableOutSideOfFOV"] = false, --// disables if player is outside of fov
     ["CamShake"] = true, --// enables humanized camera movement
     ["CamShakeValue"] = 7.5, --// humanized camera movement intensity
 },
   CamlockFOV = {
     ["Visible"] = false, --// makes camlock fov visible
     ["Radius"] = 50, --// i mean cmon its obvious what this does..
 },
   Misc = {
     ["DesyncResolver"] = true, --// resolves desync anti-lock
	 ["DesyncDetection"] = 80, --// dont mess w this unless yk what u are doing
     ["UnderGroundResolver"] = true, --// resolves underground anti-lock
	 ["SendNotifications"] = true, --// sends notification when u enable/disable something
	 ["AutoP20"] = 0.1133, --// 20 ping auto prediction setting
     ["AutoP30"] = 0.1173, --// 30 ping auto prediction setting
     ["AutoP40"] = 0.1215, --// 40 ping auto prediction setting
     ["AutoP50"] = 0.1235, --// 50 ping auto prediction setting
     ["AutoP60"] = 0.1253, --// 60 ping auto prediction setting
     ["AutoP70"] = 0.1269, --// 70 ping auto prediction setting
     ["AutoP80"] = 0.1285, --// 80 ping auto prediction setting
     ["AutoP90"] = 0.1315, --// 90 ping auto prediction setting
     ["AutoP100"] = 0.1331, --// 100 ping auto prediction setting
     ["AutoP110"] = 0.1348, --// 110 ping auto prediction setting
     ["AutoP120"] = 0.1364, --// 120 ping auto prediction setting
     ["AutoP130"] = 0.1377, --// 130 ping auto prediction setting
     ["AutoP140"] = 0.1388, --// 140 ping auto prediction setting
     ["AutoP150"] = 0.1413, --// 150 ping auto prediction setting
 },
}

local Prey = nil
local Plr  = nil

local Players, Client, Mouse, RS, Camera =
    game:GetService("Players"),
    game:GetService("Players").LocalPlayer,
    game:GetService("Players").LocalPlayer:GetMouse(),
    game:GetService("RunService"),
    game:GetService("Workspace").CurrentCamera

local Circle       = Drawing.new("Circle")
local CamlockCircle = Drawing.new("Circle")

Circle.Color           = Color3.new(125,100,255)
Circle.Thickness       = 1.5
CamlockCircle.Color     = Color3.new(125,100,255)
CamlockCircle.Thickness = 1.5

local UpdateFOV = function ()
    if (not Circle and not CamlockCircle) then
        return Circle and CamlockCircle
    end
    CamlockCircle.Visible  = getgenv().Feds.CamlockFOV.Visible
    CamlockCircle.Radius   = getgenv().Feds.CamlockFOV.Radius * 2
    CamlockCircle.Position = Vector2.new(Mouse.X, Mouse.Y + (game:GetService("GuiService"):GetGuiInset().Y))
    
    Circle.Visible  = getgenv().Feds.SilentFOV.Visible
    Circle.Radius   = getgenv().Feds.SilentFOV.Radius * 2
    Circle.Position = Vector2.new(Mouse.X, Mouse.Y + (game:GetService("GuiService"):GetGuiInset().Y))
    return Circle and CamlockCircle
end

RS.Heartbeat:Connect(UpdateFOV)

local WallCheck = function(destination, ignore)
    local Origin    = Camera.CFrame.p
    local CheckRay  = Ray.new(Origin, destination - Origin)
    local Hit       = game.workspace:FindPartOnRayWithIgnoreList(CheckRay, ignore)
    return Hit      == nil
end

local WTS = function (Object)
    local ObjectVector = Camera:WorldToScreenPoint(Object.Position)
    return Vector2.new(ObjectVector.X, ObjectVector.Y)
end

local IsOnScreen = function (Object)
    local IsOnScreen = Camera:WorldToScreenPoint(Object.Position)
    return IsOnScreen
end

local FilterObjs = function (Object)
    if string.find(Object.Name, "Gun") then
        return
    end
    if table.find({"Part", "MeshPart", "BasePart"}, Object.ClassName) then
        return true
    end
end

local ClosestPlrFromMouse = function()
    local Target, Closest = nil, 1/0
    
    for _ ,v in pairs(Players:GetPlayers()) do
    	if getgenv().Feds.Silent.WallCheck then
    		if (v.Character and v ~= Client and v.Character:FindFirstChild("HumanoidRootPart")) then
    			local Position, OnScreen = Camera:WorldToScreenPoint(v.Character.HumanoidRootPart.Position)
    			local Distance = (Vector2.new(Position.X, Position.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
    
    			if (Circle.Radius > Distance and Distance < Closest and OnScreen) and WallCheck(v.Character.HumanoidRootPart.Position, {Client, v.Character}) then
    				Closest = Distance
    				Target = v
    			end
    		end
    	else
    		if (v.Character and v ~= Client and v.Character:FindFirstChild("HumanoidRootPart")) then
    			local Position, OnScreen = Camera:WorldToScreenPoint(v.Character.HumanoidRootPart.Position)
    			local Distance = (Vector2.new(Position.X, Position.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
    
    			if (Circle.Radius > Distance and Distance < Closest and OnScreen) then
    				Closest = Distance
    				Target = v
    			end
    		end
    	end
    end
    return Target
end

local ClosestPlrFromMouse2 = function()
    local Target, Closest = nil, CamlockCircle.Radius * 1.5
    
    for _ ,v in pairs(Players:GetPlayers()) do
    	if (v.Character and v ~= Client and v.Character:FindFirstChild("HumanoidRootPart")) then
        	if getgenv().Feds.Camlock.WallCheck then
        		local Position, OnScreen = Camera:WorldToScreenPoint(v.Character.HumanoidRootPart.Position)
        		local Distance = (Vector2.new(Position.X, Position.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
        
        		if (Distance < Closest and OnScreen) and WallCheck(v.Character.HumanoidRootPart.Position, {Client, v.Character}) then
        			Closest = Distance
        			Target = v
        		end
        	    else
        			local Position, OnScreen = Camera:WorldToScreenPoint(v.Character.HumanoidRootPart.Position)
        			local Distance = (Vector2.new(Position.X, Position.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
        
        			if (Distance < Closest and OnScreen) then
        				Closest = Distance
        				Target = v
        			end
        		end
            end
        end
    return Target
end

local GetClosestBodyPart = function (character)
    local ClosestDistance = 1/0
    local BodyPart = nil
    
    if (character and character:GetChildren()) then
        for _,  x in next, character:GetChildren() do
            if FilterObjs(x) and IsOnScreen(x) then
                local Distance = (WTS(x) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                if (Circle.Radius > Distance and Distance < ClosestDistance) then
                    ClosestDistance = Distance
                    BodyPart = x
                end
            end
        end
    end
    return BodyPart
end

local GetClosestBodyPartV2 = function (character)
    local ClosestDistance = 1/0
    local BodyPart = nil
    
    if (character and character:GetChildren()) then
        for _,  x in next, character:GetChildren() do
            if FilterObjs(x) and IsOnScreen(x) then
                local Distance = (WTS(x) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                if (Distance < ClosestDistance) then
                    ClosestDistance = Distance
                    BodyPart = x
                end
            end
        end
    end
    return BodyPart
end

Mouse.KeyDown:Connect(function(Key)
    local Keybind = getgenv().Feds.Camlock.Keybind:lower()
    if (Key == Keybind) then
        if getgenv().Feds.Camlock.Enabled == true then
            IsTargetting = not IsTargetting
            if IsTargetting then
                Plr = ClosestPlrFromMouse2()
            else
                if Plr ~= nil then
                    Plr = nil
                    IsTargetting = false
                end
            end
        end
    end
end)

Mouse.KeyDown:Connect(function(Key)
    local Keybind = getgenv().Feds.Silent.Keybind:lower()
    if (Key == Keybind) and getgenv().Feds.Silent.KeybindEnabled == true then
            if getgenv().Feds.Silent.Enabled == true then
				getgenv().Feds.Silent.Enabled = false
                if getgenv().Feds.Misc.SendNotifications then
                    game.StarterGui:SetCore(
                        "SendNotification",
                        {
                            Title = "Feds",
                            Text = "Disabled Silent Aim",
                            Icon = "",
                            Duration = 1
                        }
                    )
                end
            else
				getgenv().Feds.Silent.Enabled = true
                if getgenv().Feds.Misc.SendNotifications then
                    game.StarterGui:SetCore(
                        "SendNotification",
                        {
                            Title = "Feds",
                            Text = "Enabled Silent Aim",
                            Icon = "",
                            Duration = 1
                        }
                    )
                end
            end
        end
    end
)



local grmt = getrawmetatable(game)
local backupindex = grmt.__index
setreadonly(grmt, false)

grmt.__index = newcclosure(function(self, v)
    if (getgenv().Feds.Silent.Enabled and Mouse and tostring(v) == "Hit") then
        if Prey and Prey.Character then
    		if getgenv().Feds.Silent.PredictionEnabled then
    			local endpoint = game.Players[tostring(Prey)].Character[getgenv().Feds.Silent.Aimpart].CFrame + (
    				game.Players[tostring(Prey)].Character[getgenv().Feds.Silent.Aimpart].Velocity * getgenv().Feds.Silent.Prediction
    			)
    			return (tostring(v) == "Hit" and endpoint)
    		else
    			local endpoint = game.Players[tostring(Prey)].Character[getgenv().Feds.Silent.Aimpart].CFrame
    			return (tostring(v) == "Hit" and endpoint)
    		end
        end
    end
    return backupindex(self, v)
end)



RS.Heartbeat:Connect(function()
	if getgenv().Feds.Silent.Enabled then
	    if Prey and Prey.Character and Prey.Character:WaitForChild(getgenv().Feds.Silent.Aimpart) then
            if getgenv().Feds.Misc.DesyncResolver == true and Prey.Character:WaitForChild("HumanoidRootPart").Velocity.magnitude > getgenv().Feds.Misc.DesyncDetection then            
                pcall(function()
                    local TargetVel = Prey.Character[getgenv().Feds.Silent.Aimpart]
                    TargetVel.Velocity = Vector3.new(0, 0, 0)
                    TargetVel.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                end)
            end
            if getgenv().Feds.Silent.DontShootGround == true and Prey.Character:FindFirstChild("Humanoid") == Enum.HumanoidStateType.Freefall then
                pcall(function()
                    local TargetVelv5 = Prey.Character[getgenv().Feds.Silent.Aimpart]
                    TargetVelv5.Velocity = Vector3.new(TargetVelv5.Velocity.X, (TargetVelv5.Velocity.Y * 0.5), TargetVelv5.Velocity.Z)
                    TargetVelv5.AssemblyLinearVelocity = Vector3.new(TargetVelv5.Velocity.X, (TargetVelv5.Velocity.Y * 0.5), TargetVelv5.Velocity.Z)
                end)
            end
            if getgenv().Feds.Misc.UnderGroundResolver == true then            
                pcall(function()
                    local TargetVelv2 = Prey.Character[getgenv().Feds.Silent.Aimpart]
                    TargetVelv2.Velocity = Vector3.new(TargetVelv2.Velocity.X, 0, TargetVelv2.Velocity.Z)
                    TargetVelv2.AssemblyLinearVelocity = Vector3.new(TargetVelv2.Velocity.X, 0, TargetVelv2.Velocity.Z)
                end)
            end
	    end
	end
    if getgenv().Feds.Camlock.Enabled == true then
        if getgenv().Feds.Misc.DesyncResolver == true and Plr and Plr.Character and Plr.Character:WaitForChild(getgenv().Feds.Camlock.Aimpart) and Plr.Character:WaitForChild("HumanoidRootPart").Velocity.magnitude > getgenv().Feds.Misc.DesyncDetection then
            pcall(function()
                local TargetVelv3 = Plr.Character[getgenv().Feds.Camlock.Aimpart]
                TargetVelv3.Velocity = Vector3.new(0, 0, 0)
                TargetVelv3.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            end)
        end
        if getgenv().Feds.Misc.UnderGroundResolver == true and Plr and Plr.Character and Plr.Character:WaitForChild(getgenv().Feds.Camlock.Aimpart)then
            pcall(function()
                local TargetVelv4 = Plr.Character[getgenv().Feds.Camlock.Aimpart]
                TargetVelv4.Velocity = Vector3.new(TargetVelv4.Velocity.X, 0, TargetVelv4.Velocity.Z)
                TargetVelv4.AssemblyLinearVelocity = Vector3.new(TargetVelv4.Velocity.X, 0, TargetVelv4.Velocity.Z)
            end)
        end
    end
end)

RS.RenderStepped:Connect(function()
	if getgenv().Feds.Silent.Enabled then
        if getgenv().Feds.Silent.CheckForTargetDeath == true and Prey and Prey.Character then 
            local KOd = Prey.Character:WaitForChild("BodyEffects")["K.O"].Value
            local Grabbed = Prey.Character:FindFirstChild("GRABBING_CONSTRAINT") ~= nil
            if KOd or Grabbed then
                Prey = nil
            end
        end
	end
    if getgenv().Feds.Camlock.Enabled == true then
        if getgenv().Feds.Camlock.CheckForTargetDeath == true and Plr and Plr.Character then 
            local KOd = Plr.Character:WaitForChild("BodyEffects")["K.O"].Value
            local Grabbed = Plr.Character:FindFirstChild("GRABBING_CONSTRAINT") ~= nil
            if KOd or Grabbed then
                Plr = nil
                IsTargetting = false
            end
        end
		if getgenv().Feds.Camlock.DisableOnTargetDeath == true and Plr and Plr.Character:FindFirstChild("Humanoid") then
			if Plr.Character.Humanoid.health < 4 then
				Plr = nil
				IsTargetting = false
			end
		end
		if getgenv().Feds.Camlock.DisableOnPlayerDeath == true and Plr and Plr.Character:FindFirstChild("Humanoid") then
			if Client.Character.Humanoid.health < 4 then
				Plr = nil
				IsTargetting = false
			end
		end
        if getgenv().Feds.Camlock.DisableOutSideOfFOV == true and Plr and Plr.Character and Plr.Character:WaitForChild("HumanoidRootPart") then
            if
            CamlockCircle.Radius <
                (Vector2.new(
                    Camera:WorldToScreenPoint(Plr.Character.HumanoidRootPart.Position).X,
                    Camera:WorldToScreenPoint(Plr.Character.HumanoidRootPart.Position).Y
                ) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
             then
                Plr = nil
                IsTargetting = false
            end
        end
		if getgenv().Feds.Camlock.PredictionEnabled and Plr and Plr.Character and Plr.Character:FindFirstChild(getgenv().Feds.Camlock.Aimpart) then
			if getgenv().Feds.Camlock.CamShake then
				local Main = CFrame.new(Camera.CFrame.p,Plr.Character[getgenv().Feds.Camlock.Aimpart].Position + Plr.Character[getgenv().Feds.Camlock.Aimpart].Velocity * getgenv().Feds.Camlock.Prediction +
				Vector3.new(
					math.random(-getgenv().Feds.Camlock.CamShakeValue, getgenv().Feds.Camlock.CamShakeValue),
					math.random(-getgenv().Feds.Camlock.CamShakeValue, getgenv().Feds.Camlock.CamShakeValue),
					math.random(-getgenv().Feds.Camlock.CamShakeValue, getgenv().Feds.Camlock.CamShakeValue)
				) * 0.1)
				Camera.CFrame = Camera.CFrame:Lerp(Main, getgenv().Feds.Camlock.Smoothness / 2, Enum.EasingStyle.Elastic, Enum.EasingDirection.InOut, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
			else
    			local Main = CFrame.new(Camera.CFrame.p,Plr.Character[getgenv().Feds.Camlock.Aimpart].Position + Plr.Character[getgenv().Feds.Camlock.Aimpart].Velocity * getgenv().Feds.Camlock.Prediction)
    			Camera.CFrame = Camera.CFrame:Lerp(Main, getgenv().Feds.Camlock.Smoothness / 2, Enum.EasingStyle.Elastic, Enum.EasingDirection.InOut, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
			end
		elseif getgenv().Feds.Camlock.PredictionEnabled == false and Plr and Plr.Character and Plr.Character:FindFirstChild(getgenv().Feds.Camlock.Aimpart) then
			if getgenv().Feds.Camlock.CamShake then
				local Main = CFrame.new(Camera.CFrame.p,Plr.Character[getgenv().Feds.Camlock.Aimpart].Position +
				Vector3.new(
					math.random(-getgenv().Feds.Camlock.CamShakeValue, getgenv().Feds.Camlock.CamShakeValue),
					math.random(-getgenv().Feds.Camlock.CamShakeValue, getgenv().Feds.Camlock.CamShakeValue),
					math.random(-getgenv().Feds.Camlock.CamShakeValue, getgenv().Feds.Camlock.CamShakeValue)
				) * 0.1)
				Camera.CFrame = Camera.CFrame:Lerp(Main, getgenv().Feds.Camlock.Smoothness / 2, Enum.EasingStyle.Elastic, Enum.EasingDirection.InOut, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
		    else
    			local Main = CFrame.new(Camera.CFrame.p,Plr.Character[getgenv().Feds.Camlock.Aimpart].Position)
    			Camera.CFrame = Camera.CFrame:Lerp(Main, getgenv().Feds.Camlock.Smoothness / 2, Enum.EasingStyle.Elastic, Enum.EasingDirection.InOut, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
		    end
		end
	end
end)

task.spawn(function ()
    while task.wait() do
    	if getgenv().Feds.Silent.Enabled then
            Prey = ClosestPlrFromMouse()
    	end
        if Plr then
            if getgenv().Feds.Camlock.Enabled and (Plr.Character) and getgenv().Feds.Camlock.ClosestPart then
                getgenv().Feds.Camlock.Aimpart = tostring(GetClosestBodyPartV2(Plr.Character))
            end
        end
        if Prey then
            if getgenv().Feds.Silent.Enabled and (Prey.Character) and getgenv().Feds.Silent.ClosestPart then
                getgenv().Feds.Silent.Aimpart = tostring(GetClosestBodyPart(Prey.Character))
            end
        end
    end
end)

local Script = {Functions = {}}
    Script.Functions.getToolName = function(name)
        local split = string.split(string.split(name, "[")[2], "]")[1]
        return split
    end
    Script.Functions.getEquippedWeaponName = function()
        if (Client.Character) and Client.Character:FindFirstChildWhichIsA("Tool") then
           local Tool =  Client.Character:FindFirstChildWhichIsA("Tool")
           if string.find(Tool.Name, "%[") and string.find(Tool.Name, "%]") and not string.find(Tool.Name, "Wallet") and not string.find(Tool.Name, "Phone") then
              return Script.Functions.getToolName(Tool.Name)
           end
        end
        return nil
    end
    RS.RenderStepped:Connect(function()
    if Script.Functions.getEquippedWeaponName() ~= nil then
        local WeaponSettings = getgenv().Feds.GunFOV[Script.Functions.getEquippedWeaponName()]
        if WeaponSettings ~= nil and getgenv().Feds.GunFOV.Enabled == true then
            getgenv().Feds.SilentFOV.Radius = WeaponSettings.FOV
        else
            getgenv().Feds.SilentFOV.Radius = getgenv().Feds.SilentFOV.Radius
        end
    end
end)


	

while getgenv().Feds.Silent.AutoPrediction == true do
    local ping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString()
    local pingValue = string.split(ping, " ")[1]
    local pingNumber = tonumber(pingValue)
   
    if pingNumber < 30 then
        Feds.Silent.Prediction = (getgenv().Feds.Misc.AutoP20)
    elseif pingNumber < 40 then
        Feds.Silent.Prediction = (getgenv().Feds.Misc.AutoP30)
    elseif pingNumber < 50 then
        Feds.Silent.Prediction = (getgenv().Feds.Misc.AutoP40)
    elseif pingNumber < 60 then
        Feds.Silent.Prediction = (getgenv().Feds.Misc.AutoP50)
    elseif pingNumber < 70 then
        Feds.Silent.Prediction = (getgenv().Feds.Misc.AutoP60)
    elseif pingNumber < 80 then
        Feds.Silent.Prediction = (getgenv().Feds.Misc.AutoP70)
    elseif pingNumber < 90 then
        Feds.Silent.Prediction = (getgenv().Feds.Misc.AutoP80)
    elseif pingNumber < 100 then
        Feds.Silent.Prediction = (getgenv().Feds.Misc.AutoP90)
    elseif pingNumber < 110 then
        Feds.Silent.Prediction = (getgenv().Feds.Misc.AutoP100)
         elseif pingNumber < 120 then
        Feds.Silent.Prediction = (getgenv().Feds.Misc.AutoP110)
         elseif pingNumber < 130 then
        Feds.Silent.Prediction = (getgenv().Feds.Misc.AutoP120)
         elseif pingNumber < 140 then
        Feds.Silent.Prediction = (getgenv().Feds.Misc.AutoP130)
         elseif pingNumber < 150 then
        Feds.Silent.Prediction = (getgenv().Feds.Misc.AutoP140)
         elseif pingNumber < 160 then
        Feds.Silent.Prediction = (getgenv().Feds.Misc.AutoP150)
	end
 
    wait(1)
end
