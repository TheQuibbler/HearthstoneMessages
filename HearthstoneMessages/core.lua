local addonName, addonTable = ...

local hearthstoneMessagesFrame = CreateFrame("Frame")
local announcementCooldownSeconds = 5
local lastAnnouncementTimeSeconds = 0

-----------------------------------
-- Helpers
-----------------------------------

-- Returns true when the spell description starts with one of the configured trigger prefixes.
local function isTeleportDescription(spellDescriptionText)
    if type(spellDescriptionText) ~= "string" then
        return false
    end

    local normalizedSpellDescription = spellDescriptionText:lower():match("^%s*(.-)%s*$")

    return normalizedSpellDescription:find("^returns you to") ~= nil
        or normalizedSpellDescription:find("^teleports the caster") ~= nil
end

-- Selects the best group channel and sends a random message when available.
local function announceToGroup()
    local availableMessages = addonTable.GoodbyeMessages
    if type(availableMessages) ~= "table" or #availableMessages == 0 then
        return
    end

    local selectedChatChannel
    if IsInRaid() then
        selectedChatChannel = "RAID"
    elseif IsInGroup() then
        selectedChatChannel = "PARTY"
    end

    if not selectedChatChannel then
        return
    end

    local randomMessageIndex = math.random(1, #availableMessages)
    local selectedMessage = availableMessages[randomMessageIndex]

    C_ChatInfo.SendChatMessage(selectedMessage, selectedChatChannel)
end

-----------------------------------
-- Events
-----------------------------------

-- Handles spellcast start events and announces only for the player's teleport-like casts.
local function onUnitSpellcastStart(_, _, _, _, spellIdentifier)
    local spellDescriptionText = C_Spell.GetSpellDescription(spellIdentifier)
    if not isTeleportDescription(spellDescriptionText) then
        return
    end

    local nowSeconds = GetTime()
    if nowSeconds - lastAnnouncementTimeSeconds < announcementCooldownSeconds then
        return
    end

    announceToGroup()
    lastAnnouncementTimeSeconds = nowSeconds
end

hearthstoneMessagesFrame:RegisterUnitEvent("UNIT_SPELLCAST_START", "player")
hearthstoneMessagesFrame:SetScript("OnEvent", onUnitSpellcastStart)
