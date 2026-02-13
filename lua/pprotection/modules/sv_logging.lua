DPP = DPP or {}

DPP.LogFilePath = "dpp/logs.txt"
DPP.NotificationBuckets = DPP.NotificationBuckets or {}

function DPP:Log(event, message, actor)
    if not self.Config.logging.enabled then return end

    local actorName = IsValid(actor) and actor:Nick() or "system"
    local line = string.format("[%s] [%s] [%s] %s", self:Now(), tostring(event), actorName, tostring(message))

    if self.Config.logging.console then
        MsgC(Color(80, 180, 255), "[DPP] ", Color(220, 220, 220), line .. "\n")
    end

    if self.Config.logging.file then
        file.CreateDir("dpp")
        file.Append(self.LogFilePath, line .. "\n")
    end
end

function DPP:NotifyStaff(msg, bucket)
    bucket = bucket or "general"
    local now = CurTime()
    local nextAllowed = self.NotificationBuckets[bucket] or 0

    if now < nextAllowed then return end
    self.NotificationBuckets[bucket] = now + self.Config.logging.staffNotifyThrottle

    for _, ply in ipairs(player.GetHumans()) do
        if self:HasAccess(ply, "openmenu") then
            ply:ChatPrint("[DPP] " .. msg)
        end
    end
end
