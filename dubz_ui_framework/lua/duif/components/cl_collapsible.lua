--[[
    DUIF - Dubz UI Framework
    File: cl_collapsible.lua
    Purpose: Collapsible section with header and animated open/close state.
]]

DUIF = DUIF or {}

function DUIF.CreateCollapsible(parent, title, opts)
    opts = DUIF.MergeOptions({
        dock = TOP,
        margin = {0, 0, 0, 8},
        startOpen = false,
        headerTall = 34,
        contentTall = 120
    }, opts)

    local wrap = vgui.Create("DPanel", parent)
    wrap:Dock(opts.dock)
    wrap:DockMargin(opts.margin[1], opts.margin[2], opts.margin[3], opts.margin[4])
    wrap:SetTall(opts.headerTall + (opts.startOpen and opts.contentTall or 0))
    wrap.Paint = nil

    local header = DUIF.CreateButton(wrap, title or "Section", "secondary", { tall = opts.headerTall })
    header:Dock(TOP)

    local content = DUIF.CreatePanel(wrap, { dock = TOP, padding = 8 })
    content:SetTall(opts.contentTall)
    content:SetVisible(opts.startOpen)

    wrap.Open = opts.startOpen

    function wrap:SetOpen(state)
        self.Open = state
        content:SetVisible(state)
        self:SetTall(opts.headerTall + (state and opts.contentTall or 0))
        header.Label = (state and "▾ " or "▸ ") .. (title or "Section")
    end

    header.OnClick = function()
        wrap:SetOpen(not wrap.Open)
    end

    wrap:SetOpen(opts.startOpen)

    wrap.Content = content
    return wrap
end
