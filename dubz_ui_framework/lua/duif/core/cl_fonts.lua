--[[
    DUIF - Dubz UI Framework
    File: cl_fonts.lua
    Purpose: Centralized DUIF font creation with readability-focused defaults and optional bundled-font support.
]]

DUIF = DUIF or {}

DUIF.FontConfig = DUIF.FontConfig or {
    -- Optional explicit overrides (set before DUIF loads):
    -- SansFamily = "Your Font Name",
    -- MonoFamily = "Your Mono Font Name",

    -- Keep bundled fonts opt-in so random condensed faces are not selected by default.
    UseBundledFonts = false,

    SansFallbacks = {
        "Roboto",
        "Inter",
        "Segoe UI",
        "Poppins",
        "Tahoma",
        "Arial"
    },

    MonoFallbacks = {
        "JetBrains Mono",
        "Roboto Mono",
        "Consolas",
        "Courier New"
    },

    -- Common directories where addons place downloadable font files.
    ScanPaths = {
        "resource/fonts/*.ttf",
        "resource/fonts/*.otf",
        "resource/fonts/duif/*.ttf",
        "resource/fonts/duif/*.otf",
        "materials/fonts/*.ttf",
        "materials/fonts/*.otf",
        "materials/fonts/duif/*.ttf",
        "materials/fonts/duif/*.otf"
    }
}

local function filenameToFace(path)
    local name = string.GetFileFromFilename(path)
    name = string.StripExtension(name or "")

    if name == "" then return nil end
    return name
end

local function collectBundledFaces()
    local faces = {}

    for _, pattern in ipairs(DUIF.FontConfig.ScanPaths or {}) do
        local files = file.Find(pattern, "GAME") or {}

        for _, fname in ipairs(files) do
            local guess = filenameToFace(fname)
            if guess then
                faces[#faces + 1] = guess
            end
        end
    end

    return faces
end

local function bundledFontScore(name)
    local lower = string.lower(name)
    local score = 0

    -- Prefer regular/readable weights.
    if string.find(lower, "regular", 1, true) then score = score + 5 end
    if string.find(lower, "medium", 1, true) then score = score + 4 end
    if string.find(lower, "book", 1, true) then score = score + 3 end

    -- Penalize condensed/narrow variants.
    if string.find(lower, "condensed", 1, true) then score = score - 8 end
    if string.find(lower, "narrow", 1, true) then score = score - 6 end
    if string.find(lower, "compressed", 1, true) then score = score - 6 end

    return score
end

local function bestBundledFace(faces)
    if #faces == 0 then return nil end

    local bestName = faces[1]
    local bestScore = bundledFontScore(bestName)

    for i = 2, #faces do
        local s = bundledFontScore(faces[i])
        if s > bestScore then
            bestScore = s
            bestName = faces[i]
        end
    end

    return bestName
end

local function chooseFamily(overrideName, bundled, fallback)
    if isstring(overrideName) and overrideName ~= "" then
        return overrideName
    end

    if DUIF.FontConfig.UseBundledFonts then
        local bundledBest = bestBundledFace(bundled)
        if bundledBest then
            return bundledBest
        end
    end

    return fallback[1]
end

function DUIF.BuildFonts(scale)
    scale = scale or 1

    local bundledFaces = collectBundledFaces()
    local sans = chooseFamily(DUIF.FontConfig.SansFamily, bundledFaces, DUIF.FontConfig.SansFallbacks)
    local mono = chooseFamily(DUIF.FontConfig.MonoFamily, bundledFaces, DUIF.FontConfig.MonoFallbacks)

    surface.CreateFont("DUIF.Title", {
        font = sans,
        size = math.floor(32 * scale),
        weight = 700,
        antialias = true,
        extended = true
    })

    surface.CreateFont("DUIF.Header", {
        font = sans,
        size = math.floor(24 * scale),
        weight = 650,
        antialias = true,
        extended = true
    })

    surface.CreateFont("DUIF.Body", {
        font = sans,
        size = math.floor(18 * scale),
        weight = 500,
        antialias = true,
        extended = true
    })

    surface.CreateFont("DUIF.Small", {
        font = sans,
        size = math.floor(15 * scale),
        weight = 450,
        antialias = true,
        extended = true
    })

    surface.CreateFont("DUIF.Mono", {
        font = mono,
        size = math.floor(15 * scale),
        weight = 500,
        antialias = true,
        extended = true
    })
end

DUIF.BuildFonts()

hook.Add("OnScreenSizeChanged", "DUIF.RebuildFonts", function()
    DUIF.BuildFonts()
end)
