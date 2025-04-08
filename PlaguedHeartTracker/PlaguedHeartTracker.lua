-- Plagued Heart Tracker
-- Un tracker simple pour compter les applications de Corruption sur Expert Training Dummy

-- Créer le cadre principal
local PlaguedHeartFrame = CreateFrame("Frame", "PlaguedHeartFrame", UIParent)
PlaguedHeartFrame:SetWidth(100) -- Augmenté la largeur pour plus de confort
PlaguedHeartFrame:SetHeight(80) -- Augmenté la hauteur pour plus de confort
PlaguedHeartFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
PlaguedHeartFrame:EnableMouse(true)
PlaguedHeartFrame:SetMovable(true)
PlaguedHeartFrame:RegisterForDrag("LeftButton")
PlaguedHeartFrame:SetScript("OnDragStart", function() PlaguedHeartFrame:StartMoving() end)
PlaguedHeartFrame:SetScript("OnDragStop", function() PlaguedHeartFrame:StopMovingOrSizing() end)
PlaguedHeartFrame:Hide()

-- Variables globales
PlaguedHeartFrame.counter = 0
PlaguedHeartFrame.isVisible = false

-- Arrière-plan et bordure
PlaguedHeartFrame:SetBackdrop({
    bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true, tileSize = 16, edgeSize = 16,
    insets = { left = 4, right = 4, top = 4, bottom = 4 }
})
PlaguedHeartFrame:SetBackdropColor(0, 0, 0, 0.8)

-- Titre (directement sur le cadre principal sans barre de titre colorée)
local title = PlaguedHeartFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
title:SetPoint("TOP", PlaguedHeartFrame, "TOP", 0, -10)
title:SetText("Plagued Heart")

-- Texte du compteur
local counterText = PlaguedHeartFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
counterText:SetPoint("CENTER", PlaguedHeartFrame, "CENTER", 0, 0)
counterText:SetText("0")
PlaguedHeartFrame.counterText = counterText

-- Bouton de fermeture
local closeButton = CreateFrame("Button", nil, PlaguedHeartFrame, "UIPanelCloseButton")
closeButton:SetPoint("TOPRIGHT", PlaguedHeartFrame, "TOPRIGHT", 0, 0)
closeButton:SetScript("OnClick", function() 
    PlaguedHeartFrame:Hide()
    PlaguedHeartFrame.isVisible = false
end)

-- Bouton de réinitialisation
local resetButton = CreateFrame("Button", nil, PlaguedHeartFrame, "UIPanelButtonTemplate")
resetButton:SetWidth(60)
resetButton:SetHeight(20)
resetButton:SetPoint("BOTTOM", PlaguedHeartFrame, "BOTTOM", 0, 10)
resetButton:SetText("Reset")
resetButton:SetScript("OnClick", function() 
    PlaguedHeartFrame.counter = 0
    PlaguedHeartFrame.counterText:SetText("0")
end)

-- Fonction pour incrémenter le compteur
local function IncrementCounter()
    PlaguedHeartFrame.counter = PlaguedHeartFrame.counter + 1
    PlaguedHeartFrame.counterText:SetText(PlaguedHeartFrame.counter)
end

-- Fonction pour basculer la visibilité
local function ToggleTracker()
    if PlaguedHeartFrame.isVisible then
        PlaguedHeartFrame:Hide()
        PlaguedHeartFrame.isVisible = false
    else
        PlaguedHeartFrame:Show()
        PlaguedHeartFrame.isVisible = true
    end
end

-- Pour WoW 1.12, utilisons plutôt CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE
PlaguedHeartFrame:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE")
PlaguedHeartFrame:SetScript("OnEvent", function()
    if event == "CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE" then
        -- Utilise une expression régulière pour capturer n'importe quelle cible affectée par Plagued Heart
        if string.find(arg1, "is afflicted by Plagued Heart %(1%)") then
            IncrementCounter()
            
            -- Afficher la cible dans le chat (optionnel, pour debug)
            -- local target = string.match(arg1, "(.+) is afflicted by Plagued Heart")
            -- DEFAULT_CHAT_FRAME:AddMessage("|cFF33AAFF[Plagued Heart]|r Application sur: " .. (target or "inconnu"))
        end
    end
end)

-- Commande slash pour afficher/masquer le tracker
SLASH_PLAGUEDHEARTTRACKER1 = "/plaguedhearttracker"
SLASH_PLAGUEDHEARTTRACKER2 = "/plaguedht"
SlashCmdList["PLAGUEDHEARTTRACKER"] = function(msg)
    ToggleTracker()
end

-- Message de chargement
DEFAULT_CHAT_FRAME:AddMessage("|cFF33AAFF[Plagued Heart Tracker]|r Chargé. Utilisez /plaguedhearttracker ou /plaguedht pour afficher/masquer le tracker.")
