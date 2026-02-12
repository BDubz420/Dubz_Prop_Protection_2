DPP2 = DPP2 or {}

DPP2.Ownership = DPP2.Ownership or {
    entityOwners = {},
    steamEntityIndex = {},
    transferLog = {}
}

local ENTITY = FindMetaTable("Entity")

function ENTITY:DPP2SetOwner(ply)
    if not IsValid(self) then return end

    if IsValid(ply) and ply:IsPlayer() then
        self:SetNWString("DPP2OwnerSID", ply:SteamID64() or "")
        self:SetNWString("DPP2OwnerName", ply:Nick())
        DPP2.Ownership.entityOwners[self:EntIndex()] = ply:SteamID64()

        DPP2.Ownership.steamEntityIndex[ply:SteamID64()] = DPP2.Ownership.steamEntityIndex[ply:SteamID64()] or {}
        DPP2.Ownership.steamEntityIndex[ply:SteamID64()][self:EntIndex()] = true
    else
        self:SetNWString("DPP2OwnerSID", "")
        self:SetNWString("DPP2OwnerName", "world")
        DPP2.Ownership.entityOwners[self:EntIndex()] = nil
    end
end

function ENTITY:DPP2GetOwnerSID64()
    local sid = self:GetNWString("DPP2OwnerSID", "")
    if sid ~= "" then return sid end
    return DPP2.Ownership.entityOwners[self:EntIndex()]
end

function ENTITY:DPP2IsOwnedBy(ply)
    if not IsValid(ply) then return false end
    local sid = self:DPP2GetOwnerSID64()
    return sid ~= nil and sid ~= "" and sid == ply:SteamID64()
end

function DPP2:CanInteractWithEntity(ply, ent)
    if not IsValid(ply) or not IsValid(ent) then return false end
    if self:CanBypass(ply, {"admin", "superadmin"}) then return true end

    if ent:DPP2IsOwnedBy(ply) then return true end

    local ownerSid = ent:DPP2GetOwnerSID64()
    if not ownerSid or ownerSid == "" then return self.Config.canProperty.canTargetWorldEntities end

    local trusted = self.Config.ownership.trust.permanent[ownerSid]
    if trusted and trusted[ply:SteamID64()] then return true end

    return false
end

hook.Add("PlayerSpawnedProp", "DPP2.Ownership.Prop", function(ply, model, ent)
    if IsValid(ent) then
        ent:DPP2SetOwner(ply)
    end
end)

hook.Add("PlayerSpawnedSENT", "DPP2.Ownership.Sent", function(ply, ent)
    if IsValid(ent) then
        ent:DPP2SetOwner(ply)
    end
end)

hook.Add("PlayerDisconnected", "DPP2.Ownership.TrackDisconnect", function(ply)
    DPP2:Log("disconnect", "Tracking disconnected owner entities for cleanup", ply)
end)

hook.Add("EntityRemoved", "DPP2.Ownership.CleanupIndex", function(ent)
    if not IsValid(ent) then return end
    local sid = ent:DPP2GetOwnerSID64()
    if sid and DPP2.Ownership.steamEntityIndex[sid] then
        DPP2.Ownership.steamEntityIndex[sid][ent:EntIndex()] = nil
    end
    DPP2.Ownership.entityOwners[ent:EntIndex()] = nil
end)
