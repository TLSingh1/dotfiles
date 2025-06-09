-- Force reload Caelestia colors after all plugins are loaded
vim.defer_fn(function()
    local ok, dynamic_colors = pcall(require, "plugins.ui.dynamic-colors")
    if ok then
        local config = dynamic_colors.setup()
        if config.color_overrides and config.color_overrides.mocha then
            -- Force catppuccin to reload with new colors
            require("catppuccin").setup(vim.tbl_deep_extend("force", 
                require("catppuccin").options or {},
                config
            ))
            vim.cmd("colorscheme catppuccin")
            vim.notify("Applied Caelestia colors", vim.log.levels.INFO)
        end
    end
end, 100)