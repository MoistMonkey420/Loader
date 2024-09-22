local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Window = OrionLib:MakeWindow({Name = "Lester V3", HidePremium = false, SaveConfig = true, ConfigFolder = "Lester", IntroEnabled = true, IntroText = "Lester V3"})

local bToggleAimbot = false
local bToggleName = false
local bToggleBox = false

--Aimbot
local TabAimbot = Window:MakeTab({
    Name = "Aimbot",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})
TabAimbot:AddToggle({
    Name = "Aimbot",
    Default = false,
    Callback = function(Value)
        bToggleAimbot = Value
    end    
})
--ESP
local TabEsp = Window:MakeTab({
    Name = "Esp",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})
TabEsp:AddToggle({
    Name = "Name",
    Default = false,
    Callback = function(Value)
        bToggleName = Value
    end    
})
TabEsp:AddToggle({
    Name = "Box",
    Default = false,
    Callback = function(Value)
        bToggleBox = Value
    end    
})
--Scripthub
local TabScriptHub = Window:MakeTab({
    Name = "ScriptHub",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})
TabScriptHub:AddButton({
	Name = "Infinite Yield",
	Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/refs/heads/master/source"))()
  	end    
})
TabScriptHub:AddButton({
	Name = "Simple Spy",
	Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/exxtremestuffs/SimpleSpySource/refs/heads/master/SimpleSpy.lua"))()
  	end    
})
TabScriptHub:AddButton({
	Name = "Turtle Spy",
	Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Turtle-Brand/Turtle-Spy/refs/heads/main/source.lua"))()
  	end    
})

local lplr = game.Players.LocalPlayer
local camera = game:GetService("Workspace").CurrentCamera
local worldToViewportPoint = camera.WorldToViewportPoint

local HeadOff = Vector3.new(0, 0.5, 0)
local LegOff = Vector3.new(0, 3, 0)

local function createBox()
    local BoxOutline = Drawing.new("Square")
    BoxOutline.Visible = false
    BoxOutline.Color = Color3.new(0, 0, 0)
    BoxOutline.Thickness = 3
    BoxOutline.Transparency = 1
    BoxOutline.Filled = false

    local Box = Drawing.new("Square")
    Box.Visible = false
    Box.Color = Color3.new(1, 1, 1)
    Box.Thickness = 1
    Box.Transparency = 1
    Box.Filled = false

    return BoxOutline, Box
end

local function createNameLabel()
    local NameLabel = Drawing.new("Text")
    NameLabel.Visible = false
    NameLabel.Size = 20
    NameLabel.Center = true
    NameLabel.Outline = true
    NameLabel.Color = Color3.new(1, 1, 1)
    return NameLabel
end

local function updateBox(BoxOutline, Box, NameLabel, character)
    if character and character:FindFirstChild("Humanoid") and character:FindFirstChild("HumanoidRootPart") then
        local RootPart = character.HumanoidRootPart
        local Head = character:FindFirstChild("Head")
        if not Head then return end  -- Early exit if Head is missing

        local RootPosition, RootVis = worldToViewportPoint(camera, RootPart.Position)
        local HeadPosition = worldToViewportPoint(camera, Head.Position + HeadOff)
        local LegPosition = worldToViewportPoint(camera, RootPart.Position - LegOff)

        local onScreen = RootVis and (RootPosition.Z > 0)  -- Ensure it's in front of the camera
        local isAlive = character.Humanoid.Health > 0

        if onScreen and isAlive then
            local boxHeight = HeadPosition.Y - LegPosition.Y
            BoxOutline.Size = Vector2.new(boxHeight / 2, boxHeight)
            BoxOutline.Position = Vector2.new(RootPosition.X - BoxOutline.Size.X / 2, RootPosition.Y - BoxOutline.Size.Y / 2)
            BoxOutline.Visible = bToggleBox

            Box.Size = BoxOutline.Size
            Box.Position = BoxOutline.Position
            Box.Visible = bToggleBox

            -- Update Name Label
            NameLabel.Position = Vector2.new(RootPosition.X, RootPosition.Y + boxHeight)
            NameLabel.Text = character.Name
            NameLabel.Visible = bToggleName
        else
            BoxOutline.Visible = false
            Box.Visible = false
            NameLabel.Visible = false
        end
    else
        BoxOutline.Visible = false
        Box.Visible = false
        NameLabel.Visible = false
    end
end


local function boxEsp(player)
    local BoxOutline, Box = createBox()
    local NameLabel = createNameLabel()

    game:GetService("RunService").RenderStepped:Connect(function()
        updateBox(BoxOutline, Box, NameLabel, player.Character)
    end)

    player.CharacterAdded:Connect(function(character)
        NameLabel = createNameLabel()
        character:WaitForChild("Humanoid").Died:Connect(function() 
            BoxOutline:Remove()
            Box:Remove()
            NameLabel:Remove()
        end)
    end)
end

for _, player in pairs(game.Players:GetPlayers()) do
    if player ~= lplr then
        boxEsp(player)
    end
end

game.Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        boxEsp(player)
    end)
end)

-- Aimbot Logic
local dwCamera = workspace.CurrentCamera
local dwRunService = game:GetService("RunService")
local dwUIS = game:GetService("UserInputService")
local dwEntities = game:GetService("Players")
local dwLocalPlayer = dwEntities.LocalPlayer
local dwMouse = dwLocalPlayer:GetMouse()

local settings = {
    Aimbot = true,
    Aiming = false,
    Aimbot_AimPart = "Head",
    Aimbot_TeamCheck = true,
    Aimbot_Draw_FOV = true,
    Aimbot_FOV_Radius = 200,
    Aimbot_FOV_Color = Color3.fromRGB(255, 255, 255)
}

local fovcircle = Drawing.new("Circle")
fovcircle.Visible = settings.Aimbot_Draw_FOV
fovcircle.Radius = settings.Aimbot_FOV_Radius
fovcircle.Color = settings.Aimbot_FOV_Color
fovcircle.Thickness = 1
fovcircle.Filled = false
fovcircle.Transparency = 1
fovcircle.Position = Vector2.new(dwCamera.ViewportSize.X / 2, dwCamera.ViewportSize.Y / 2)

dwUIS.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton2 then
        settings.Aiming = true
    end
end)

dwUIS.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton2 then
        settings.Aiming = false
    end
end)

dwRunService.RenderStepped:Connect(function()
    local dist = math.huge
    local closest_char = nil

    if settings.Aiming then
        for i, v in next, dwEntities:GetChildren() do 
            if v ~= dwLocalPlayer and
               v.Character and
               v.Character:FindFirstChild("HumanoidRootPart") and
               v.Character:FindFirstChild("Humanoid") and
               v.Character:FindFirstChild("Humanoid").Health > 0 then

                if bToggleAimbot == true then
                    local char = v.Character
                    local char_part_pos, is_onscreen = dwCamera:WorldToViewportPoint(char[settings.Aimbot_AimPart].Position)

                    if is_onscreen then
                        local mag = (Vector2.new(dwMouse.X, dwMouse.Y) - Vector2.new(char_part_pos.X, char_part_pos.Y)).Magnitude

                        if mag < dist and mag < settings.Aimbot_FOV_Radius then
                            dist = mag
                            closest_char = char
                        end
                    end
                end
            end
        end

        if closest_char ~= nil and
           closest_char:FindFirstChild("HumanoidRootPart") and
           closest_char:FindFirstChild("Humanoid") and
           closest_char:FindFirstChild("Humanoid").Health > 0 then

            dwCamera.CFrame = CFrame.new(dwCamera.CFrame.Position, closest_char[settings.Aimbot_AimPart].Position)
        end
    end
end)
