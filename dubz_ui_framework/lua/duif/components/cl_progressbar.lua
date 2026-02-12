--[[
    DUIF - Dubz UI Framework
    File: cl_progressbar.lua
    Purpose: Theme-aware progress bar with optional animated gradient fill and label.
]]

DUIF = DUIF or {}

function DUIF.CreateProgressBar(parent, opts)
    opts = DUIF.MergeOptions({
        tall = 20,
        rounded = 8,
        value = 0,
        max = 100,
        showText = true
    }, opts)

    local bar = vgui.Create("DPanel", parent)
    bar:SetTall(opts.tall)
    bar.Value = opts.value
    bar.Max = math.max(1, opts.max)

    function bar:SetValue(v)
        self.Value = math.Clamp(v, 0, self.Max)
    end

    function bar:SetMax(v)
        self.Max = math.max(1, v)
    end

    function bar:GetFraction()
        return math.Clamp(self.Value / self.Max, 0, 1)
    end

    bar.Paint = function(self, w, h)
        local frac = self:GetFraction()
        DUIF.DrawRoundedBox(opts.rounded, 0, 0, w, h, ColorAlpha(DUIF.GetColor("SurfaceAlt"), 210))

        local fillW = math.max(0, (w - 2) * frac)
        if fillW > 0 then
            DUIF.DrawGradient(1, 1, fillW, h - 2, DUIF.GetColor("Accent"), DUIF.GetColor("AccentAlt"), true)
        end

        if opts.showText then
            draw.SimpleText(string.format("%d%%", math.floor(frac * 100)), "DUIF.Small", w * 0.5, h * 0.5, DUIF.GetColor("Text"), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
    end

    return bar
end
