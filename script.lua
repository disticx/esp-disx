_G.EspEnabled = false
_G.EspVisibleCheck =false
local workspace = game:GetService("Workspace")
function DeleteESP()
    for _, model in pairs(workspace:GetDescendants()) do
        if model:IsA("Model") then
            local headPart = model:FindFirstChild("Head")
            if headPart then
                local highlightPart = headPart:FindFirstChild("Highlight")
                if highlightPart then
                    highlightPart:Destroy()
                end
            end
        end
    end
    
end
function ESPDethMode()
    for _, model in pairs(workspace:GetDescendants()) do
        if model:IsA("Model") then
            local headPart = model:FindFirstChild("Head")
            if headPart then
                local highlightPart = headPart:FindFirstChild("Highlight")
                if highlightPart then
                    if _G.EspVisibleCheck ==false then
                        highlightPart.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    else
                        highlightPart.DepthMode = Enum.HighlightDepthMode.Occluded
                    end
                end
            end
        end
    end
    
end
function toColor3(brickColor)
    return Color3.new(brickColor.r, brickColor.g, brickColor.b) 
end

game:GetService('RunService').RenderStepped:connect(function()
    if _G.EspEnabled then
        for i,v in next, game:GetService('Players'):GetPlayers() do
            if v.Name ~= game:GetService('Players').LocalPlayer.Name then
            pcall(function()
                    local hl =  v.Character.Head:FindFirstChild("Highlight")
                    if  hl==nil then
                    local highlightclone = Instance.new("Highlight")
                    highlightclone.Adornee = v.Character
                    highlightclone.Parent = v.Character:FindFirstChild("Head")  
                    highlightclone.Name = "Highlight"
                    highlightclone.FillColor = toColor3(v.TeamColor) 
                    if _G.EspVisibleCheck ==false then
                        highlightclone.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    else
                        highlightclone.DepthMode = Enum.HighlightDepthMode.Occluded
                    end
                    hl.FillColor=toColor3(v.TeamColor)
                end
            end)
        end
    end
            
    end
end)
print("ESP Module Loaded!")
