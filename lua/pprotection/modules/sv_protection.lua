DPP2 = DPP2 or {}
DPP2.SpawnTrack = DPP2.SpawnTrack or {}

local function isBlockedByModel(model)
    local cfg = DPP2.Config.spawnRestriction
    local exists = DPP2:MapContains(cfg.blockedModels, string.lower(model or ""))
    return cfg.blockedModelsBlacklist and exists or (not cfg.blockedModelsBlacklist and not exists)
end

local function isOutOfBounds(pos)
    local oob = DPP2.Config.core.outOfBounds
    return pos.x < oob.min.x or pos.y < oob.min.y or pos.z < oob.min.z or pos.x > oob.max.x or pos.y > oob.max.y or pos.z > oob.max.z
end

hook.Add("EntityTakeDamage", "DPP2.DamageRules", function(target, dmg)
    local cfg = DPP2.Config.damage
    if not cfg.enabled then return end

    local attacker = dmg:GetAttacker()
    if IsValid(attacker) and attacker:IsPlayer() and DPP2:CanBypass(attacker, cfg.bypassGroups) then return end

    if cfg.disableWorldDamage and IsValid(attacker) and attacker:IsWorld() then
        return true
    end

    if cfg.disableVehicleDamage and target:IsVehicle() then
        return true
    end

    if DPP2:MapContains(cfg.immortalEntities, target:GetClass()) then
        dmg:SetDamage(0)
        return true
    end
end)

hook.Add("CanTool", "DPP2.ToolgunRules", function(ply, tr, tool)
    local cfg = DPP2.Config.toolgun
    if not cfg.enabled then return end
    if DPP2:CanBypass(ply, cfg.bypassGroups) then return end

    local ent = tr.Entity
    if IsValid(ent) and not ent:IsWorld() and not DPP2:CanInteractWithEntity(ply, ent) then
        return false
    end

    if DPP2:MapContains(cfg.restrictedTools, tool) then
        return false
    end
end)

hook.Add("PhysgunPickup", "DPP2.PhysgunRules", function(ply, ent)
    local cfg = DPP2.Config.physgun
    if not cfg.enabled then return end
    if DPP2:CanBypass(ply, cfg.bypassGroups) then return end

    if IsValid(ent) and ent:IsVehicle() and not DPP2:MapContains(cfg.pickupVehiclePermission, ply:GetUserGroup()) then
        return false
    end

    if IsValid(ent) and not ent:IsWorld() and not DPP2:CanInteractWithEntity(ply, ent) then
        return false
    end

    if DPP2:MapContains(cfg.blockedEntities, ent:GetClass()) then
        return false
    end
end)

hook.Add("GravGunPunt", "DPP2.GravgunPunt", function(ply, ent)
    local cfg = DPP2.Config.gravgun
    if not cfg.enabled then return end
    if cfg.disableGravityGunPunting then return false end
end)

hook.Add("CanProperty", "DPP2.CanPropertyRules", function(ply, propertyName, ent)
    local cfg = DPP2.Config.canProperty
    if not cfg.enabled then return end
    if DPP2:CanBypass(ply, cfg.bypassGroups) then return end

    if DPP2:MapContains(cfg.blockedProperties, propertyName) then
        return false
    end

    if IsValid(ent) and not DPP2:CanInteractWithEntity(ply, ent) then
        return false
    end
end)

hook.Add("PlayerSpawnProp", "DPP2.SpawnRestriction.Prop", function(ply, model)
    local cfg = DPP2.Config.spawnRestriction
    if not cfg.enabled then return end
    if DPP2:CanBypass(ply, cfg.bypassGroups) then return end
    if isBlockedByModel(model) then return false end
end)

hook.Add("PlayerSpawnedProp", "DPP2.SpamProtection.Prop", function(ply)
    local cfg = DPP2.Config.spamProtection
    if not cfg.enabled then return end

    local sid = ply:SteamID64() or "bot"
    local now = CurTime()
    local data = DPP2.SpawnTrack[sid] or {windowStart = now, count = 0}

    if now - data.windowStart > cfg.spawnDelay then
        data.windowStart = now
        data.count = 0
    end

    data.count = data.count + 1
    DPP2.SpawnTrack[sid] = data

    if data.count >= cfg.spawnThreshold then
        DPP2:Log("spam", "Spawn threshold reached", ply)
        if cfg.notifyStaff then
            DPP2:NotifyStaff(ply:Nick() .. " hit spawn threshold", "spawnspam")
        end
        if cfg.punishmentMode == "freeze" then
            ply:Freeze(true)
            timer.Simple(2, function() if IsValid(ply) then ply:Freeze(false) end end)
        end
    end
end)

local function cleanOutOfBounds()
    if not DPP2.Config.core.outOfBounds.timerEnabled then return end
    local removed = 0

    for _, ent in ipairs(ents.GetAll()) do
        if not IsValid(ent) or ent:IsPlayer() then continue end
        if DPP2:MapContains(DPP2.Config.core.outOfBounds.whitelistClasses, ent:GetClass()) then continue end

        if isOutOfBounds(ent:GetPos()) then
            ent:Remove()
            removed = removed + 1
            if removed >= DPP2.Config.core.cleanupBatchSize then break end
        end
    end

    if removed > 0 then
        DPP2:Log("cleanup", "Removed " .. removed .. " out-of-bounds entities")
    end
end

local function clearDecalsTimer()
    if DPP2.Config.miscs.enabled and DPP2.Config.miscs.clearDecalsTimer > 0 then
        game.CleanUpMap(false, {"env_fire"})
    end
end

DPP2:RegisterModule("protection", function()
    timer.Create("DPP2.OutOfBoundsCleanup", DPP2.Config.core.outOfBounds.timerSeconds, 0, cleanOutOfBounds)
    timer.Create("DPP2.ClearDecals", DPP2.Config.miscs.clearDecalsTimer, 0, clearDecalsTimer)
end)
