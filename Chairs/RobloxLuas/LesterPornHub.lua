local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Window = OrionLib:MakeWindow({Name = "Lester PornHub", HidePremium = false, SaveConfig = true, ConfigFolder = "Lester", IntroEnabled = true, IntroText = "Lester PornHub"})

local menuSettings = {
    bAimbot = false,
    bName = false,
    bBox = false,
    bHealthbar = false,
    bTracers = false
}

--Aim
local disableAimbot = false
local teamCheck = false
local fov = 150
local smoothing = 1

local RunService = game:GetService("RunService")

local FOVring = Drawing.new("Circle")
FOVring.Visible = true
FOVring.Thickness = 1.5
FOVring.Radius = fov
FOVring.Transparency = 1
FOVring.Color = Color3.fromRGB(255, 255, 255)
FOVring.Position = workspace.CurrentCamera.ViewportSize/2

--esp
local Settings = {
    Box_Color = Color3.fromRGB(255, 0, 0),
    Tracer_Color = Color3.fromRGB(255, 0, 0),
    Tracer_Thickness = 1,
    Box_Thickness = 1,
    Tracer_Origin = "Bottom", -- Middle or Bottom if FollowMouse is on this won't matter...
    Tracer_FollowMouse = false,
    Tracers = true
}
local Team_Check = {
    TeamCheck = false, -- if TeamColor is on this won't matter...
    Green = Color3.fromRGB(0, 255, 0),
    Red = Color3.fromRGB(255, 0, 0)
}
local TeamColor = true

--// SEPARATION
local player = game:GetService("Players").LocalPlayer
local camera = game:GetService("Workspace").CurrentCamera
local mouse = player:GetMouse()

local TabAimbot = Window:MakeTab({
    Name = "Aimbot",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})
TabAimbot:AddToggle({
    Name = "Aimbot",
    Default = false,
    Callback = function(Value)
        menuSettings.bAimbot = Value
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
        menuSettings.bName = Value
    end    
})
TabEsp:AddToggle({
    Name = "Box",
    Default = false,
    Callback = function(Value)
        menuSettings.bBox = Value
    end    
})
TabEsp:AddToggle({
    Name = "Health bar",
    Default = false,
    Callback = function(Value)
        menuSettings.bHealthbar = Value
    end    
})
TabEsp:AddToggle({
    Name = "Tracers",
    Default = false,
    Callback = function(Value)
        menuSettings.bTracers = Value
    end    
})

-- AimBot
local function getClosest(cframe)
    local ray = Ray.new(cframe.Position, cframe.LookVector).Unit
           
    local target = nil
    local mag = math.huge

    if game.PlaceId == 286090429 then
        teamCheck = true
    end
    if game.PlaceId == 2377868063 then
        disableAimbot = true
    else
        disableAimbot = false
    end
           
    for i,v in pairs(game.Players:GetPlayers()) do
        if v.Character and v.Character:FindFirstChild("Head") and v.Character:FindFirstChild("Humanoid") and v.Character:FindFirstChild("HumanoidRootPart") and v ~= game.Players.LocalPlayer and (v.Team ~= game.Players.LocalPlayer.Team or (not teamCheck)) then
            local magBuf = (v.Character.Head.Position - ray:ClosestPoint(v.Character.Head.Position)).Magnitude
                   
            if magBuf < mag then
                mag = magBuf
                target = v
            end
        end
    end
           
    return target
end
        
loop = RunService.RenderStepped:Connect(function()
    local UserInputService = game:GetService("UserInputService")
    local pressed = UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
    local localPlay = game.Players.localPlayer.Character
    local cam = workspace.CurrentCamera
    local zz = workspace.CurrentCamera.ViewportSize/2
           
    if pressed and menuSettings.bAimbot and not disableAimbot then
        local Line = Drawing.new("Line")
        local curTar = getClosest(cam.CFrame)
        local ssHeadPoint = cam:WorldToScreenPoint(curTar.Character.Head.Position)
        ssHeadPoint = Vector2.new(ssHeadPoint.X, ssHeadPoint.Y)
        if (ssHeadPoint - zz).Magnitude < fov then
            workspace.CurrentCamera.CFrame = workspace.CurrentCamera.CFrame:Lerp(CFrame.new(cam.CFrame.Position, curTar.Character.Head.Position), smoothing)
        end
    end
           
    if UserInputService:IsKeyDown(Enum.KeyCode.Delete) then
        loop:Disconnect()
        FOVring:Remove()
    end
end)

--ESP
local function NewQuad(thickness, color)
    local quad = Drawing.new("Quad")
    quad.Visible = false
    quad.PointA = Vector2.new(0,0)
    quad.PointB = Vector2.new(0,0)
    quad.PointC = Vector2.new(0,0)
    quad.PointD = Vector2.new(0,0)
    quad.Color = color
    quad.Filled = false
    quad.Thickness = thickness
    quad.Transparency = 1
    return quad
end

local function NewLine(thickness, color)
    local line = Drawing.new("Line")
    line.Visible = false
    line.From = Vector2.new(0, 0)
    line.To = Vector2.new(0, 0)
    line.Color = color 
    line.Thickness = thickness
    line.Transparency = 1
    return line
end

local function NewText(size, color)
    local text = Drawing.new("Text")
    text.Visible = false
    text.Size = size
    text.Color = color
    text.Center = true
    text.Outline = true
    text.OutlineColor = Color3.fromRGB(0, 0, 0)
    text.Transparency = 1
    return text
end

local function Visibility(state, lib)
    for u, x in pairs(lib) do
        x.Visible = state
    end
end

local black = Color3.fromRGB(0, 0 ,0)
local function ESP(plr)
    local library = {
        blacktracer = NewLine(Settings.Tracer_Thickness*2, black),
        tracer = NewLine(Settings.Tracer_Thickness, Settings.Tracer_Color),
        black = NewQuad(Settings.Box_Thickness*2, black),
        box = NewQuad(Settings.Box_Thickness, Settings.Box_Color),
        healthbar = NewLine(3, black),
        greenhealth = NewLine(1.5, black),
        nameTag = NewText(14, Color3.fromRGB(255, 255, 255))
    }

    local function Colorize(color)
        for u, x in pairs(library) do
            if x ~= library.healthbar and x ~= library.greenhealth and x ~= library.blacktracer and x ~= library.black then
                x.Color = color
            end
        end
    end

    local function Updater()
        local connection
        connection = game:GetService("RunService").RenderStepped:Connect(function()
            if plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character.Humanoid.Health > 0 and plr.Character:FindFirstChild("Head") then
                local HumPos, OnScreen = camera:WorldToViewportPoint(plr.Character.HumanoidRootPart.Position)
                if OnScreen then
                    local head = camera:WorldToViewportPoint(plr.Character.Head.Position)
                    local DistanceY = math.clamp((Vector2.new(head.X, head.Y) - Vector2.new(HumPos.X, HumPos.Y)).Magnitude, 2, math.huge)

                    -- Name
                    if menuSettings.bName then
                        library.nameTag.Text = plr.Name
                        library.nameTag.Position = Vector2.new(head.X, head.Y - 20)
                        library.nameTag.Visible = true
                    else
                        library.nameTag.Visible = false
                    end

                    -- Box
                    local function Size(item)
                        if menuSettings.bBox then
                            item.PointA = Vector2.new(HumPos.X + DistanceY, HumPos.Y - DistanceY*2)
                            item.PointB = Vector2.new(HumPos.X - DistanceY, HumPos.Y - DistanceY*2)
                            item.PointC = Vector2.new(HumPos.X - DistanceY, HumPos.Y + DistanceY*2)
                            item.PointD = Vector2.new(HumPos.X + DistanceY, HumPos.Y + DistanceY*2)
                        else
                            item.PointA = Vector2.new(0, 0)
                            item.PointB = Vector2.new(0, 0)
                            item.PointC = Vector2.new(0, 0)
                            item.PointD = Vector2.new(0, 0)
                        end
                    end
                    Size(library.box)
                    Size(library.black)

                    -- Tracer 
                    if menuSettings.bTracers then
                        if Settings.Tracer_Origin == "Middle" then
                            library.tracer.From = camera.ViewportSize * 0.5
                            library.blacktracer.From = camera.ViewportSize * 0.5
                        elseif Settings.Tracer_Origin == "Bottom" then
                            library.tracer.From = Vector2.new(camera.ViewportSize.X * 0.5, camera.ViewportSize.Y)
                            library.blacktracer.From = Vector2.new(camera.ViewportSize.X * 0.5, camera.ViewportSize.Y)
                        end
                        if Settings.Tracer_FollowMouse then
                            library.tracer.From = Vector2.new(mouse.X, mouse.Y + 36)
                            library.blacktracer.From = Vector2.new(mouse.X, mouse.Y + 36)
                        end
                        library.tracer.To = Vector2.new(HumPos.X, HumPos.Y + DistanceY*2)
                        library.blacktracer.To = Vector2.new(HumPos.X, HumPos.Y + DistanceY*2)
                    else 
                        library.tracer.From = Vector2.new(0, 0)
                        library.blacktracer.From = Vector2.new(0, 0)
                        library.tracer.To = Vector2.new(0, 0)
                        library.blacktracer.To = Vector2.new(0, 0)
                    end

                    -- Healthbar
                    local d = (Vector2.new(HumPos.X - DistanceY, HumPos.Y - DistanceY*2) - Vector2.new(HumPos.X - DistanceY, HumPos.Y + DistanceY*2)).Magnitude 
                    local healthoffset = plr.Character.Humanoid.Health / plr.Character.Humanoid.MaxHealth * d

                    local green = Color3.fromRGB(0, 255, 0)
                    local red = Color3.fromRGB(255, 0, 0)
                    if menuSettings.bHealthbar then
                        library.greenhealth.From = Vector2.new(HumPos.X - DistanceY - 4, HumPos.Y + DistanceY*2)
                        library.greenhealth.To = Vector2.new(HumPos.X - DistanceY - 4, HumPos.Y + DistanceY*2 - healthoffset)

                        library.healthbar.From = Vector2.new(HumPos.X - DistanceY - 4, HumPos.Y + DistanceY*2)
                        library.healthbar.To = Vector2.new(HumPos.X - DistanceY - 4, HumPos.Y - DistanceY*2)

                        library.greenhealth.Color = red:lerp(green, plr.Character.Humanoid.Health / plr.Character.Humanoid.MaxHealth)
                    else
                        library.greenhealth.From = Vector2.new(0, 0)
                        library.greenhealth.To = Vector2.new(0, 0)

                        library.healthbar.From = Vector2.new(0, 0)
                        library.healthbar.To = Vector2.new(0, 0)

                        library.greenhealth.Color = red:lerp(green, plr.Character.Humanoid.Health / plr.Character.Humanoid.MaxHealth)
                    end

                    Visibility(true, library)
                else
                    Visibility(false, library)
                end
            else
                Visibility(false, library)
                if game.Players:FindFirstChild(plr.Name) == nil then
                    connection:Disconnect()
                end
            end
        end)
    end
    coroutine.wrap(Updater)()
end

for _, v in pairs(game:GetService("Players"):GetPlayers()) do
    if v.Name ~= player.Name then
        ESP(v)
    end
end
game:GetService("Players").PlayerAdded:Connect(function(v)
    ESP(v)
end)

OrionLib:Init()
