local M = {}

function M.setup()
    -- Custom command to enable norminette
    vim.api.nvim_create_user_command('NorminetteEnable', function()
        -- Enable the norminette
        vim.cmd('lua require("norminette").enable()')
        print("Norminette enabled")
    end, {})
    
    -- Custom command to disable norminette  
    vim.api.nvim_create_user_command('NorminetteDisable', function()
        -- Disable the norminette
        vim.cmd('lua require("norminette").disable()')
        print("Norminette disabled")
    end, {})
    
    -- Custom command to toggle norminette
    vim.api.nvim_create_user_command('NorminetteToggle', function()
        -- Toggle norminette state
        -- You might need to check the plugin's API for toggle functionality
        print("Norminette toggle - check plugin API")
    end, {})
end

return M
