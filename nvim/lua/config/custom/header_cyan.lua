local M = {}

function M.setup()
    -- Make all comments cyan (since 42 header is comments)
    vim.api.nvim_set_hl(0, "Comment", { 
        fg = "#00FFFF",  -- Bright cyan
        italic = false   -- Remove italic if present
    })
    
    -- Additional syntax groups that might affect the header
    vim.api.nvim_set_hl(0, "@comment", { fg = "#00FFFF" }) -- Treesitter
    vim.api.nvim_set_hl(0, "pythonComment", { fg = "#00FFFF" }) -- Python
    vim.api.nvim_set_hl(0, "luaComment", { fg = "#00FFFF" }) -- Lua
    vim.api.nvim_set_hl(0, "cComment", { fg = "#00FFFF" }) -- C
    
    -- Apply specifically to C files where 42 header appears
    vim.api.nvim_create_autocmd({"FileType"}, {
        pattern = {"c", "h", "cpp", "hpp"},
        callback = function()
            vim.api.nvim_set_hl(0, "Comment", { fg = "#00FFFF" })
        end
    })
end

return M
