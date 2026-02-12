DPP2 = DPP2 or {}
DPP2.Version = "1.0.0"
DPP2.Modules = DPP2.Modules or {}
DPP2.Cache = DPP2.Cache or {}

function DPP2:RegisterModule(name, onBoot)
    self.Modules[name] = {
        name = name,
        onBoot = onBoot
    }
end

function DPP2:BootModules()
    for _, data in pairs(self.Modules) do
        if isfunction(data.onBoot) then
            local ok, err = pcall(data.onBoot)
            if not ok then
                MsgC(Color(255, 90, 90), "[DPP2] Module failed: " .. tostring(data.name) .. " -> " .. tostring(err) .. "\n")
            end
        end
    end
end

function DPP2:Now()
    return os.date("%Y-%m-%d %H:%M:%S")
end

function DPP2:IsDarkRP()
    return DarkRP ~= nil
end

function DPP2:EnsureTable(path)
    local ref = self.Config
    for _, key in ipairs(path) do
        ref[key] = ref[key] or {}
        ref = ref[key]
    end
    return ref
end

function DPP2:MapContains(list, value)
    if istable(list) then
        if list[value] ~= nil then return true end
        for _, v in pairs(list) do
            if v == value then return true end
        end
    end
    return false
end
