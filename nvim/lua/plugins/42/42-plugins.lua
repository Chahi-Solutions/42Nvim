return {
	-- 42 Header (uncommented the stdheader-fixes branch)
	{
		'fclivaz42/42header-ls',
		branch = 'stdheader-fixes' -- Uncommented for non-Lausanne users
	},
	
	-- Norminette plugin
	{
		"hardyrafael17/norminette42.nvim",
		config = function()
			require('norminette').setup({
				-- Enable norminette on save
				runOnSave = true,
				-- Show errors in diagnostics
				showErrors = true,
			})
		end,
	}
}
