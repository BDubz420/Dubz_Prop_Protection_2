DPP = DPP or {}

function DPP:PlayerInGroup(ply, groups)
    if not IsValid(ply) or not ply:IsPlayer() then return false end

    local userGroup = ply.GetUserGroup and ply:GetUserGroup() or "user"
    return self:MapContains(groups, userGroup)
end

function DPP:HasAccess(ply, feature)
    if not IsValid(ply) or not ply:IsPlayer() then return false end

    if CAMI and self.Config.permissions.useCAMI then
        local allowed = false
        local done = false

        CAMI.PlayerHasAccess(ply, "dpp." .. tostring(feature), function(_, granted)
            allowed = granted == true
            done = true
        end)

        if done and allowed then
            return true
        end
    end

    return self:PlayerInGroup(ply, self.Config.permissions.fallbackGroups)
end

function DPP:CanBypass(ply, groupList)
    return self:PlayerInGroup(ply, groupList)
end

DPP:RegisterModule("permissions", function()
    if CAMI and CAMI.RegisterPrivilege then
        CAMI.RegisterPrivilege({
            Name = "dpp.openmenu",
            MinAccess = "admin",
            Description = "Allows access to DPP admin dashboard"
        })
    end
end)
