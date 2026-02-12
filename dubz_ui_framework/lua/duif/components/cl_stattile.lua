--[[
    DUIF - Dubz UI Framework
    File: cl_stattile.lua
    Purpose: Dashboard stat tile component for quick KPI-style summaries.
]]

DUIF = DUIF or {}

function DUIF.CreateStatTile(parent, opts)
    opts = DUIF.MergeOptions({
        title = "Stat",
        value = "0",
        subtitle = nil,
        icon = nil,
        accent = true,
        tall = 108,
        dock = TOP,
        margin = {0, 0, 0, 8}
    }, opts)

    local tile = DUIF.CreateCard(parent, {
        tall = opts.tall,
        dock = opts.dock,
        margin = opts.margin,
        header = opts.title,
        description = opts.subtitle,
        icon = opts.icon,
        accentBorder = opts.accent
    })

    tile.ValueText = opts.value

    local oldPaint = tile.Paint
    tile.Paint = function(self, w, h)
        oldPaint(self, w, h)
        draw.SimpleText(self.ValueText, "DUIF.Title", 14, h - 14, DUIF.GetColor("Text"), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
    end

    function tile:SetValue(v)
        self.ValueText = tostring(v)
    end

    return tile
end
