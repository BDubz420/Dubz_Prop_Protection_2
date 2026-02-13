DPP = DPP or {}

local sharedFiles = {
    "pprotection/sh_core.lua",
    "pprotection/sh_config.lua"
}

local serverFiles = {
    "pprotection/modules/sv_permissions.lua",
    "pprotection/modules/sv_logging.lua",
    "pprotection/modules/sv_ownership.lua",
    "pprotection/modules/sv_protection.lua",
    "pprotection/modules/sv_actions.lua",
    "pprotection/modules/sv_network.lua"
}

local clientFiles = {
    "pprotection/ui/cl_menu.lua"
}

if SERVER then
    for _, path in ipairs(sharedFiles) do
        AddCSLuaFile(path)
        include(path)
    end

    for _, path in ipairs(serverFiles) do
        include(path)
    end

    for _, path in ipairs(clientFiles) do
        AddCSLuaFile(path)
    end

    return
end

for _, path in ipairs(sharedFiles) do
    include(path)
end

for _, path in ipairs(clientFiles) do
    include(path)
end
