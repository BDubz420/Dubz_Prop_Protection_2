--[[
    DUIF - Dubz UI Framework
    File: cl_modal.lua
    Purpose: Modal dialog helper with dimmed backdrop and action buttons.
]]

DUIF = DUIF or {}

function DUIF.CreateModal(title, bodyText, opts)
    opts = DUIF.MergeOptions({
        w = 460,
        h = 220,
        confirmText = "Confirm",
        cancelText = "Cancel",
        onConfirm = nil,
        onCancel = nil
    }, opts)

    local backdrop = vgui.Create("EditablePanel")
    backdrop:SetSize(ScrW(), ScrH())
    backdrop:MakePopup()
    backdrop:SetKeyboardInputEnabled(true)
    backdrop.Paint = function(_, w, h)
        surface.SetDrawColor(0, 0, 0, 120)
        surface.DrawRect(0, 0, w, h)
    end

    local frame = DUIF.CreateFrame(title or "Modal", opts.w, opts.h, {
        onClose = function()
            if IsValid(backdrop) then backdrop:Remove() end
            if isfunction(opts.onCancel) then opts.onCancel() end
        end
    })
    frame:SetParent(backdrop)
    frame:Center()

    local text = vgui.Create("DLabel", frame)
    text:SetFont("DUIF.Body")
    text:SetTextColor(DUIF.GetColor("TextMuted"))
    text:SetText(bodyText or "")
    text:SetWrap(true)
    text:SetAutoStretchVertical(true)
    text:SetPos(16, 70)
    text:SetSize(opts.w - 32, 80)

    local controls = vgui.Create("DPanel", frame)
    controls:Dock(BOTTOM)
    controls:SetTall(52)
    controls:DockMargin(10, 0, 10, 10)
    controls.Paint = nil

    local cancel = DUIF.CreateButton(controls, opts.cancelText, "ghost", {
        onClick = function()
            if isfunction(opts.onCancel) then opts.onCancel() end
            backdrop:Remove()
        end
    })
    cancel:Dock(RIGHT)
    cancel:SetWide(100)

    local confirm = DUIF.CreateButton(controls, opts.confirmText, "primary", {
        onClick = function()
            if isfunction(opts.onConfirm) then opts.onConfirm() end
            backdrop:Remove()
        end
    })
    confirm:Dock(RIGHT)
    confirm:DockMargin(0, 0, 8, 0)
    confirm:SetWide(110)

    return frame, backdrop
end
