DPP2 = DPP2 or {}

local iconMap = {
    Core = "🏠",
    Ownership = "👥",
    Protection = "🛡",
    Weapons = "🔫",
    Tools = "🧰",
    Vehicles = "🚗",
    Duplication = "📦",
    Logs = "📊",
    Advanced = "⚙"
}

local categories = {
    {
        id = "Core",
        sections = {
            {
                title = "Core System",
                desc = "Master toggles and cleanup behavior",
                fields = {
                    {"Master enable", "toggle", "core.enabled"},
                    {"Out-of-bounds timer", "toggle", "core.outOfBounds.timerEnabled"},
                    {"Out-of-bounds whitelist", "table", "core.outOfBounds.whitelistClasses"},
                    {"Protected frozen entities", "table", "core.protectedFrozenEntities"},
                    {"Disconnected cleanup list", "table", "core.disconnectedCleanup.specificSteamIDs"}
                }
            },
            {
                title = "General Actions",
                desc = "Player management and one-click actions",
                fields = {
                    {"Ghost props", "action", "ghost"},
                    {"Freeze props", "action", "freeze"},
                    {"Remove props", "action", "remove_props"},
                    {"Remove entities", "action", "remove_entities"},
                    {"Highlight entities", "action", "highlight"},
                    {"Ghost everyone", "global", "ghost"},
                    {"Freeze everyone", "global", "freeze"}
                }
            }
        }
    },
    {
        id = "Ownership",
        sections = {
            {
                title = "Ownership & Trust",
                desc = "Sharing and trust relationships",
                fields = {
                    {"Shared ownership mode", "toggle", "ownership.sharedOwnershipMode"},
                    {"Team trust", "table", "ownership.trust.teamTrust"},
                    {"Temporary trust", "table", "ownership.trust.temporary"},
                    {"Transfer ownership command", "label", "Available via backend action API"},
                    {"Ownership logs", "toggle", "ownership.logs"}
                }
            }
        }
    },
    {
        id = "Protection",
        sections = {
            {
                title = "Build Protection",
                desc = "Ghosting, damage, anti-collide and spam protection",
                fields = {
                    {"Ghosting enabled", "toggle", "ghosting.enabled"},
                    {"Ghost on physgun", "toggle", "ghosting.ghostOnPhysgun"},
                    {"Damage protection", "toggle", "damage.enabled"},
                    {"Anti-collide", "toggle", "antiCollide.enabled"},
                    {"Spam protection", "toggle", "spamProtection.enabled"},
                    {"Spawn restriction", "toggle", "spawnRestriction.enabled"}
                }
            }
        }
    },
    {
        id = "Weapons",
        sections = {
            {
                title = "Weapon Control",
                desc = "Toolgun, physgun, gravgun and CanProperty restrictions",
                fields = {
                    {"Toolgun restrictions", "toggle", "toolgun.enabled"},
                    {"Physgun restrictions", "toggle", "physgun.enabled"},
                    {"Gravgun restrictions", "toggle", "gravgun.enabled"},
                    {"CanProperty control", "toggle", "canProperty.enabled"},
                    {"Tool restrictions list", "table", "toolgun.restrictedTools"},
                    {"Physgun blocked entities", "table", "physgun.blockedEntities"}
                }
            }
        }
    },
    {
        id = "Duplication",
        sections = {
            {
                title = "Adv Dupe 2",
                desc = "Duping constraints and value validation",
                fields = {
                    {"Dupe protection", "toggle", "advDupe2.enabled"},
                    {"Prevent rope spawning", "toggle", "advDupe2.preventRopeSpawning"},
                    {"Prevent scaling", "toggle", "advDupe2.preventScaling"},
                    {"Prevent unreasonable values", "toggle", "advDupe2.preventUnreasonableValues"},
                    {"Whitelisted constraints", "table", "advDupe2.whitelistedConstraints"}
                }
            }
        }
    },
    {
        id = "Advanced",
        sections = {
            {
                title = "Performance + Crash Guard",
                desc = "Anti-crash controls and automation",
                fields = {
                    {"Crash guard", "toggle", "crashGuard.enabled"},
                    {"Constraint limit", "label", "Configurable in shared config"},
                    {"Auto-freeze large contraptions", "toggle", "automation.autoFreezeLargeContraptions"},
                    {"Auto-ghost large builds", "toggle", "automation.autoGhostLargeBuilds"},
                    {"Per-map limits", "table", "automation.perMapLimits"}
                }
            }
        }
    },
    {
        id = "Logs",
        sections = {
            {
                title = "Logs & Analytics",
                desc = "Auditing, history and monitoring",
                fields = {
                    {"Logging enabled", "toggle", "logging.enabled"},
                    {"Staff notification throttle", "label", "logging.staffNotifyThrottle"},
                    {"Action history viewer", "label", "Backed by file dpp2/logs.txt"},
                    {"Violation monitor", "label", "Available in right live panel"}
                }
            }
        }
    }
}

local function getPath(root, path)
    local node = root
    for token in string.gmatch(path, "([^.]+)") do
        if not istable(node) then return nil end
        node = node[token]
        if node == nil then return nil end
    end
    return node
end

local function addFieldRow(parent, data, config)
    local row = vgui.Create("DPanel", parent)
    row:Dock(TOP)
    row:SetTall(32)
    row:DockMargin(0, 0, 0, 6)
    row.Paint = function(_, w, h)
        DUIF.DrawRoundedBox(6, 0, 0, w, h, ColorAlpha(DUIF.GetColor("SurfaceAlt"), 180))
        draw.SimpleText(data[1], "DUIF.Small", 10, h * 0.5, DUIF.GetColor("Text"), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    if data[2] == "toggle" then
        local value = tobool(getPath(config, data[3]))
        local t = DUIF.CreateToggle(row, value)
        t:SetPos(400, 3)
    elseif data[2] == "action" then
        local b = DUIF.CreateButton(row, "Run", "secondary")
        b:SetSize(66, 24)
        b:SetPos(390, 4)
        b.OnClick = function()
            local sid = IsValid(DPP2.SelectedPlayer) and DPP2.SelectedPlayer:SteamID64() or ""
            net.Start("DPP2.Action")
                net.WriteString("player")
                net.WriteString(sid)
                net.WriteString(data[3])
            net.SendToServer()
        end
    elseif data[2] == "global" then
        local b = DUIF.CreateButton(row, "Run", "danger")
        b:SetSize(66, 24)
        b:SetPos(390, 4)
        b.OnClick = function()
            net.Start("DPP2.Action")
                net.WriteString("global")
                net.WriteString("")
                net.WriteString(data[3])
            net.SendToServer()
        end
    elseif data[2] == "table" then
        local b = DUIF.CreateButton(row, "View", "ghost")
        b:SetSize(66, 24)
        b:SetPos(390, 4)
        b.OnClick = function()
            DUIF.CreateModal("Table Viewer", data[3] .. "\n\nUse your backend editor for advanced table mutation.")
        end
    else
        draw.SimpleText(tostring(data[3] or ""), "DUIF.Small", 455, 16, DUIF.GetColor("TextMuted"), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
    end
end

function DPP2.OpenDashboard(snapshot)
    if IsValid(DPP2.Frame) then DPP2.Frame:Remove() end

    local config = snapshot.config or {}

    local frame = DUIF.CreateFrame("Dubz Prop Protection", 1320, 820)
    DPP2.Frame = frame

    local topBar = vgui.Create("DPanel", frame)
    topBar:Dock(TOP)
    topBar:DockMargin(8, 62, 8, 8)
    topBar:SetTall(54)
    topBar.Paint = function(_, w, h)
        DUIF.DrawRoundedBox(8, 0, 0, w, h, ColorAlpha(DUIF.GetColor("Surface"), 210))
    end

    local search = DUIF.CreateTextEntry(topBar, "Search settings...")
    search:SetPos(12, 10)
    search:SetSize(260, 34)

    local enabledToggle = DUIF.CreateToggle(topBar, tobool(getPath(config, "core.enabled")))
    enabledToggle:SetPos(286, 13)

    local statsText = string.format("Violations: %s | Players: %s | Ents: %s | FPS: %s", snapshot.stats.violations or 0, snapshot.stats.players or 0, snapshot.stats.entities or 0, snapshot.stats.fps or 0)
    local stat = vgui.Create("DLabel", topBar)
    stat:SetFont("DUIF.Small")
    stat:SetTextColor(DUIF.GetColor("TextMuted"))
    stat:SetText(statsText)
    stat:SizeToContents()
    stat:SetPos(360, 18)

    local sidebar = DUIF.CreateSidebar(frame, { width = 70, topPadding = 124 })

    local content = vgui.Create("DScrollPanel", frame)
    content:Dock(FILL)
    content:DockMargin(8, 0, 256, 12)
    DUIF.StyleScrollBar(content)

    local right = vgui.Create("DPanel", frame)
    right:Dock(RIGHT)
    right:SetWide(240)
    right:DockMargin(0, 124, 12, 12)
    right.Paint = function(_, w, h)
        DUIF.DrawRoundedBox(8, 0, 0, w, h, ColorAlpha(DUIF.GetColor("Surface"), 200))
        draw.SimpleText("Live Data", "DUIF.Header", 12, 12, DUIF.GetColor("Text"))
        draw.SimpleText("Active alerts: 0", "DUIF.Small", 12, 44, DUIF.GetColor("TextMuted"))
        draw.SimpleText("Recent spawns: n/a", "DUIF.Small", 12, 62, DUIF.GetColor("TextMuted"))
        draw.SimpleText("Heatmap: ready", "DUIF.Small", 12, 80, DUIF.GetColor("TextMuted"))
    end

    local playerCard = DUIF.CreateCard(right, {
        dock = TOP,
        tall = 170,
        margin = {8, 120, 8, 0},
        header = "Player Management",
        description = "Search and target actions"
    })

    local pSearch = DUIF.CreateTextEntry(playerCard, "Find player")
    pSearch:SetPos(10, 62)
    pSearch:SetSize(220, 28)

    local pList = vgui.Create("DComboBox", playerCard)
    pList:SetPos(10, 96)
    pList:SetSize(220, 26)
    for _, ply in ipairs(player.GetHumans()) do
        pList:AddChoice(ply:Nick(), ply)
    end

    pList.OnSelect = function(_, _, _, data)
        DPP2.SelectedPlayer = data
    end

    local cards = {}

    local function rebuild(activeCategory)
        content:Clear()
        for _, cat in ipairs(categories) do
            if cat.id ~= activeCategory then continue end

            for _, section in ipairs(cat.sections) do
                local card = DUIF.CreateCard(content, {
                    tall = 56 + (#section.fields * 40),
                    header = section.title,
                    description = section.desc,
                    accentBorder = true
                })

                local body = vgui.Create("DPanel", card)
                body:SetPos(12, 56)
                body:SetSize(470, card:GetTall() - 64)
                body.Paint = nil

                for _, field in ipairs(section.fields) do
                    addFieldRow(body, field, config)
                end

                cards[#cards + 1] = card
            end
        end
    end

    for i, cat in ipairs(categories) do
        local btn = sidebar:AddItem(iconMap[cat.id] or "•", function()
            rebuild(cat.id)
        end, "ghost")

        btn:SetTooltip(cat.id)
        if i == 1 then
            rebuild(cat.id)
        end
    end
end

net.Receive("DPP2.OpenMenu", function()
    local snapshot = net.ReadTable()
    DPP2.OpenDashboard(snapshot)
end)

concommand.Add("dpp2_open", function()
    RunConsoleCommand("dpp2_menu")
end)
