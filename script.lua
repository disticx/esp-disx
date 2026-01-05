--[[  
    ESP + Tracers Only Library  
    Extracted from AirHub WallHack  
    By Distic  
]]

--// Cache
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local Drawingnew = Drawing.new
local Vector2new = Vector2.new
local Vector3new = Vector3.new
local Color3fromRGB = Color3.fromRGB
local WorldToViewportPoint = function(...)
    return Camera:WorldToViewportPoint(...)
end

--// Global Env
getgenv().DisticESP = {
    Enabled = false,

    ESP = {
        Enabled = true,
        TextSize = 14,
        Color = Color3fromRGB(255,255,255),
        Outline = true,
        OutlineColor = Color3fromRGB(0,0,0),
        Transparency = 0.7,
        ShowName = true,
        ShowHealth = true,
        ShowDistance = true,
        Offset = 20
    },

    Tracers = {
        Enabled = false,
        Type = 1, -- 1 Bottom | 2 Center | 3 Mouse
        Color = Color3fromRGB(255,255,255),
        Thickness = 1,
        Transparency = 0.7
    },

    Players = {}
}

local Env = getgenv().DisticESP

--// Player Wrapper
local function WrapPlayer(player)
    if player == LocalPlayer then return end
    if Env.Players[player] then return end

    local data = {
        ESP = Drawingnew("Text"),
        Tracer = Drawingnew("Line")
    }

    Env.Players[player] = data

    -- ESP Update
    data.ESP.Center = true
    data.ESP.Font = Drawing.Fonts.UI

    RunService.RenderStepped:Connect(function()
        if not Env.Enabled then
            data.ESP.Visible = false
            data.Tracer.Visible = false
            return
        end

        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local head = char and char:FindFirstChild("Head")
        local hum = char and char:FindFirstChildOfClass("Humanoid")

        if not (char and hrp and head and hum and hum.Health > 0) then
            data.ESP.Visible = false
            data.Tracer.Visible = false
            return
        end

        local headPos, onScreen = WorldToViewportPoint(head.Position)
        if not onScreen then
            data.ESP.Visible = false
            data.Tracer.Visible = false
            return
        end

        --================ ESP =================--
        if Env.ESP.Enabled then
            local text = ""

            if Env.ESP.ShowName then
                text = player.DisplayName
            end
            if Env.ESP.ShowHealth then
                text = text .. " (" .. math.floor(hum.Health) .. ")"
            end
            if Env.ESP.ShowDistance then
                local dist = (hrp.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                text = text .. " [" .. math.floor(dist) .. "]"
            end

            data.ESP.Text = text
            data.ESP.Size = Env.ESP.TextSize
            data.ESP.Color = Env.ESP.Color
            data.ESP.Outline = Env.ESP.Outline
            data.ESP.OutlineColor = Env.ESP.OutlineColor
            data.ESP.Transparency = Env.ESP.Transparency
            data.ESP.Position = Vector2new(headPos.X, headPos.Y - Env.ESP.Offset)
            data.ESP.Visible = true
        else
            data.ESP.Visible = false
        end

        --================ TRACERS =================--
        if Env.Tracers.Enabled then
            local hrpPos = WorldToViewportPoint(hrp.Position)

            if Env.Tracers.Type == 1 then
                data.Tracer.From = Vector2new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
            elseif Env.Tracers.Type == 2 then
                data.Tracer.From = Vector2new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
            else
                local mouse = UserInputService:GetMouseLocation()
                data.Tracer.From = Vector2new(mouse.X, mouse.Y)
            end

            data.Tracer.To = Vector2new(hrpPos.X, hrpPos.Y)
            data.Tracer.Color = Env.Tracers.Color
            data.Tracer.Thickness = Env.Tracers.Thickness
            data.Tracer.Transparency = Env.Tracers.Transparency
            data.Tracer.Visible = true
        else
            data.Tracer.Visible = false
        end
    end)
end

--// Player Events
for _,plr in pairs(Players:GetPlayers()) do
    WrapPlayer(plr)
end

Players.PlayerAdded:Connect(WrapPlayer)
Players.PlayerRemoving:Connect(function(plr)
    local data = Env.Players[plr]
    if data then
        data.ESP:Remove()
        data.Tracer:Remove()
        Env.Players[plr] = nil
    end
end)

print("[DisticESP] ESP + Tracers Loaded")
