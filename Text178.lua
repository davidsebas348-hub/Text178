-- ===============================
-- ESP HIGHLIGHT PARA JUGADORES + TOGGLE
-- ===============================

if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

-- Color y transparencia
local FILL_COLOR = Color3.fromRGB(0, 255, 0)
local FILL_TRANSPARENCY = 0.5
local OUTLINE_COLOR = Color3.fromRGB(0, 255, 0)
local OUTLINE_TRANSPARENCY = 0

-- Tabla para guardar los highlights aplicados
local ESPTable = {}

-- Toggle global
_G.ESP_Toggle = not _G.ESP_Toggle

-- Función para aplicar o actualizar ESP a un personaje
local function aplicarESP(character)
    if character and not ESPTable[character] then
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
    elseif character and ESPTable[character] then
        ESPTable[character].Enabled = _G.ESP_Toggle
    end
end

-- Aplicar ESP a todos los jugadores actuales
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

-- ===== Función para cambiar el toggle =====
function ToggleESP()
    _G.ESP_Toggle = not _G.ESP_Toggle
    for char, highlight in pairs(ESPTable) do
        highlight.Enabled = _G.ESP_Toggle
    end
end

-- EJEMPLO: ejecutar ToggleESP() para activar/desactivar
-- ToggleESP()
