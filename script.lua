_G.EspEnabled = false
_G.EspVisibleCheck = false

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local workspace = game:GetService("Workspace")

function DeleteESP()
    for _, model in pairs(workspace:GetDescendants()) do
        if model:IsA("Model") then
            local hl = model:FindFirstChild("Highlight", true)
            if hl then
                hl:Destroy()
            end
        end
    end
end

function ESPDethMode()
    for _, model in pairs(workspace:GetDescendants()) do
        if model:IsA("Model") then
            local hl = model:FindFirstChild("Highlight", true)
            if hl then
                hl.DepthMode = _G.EspVisibleCheck == false
                    and Enum.HighlightDepthMode.AlwaysOnTop
                    or Enum.HighlightDepthMode.Occluded
            end
        end
    end
end

function toColor3(brickColor)
    return Color3.new(brickColor.r, brickColor.g, brickColor.b)
end

RunService.RenderStepped:Connect(function()
    if _G.EspEnabled then
        for _, v in next, Players:GetPlayers() do
            if v ~= Players.LocalPlayer and v.Character then
                pcall(function()
                    if not v.Character:FindFirstChild("Highlight") then
                        local highlightclone = Instance.new("Highlight")
                        highlightclone.Name = "Highlight"
                        highlightclone.Adornee = v.Character
                        highlightclone.FillColor = toColor3(v.TeamColor)
                        highlightclone.DepthMode = _G.EspVisibleCheck == false
                            and Enum.HighlightDepthMode.AlwaysOnTop
                            or Enum.HighlightDepthMode.Occluded

                        -- 🔥 SATU-SATUNYA FIX (WAJIB)
                        highlightclone.Parent = v.Character
                    end
                end)
            end
        end
    end
end)

print("ESP Module Loaded (FPS Safe)")
