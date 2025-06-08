-- Plugin configuration loader
-- Automatically loads all plugin configurations from plugins/**/*.lua

-- Check if we're running via nixCats
local is_nixcats = nixCats ~= nil

-- Only configure plugins if we're running via nixCats
if not is_nixcats then
	return
end

-- Function to recursively find lua files
local function find_lua_files(dir)
	local files = {}

	local handle = vim.loop.fs_scandir(dir)
	if not handle then
		return files
	end

	while true do
		local name, type = vim.loop.fs_scandir_next(handle)
		if not name then
			break
		end

		local full_path = dir .. "/" .. name
		if type == "directory" then
			-- Recursively scan subdirectories
			local subfiles = find_lua_files(full_path)
			for _, file in ipairs(subfiles) do
				table.insert(files, file)
			end
		elseif type == "file" and name:match("%.lua$") then
			-- Add lua files
			table.insert(files, full_path)
		end
	end

	return files
end

-- Function to automatically load all plugin files recursively
local function load_plugins()
	local plugins = {}

	-- Get the directory path of the plugins folder
	local current_file = debug.getinfo(1, "S").source:sub(2) -- Remove @ prefix
	local current_dir = vim.fn.fnamemodify(current_file, ":h") -- Get directory of this file
	local plugins_dir = current_dir

	-- Check if directory exists
	local stat = vim.loop.fs_stat(plugins_dir)
	if not stat then
		return plugins
	end

	-- Try glob method first, fallback to manual scanning
	local plugin_files = vim.fn.glob(plugins_dir .. "/**/*.lua", false, true)
	if #plugin_files == 0 then
		plugin_files = find_lua_files(plugins_dir)
	end

	for _, file_path in ipairs(plugin_files) do
		-- Extract the relative path from the plugins directory
		local relative_path = string.sub(file_path, string.len(plugins_dir) + 2) -- +2 for the slash

		-- Convert file path to module name (e.g., "coding/lsp.lua" -> "plugins.coding.lsp")
		local module_name = "plugins." .. string.gsub(relative_path, "/", "."):gsub("%.lua$", "")

		-- Skip init.lua to avoid self-reference
		if not string.match(module_name, "%.init$") then
			-- Require the plugin file and add its configuration to the plugins table
			local success, plugin_config = pcall(require, module_name)
			if success and plugin_config then
				table.insert(plugins, plugin_config)
			end
		end
	end

	return plugins
end

-- Load all plugins and pass them to lze
local loaded_plugins = load_plugins()
require("lze").load(loaded_plugins)

