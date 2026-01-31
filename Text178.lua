-- ===============================
-- ESP HIGHLIGHT PARA JUGADORES + TOGGLE
-- ===============================

if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

-- Colores y transparencia
local FILL_COLOR = Color3.fromRGB(0,255,0)
local FILL_TRANSPARENCY = 0.5
local OUTLINE_COLOR = Color3.fromRGB(0,255,0)
local OUTLINE_TRANSPARENCY = 0

-- Tabla para guardar highlights
local ESPTable = {}

-- Toggle global
_G.ESP_Toggle = true

-- Función para aplicar highlight a un personaje
local function aplicarESP(character)
    if not character then return end

    if not ESPTable[character] then
        local highlight = Instance.new("Highlight")
        highlight.Adornee = character
        highlight.FillColor = FILL_COLOR
        highlight.FillTransparency = FILL_TRANSPARENCY
        highlight.OutlineColor = OUTLINE_COLOR
        highlight.OutlineTransparency = OUTLINE_TRANSPARENCY
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.Enabled = _G.ESP_Toggle
        highlight.Parent = CoreGui

        ESPTable[character] = highlight
    else
        -- Solo actualizar toggle
        ESPTable[character].Enabled = _G.ESP_Toggle
    end
end

-- Configurar todos los jugadores actuales
for _, plr in pairs(Players:GetPlayers()) do
    if plr ~= LocalPlayer then
        plr.CharacterAdded:Connect(aplicarESP)
        if plr.Character then
            aplicarESP(plr.Character)
        end
    end
end

-- Detectar jugadores nuevos
Players.PlayerAdded:Connect(function(plr)
    if plr ~= LocalPlayer then
        plr.CharacterAdded:Connect(aplicarESP)
        if plr.Character then
            aplicarESP(plr.Character)
        end
    end
end)

-- Limpiar highlights al salir
Players.PlayerRemoving:Connect(function(plr)
    if plr.Character and ESPTable[plr.Character] then
        ESPTable[plr.Character]:Destroy()
        ESPTable[plr.Character] = nil
    end
end)

-- ===== Función toggle =====
function ToggleESP()
    _G.ESP_Toggle = not _G.ESP_Toggle
    for _, highlight in pairs(ESPTable) do
        highlight.Enabled = _G.ESP_Toggle
    end
end

-- EJEMPLO: ToggleESP() para activar/desactivar
-- ToggleESP()
