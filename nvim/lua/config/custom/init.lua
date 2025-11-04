-- [[ Custom plugin config loader. ]] --

-- NOTE: Those 'custom' configurations will *never* be changed upstream. you are safe to change them at will!

local custom = ... .. "."

-- NOTE: in order to load the config for your plugins, you must put
-- 'require(custom .. "myplugin")' for every lua file that you have.
-- I personally recommend prepending "_" to your config files to differentiate from the init.lua.

-- As an example, we will set your default theme here:
require(custom .. "_themeselect")
-- Transparency configuration
local function setup_transparency()
    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "none" })
    -- Optional: Make other elements transparent too
    vim.api.nvim_set_hl(0, "LineNr", { bg = "none" })
    vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
    vim.api.nvim_set_hl(0, "FoldColumn", { bg = "none" })
    vim.api.nvim_set_hl(0, "CursorLine", { bg = "none" })
end

setup_transparency()

-- FIX: Disable relative numbers to show absolute line numbers
vim.opt.relativenumber = false  -- This will show 0,1,2,3... instead of relative to cursor
vim.opt.number = true          -- Keep regular numbers enabled

-- Line numbers with grey 60% transparency
vim.api.nvim_set_hl(0, "LineNr", { fg = "#999999", bg = "none" }) -- Grey text, transparent background
vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#ffffff", bg = "none", bold = true }) -- White when cursor is on line

-- If you want the entire number column to have a subtle grey background:
vim.api.nvim_set_hl(0, "SignColumn", { bg = "#3a3a3a" }) -- Dark grey background for number column

-- Fix the green ~ characters at the end of buffer
vim.api.nvim_set_hl(0, "EndOfBuffer", { 
    fg = "#333333",  -- Dark grey instead of green
    bg = "none"      -- Transparent background
})

-- Or make them completely blend in:
vim.api.nvim_set_hl(0, "EndOfBuffer", { 
    fg = "#1a1a1a",  -- Very dark grey (almost invisible)
    bg = "none"
})

-- Or make them match your terminal background:
vim.api.nvim_set_hl(0, "EndOfBuffer", { 
    fg = "#000000",  -- Black (if terminal is black)
    bg = "none"
})
--cyan 42header
require('config.custom.header_cyan').setup()

-- 70% capacity cyan for 42 header
vim.api.nvim_set_hl(0, "Comment", { fg = "#66FFFF", bold = false }) -- Light cyan (70%)

-- Alternative lighter cyan shades:
-- vim.api.nvim_set_hl(0, "Comment", { fg = "#80FFFF", bold = false }) -- Even lighter
-- vim.api.nvim_set_hl(0, "Comment", { fg = "#99FFFF", bold = false }) -- Very light cyaa
-- 50% transparency cyan for 42 header
vim.api.nvim_set_hl(0, "Comment", { fg = "#008080", bold = false }) -- Teal/Dark cyan (50%)

-- Alternative 50% transparency cyan shades:
require('config.custom.header_cyan_50').setup()
require('config.custom.neotree_transparent').setup()

-- Disable nvim-cmp completions
local cmp = require('cmp')
cmp.setup({
  enabled = false
})

-- Disable norminette inline diagnostics (the annoying popups)
vim.api.nvim_create_autocmd("FileType", {
  pattern = {"c", "h"},
  callback = function()
    -- Disable virtual text (inline messages)
    vim.diagnostic.config({
      virtual_text = false,
      underline = false,
      signs = false
    })
    
    -- Hide the norminette messages but keep the plugin loaded
    vim.diagnostic.hide()
  end
})

-- Remove the grey line left of number row
vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
vim.api.nvim_set_hl(0, "FoldColumn", { bg = "none" })

-- Make it consistent with your transparency theme
vim.api.nvim_set_hl(0, "SignColumn", { 
    bg = "none",
    fg = "none" 
})

vim.api.nvim_set_hl(0, "FoldColumn", { 
    bg = "none",
    fg = "none" 
}) 

-- Top-left aligned numbers with gap to code
vim.opt.number = true
vim.opt.relativenumber = false  -- CHANGED: Disable relative numbers
vim.opt.numberwidth = 5        -- Minimal width for numbers
vim.opt.signcolumn = "no"      -- No sign column on left

-- Create gap using text offset
vim.opt.foldcolumn = "0"       -- No fold column

-- Style numbers to be top-left aligned
vim.api.nvim_set_hl(0, "LineNr", {
    fg = "#999999",
    bg = "none",
})

-- Remove any left padding
vim.opt.winbar = ""  -- Clear any winbar content

-- Disable neovim notifications completely
-- Disable background and popup notifications
local original_notify = vim.notify
vim.notify = function(msg, level, opts)
    -- Filter out background notifications
    if opts and (opts.background or opts.title == "Background") then
        return
    end
    -- Allow only important notifications
    if level == vim.log.levels.ERROR then
        original_notify(msg, level, opts)
    end
end
