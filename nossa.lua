--// universal i fhink
--// i tried to simplify it so yea

local CFrame_new, Color3_new, coroutine_wrap, Drawing_new, getgenv, getconnections, ipairs, task_wait, Vector2_new, spawn, pcall, pairs, Ray_new, table_find, Vector3_new, hookmetamethod = CFrame.new, Color3.new, coroutine.wrap, Drawing.new, getgenv, getconnections, ipairs, task.wait, Vector2.new, spawn, pcall, pairs, Ray.new, table.find, Vector3.new, hookmetamethod

local prediction = 0.18
local fov = 80
local aimKey = "p"
local dontShootThesePeople = {
  "sonnyuwugangagn",
  "sonnyuwugangagn"
}

local isEnabled = true
local localPlayer = game:GetService("Players").LocalPlayer
local playersService = game:GetService("Players")
local mouse = localPlayer:GetMouse()
local camera = game:GetService("Workspace").CurrentCamera
local logService = game:GetService("LogService")
local logOutput = logService.MessageOut
for _, connection in ipairs(getconnections(Drawing_new)) do
  connection:Disable()
end

local getrawmetatable = getrawmetatable
local setreadonly = setreadonly
local wrap = coroutine.wrap
local metatable = setmetatable
local Drawing = Drawing

local circle = Drawing_new("Circle")
circle.Visible = true
circle.Filled = false
circle.Thickness = 1
circle.Transparency = 1
circle.Color = Color3_new(0, 1, 0)
circle.Radius = fov
circle.Position = Vector2_new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)

local options = {
  Torso = "UpperTorso",
  Head = "Head"
}

local function updateCirclePosition()
  spawn(function()
    while isEnabled do
      task_wait()
      circle.Position = Vector2_new(mouse.X, (mouse.Y + 36))
    end
  end)
end
wrap(updateCirclePosition)()

mouse.KeyDown:Connect(function(key)
  if key == aimKey:lower() then
    if isEnabled == false then
      circle.Color = Color3_new(0, 1, 0)
      isEnabled = true
    elseif isEnabled == true then
      circle.Color = Color3_new(1, 0, 0)
      isEnabled = false
    end
  end
end)

local rayMetatable = nil
rayMetatable = metatable(game, "__index", function(self, key)
  local result = rayMetatable(self, key)
  local hitKey = "hit"
  if self == mouse and key:lower() == hitKey then
    local nearestDistance = 9
    local nearestPlayer = nil
    local players = playersService:GetPlayers()
    local localPlayer = localPlayer
    local workspaceCamera = game:GetService("Workspace").CurrentCamera
    for _, player in ipairs(players) do
      if not table_find(dontShootThesePeople, player.Name) then
        if player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") and player.Character:FindFirstChild("Humanoid").Health > 0 then
          local playerCharacter = player.Character
          local targetPosition = (workspaceCamera.CFrame.Position - playerCharacter[options.Torso].CFrame.Position) * CFrame_new(0, 0, -4)
          local targetRay = Ray_new(targetPosition.Position, targetPosition.LookVector * 9000)
          local hitPart, hitPoint = game:GetService("Workspace"):FindPartOnRayWithIgnoreList(targetRay, {
            localPlayer.Character:FindFirstChild("Head")
          })
          local distance = (playerCharacter[options.Torso].CFrame.Position - hitPoint).magnitude
          if distance < 4 then
            local screenPos, onScreen = workspaceCamera:WorldToScreenPoint(playerCharacter[options.Torso].Position)
            if onScreen then
              local distanceToMouse = (Vector2_new(mouse.X, mouse.Y) - Vector2_new(screenPos.X, screenPos.Y)).Magnitude
              if distanceToMouse < nearestDistance and distanceToMouse < circle.Radius then
                nearestDistance = distanceToMouse
                nearestPlayer = playerCharacter
              end
            end
          end
        end
      end
    end

    if nearestPlayer ~= nil and nearestPlayer[options.Torso] and nearestPlayer:FindFirstChild("Humanoid") and nearestPlayer:FindFirstChild("Humanoid").Health > 0 then
      local targetPosition = nearestPlayer[options.Torso].CFrame + (nearestPlayer[options.Torso].AssemblyLinearVelocity * prediction + Vector3_new(0, -1, 0))
      return key:lower() == hitKey and targetPosition
    end
    return result
  end
  return rayMetatable(self, key, result)
end)

local runService = game:GetService("RunService")
runService.Heartbeat:Connect(function()
  spawn(function()
    for _, player in ipairs(game.Players:GetChildren()) do
      if player.Name ~= game.Players.LocalPlayer.Name then
        local character = player.Character.HumanoidRootPart
        character.Velocity = Vector3_new(character.Velocity.X, 0, character.Velocity.Z)
        character.AssemblyLinearVelocity = Vector3_new(character.Velocity.X, 0, character.Velocity.Z)
      end
    end
  end)
end)
