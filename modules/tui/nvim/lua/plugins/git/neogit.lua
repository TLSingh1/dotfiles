return {
	"neogit",

	enabled = function()
		return nixCats.cats.git
	end,

	cmd = { "Neogit" },
	keys = {
		{ "<leader>n", "<cmd>Neogit<CR>", desc = "Neogit" },
		-- { "<leader>gc", "<cmd>Neogit commit<CR>", desc = "Neogit commit" },
		-- { "<leader>gp", "<cmd>Neogit push<CR>", desc = "Neogit push" },
		-- { "<leader>gl", "<cmd>Neogit pull<CR>", desc = "Neogit pull" },
	},
	after = function()
		require("neogit").setup({
			kind = "split", -- Opens neogit in a split
			signs = {
				item = { "", " " },
				section = { "", " " },
			},
			integrations = {
				telescope = true,
				diffview = true,
			},
			mappings = {
				status = {
					["l"] = "Toggle",
					["S"] = "StageAll",
				},
			},
		})
	end,
}
