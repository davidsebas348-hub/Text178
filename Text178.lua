-- ===============================
-- HIGHLIGHT ESP TOGGLE
-- ===============================

if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

-- Nombre del ScreenGui
local guiName = "ESP_Holder"

-- Colores de ESP
local FILL_COLOR = Color3.fromRGB(0, 255, 0)
local OUTLINE_COLOR = Color3.fromRGB(0, 255, 0)

-- Tabla para guardar los highlights
local ESPTable = {}

-- Verificar si ya existe el ESP
local existingGui = CoreGui:FindFirstChild(guiName)

if existingGui then
    -- Si existe, destruir todos los highlights y la GUI (toggle off)
    for _, highlight in pairs(existingGui:GetChildren()) do
        highlight:Destroy()
    end
    existingGui:Destroy()
    ESPTable = {}
else
    -- Si no existe, crear el ESP (toggle on)
    local ESPGui = Instance.new("ScreenGui")
    ESPGui.Name = guiName
    ESPGui.Parent = CoreGui

    local function aplicarESP(character)
        if not character then return end

        if ESPTable[character] then return end

        local highlight = Instance.new("Highlight")
        highlight.Adornee = character
        highlight.FillColor = FILL_COLOR
        highlight.OutlineColor = OUTLINE_COLOR
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.FillTransparency = 0.5
        highlight.OutlineTransparency = 0
        highlight.Parent = ESPGui

        ESPTable[character] = highlight

        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.Died:Connect(function()
                if ESPTable[character] then
                    ESPTable[character]:Destroy()
                    ESPTable[character] = nil
                end
            end)
        end
    end

    -- Aplicar ESP a jugadores actuales
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            plr.CharacterAdded:Connect(aplicarESP)
            if plr.Character then
                aplicarESP(plr.Character)
            end
        end
    end

    -- Aplicar ESP a jugadores que se unan después
    Players.PlayerAdded:Connect(function(plr)
        if plr ~= LocalPlayer then
            plr.CharacterAdded:Connect(aplicarESP)
            if plr.Character then
                aplicarESP(plr.Character)
            end
        end
    end)
end
