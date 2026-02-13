DPP = DPP or {}

DPP.Ownership = DPP.Ownership or {
    entityOwners = {},
    steamEntityIndex = {},
    transferLog = {}
}

local ENTITY = FindMetaTable("Entity")

function ENTITY:DPPSetOwner(ply)
    if not IsValid(self) then return end

    if IsValid(ply) and ply:IsPlayer() then
        self:SetNWString("DPPOwnerSID", ply:SteamID64() or "")
        self:SetNWString("DPPOwnerName", ply:Nick())
        DPP.Ownership.entityOwners[self:EntIndex()] = ply:SteamID64()

        DPP.Ownership.steamEntityIndex[ply:SteamID64()] = DPP.Ownership.steamEntityIndex[ply:SteamID64()] or {}
        DPP.Ownership.steamEntityIndex[ply:SteamID64()][self:EntIndex()] = true
    else
        self:SetNWString("DPPOwnerSID", "")
        self:SetNWString("DPPOwnerName", "world")
        DPP.Ownership.entityOwners[self:EntIndex()] = nil
    end
end

function ENTITY:DPPGetOwnerSID64()
    local sid = self:GetNWString("DPPOwnerSID", "")
    if sid ~= "" then return sid end
    return DPP.Ownership.entityOwners[self:EntIndex()]
end

function ENTITY:DPPIsOwnedBy(ply)
    if not IsValid(ply) then return false end
    local sid = self:DPPGetOwnerSID64()
    return sid ~= nil and sid ~= "" and sid == ply:SteamID64()
end

function DPP:CanInteractWithEntity(ply, ent)
    if not IsValid(ply) or not IsValid(ent) then return false end
    if self:CanBypass(ply, {"admin", "superadmin"}) then return true end

    if ent:DPPIsOwnedBy(ply) then return true end

    local ownerSid = ent:DPPGetOwnerSID64()
    if not ownerSid or ownerSid == "" then return self.Config.canProperty.canTargetWorldEntities end

    local trusted = self.Config.ownership.trust.permanent[ownerSid]
    if trusted and trusted[ply:SteamID64()] then return true end

    return false
end

hook.Add("PlayerSpawnedProp", "DPP.Ownership.Prop", function(ply, model, ent)
    if IsValid(ent) then
        ent:DPPSetOwner(ply)
    end
end)

hook.Add("PlayerSpawnedSENT", "DPP.Ownership.Sent", function(ply, ent)
    if IsValid(ent) then
        ent:DPPSetOwner(ply)
    end
end)

hook.Add("PlayerDisconnected", "DPP.Ownership.TrackDisconnect", function(ply)
    DPP:Log("disconnect", "Tracking disconnected owner entities for cleanup", ply)
end)

hook.Add("EntityRemoved", "DPP.Ownership.CleanupIndex", function(ent)
    if not IsValid(ent) then return end
    local sid = ent:DPPGetOwnerSID64()
    if sid and DPP.Ownership.steamEntityIndex[sid] then
        DPP.Ownership.steamEntityIndex[sid][ent:EntIndex()] = nil
    end
    DPP.Ownership.entityOwners[ent:EntIndex()] = nil
end)
