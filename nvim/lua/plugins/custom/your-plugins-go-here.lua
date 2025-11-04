--[[
-- NOTE: This is where your plugins go! put them in brackets like the following. Lazy will automatically pick them up and install them
-- If you feel like this plugin is useful, feel free to git add commit push and make a pull request from your fork on GitHub.
-- If there is a good, general use-case, I will merge it into the main branch :)
-- There is another example, image-nvim.lua which is a (commented out) example of how plugins can be imported, with options.
]]--
return {
  -- Add GitHub Copilot
  {
    "github/copilot.vim",
    event = "InsertEnter",
    config = function()
      -- Map tab to accept copilot suggestions
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
    end,
  }
}
