local M = {}

function M.setup()
    -- Neo-tree transparency highlights
    local highlights = {
        "NeoTreeNormal",
        "NeoTreeNormalNC", 
        "NeoTreeEndOfBuffer",
        "NeoTreeVertSplit",
        "NeoTreeWinSeparator",
        "NeoTreeRootName",
        "NeoTreeTitleBar",
        "NeoTreeTabInactive",
        "NeoTreeTabActive",
        "NeoTreeTabSeparatorInactive",
        "NeoTreeTabSeparatorActive",
    }
    
    for _, hl in ipairs(highlights) do
        vim.api.nvim_set_hl(0, hl, { bg = "none" })
    end
    
    -- Selection with slight visibility
    vim.api.nvim_set_hl(0, "NeoTreeCursorLine", { bg = "#2a2a37" })
    vim.api.nvim_set_hl(0, "NeoTreeSelection", { bg = "#3a3a47" })
end

return M
