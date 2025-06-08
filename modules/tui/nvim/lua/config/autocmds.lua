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

