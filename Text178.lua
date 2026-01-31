-- ===============================
-- ESP HIGHLIGHT JUGADORES (FIXED)
-- ===============================

if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

local FILL_COLOR = Color3.fromRGB(0,255,0)
local FILL_TRANSPARENCY = 0.5
local OUTLINE_COLOR = Color3.fromRGB(0,255,0)
local OUTLINE_TRANSPARENCY = 0

local ESPTable = {}

-- Toggle automático por ejecución
_G.ESP_Toggle = not _G.ESP_Toggle

-- ===== Crear o actualizar ESP =====
local function aplicarESP(character)
    if not character then return end

    local highlight = ESPTable[character]

    if not highlight then
        highlight = Instance.new("Highlight")
        highlight.FillColor = FILL_COLOR
        highlight.FillTransparency = FILL_TRANSPARENCY
        highlight.OutlineColor = OUTLINE_COLOR
        highlight.OutlineTransparency = OUTLINE_TRANSPARENCY
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.Parent = CoreGui

        ESPTable[character] = highlight
    end

    highlight.Adornee = character
    highlight.Enabled = _G.ESP_Toggle
end

-- ===== Limpiar ESP al morir =====
local function limpiarESP(character)
    local highlight = ESPTable[character]
    if highlight then
        highlight.Enabled = false
        highlight.Adornee = nil
        ESPTable[character] = nil
    end
end

-- ===== Setup jugador =====
local function setupPlayer(plr)
    if plr == LocalPlayer then return end

    plr.CharacterAdded:Connect(aplicarESP)
    plr.CharacterRemoving:Connect(limpiarESP)

    if plr.Character then
        aplicarESP(plr.Character)
    end
end

-- Inicial
for _, plr in pairs(Players:GetPlayers()) do
    setupPlayer(plr)
end

Players.PlayerAdded:Connect(setupPlayer)

-- ===== Toggle manual opcional =====
function ToggleESP()
    _G.ESP_Toggle = not _G.ESP_Toggle
    for char, highlight in pairs(ESPTable) do
        highlight.Enabled = _G.ESP_Toggle
        highlight.Adornee = char
    end
end
