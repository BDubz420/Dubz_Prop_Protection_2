DPP2 = DPP2 or {}

DPP2.LogFilePath = "dpp2/logs.txt"
DPP2.NotificationBuckets = DPP2.NotificationBuckets or {}

function DPP2:Log(event, message, actor)
    if not self.Config.logging.enabled then return end

    local actorName = IsValid(actor) and actor:Nick() or "system"
    local line = string.format("[%s] [%s] [%s] %s", self:Now(), tostring(event), actorName, tostring(message))

    if self.Config.logging.console then
        MsgC(Color(80, 180, 255), "[DPP2] ", Color(220, 220, 220), line .. "\n")
    end

    if self.Config.logging.file then
        file.CreateDir("dpp2")
        file.Append(self.LogFilePath, line .. "\n")
    end
end

function DPP2:NotifyStaff(msg, bucket)
    bucket = bucket or "general"
    local now = CurTime()
    local nextAllowed = self.NotificationBuckets[bucket] or 0

    if now < nextAllowed then return end
    self.NotificationBuckets[bucket] = now + self.Config.logging.staffNotifyThrottle

    for _, ply in ipairs(player.GetHumans()) do
        if self:HasAccess(ply, "openmenu") then
            ply:ChatPrint("[DPP2] " .. msg)
        end
    end
end
