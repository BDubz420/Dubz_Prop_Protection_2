DPP2 = DPP2 or {}

util.AddNetworkString("DPP2.OpenMenu")
util.AddNetworkString("DPP2.ConfigSnapshot")
util.AddNetworkString("DPP2.Action")

local function getDashboardSnapshot()
    return {
        version = DPP2.Version,
        config = DPP2.Config,
        stats = {
            players = #player.GetHumans(),
            entities = #ents.GetAll(),
            violations = 0,
            fps = math.floor(1 / FrameTime())
        }
    }
end

concommand.Add("dpp2_menu", function(ply)
    if IsValid(ply) and not DPP2:HasAccess(ply, "openmenu") then return end

    if IsValid(ply) then
        net.Start("DPP2.OpenMenu")
            net.WriteTable(getDashboardSnapshot())
        net.Send(ply)
    end
end)

net.Receive("DPP2.Action", function(_, ply)
    if not DPP2:HasAccess(ply, "openmenu") then return end

    local mode = net.ReadString()
    local targetSid = net.ReadString()
    local action = net.ReadString()

    if mode == "global" then
        DPP2:GlobalAction(ply, action)
        return
    end

    local target
    for _, candidate in ipairs(player.GetHumans()) do
        if candidate:SteamID64() == targetSid then
            target = candidate
            break
        end
    end

    if IsValid(target) then
        DPP2:RunEntityAction(ply, target, action)
    end
end)

hook.Add("InitPostEntity", "DPP2.Boot", function()
    DPP2:BootModules()
end)
