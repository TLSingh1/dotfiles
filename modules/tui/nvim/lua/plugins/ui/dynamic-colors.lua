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

-- Map Caelestia colors to Catppuccin theme
function M.generate_catppuccin_overrides(caelestia_colors)
    if not caelestia_colors then
        return {}
    end
    
    -- Base colors using overlay tones
    local base_colors = {
        base = caelestia_colors.crust or "#11111b",
        mantle = caelestia_colors.mantle or "#181825",
        crust = caelestia_colors.base or "#1e1e2e",
    }
    
    -- Surface colors
    local surface_colors = {
        surface0 = caelestia_colors.surface0 or "#313244",
        surface1 = caelestia_colors.surface1 or "#45475a",
        surface2 = caelestia_colors.surface2 or "#585b70",
    }
    
    -- Overlay colors
    local overlay_colors = {
        overlay0 = caelestia_colors.overlay0 or "#6c7086",
        overlay1 = caelestia_colors.overlay1 or "#7f849c",
        overlay2 = caelestia_colors.overlay2 or "#9399b2",
    }
    
    -- Text colors
    local text_colors = {
        text = caelestia_colors.text or "#cdd6f4",
        subtext1 = caelestia_colors.subtext1 or "#bac2de",
        subtext0 = caelestia_colors.subtext0 or "#a6adc8",
    }
    
    -- Main theme colors
    local theme_colors = {
        rosewater = caelestia_colors.rosewater,
        flamingo = caelestia_colors.flamingo,
        pink = caelestia_colors.pink,
        mauve = caelestia_colors.mauve,
        red = caelestia_colors.red,
        maroon = caelestia_colors.maroon,
        peach = caelestia_colors.peach,
        yellow = caelestia_colors.yellow,
        green = caelestia_colors.green,
        teal = caelestia_colors.teal,
        sky = caelestia_colors.sky,
        sapphire = caelestia_colors.sapphire,
        blue = caelestia_colors.blue,
        lavender = caelestia_colors.lavender,
    }
    
    -- Merge all color groups
    local colors = vim.tbl_extend("force", 
        base_colors, 
        surface_colors, 
        overlay_colors, 
        text_colors, 
        theme_colors
    )
    
    return colors
end

-- Generate custom highlights based on Caelestia colors
function M.generate_custom_highlights(colors)
    if not colors then
        return function() return {} end
    end
    
    return function()
        return {
            -- Window backgrounds
            ActiveWindow = { bg = colors.mantle },
            InactiveWindow = { bg = colors.crust },
            WinBar = { bg = colors.mantle },
            WinBarNC = { bg = colors.crust },
            StatusLine = { bg = colors.crust },
            FloatBorder = { fg = colors.blue, bg = colors.crust },
            WinSeparator = { fg = colors.blue, bg = colors.crust },
            
            -- NeoTree
            NeoTreeFloatBorder = { fg = colors.blue, bg = colors.mantle },
            NeoTreeFloatTitle = { fg = colors.yellow, bg = colors.mantle },
            NeoTreeNormal = { bg = colors.mantle },
            NeoTreeTabActive = { bg = colors.surface0 },
            NeoTreeTabSeparatorActive = { fg = colors.surface0, bg = colors.surface0 },
            
            -- Command line
            NoiceCmdLine = { bg = colors.crust },
            
            -- Telescope
            TelescopePromptNormal = { fg = colors.yellow, bg = colors.surface0 },
            TelescopePromptBorder = { fg = colors.blue, bg = colors.surface0 },
            TelescopePrompt = { fg = colors.surface0, bg = colors.surface0 },
            TelescopeBorder = { fg = colors.blue, bg = colors.mantle },
            TelescopeSelection = { bg = colors.surface1 },
            TelescopeSelectionCaret = { bg = colors.surface1 },
            TelescopeTitle = { fg = colors.yellow, bg = colors.surface0 },
            TelescopeResultsNormal = { bg = colors.mantle },
            TelescopePreviewNormal = { bg = colors.mantle },
            
            -- Editor highlights
            Folded = { bg = colors.surface1, style = { "italic", "bold" } },
            CursorLine = { bg = colors.surface0 },
            CursorLineNr = { fg = colors.blue, bg = colors.surface0, style = { "bold" } },
            
            -- Tree and markdown
            NvimTreeNormalFloat = { bg = colors.mantle },
            NvimTreeSignColumn = { bg = colors.mantle },
            HelpviewCode = { bg = colors.surface0 },
            RenderMarkdownCode = { bg = colors.surface0 },
            RenderMarkdown_Inverse_RenderMarkdownCode = { fg = colors.surface0, bg = colors.surface0 },
            
            -- Additional highlights
            Normal = { bg = colors.base },
            NormalFloat = { bg = colors.mantle },
            LineNr = { fg = colors.overlay0 },
            SignColumn = { bg = colors.base },
            VertSplit = { fg = colors.blue, bg = colors.base },
            
            -- Git signs
            GitSignsAdd = { fg = colors.green },
            GitSignsChange = { fg = colors.yellow },
            GitSignsDelete = { fg = colors.red },
        }
    end
end

-- Setup function to be called from catppuccin config
function M.setup()
    local colors = M.read_caelestia_colors()
    local overrides = M.generate_catppuccin_overrides(colors)
    local highlights = M.generate_custom_highlights(colors)
    
    return {
        color_overrides = {
            mocha = overrides
        },
        custom_highlights = highlights
    }
end

-- The watch_colors functionality has been moved to autocmds.lua

return M