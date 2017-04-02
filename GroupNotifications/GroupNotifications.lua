--[[

Group Notifications
by CaptainBlagbird
https://github.com/CaptainBlagbird

--]]


-- Addon info
local AddonName = "GroupNotifications"

-- Language
local SI_GROUP_NOTIFICATION_GROUP_JOINED = "<<1>> has joined the group."
if GetCVar("Language.2") == "de" then
    SI_GROUP_NOTIFICATION_GROUP_JOINED = "<<1>> ist der Gruppe beigetreten."
elseif GetCVar("Language.2") == "fr" then
    SI_GROUP_NOTIFICATION_GROUP_JOINED = "<<1>> a rejoint le groupe."
end


-- Event handler function for EVENT_GROUP_MEMBER_LEFT and EVENT_GROUP_MEMBER_JOINED
local function OnGroupMemberJoinedOrLeft(eventCode, memberName, reason, isLocalPlayer, isLeader, memberDisplayName)
    if not IsUnitGrouped("player") then return end
    memberName = ZO_LinkHandler_CreateCharacterLink(memberName)--zo_strformat(SI_UNIT_NAME, memberName)
    local msg = ""
    
    -- Joined
    if reason == nil then
        msg = zo_strformat(SI_GROUP_NOTIFICATION_GROUP_JOINED, memberName)
    -- Disbanded
    elseif reason == GROUP_LEAVE_REASON_DISBAND and isLeader and not isLocalPlayer then
        msg = zo_strformat(SI_GROUP_NOTIFICATION_GROUP_DISBANDED, memberName)
    -- Kicked
    elseif reason == GROUP_LEAVE_REASON_KICKED then
        if isLocalPlayer then
            msg = zo_strformat(SI_GROUP_NOTIFICATION_GROUP_SELF_KICKED)
        else
            -- msg = zo_strformat(SI_GROUPLEAVEREASON1, memberName, memberDisplayName)
            msg = zo_strformat(SI_GROUPLEAVEREASON1, memberName)
            msg = msg:gsub("%(%)", "")
        end
    -- Left
    elseif reason == GROUP_LEAVE_REASON_VOLUNTARY and not isLocalPlayer then
        -- msg = zo_strformat(SI_GROUPLEAVEREASON0, memberName, memberDisplayName)
        msg = zo_strformat(SI_GROUPLEAVEREASON0, memberName)
        msg = msg:gsub("%(%)", "")
    -- Destroyed
    else -- GROUP_LEAVE_REASON_DESTROYED
        -- Reason for every other group member after leaving or being kicked from a group
        -- Don't display a message in this case
        return
    end
    
    d(msg)
end
EVENT_MANAGER:RegisterForEvent(AddonName, EVENT_GROUP_MEMBER_LEFT, OnGroupMemberJoinedOrLeft)
EVENT_MANAGER:RegisterForEvent(AddonName, EVENT_GROUP_MEMBER_JOINED, OnGroupMemberJoinedOrLeft)

-- Event handler function for EVENT_LEADER_UPDATE
local function OnLeaderUpdate(eventCode, leaderTag)
    if not IsUnitGrouped("player") then return end
    d(zo_strformat(SI_GROUP_NOTIFICATION_GROUP_LEADER_CHANGED, ZO_LinkHandler_CreateCharacterLink(GetUnitName(leaderTag))))
end
EVENT_MANAGER:RegisterForEvent(AddonName, EVENT_LEADER_UPDATE, OnLeaderUpdate)