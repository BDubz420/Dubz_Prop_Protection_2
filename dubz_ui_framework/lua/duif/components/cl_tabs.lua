--[[
    DUIF - Dubz UI Framework
    File: cl_tabs.lua
    Purpose: Simple themed tab bar with content switching for modular layouts.
]]

DUIF = DUIF or {}

function DUIF.CreateTabs(parent, opts)
    opts = DUIF.MergeOptions({
        tabTall = 34,
        spacing = 6
    }, opts)

    local root = vgui.Create("DPanel", parent)
    root.Paint = nil

    local header = vgui.Create("DPanel", root)
    header:Dock(TOP)
    header:SetTall(opts.tabTall)
    header.Paint = nil

    local content = vgui.Create("DPanel", root)
    content:Dock(FILL)
    content.Paint = nil

    root.Tabs = {}
    root.ActiveTab = nil

    function root:AddTab(name, buildFunc)
        local btn = DUIF.CreateButton(header, name, "secondary", { tall = opts.tabTall })
        btn:Dock(LEFT)
        btn:DockMargin(0, 0, opts.spacing, 0)
        btn:SetWide(120)

        local panel = vgui.Create("DPanel", content)
        panel:Dock(FILL)
        panel:SetVisible(false)
        panel.Paint = nil

        if isfunction(buildFunc) then
            buildFunc(panel)
        end

        btn.OnClick = function()
            for _, t in ipairs(root.Tabs) do
                t.Panel:SetVisible(false)
                t.Button.Style = "secondary"
            end

            panel:SetVisible(true)
            btn.Style = "primary"
            root.ActiveTab = name
        end

        table.insert(root.Tabs, { Name = name, Button = btn, Panel = panel })

        if #root.Tabs == 1 then
            btn:DoClick()
        end

        return panel
    end

    return root
end
