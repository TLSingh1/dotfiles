-- Dynamic color integration with Caelestia
local M = {}

-- Read color scheme from Caelestia
function M.read_caelestia_colors()
    local scheme_file = vim.fn.expand("~/.local/state/caelestia/scheme/current.txt")
    local colors = {}
    
    if vim.fn.filereadable(scheme_file) == 0 then
        return nil
    end
    
    for line in io.lines(scheme_file) do
        local name, value = line:match("(%S+)%s+(%S+)")
        if name and value then
            colors[name] = "#" .. value
        end
    end
    
    return colors
end

-- Helper to convert hex to HSL
local function hex_to_hsl(hex)
    hex = hex:gsub("#", "")
    local r = tonumber(hex:sub(1, 2), 16) / 255
    local g = tonumber(hex:sub(3, 4), 16) / 255
    local b = tonumber(hex:sub(5, 6), 16) / 255
    
    local max, min = math.max(r, g, b), math.min(r, g, b)
    local l = (max + min) / 2
    local h, s = 0, 0
    
    if max ~= min then
        local d = max - min
        s = l > 0.5 and d / (2 - max - min) or d / (max + min)
        
        if max == r then
            h = (g - b) / d + (g < b and 6 or 0)
        elseif max == g then
            h = (b - r) / d + 2
        else
            h = (r - g) / d + 4
        end
        h = h / 6
    end
    
    return h * 360, s, l
end

-- Helper to convert HSL to hex
local function hsl_to_hex(h, s, l)
    h = h / 360
    local r, g, b
    
    if s == 0 then
        r, g, b = l, l, l
    else
        local function hue2rgb(p, q, t)
            if t < 0 then t = t + 1 end
            if t > 1 then t = t - 1 end
            if t < 1/6 then return p + (q - p) * 6 * t end
            if t < 1/2 then return q end
            if t < 2/3 then return p + (q - p) * (2/3 - t) * 6 end
            return p
        end
        
        local q = l < 0.5 and l * (1 + s) or l + s - l * s
        local p = 2 * l - q
        r = hue2rgb(p, q, h + 1/3)
        g = hue2rgb(p, q, h)
        b = hue2rgb(p, q, h - 1/3)
    end
    
    return string.format("#%02x%02x%02x", 
        math.floor(r * 255), 
        math.floor(g * 255), 
        math.floor(b * 255)
    )
end

-- Create holographic palette from wallpaper colors
function M.generate_holographic_palette(caelestia_colors)
    if not caelestia_colors then
        return {}
    end
    
    -- Get the primary colors from the wallpaper
    local primary = caelestia_colors.blue or caelestia_colors.sapphire or "#83a598"
    local secondary = caelestia_colors.mauve or caelestia_colors.pink or "#b16286"
    local accent = caelestia_colors.yellow or caelestia_colors.peach or "#d79921"
    
    -- Convert primary color to HSL for manipulation
    local h, s, l = hex_to_hsl(primary)
    
    -- Generate holographic effect colors based on the primary hue
    -- Create a gradient of colors that shift through the spectrum
    local palette = {
        -- Very dark backgrounds with slight color tint
        base = hsl_to_hex(h, s * 0.15, 0.04),      -- Almost black with color hint
        mantle = hsl_to_hex(h, s * 0.2, 0.06),     -- Slightly lighter
        crust = hsl_to_hex(h, s * 0.25, 0.08),     -- Darkest visible tint
        
        -- Surface colors - gradient with hue shift for holographic effect
        surface0 = hsl_to_hex(h + 10, s * 0.3, 0.15),   -- Slight hue shift
        surface1 = hsl_to_hex(h + 20, s * 0.35, 0.20),  -- More hue shift
        surface2 = hsl_to_hex(h + 30, s * 0.4, 0.25),   -- Maximum hue shift
        
        -- Overlay colors - desaturated versions
        overlay0 = hsl_to_hex(h, s * 0.3, 0.35),
        overlay1 = hsl_to_hex(h, s * 0.25, 0.45),
        overlay2 = hsl_to_hex(h, s * 0.2, 0.55),
        
        -- Text colors - high contrast
        text = hsl_to_hex(h, s * 0.1, 0.90),      -- Almost white with slight tint
        subtext1 = hsl_to_hex(h, s * 0.15, 0.80),
        subtext0 = hsl_to_hex(h, s * 0.2, 0.70),
    }
    
    -- Generate accent colors with holographic shifts
    -- These create the characteristic "rainbow" effect
    local accent_h, accent_s, accent_l = hex_to_hsl(accent)
    local secondary_h, secondary_s, secondary_l = hex_to_hsl(secondary)
    
    local accents = {
        -- Warm spectrum (reds/oranges/yellows)
        rosewater = hsl_to_hex(accent_h - 20, accent_s * 0.6, 0.85),
        flamingo = hsl_to_hex(accent_h - 10, accent_s * 0.7, 0.75),
        pink = caelestia_colors.pink or hsl_to_hex(secondary_h, secondary_s, 0.70),
        mauve = caelestia_colors.mauve or hsl_to_hex(secondary_h + 10, secondary_s * 0.9, 0.65),
        red = caelestia_colors.red or hsl_to_hex(0, 0.7, 0.60),
        maroon = caelestia_colors.maroon or hsl_to_hex(10, 0.6, 0.55),
        peach = caelestia_colors.peach or hsl_to_hex(accent_h, accent_s, accent_l),
        yellow = caelestia_colors.yellow or hsl_to_hex(accent_h + 10, accent_s * 1.1, 0.75),
        
        -- Cool spectrum (greens/blues/purples)
        green = caelestia_colors.green or hsl_to_hex(h - 30, s * 0.8, 0.60),
        teal = caelestia_colors.teal or hsl_to_hex(h - 20, s * 0.85, 0.55),
        sky = caelestia_colors.sky or hsl_to_hex(h - 10, s * 0.9, 0.65),
        sapphire = caelestia_colors.sapphire or hsl_to_hex(h, s * 0.95, 0.60),
        blue = caelestia_colors.blue or primary,
        lavender = caelestia_colors.lavender or hsl_to_hex(h + 40, s * 0.7, 0.70),
    }
    
    return vim.tbl_extend("force", palette, accents)
end

-- Generate custom highlights for holographic effect
function M.generate_custom_highlights(colors)
    if not colors then
        return function() return {} end
    end
    
    -- Get primary color for additional effects
    local primary_h, primary_s, primary_l = hex_to_hsl(colors.blue)
    
    return function()
        return {
            -- Window backgrounds - dark with subtle color
            ActiveWindow = { bg = colors.mantle },
            InactiveWindow = { bg = colors.base },
            WinBar = { bg = colors.mantle },
            WinBarNC = { bg = colors.base },
            StatusLine = { bg = colors.base },
            
            -- Borders with holographic gradient effect
            FloatBorder = { fg = colors.sapphire, bg = colors.base },
            WinSeparator = { fg = colors.teal, bg = colors.base },
            
            -- NeoTree with depth
            NeoTreeFloatBorder = { fg = colors.sky, bg = colors.mantle },
            NeoTreeFloatTitle = { fg = colors.yellow, bg = colors.mantle, style = { "bold" } },
            NeoTreeNormal = { bg = colors.mantle },
            NeoTreeTabActive = { bg = colors.surface0 },
            NeoTreeTabSeparatorActive = { fg = colors.surface0, bg = colors.surface0 },
            
            -- Command line
            NoiceCmdLine = { bg = colors.crust },
            
            -- Telescope with holographic depth
            TelescopePromptNormal = { fg = colors.text, bg = colors.surface1 },
            TelescopePromptBorder = { fg = colors.mauve, bg = colors.surface1 },
            TelescopePrompt = { fg = colors.text, bg = colors.surface1 },
            TelescopeBorder = { fg = colors.blue, bg = colors.mantle },
            TelescopeSelection = { bg = colors.surface2, fg = colors.text },
            TelescopeSelectionCaret = { bg = colors.surface2, fg = colors.peach },
            TelescopeTitle = { fg = colors.yellow, bg = colors.surface0, style = { "bold" } },
            TelescopeResultsNormal = { bg = colors.mantle },
            TelescopePreviewNormal = { bg = colors.crust },
            
            -- Editor highlights with holographic touch
            Folded = { bg = colors.surface1, fg = colors.overlay2, style = { "italic" } },
            CursorLine = { bg = colors.surface0 },
            CursorLineNr = { fg = colors.peach, bg = colors.surface0, style = { "bold" } },
            
            -- Code elements
            NvimTreeNormalFloat = { bg = colors.mantle },
            NvimTreeSignColumn = { bg = colors.mantle },
            HelpviewCode = { bg = colors.surface0 },
            RenderMarkdownCode = { bg = colors.surface0 },
            RenderMarkdown_Inverse_RenderMarkdownCode = { fg = colors.surface0, bg = colors.surface0 },
            
            -- Base highlights
            Normal = { bg = colors.base, fg = colors.text },
            NormalFloat = { bg = colors.mantle },
            LineNr = { fg = colors.overlay0 },
            SignColumn = { bg = colors.base },
            VertSplit = { fg = colors.surface2, bg = colors.base },
            
            -- Git signs with accent colors
            GitSignsAdd = { fg = colors.green },
            GitSignsChange = { fg = colors.yellow },
            GitSignsDelete = { fg = colors.red },
            
            -- Search and selection with holographic effect
            Search = { bg = colors.surface2, fg = colors.base, style = { "bold" } },
            IncSearch = { bg = colors.peach, fg = colors.base, style = { "bold" } },
            Visual = { bg = colors.surface1 },
            VisualNOS = { bg = colors.surface0 },
            
            -- Holographic gradient effect for special elements
            MatchParen = { bg = colors.surface2, fg = colors.pink, style = { "bold" } },
            CursorColumn = { bg = colors.surface0 },
            ColorColumn = { bg = colors.surface0 },
            
            -- Diagnostic highlights with holographic colors
            DiagnosticError = { fg = colors.red },
            DiagnosticWarn = { fg = colors.yellow },
            DiagnosticInfo = { fg = colors.sky },
            DiagnosticHint = { fg = colors.teal },
            
            -- Popup menu with depth
            Pmenu = { bg = colors.mantle, fg = colors.text },
            PmenuSel = { bg = colors.surface1, fg = colors.text, style = { "bold" } },
            PmenuSbar = { bg = colors.surface0 },
            PmenuThumb = { bg = colors.surface2 },
        }
    end
end

-- Setup function to be called from catppuccin config
function M.setup()
    local colors = M.read_caelestia_colors()
    local holographic_colors = M.generate_holographic_palette(colors)
    local highlights = M.generate_custom_highlights(holographic_colors)
    
    return {
        color_overrides = {
            mocha = holographic_colors
        },
        custom_highlights = highlights
    }
end

-- The watch_colors functionality has been moved to autocmds.lua

return M