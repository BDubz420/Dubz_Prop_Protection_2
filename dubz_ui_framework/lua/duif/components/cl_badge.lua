--[[
    DUIF - Dubz UI Framework
    File: cl_badge.lua
    Purpose: Small status/label badges for cards, tables, and metadata displays.
]]

DUIF = DUIF or {}

function DUIF.CreateBadge(parent, text, style, opts)
    opts = DUIF.MergeOptions({
        rounded = 6,
        paddingX = 10,
        tall = 22
    }, opts)

    local palette = {
        primary = DUIF.GetColor("Accent"),
        success = DUIF.GetColor("Success"),
        danger = DUIF.GetColor("Danger"),
        warning = DUIF.GetColor("Warning"),
        muted = DUIF.GetColor("SurfaceAlt")
    }

    local badge = vgui.Create("DPanel", parent)
    badge.Text = text or "Badge"
    badge.Style = style or "primary"
    badge:SetTall(opts.tall)

    surface.SetFont("DUIF.Small")
    local tw = select(1, surface.GetTextSize(badge.Text))
    badge:SetWide((tw > 0 and tw or 40) + (opts.paddingX * 2))

    badge.Paint = function(self, w, h)
        local col = palette[self.Style] or palette.primary
        DUIF.DrawRoundedBox(opts.rounded, 0, 0, w, h, ColorAlpha(col, 220))
        draw.SimpleText(self.Text, "DUIF.Small", w * 0.5, h * 0.5, DUIF.GetColor("Text"), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    return badge
end
