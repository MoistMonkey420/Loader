local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Window = OrionLib:MakeWindow({Name = "Lester V3", HidePremium = false, SaveConfig = true, ConfigFolder = "Lester", IntroEnabled = true, IntroText = "Lester V3"})

local bToggleAimbot = false
local bToggleBox = false

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
local TabEsp = Window:MakeTab({
	Name = "Esp",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})
TabEsp:AddToggle({
	Name = "Box",
	Default = false,
	Callback = function(Value)
		bToggleBox = Value
	end    
})

local lplr = game.Players.LocalPlayer
local camera = game:GetService("Workspace").CurrentCamera
local worldToViewportPoint = camera.worldToViewportPoint

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

local function updateBox(BoxOutline, Box, character)
    if character and character:FindFirstChild("Humanoid") and character:FindFirstChild("HumanoidRootPart") and character.Humanoid.Health > 0 and character ~= lplr then
        local RootPart = character.HumanoidRootPart
        local Head = character.Head
        local RootPosition, RootVis = worldToViewportPoint(camera, RootPart.Position)
        local HeadPosition = worldToViewportPoint(camera, Head.Position + HeadOff)
        local LegPosition = worldToViewportPoint(camera, RootPart.Position - LegOff)
        local onScreen = RootVis
        local boxHight = HeadPosition.Y - LegPosition.Y

        if onScreen then
            BoxOutline.Size = Vector2.new(boxHight / 2, boxHight)
            BoxOutline.Position = Vector2.new(RootPosition.X - BoxOutline.Size.X / 2, RootPosition.Y - BoxOutline.Size.Y / 2)
            BoxOutline.Visible = bToggleBox

            Box.Size = BoxOutline.Size
            Box.Position = BoxOutline.Position
            Box.Visible = bToggleBox
        else
            BoxOutline.Visible = false
            Box.Visible = false
        end
    else
        BoxOutline.Visible = false
        Box.Visible = false
    end
end

local function boxEsp(player)
    local BoxOutline, Box = createBox()

    game:GetService("RunService").RenderStepped:Connect(function()
        updateBox(BoxOutline, Box, player.Character)
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
    Aimbot_FOV_Color = Color3.fromRGB(255,255,255)
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

        for i,v in next, dwEntities:GetChildren() do 

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
