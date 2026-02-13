DPP = DPP or {}

util.AddNetworkString("DPP.OpenMenu")
util.AddNetworkString("DPP.ConfigSnapshot")
util.AddNetworkString("DPP.Action")

local function getDashboardSnapshot()
    return {
        version = DPP.Version,
        config = DPP.Config,
        stats = {
            players = #player.GetHumans(),
            entities = #ents.GetAll(),
            violations = 0,
            fps = math.floor(1 / FrameTime())
        }
    }
end

concommand.Add("dpp_menu", function(ply)
    if IsValid(ply) and not DPP:HasAccess(ply, "openmenu") then return end

    if IsValid(ply) then
        net.Start("DPP.OpenMenu")
            net.WriteTable(getDashboardSnapshot())
        net.Send(ply)
    end
end)

net.Receive("DPP.Action", function(_, ply)
    if not DPP:HasAccess(ply, "openmenu") then return end

    local mode = net.ReadString()
    local targetSid = net.ReadString()
    local action = net.ReadString()

    if mode == "global" then
        DPP:GlobalAction(ply, action)
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
        DPP:RunEntityAction(ply, target, action)
    end
end)

hook.Add("InitPostEntity", "DPP.Boot", function()
    DPP:BootModules()
end)
