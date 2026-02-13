DPP = DPP or {}

function DPP:GetPlayerEntities(target)
    local sid = target:SteamID64()
    local out = {}

    for _, ent in ipairs(ents.GetAll()) do
        if IsValid(ent) and not ent:IsPlayer() and ent.DPPGetOwnerSID64 and ent:DPPGetOwnerSID64() == sid then
            out[#out + 1] = ent
        end
    end

    return out
end

function DPP:GhostEntity(ent, enabled)
    if not IsValid(ent) then return end

    if enabled then
        local c = self.Config.ghosting.color
        ent:SetRenderMode(RENDERMODE_TRANSCOLOR)
        ent:SetColor(c)
        ent:SetCollisionGroup(COLLISION_GROUP_WORLD)
    else
        ent:SetColor(Color(255, 255, 255, 255))
        ent:SetCollisionGroup(COLLISION_GROUP_NONE)
    end
end

function DPP:RunEntityAction(admin, target, action)
    if not IsValid(target) then return end

    for _, ent in ipairs(self:GetPlayerEntities(target)) do
        if action == "ghost" then
            self:GhostEntity(ent, true)
        elseif action == "freeze" and IsValid(ent:GetPhysicsObject()) then
            ent:GetPhysicsObject():EnableMotion(false)
        elseif action == "remove_props" and ent:GetClass() == "prop_physics" then
            ent:Remove()
        elseif action == "remove_entities" then
            ent:Remove()
        elseif action == "highlight" then
            ent:SetNWBool("DPPHighlighted", true)
            timer.Simple(12, function()
                if IsValid(ent) then ent:SetNWBool("DPPHighlighted", false) end
            end)
        end
    end

    self:Log("action", string.format("Executed %s on %s", action, target:Nick()), admin)
end

function DPP:GlobalAction(admin, action)
    for _, ply in ipairs(player.GetHumans()) do
        self:RunEntityAction(admin, ply, action)
    end
end
