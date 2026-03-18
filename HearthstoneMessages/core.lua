local addonName, addonTable = ...

local hearthstoneMessagesFrame = CreateFrame("Frame")
local announcementCooldown = 5
local lastAnnouncementTime = 0

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
        or normalizedSpellDescription:find("^teleports you") ~= nil
end

-- Picks a random goodbye message from configured flavor buckets.
local function selectRandomGoodbyeMessage()
    local configuredMessages = addonTable.GoodbyeMessages
    if type(configuredMessages) ~= "table" then
        return nil
    end

    local availableFlavorBuckets = {}

    for _, possibleBucket in pairs(configuredMessages) do
        if type(possibleBucket) == "table" and #possibleBucket > 0 then
            table.insert(availableFlavorBuckets, possibleBucket)
        end
    end

    if #availableFlavorBuckets == 0 then
        return nil
    end

    local selectedFlavorBucket = availableFlavorBuckets[math.random(1, #availableFlavorBuckets)]
    return selectedFlavorBucket[math.random(1, #selectedFlavorBucket)]
end

-- Selects the best group channel and sends a random message when available.
local function announceToGroup()
    local selectedChatChannel
    if IsInRaid() then
        selectedChatChannel = "RAID"
    elseif IsInGroup() then
        selectedChatChannel = "PARTY"
    end

    if not selectedChatChannel then
        return
    end

    local selectedMessage = selectRandomGoodbyeMessage()
    if type(selectedMessage) ~= "string" or selectedMessage == "" then
        return
    end

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

    local now = GetTime()
    if now - lastAnnouncementTime < announcementCooldown then
        return
    end

    announceToGroup()
    lastAnnouncementTime = now
end

hearthstoneMessagesFrame:RegisterUnitEvent("UNIT_SPELLCAST_START", "player")
hearthstoneMessagesFrame:SetScript("OnEvent", onUnitSpellcastStart)
