--[[
    DUIF - Dubz UI Framework
    File: cl_utils.lua
    Purpose: Shared draw helpers, interpolation helpers, and small utility builders.
]]

DUIF = DUIF or {}

function DUIF.DrawRoundedBox(radius, x, y, w, h, color)
    draw.RoundedBox(radius, x, y, w, h, color)
end

function DUIF.LerpColor(frac, fromCol, toCol)
    return Color(
        Lerp(frac, fromCol.r, toCol.r),
        Lerp(frac, fromCol.g, toCol.g),
        Lerp(frac, fromCol.b, toCol.b),
        Lerp(frac, fromCol.a or 255, toCol.a or 255)
    )
end

function DUIF.DrawGradient(x, y, w, h, startCol, endCol, horizontal)
    if w <= 0 or h <= 0 then return end

    local steps = math.Clamp(math.floor((horizontal and w or h) / 5), 36, 160)

    for i = 0, steps do
        local t = i / steps
        local c = DUIF.LerpColor(t, startCol, endCol)
        surface.SetDrawColor(c)

        if horizontal then
            local sw = (w / steps) + 1
            surface.DrawRect(x + (t * w), y, sw, h)
        else
            local sh = (h / steps) + 1
            surface.DrawRect(x, y + (t * h), w, sh)
        end
    end
end

function DUIF.DrawShadowedPanel(x, y, w, h, radius, mainColor, shadowColor)
    DUIF.DrawRoundedBox(radius + 1, x + 2, y + 2, w, h, shadowColor or DUIF.GetColor("Shadow"))
    DUIF.DrawRoundedBox(radius, x, y, w, h, mainColor)
end

function DUIF.Clamp01(n)
    return math.Clamp(n, 0, 1)
end

function DUIF.MergeOptions(defaults, custom)
    local out = table.Copy(defaults or {})
    for k, v in pairs(custom or {}) do
        out[k] = v
    end
    return out
end

function DUIF.AttachTooltip(panel, text)
    if not IsValid(panel) then return end
    panel:SetTooltip(text or "")
end

function DUIF.CreateDivider(parent, opts)
    opts = DUIF.MergeOptions({
        tall = 1,
        margin = {0, 6, 0, 6},
        color = nil
    }, opts)

    local div = vgui.Create("DPanel", parent)
    div:Dock(TOP)
    div:SetTall(opts.tall)
    div:DockMargin(opts.margin[1], opts.margin[2], opts.margin[3], opts.margin[4])
    div.Paint = function(_, w, h)
        surface.SetDrawColor(opts.color or ColorAlpha(DUIF.GetColor("Border"), 180))
        surface.DrawRect(0, 0, w, h)
    end

    return div
end

function DUIF.Toast(message, duration)
    duration = duration or 3

    local toast = vgui.Create("DPanel")
    toast:SetSize(320, 44)
    toast:SetPos(ScrW() - 340, 24)
    toast:SetAlpha(0)
    toast:SetMouseInputEnabled(false)
    toast.Paint = function(_, w, h)
        DUIF.DrawShadowedPanel(0, 0, w, h, 8, DUIF.GetColor("Surface"))
        DUIF.DrawGradient(0, 0, 4, h, DUIF.GetColor("Accent"), DUIF.GetColor("AccentAlt"))
        draw.SimpleText(message or "Toast", "DUIF.Body", 12, h * 0.5, DUIF.GetColor("Text"), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    DUIF.Fade(toast, 0, 255, 0.18)

    timer.Simple(duration, function()
        if not IsValid(toast) then return end
        DUIF.Fade(toast, toast:GetAlpha(), 0, 0.2, function(pnl)
            if IsValid(pnl) then pnl:Remove() end
        end)
    end)
end

function DUIF.StyleScrollBar(scrollPanel, opts)
    if not IsValid(scrollPanel) or not IsValid(scrollPanel.VBar) then return end

    opts = DUIF.MergeOptions({
        wide = 10,
        rounded = 6
    }, opts)

    local bar = scrollPanel.VBar
    bar:SetWide(opts.wide)

    bar.Paint = function(_, w, h)
        DUIF.DrawRoundedBox(opts.rounded, 0, 0, w, h, ColorAlpha(DUIF.GetColor("Surface"), 120))
    end

    bar.btnUp.Paint = function(self, w, h)
        DUIF.DrawRoundedBox(4, 0, 0, w, h, ColorAlpha(DUIF.GetColor("SurfaceAlt"), self:IsHovered() and 220 or 170))
        draw.SimpleText("▴", "DUIF.Small", w * 0.5, h * 0.5, DUIF.GetColor("TextMuted"), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    bar.btnDown.Paint = function(self, w, h)
        DUIF.DrawRoundedBox(4, 0, 0, w, h, ColorAlpha(DUIF.GetColor("SurfaceAlt"), self:IsHovered() and 220 or 170))
        draw.SimpleText("▾", "DUIF.Small", w * 0.5, h * 0.5, DUIF.GetColor("TextMuted"), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    bar.btnGrip.Paint = function(self, w, h)
        local hover = self:IsHovered() and 1 or 0
        local gripColor = DUIF.LerpColor(hover, DUIF.GetColor("Accent"), DUIF.GetColor("AccentAlt"))

        DUIF.DrawRoundedBox(opts.rounded, 1, 0, w - 2, h, ColorAlpha(gripColor, 220))
        DUIF.DrawRoundedBox(opts.rounded, 3, 4, w - 6, h - 8, Color(255, 255, 255, 28))
    end
end
