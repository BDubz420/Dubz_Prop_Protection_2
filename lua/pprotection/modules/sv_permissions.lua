DPP2 = DPP2 or {}

function DPP2:PlayerInGroup(ply, groups)
    if not IsValid(ply) or not ply:IsPlayer() then return false end

    local userGroup = ply.GetUserGroup and ply:GetUserGroup() or "user"
    return self:MapContains(groups, userGroup)
end

function DPP2:HasAccess(ply, feature)
    if not IsValid(ply) or not ply:IsPlayer() then return false end

    if CAMI and self.Config.permissions.useCAMI then
        local allowed = false
        local done = false

        CAMI.PlayerHasAccess(ply, "dpp2." .. tostring(feature), function(_, granted)
            allowed = granted == true
            done = true
        end)

        if done and allowed then
            return true
        end
    end

    return self:PlayerInGroup(ply, self.Config.permissions.fallbackGroups)
end

function DPP2:CanBypass(ply, groupList)
    return self:PlayerInGroup(ply, groupList)
end

DPP2:RegisterModule("permissions", function()
    if CAMI and CAMI.RegisterPrivilege then
        CAMI.RegisterPrivilege({
            Name = "dpp2.openmenu",
            MinAccess = "admin",
            Description = "Allows access to DPP2 admin dashboard"
        })
    end
end)
