--[[ 42-Nvim config file ]] --
--
-- 42-Nvim is a neovim configuration, supercharged for 42 Students.
---@diagnostic disable: missing-fields
-- Set Vim settings. Necessary before lazy is run.
require "config.vim_settings"

-- Install lazy.nvim, the package manager.
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system {
		'git',
		'clone',
		'--filter=blob:none',
		'https://github.com/folke/lazy.nvim.git',
		'--branch=stable',
		lazypath,
	}
end
vim.opt.rtp:prepend(lazypath)

-- Validate that lazy is available.
if not pcall(require, "lazy") then
	vim.api.nvim_echo(
		{ { ("Unable to load lazy from: %s\n"):format(lazypath), "ErrorMsg" }, { "Press any key to exit...", "MoreMsg" } },
		true, {})
	vim.fn.getchar()
	vim.cmd.quit()
end

-- Load Lazy and make sure every plugin is installed.
require "plugins"

-- Load config/init.lua which will load every plugin configuration.
require "config"

-- Add GitHub Copilot configuration
vim.g.copilot_no_tab_map = true
vim.keymap.set("i", "<C-J>", 'copilot#Accept("\\<CR>")', {
  expr = true,
  replace_keycodes = false,
})
vim.g.copilot_filetypes = {
  ["*"] = false,
  ["javascript"] = true,
  ["typescript"] = true,
  ["lua"] = true,
  ["rust"] = true,
  ["c"] = true,
  ["c#"] = true,
  ["c++"] = true,
  ["go"] = true,
  ["python"] = true,
}

-- Launch! :)
if (vim.g.user42 == nil) then
	vim.g.user42 = vim.env.USER
end

local stdpath = vim.fn.stdpath('config')

if not string.find(vim.fn.system("git -C " .. stdpath .. " remote -v"), "upstream") then
	vim.fn.system("git -C " .. stdpath .. " remote add upstream https://github.com/fclivaz42/42-nvim.git")
end

if vim.g.receiveupdates == true then
	vim.loop.spawn('git', {
			args = { '-C', stdpath, 'fetch', 'upstream' },
			stdio = { nil, nil, nil }
		},
		vim.schedule_wrap(function(code)
			if code == 0 then
				local mainc = vim.fn.system('git -C ' .. stdpath .. ' rev-list --count HEAD..upstream/main')

				if mainc ~= '0\n' then
					vim.notify("Update available!", vim.log.levels.WARN, { title = "42-Nvim" })
				end
			else
				vim.notify("Could not fetch upstream for updates.", vim.log.levels.WARN, { title = "42-Nvim" })
			end
		end
		))
end


-- Add this to your init.lua before the "Launch!" section
vim.g.copilot_assume_mapped = true
vim.g.copilot_filetypes = { ['*'] = true }
vim.g.copilot_enabled = true

-- Force ghost text to be visible
vim.api.nvim_set_hl(0, 'CopilotSuggestion', { fg = '#808080' })

