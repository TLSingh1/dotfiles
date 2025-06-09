local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

local config_group = augroup("UserConfig", { clear = true })

-- Auto-hide cursor line in non-active windows
local cl_var = "auto_cursorline"

autocmd({ "InsertLeave", "WinEnter" }, {
	group = augroup("enable_auto_cursorline", { clear = true }),
	callback = function()
		local ok, cl = pcall(vim.api.nvim_win_get_var, 0, cl_var)
		if ok and cl then
			vim.api.nvim_win_del_var(0, cl_var)
			vim.wo.cursorline = true
		end
	end,
	desc = "Enable cursor line in active window",
})

autocmd({ "InsertEnter", "WinLeave" }, {
	group = augroup("disable_auto_cursorline", { clear = true }),
	callback = function()
		local cl = vim.wo.cursorline
		if cl then
			vim.api.nvim_win_set_var(0, cl_var, cl)
			vim.wo.cursorline = false
		end
	end,
	desc = "Disable cursor line in inactive windows",
})

-- Set InactiveWindow background color on startup
autocmd("VimEnter", {
	group = config_group,
	pattern = "*",
	callback = function()
		vim.cmd("hi InactiveWindow guibg=#000000")
	end,
	desc = "Set InactiveWindow background to pure black",
})

-- Also set it after colorscheme changes
autocmd("ColorScheme", {
	group = config_group,
	pattern = "*",
	callback = function()
		vim.defer_fn(function()
			vim.cmd("hi InactiveWindow guibg=#000000")
		end, 1)
	end,
	desc = "Ensure InactiveWindow stays black after colorscheme changes",
})

-- Dynamic color integration with Caelestia
local caelestia_group = augroup("CaelestiaColors", { clear = true })

-- Watch for Caelestia color scheme changes
local function setup_caelestia_watcher()
	local timer = vim.loop.new_timer()
	local last_mtime = 0
	local scheme_file = vim.fn.expand("~/.local/state/caelestia/scheme/current.txt")
	
	timer:start(1000, 5000, vim.schedule_wrap(function()
		local stat = vim.loop.fs_stat(scheme_file)
		
		if stat and stat.mtime.sec > last_mtime then
			last_mtime = stat.mtime.sec
			
			-- Reload colors
			local ok, dynamic_colors = pcall(require, "plugins.ui.dynamic-colors")
			if ok then
				local colors = dynamic_colors.read_caelestia_colors()
				if colors then
					local config = dynamic_colors.setup()
					-- Reload catppuccin with new colors
					require("catppuccin").setup(vim.tbl_extend("force", 
						require("catppuccin").options or {},
						config
					))
					vim.cmd.colorscheme("catppuccin")
				end
			end
		end
	end))
end

-- Start watching after VimEnter
autocmd("VimEnter", {
	group = caelestia_group,
	callback = setup_caelestia_watcher,
	desc = "Start watching for Caelestia color changes",
})

-- Commands for dynamic color integration
vim.api.nvim_create_user_command("CaelestiaReloadColors", function()
	local ok, dynamic_colors = pcall(require, "plugins.ui.dynamic-colors")
	if not ok then
		vim.notify("Dynamic colors module not found", vim.log.levels.ERROR)
		return
	end
	
	local config = dynamic_colors.setup()
	
	if config.color_overrides and config.color_overrides.mocha then
		-- Reload catppuccin with new colors
		require("catppuccin").setup(vim.tbl_extend("force", 
			require("catppuccin").options or {},
			config
		))
		vim.cmd.colorscheme("catppuccin")
		vim.notify("Caelestia colors reloaded", vim.log.levels.INFO)
	else
		vim.notify("No Caelestia colors found", vim.log.levels.WARN)
	end
end, { desc = "Reload colors from Caelestia color scheme" })

vim.api.nvim_create_user_command("CaelestiaShowColors", function()
	local ok, dynamic_colors = pcall(require, "plugins.ui.dynamic-colors")
	if not ok then
		vim.notify("Dynamic colors module not found", vim.log.levels.ERROR)
		return
	end
	
	local colors = dynamic_colors.read_caelestia_colors()
	
	if colors then
		local lines = { "Caelestia Color Scheme:" }
		for name, value in pairs(colors) do
			table.insert(lines, string.format("  %s: %s", name, value))
		end
		vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO)
	else
		vim.notify("No Caelestia colors found", vim.log.levels.WARN)
	end
end, { desc = "Show current Caelestia colors" })

-- Debug command to test color generation
vim.api.nvim_create_user_command("CaelestiaTestColors", function()
	local ok, dynamic_colors = pcall(require, "plugins.ui.dynamic-colors")
	if not ok then
		vim.notify("Dynamic colors module not found", vim.log.levels.ERROR)
		return
	end
	
	local caelestia_colors = dynamic_colors.read_caelestia_colors()
	if caelestia_colors then
		vim.notify("Found colors: blue=" .. (caelestia_colors.blue or "nil") .. ", yellow=" .. (caelestia_colors.yellow or "nil"), vim.log.levels.INFO)
		
		local palette = dynamic_colors.generate_holographic_palette(caelestia_colors)
		vim.notify("Generated palette: base=" .. (palette.base or "nil") .. ", surface0=" .. (palette.surface0 or "nil"), vim.log.levels.INFO)
	else
		vim.notify("No Caelestia colors found at ~/.local/state/caelestia/scheme/current.txt", vim.log.levels.ERROR)
	end
end, { desc = "Test Caelestia color generation" })

