local M = {}

function M.setup()
    -- 50% transparency cyan for comments (42 header uses comments)
    vim.api.nvim_set_hl(0, "Comment", { 
        fg = "#008080",  -- 50% transparency cyan (Teal)
        bold = false
    })
    
    -- Treesitter comments
    vim.api.nvim_set_hl(0, "@comment", { fg = "#008080" })
    
    -- File type specific
    vim.api.nvim_create_autocmd({"FileType"}, {
        pattern = {"c", "h", "cpp", "hpp"},
        callback = function()
            vim.api.nvim_set_hl(0, "Comment", { fg = "#008080" })
        end
    })
end

return M
