local M = {}
local api = vim.api
local diagnostic = vim.diagnostic

local function is_git_repo()
	local git_dir = vim.fn.finddir(".git", vim.fn.expand("%:p:h") .. ";")
	return git_dir and #git_dir > 0
end

local function create_git_component()
	if not is_git_repo() then
		return ""
	end

	local status_dict = vim.b.gitsigns_status_dict
	if not status_dict then
		return ""
	end

	local components = {}

	local function add_count(symbol, count, highlight)
		if count and count > 0 then
			table.insert(components, string.format("%%#%s#%s %d ", highlight, symbol, count))
		end
	end

	add_count("󰐕", status_dict.added, "StatusLineGitAdded") -- Plus circle icon
	add_count("󰍴", status_dict.removed, "StatusLineGitRemoved") -- Trash/delete icon
	add_count("󰏫", status_dict.changed, "StatusLineGitChanged") -- Pencil/edit icon

	if status_dict.head then
		table.insert(components, string.format("%%#StatusLineGitBranch# 󰊢 %s ", status_dict.head))
	end

	return table.concat(components)
end

local function get_buffer_list()
	local buffers = {}
	for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_get_option_value("buflisted", { buf = bufnr }) then
			table.insert(buffers, bufnr)
		end
	end
	return buffers
end

local function get_diagnostics(bufnr)
	local diagnostics = {
		errors = #diagnostic.get(bufnr, { severity = diagnostic.severity.ERROR }),
		warnings = #diagnostic.get(bufnr, { severity = diagnostic.severity.WARN }),
		info = #diagnostic.get(bufnr, { severity = diagnostic.severity.INFO }),
		hints = #diagnostic.get(bufnr, { severity = diagnostic.severity.HINT }),
	}
	return diagnostics
end

local function get_buffer_info(bufnr)
	local name = api.nvim_buf_get_name(bufnr)
	local filename = name ~= "" and vim.fn.fnamemodify(name, ":t") or "[No Name]"
	local is_current = bufnr == api.nvim_get_current_buf()
	local is_visible = false

	for _, winid in ipairs(api.nvim_list_wins()) do
		if api.nvim_win_get_buf(winid) == bufnr then
			is_visible = true
			break
		end
	end

	-- Get buffer state info
	local modified = vim.bo[bufnr].modified
	local readonly = vim.bo[bufnr].readonly
	local modifiable = vim.bo[bufnr].modifiable

	-- Check if file requires sudo (is owned by root or not writable)
	local is_sudo = false
	if name ~= "" then
		local stat = vim.loop.fs_stat(name)
		if stat then
			-- Check if we don't have write permission
			is_sudo = not vim.fn.filewritable(name) == 1
		end
	end

	return {
		bufnr = bufnr,
		filename = filename,
		is_current = is_current,
		is_visible = is_visible,
		diagnostics = get_diagnostics(bufnr),
		modified = modified,
		readonly = readonly,
		modifiable = modifiable,
		is_sudo = is_sudo,
	}
end

local function create_buffer_component(info)
	-- Determine buffer state icon
	local state_icon = ""
	if info.is_sudo or (info.readonly and not info.modifiable) then
		state_icon = "󰌾 " -- Lock icon for sudo/readonly files
	elseif info.modified then
		state_icon = "󰆓 " -- Circle dot icon for modified files
	elseif info.readonly then
		state_icon = "󰈡 " -- Eye icon for readonly files
	else
		state_icon = "󰈙 " -- Document icon for normal files
	end

	local diag_str = ""
	if info.diagnostics.errors > 0 then
		diag_str = diag_str .. string.format(" %%#StatusLineDiagError_%s#󰅚 %d", info.bufnr, info.diagnostics.errors)
	end
	if info.diagnostics.warnings > 0 then
		diag_str = diag_str .. string.format(" %%#StatusLineDiagWarn_%s#󰀦 %d", info.bufnr, info.diagnostics.warnings)
	end
	if info.diagnostics.info > 0 then
		diag_str = diag_str .. string.format(" %%#StatusLineDiagInfo_%s#󰋼 %d", info.bufnr, info.diagnostics.info)
	end
	if info.diagnostics.hints > 0 then
		diag_str = diag_str .. string.format(" %%#StatusLineDiagHint_%s#󰌵 %d", info.bufnr, info.diagnostics.hints)
	end

	return string.format("%%#StatusLineBuffer_%s# %s%s %s  %%*", info.bufnr, state_icon, info.filename, diag_str)
end

function M.build_statusline()
	local buffers = get_buffer_list()
	local components = {}

	local comment_hl = api.nvim_get_hl(0, { name = "Comment" })
	local comment_fg = comment_hl.fg and string.format("#%06x", comment_hl.fg) or "Gray"

	for _, bufnr in ipairs(buffers) do
		local info = get_buffer_info(bufnr)
		local bg_color, fg_color, bold, italic
		if info.is_current then
			-- Active buffer - bright teal glow (Material You 3)
			bg_color = "#1e2829" -- surface0 (dark teal surface)
			fg_color = "#5eead4" -- yellow (primary 80 - bright teal)
			italic = false
			bold = true
		elseif info.is_visible then
			-- Visible but not active - subtle teal
			bg_color = "#161f20" -- window_bg
			fg_color = "#7dd3c0" -- peach (primary 70)
			italic = true
			bold = false
		else
			-- Hidden buffers - minimal highlight
			bg_color = "#0e1415" -- base
			fg_color = "#5f7c7d" -- line_number (muted teal)
			italic = true
			bold = false
		end

		-- Use native Neovim API to set highlights
		local diagnostic_highlights = {
			StatusLineDiagError = "DiagnosticError",
			StatusLineDiagWarn = "DiagnosticWarn",
			StatusLineDiagHint = "DiagnosticHint",
			StatusLineDiagInfo = "DiagnosticInfo",
		}

		api.nvim_set_hl(
			0,
			string.format("StatusLineBuffer_%s", bufnr),
			{ bg = bg_color, fg = fg_color, bold = bold, italic = italic }
		)
		-- Set buffer-specific diagnostic highlights with Material You 3 colors
		local diagnostic_colors = {
			StatusLineDiagError = "#f2718b", -- red (error 70)
			StatusLineDiagWarn = "#e694b3",  -- flamingo (tertiary 70)
			StatusLineDiagHint = "#a385cf",  -- mauve (secondary 70)
			StatusLineDiagInfo = "#67e8f9",  -- sky (secondary 80)
		}

		for hl, base_hl in pairs(diagnostic_highlights) do
			local fg_color = diagnostic_colors[hl]
			api.nvim_set_hl(0, hl .. "_" .. bufnr, { fg = fg_color, bg = bg_color })
		end

		table.insert(components, create_buffer_component(info))
	end

	-- Git highlights with Material You 3 cyan/teal theme
	api.nvim_set_hl(0, "StatusLineGitAdded", { fg = "#5eead4", bg = "#0e1415" })   -- yellow (primary 80)
	api.nvim_set_hl(0, "StatusLineGitRemoved", { fg = "#f2718b", bg = "#0e1415" }) -- red (error 70)
	api.nvim_set_hl(0, "StatusLineGitChanged", { fg = "#7dd3c0", bg = "#0e1415" }) -- peach (primary 70)
	api.nvim_set_hl(0, "StatusLineGitBranch", { fg = "#38bdf8", bg = "#0e1415", bold = true }) -- sapphire (secondary 70)

	table.insert(components, "%=") -- Right align
	table.insert(components, create_git_component())

	return table.concat(components)
end

-- Return lze plugin spec
return {
	"statusline",
	lazy = false,
	priority = 1000,
	load = function()
		-- No-op since this isn't a real plugin
	end,
	before = function()
		-- Make the module available globally
		_G.StatuslineModule = M

		-- Set up the statusline
		vim.opt.statusline = "%{%v:lua.StatuslineModule.build_statusline()%}"

		-- Always show statusline
		vim.opt.laststatus = 3 -- Global statusline
	end,
}