return {
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				"<leader>cf",
				function()
					require("conform").format({ async = true })
				end,
				mode = "",
				desc = "Format C file with 42 formatter",
			},
		},
		opts = {
			formatters_by_ft = {
				c = { "c_formatter_42" },
			},
			-- Optional: enable auto-format on save
			-- format_on_save = {
			-- 	timeout_ms = 500,
			-- },
			formatters = {
				c_formatter_42 = {
					command = "c_formatter_42",
					args = { "$FILENAME" },
					stdin = false,
				},
			},
		},
	},
}
