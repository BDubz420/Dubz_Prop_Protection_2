--[[
    DUIF - Dubz UI Framework
    File: cl_showcase.lua
    Purpose: Interactive showcase panel for DUIF components and usage snippets.
]]

DUIF = DUIF or {}

local function section(parent, title, desc)
    local p = vgui.Create("DPanel", parent)
    p:Dock(TOP)
    p:SetTall(56)
    p:DockMargin(0, 0, 0, 6)
    p.Paint = function(_, w, h)
        draw.SimpleText(title, "DUIF.Header", 0, 4, DUIF.GetColor("Text"), TEXT_ALIGN_LEFT)
        draw.SimpleText(desc or "", "DUIF.Small", 0, 32, DUIF.GetColor("TextMuted"), TEXT_ALIGN_LEFT)
    end
    return p
end

local function snippet(parent, code)
    local p = vgui.Create("DPanel", parent)
    p:Dock(TOP)
    p:SetTall(44)
    p:DockMargin(0, 0, 0, 12)
    p.Paint = function(_, w, h)
        DUIF.DrawRoundedBox(8, 0, 0, w, h, ColorAlpha(DUIF.GetColor("Surface"), 140))
        draw.SimpleText(code, "DUIF.Mono", 10, h * 0.5, DUIF.GetColor("TextMuted"), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end
    return p
end

local function createButtonDemo(parent)
    section(parent, "Buttons", "All styles with hover/press animations and callbacks")

    local row = vgui.Create("DPanel", parent)
    row:Dock(TOP)
    row:SetTall(40)
    row:DockMargin(0, 0, 0, 8)
    row.Paint = nil

    for _, st in ipairs({ "primary", "secondary", "danger", "success", "ghost", "gradient" }) do
        local b = DUIF.CreateButton(row, st, st)
        b:Dock(LEFT)
        b:DockMargin(0, 0, 8, 0)
        b:SetWide(112)
        b.OnClick = function() chat.AddText(DUIF.GetColor("Accent"), "[DUIF] ", DUIF.GetColor("Text"), "Clicked style: " .. st) end
    end

    snippet(parent, 'local b = DUIF.CreateButton(parent, "Click Me", "primary")')
end

local function createInputDemo(parent)
    section(parent, "Inputs", "Text entry, slider, dropdown and modern toggle")

    local card = DUIF.CreateCard(parent, {
        tall = 190,
        header = "Live Test Area",
        description = "Interact with all controls below",
        accentBorder = true
    })

    local entry = DUIF.CreateTextEntry(card, "Type here and press enter...")
    entry:SetPos(12, 64)
    entry:SetSize(280, 34)

    local slider = DUIF.CreateSlider(card, 0, 100, {
        default = 35,
        onChanged = function(_, value)
            card.Description = "Slider: " .. math.Round(value, 1)
        end
    })
    slider:SetPos(304, 60)
    slider:SetSize(260, 42)

    local dropdown = DUIF.CreateDropdown(card, { "Alpha", "Bravo", "Charlie", "Delta" })
    dropdown:SetPos(576, 64)
    dropdown:SetSize(200, 34)

    local toggle = DUIF.CreateToggle(card, true)
    toggle:SetPos(790, 67)

    snippet(parent, "DUIF.CreateTextEntry / CreateSlider / CreateDropdown / CreateToggle")
end

local function createLayoutDemo(parent)
    section(parent, "Cards + Close Button", "Card component with icon and standalone close button")

    local row = vgui.Create("DPanel", parent)
    row:Dock(TOP)
    row:SetTall(110)
    row:DockMargin(0, 0, 0, 12)
    row.Paint = nil

    local card = DUIF.CreateCard(row, {
        dock = LEFT,
        margin = {0, 0, 8, 0},
        tall = 110,
        header = "Server Status",
        description = "128 players online • 65 tick • Premium theme",
        icon = "◆",
        accentBorder = true
    })
    card:SetWide(540)

    local closeDemo = DUIF.CreatePanel(row, { dock = FILL, padding = 8 })
    local lbl = vgui.Create("DLabel", closeDemo)
    lbl:SetFont("DUIF.Body")
    lbl:SetTextColor(DUIF.GetColor("Text"))
    lbl:SetText("Close button demo")
    lbl:SizeToContents()
    lbl:SetPos(12, 14)

    local close = DUIF.CreateCloseButton(closeDemo, {
        onClick = function(btn)
            local p = btn:GetParent()
            DUIF.Fade(p, 255, 0, 0.2, function(pp)
                pp:SetAlpha(255)
            end)
        end
    })
    close:SetPos(12, 42)

    snippet(parent, "DUIF.CreateCard(...) and DUIF.CreateCloseButton(parent)")
end

local function createExtraModuleDemo(parent)
    section(parent, "Extra Modules", "Progress bars, tabs, collapsible sections, modal helper")

    local card = DUIF.CreateCard(parent, {
        tall = 254,
        header = "Toolkit Extras",
        description = "More ready-to-use modules for larger projects",
        accentBorder = true
    })

    local progress = DUIF.CreateProgressBar(card, { value = 64, max = 100, showText = true })
    progress:SetPos(12, 62)
    progress:SetSize(280, 20)

    local tabs = DUIF.CreateTabs(card)
    tabs:SetPos(304, 58)
    tabs:SetSize(380, 144)

    tabs:AddTab("Stats", function(panel)
        local t = vgui.Create("DLabel", panel)
        t:SetFont("DUIF.Small")
        t:SetTextColor(DUIF.GetColor("TextMuted"))
        t:SetText("Server Uptime: 04:22:15")
        t:SizeToContents()
        t:SetPos(8, 12)
    end)

    tabs:AddTab("Logs", function(panel)
        local t = vgui.Create("DLabel", panel)
        t:SetFont("DUIF.Small")
        t:SetTextColor(DUIF.GetColor("TextMuted"))
        t:SetText("No warnings in the last 5 minutes.")
        t:SizeToContents()
        t:SetPos(8, 12)
    end)

    local coll = DUIF.CreateCollapsible(card, "Advanced Actions", {
        startOpen = false,
        contentTall = 72
    })
    coll:SetPos(694, 58)
    coll:SetSize(270, 106)

    local modalBtn = DUIF.CreateButton(card, "Open Modal", "primary", {
        onClick = function()
            DUIF.CreateModal("DUIF Modal", "This is a reusable modal dialog component.")
        end
    })
    modalBtn:SetPos(694, 170)
    modalBtn:SetSize(130, 32)

    snippet(parent, "CreateProgressBar / CreateTabs / CreateCollapsible / CreateModal")
end

function DUIF.OpenShowcase()
    if IsValid(DUIF.ShowcaseFrame) then DUIF.ShowcaseFrame:Remove() end

    local frame = DUIF.CreateFrame("DUIF Showcase", 1120, 760)
    DUIF.ShowcaseFrame = frame

    local sidebar = DUIF.CreateSidebar(frame, { width = 210 })
    sidebar:AddItem("Dark", function() DUIF.SetTheme("dark") end, "secondary")
    sidebar:AddItem("Light", function() DUIF.SetTheme("light") end, "secondary")
    sidebar:AddItem("Neon", function() DUIF.SetTheme("neon") end, "secondary")

    local body = vgui.Create("DScrollPanel", frame)
    body:Dock(FILL)
    body:DockMargin(12, 64, 12, 12)
    DUIF.StyleScrollBar(body, { wide = 12, rounded = 6 })

    local headWrap = vgui.Create("DPanel", body)
    headWrap:Dock(TOP)
    headWrap:SetTall(88)
    headWrap:DockMargin(0, 0, 0, 10)
    headWrap.Paint = function(_, w, h)
        DUIF.DrawRoundedBox(10, 0, 0, w, h, ColorAlpha(DUIF.GetColor("Surface"), 180))
        DUIF.DrawGradient(0, 0, w, 3, DUIF.GetColor("Accent"), DUIF.GetColor("AccentAlt"), true)
        draw.SimpleText("Dubz UI Framework", "DUIF.Title", 12, 8, DUIF.GetColor("Text"), TEXT_ALIGN_LEFT)
        draw.SimpleText("Reusable Derma toolkit with modular components, themes, and animations.", "DUIF.Body", 12, 46, DUIF.GetColor("TextMuted"), TEXT_ALIGN_LEFT)
    end

    createButtonDemo(body)
    createInputDemo(body)
    createLayoutDemo(body)
    createExtraModuleDemo(body)
end

concommand.Add("duif_showcase", function()
    DUIF.OpenShowcase()
end)
