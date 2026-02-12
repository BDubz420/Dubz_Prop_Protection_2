--[[
    DUIF - Dubz UI Framework
    File: cl_slider.lua
    Purpose: Lightweight themed slider with smooth value animation and callbacks.
]]

DUIF = DUIF or {}

function DUIF.CreateSlider(parent, min, max, opts)
    opts = DUIF.MergeOptions({
        tall = 40,
        rounded = 8,
        default = min or 0,
        onChanged = nil
    }, opts)

    local pnl = vgui.Create("DPanel", parent)
    pnl:SetTall(opts.tall)
    pnl.Min = min or 0
    pnl.Max = max or 100
    pnl.Value = math.Clamp(opts.default, pnl.Min, pnl.Max)

    local slider = vgui.Create("DSlider", pnl)
    slider:Dock(FILL)
    slider.Paint = function() end

    slider.Knob:SetSize(14, 14)
    slider.Knob.Paint = function(self, w, h)
        DUIF.DrawRoundedBox(7, 0, 0, w, h, Color(238, 243, 255))
    end

    slider:SetSlideX((pnl.Value - pnl.Min) / math.max(1, (pnl.Max - pnl.Min)))

    function pnl:SetValue(v, noCallback)
        self.Value = math.Clamp(v, self.Min, self.Max)
        local frac = (self.Value - self.Min) / math.max(1, (self.Max - self.Min))
        slider:SetSlideX(frac)

        if not noCallback then
            if isfunction(self.OnChanged) then self:OnChanged(self.Value) end
            if isfunction(opts.onChanged) then opts.onChanged(self, self.Value) end
        end
    end

    function pnl:GetValue()
        return self.Value
    end

    slider.TranslateValues = function(_, x)
        local value = pnl.Min + (x * (pnl.Max - pnl.Min))
        value = math.Round(value, 2)
        pnl:SetValue(value)
        return x, 0.5
    end

    pnl.Paint = function(self, w, h)
        local frac = (self.Value - self.Min) / math.max(1, (self.Max - self.Min))
        frac = math.Clamp(frac, 0, 1)
        local lineY = h * 0.5
        local trackX, trackW = 10, (w - 20)

        DUIF.DrawRoundedBox(2, trackX, lineY - 2, trackW, 4, ColorAlpha(DUIF.GetColor("Border"), 180))

        local fillW = math.max(0, trackW * frac)
        if fillW > 0.5 then
            DUIF.DrawGradient(trackX, lineY - 2, fillW, 4, DUIF.GetColor("Accent"), DUIF.GetColor("AccentAlt"), true)
        end

        draw.SimpleText(string.format("%s", self.Value), "DUIF.Small", w - 2, 2, DUIF.GetColor("TextMuted"), TEXT_ALIGN_RIGHT)
    end

    return pnl
end
