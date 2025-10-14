-- Set background mode for plugins that need it
vim.o.background = "dark"  -- or "light" if you prefer
-- Enable true color support early
vim.o.termguicolors = true
-- Transparent background for Normal highlight group (no annoying bg)
vim.cmd("hi Normal guibg=NONE ctermbg=NONE")

-- Bootstrap lazy.nvim if not installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end 
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {
    "folke/noice.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    config = function()
      require("noice").setup({
        cmdline = {
          enabled = true,
          view = "cmdline_popup",
          format = {
            cmdline = { pattern = "^:", icon = "", lang = "vim" },
            search_down = { kind = "search", pattern = "^/", icon = " ", lang = "regex" },
            search_up = { kind = "search", pattern = "^%?", icon = " ", lang = "regex" },
          },
        },
        popupmenu = { enabled = true, backend = "nui" },
        notify = {
          enabled = true,
          view = "mini",
          timeout = 1500,
          stages = "fade_in_slide_out",
        },
        messages = {
          enabled = false,
        },
        routes = {
          {
            filter = { event = "msg_showmode" },
            opts = { skip = true },
          },
          {
            filter = { event = "msg_show", kind = "", find = "written" },
            opts = { skip = true },
          },
        },
      })
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      -- Function to get system info
      local function get_os_info()
        local handle = io.popen("uname -s 2>/dev/null")
        local os_name = handle and handle:read("*a"):gsub("\n", "") or "Unknown"
        if handle then handle:close() end
        return os_name
      end

      -- Function to get kernel version
      local function get_kernel()
        local handle = io.popen("uname -r 2>/dev/null")
        local kernel = handle and handle:read("*a"):gsub("\n", "") or "Unknown"
        if handle then handle:close() end
        return kernel:match("^[^-]+") or kernel -- Get just the version part
      end

      -- Function to get uptime
      local function get_uptime()
        local handle = io.popen("uptime -p 2>/dev/null")
        local uptime = handle and handle:read("*a"):gsub("\n", "") or ""
        if handle then handle:close() end
        return uptime:gsub("up ", "") or "Unknown"
      end

      -- Function to get memory usage
      local function get_memory()
        local handle = io.popen("free -h 2>/dev/null | awk 'NR==2{printf \"%.1f/%.1fG\", $3/$2*100, $2}' 2>/dev/null")
        local memory = handle and handle:read("*a"):gsub("\n", "") or ""
        if handle then handle:close() end
        return memory ~= "" and memory or "N/A"
      end

      require("lualine").setup({
        options = {
          theme = "solarized_dark",
          section_separators = { left = "", right = "" },
          component_separators = { left = "│", right = "│" },
          disabled_filetypes = { statusline = { "alpha", "dashboard" } },
          globalstatus = true,
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = { 
            {
              "filename",
              path = 1, -- Show relative path
              symbols = {
                modified = " ●",
                readonly = " ",
                unnamed = "[No Name]",
              }
            }
          },
          lualine_x = { "encoding", "fileformat", "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" }
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { "filename" },
          lualine_x = { "location" },
          lualine_y = {},
          lualine_z = {}
        },
        -- Custom bottom status line with system info
        winbar = {},
        inactive_winbar = {},
        extensions = { "neo-tree", "lazy" },
        -- Add custom section at bottom
        tabline = {},
      })

      -- Create a custom status line at the bottom with system info
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
          local os_info = get_os_info()
          local kernel = get_kernel()
          local linux_icon = " "
          if os_info:lower():find("linux") then
            linux_icon = " "
          elseif os_info:lower():find("darwin") then
            linux_icon = " "
          end
          
          -- Set up a custom command line display
          vim.o.laststatus = 3 -- Global statusline
          
          -- Create autocommand to show system info periodically
          vim.api.nvim_create_user_command("SystemInfo", function()
            local info = string.format("%s %s │ Kernel: %s │ Uptime: %s │ Memory: %s", 
              linux_icon, os_info, kernel, get_uptime(), get_memory())
            vim.notify(info, vim.log.levels.INFO, { title = "System Information" })
          end, {})
        end
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { 
          "lua", "bash", "python", "c", "cpp", "javascript", "typescript", 
          "html", "css", "json", "markdown", "yaml" 
        },
        highlight = { 
          enable = true, 
          additional_vim_regex_highlighting = false 
        },
        indent = { enable = true },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<C-space>",
            node_incremental = "<C-space>",
            scope_incremental = "<C-s>",
            node_decremental = "<C-backspace>",
          },
        },
      })
    end,
  },
  {
    "craftzdog/solarized-osaka.nvim",
    priority = 1000,
    config = function()
      require("solarized-osaka").setup({
        transparent = true,         -- do not set background color
        terminal_colors = true,     -- define vim.g.terminal_color_{0,17}
        styles = {
          comments = { italic = true },
          keywords = { italic = true },
          functions = {},
          variables = {},
          sidebars = "dark",
          floats = "dark",
        },
        sidebars = { "qf", "help" },
        day_brightness = 0.3,
        hide_inactive_statusline = false,
        dim_inactive = false,
        lualine_bold = false,
        on_colors = function(colors)
          -- Customize colors if needed
        end,
        on_highlights = function(highlights, colors)
          -- Ensure transparency is maintained
          highlights.Normal = { bg = "NONE" }
          highlights.NormalFloat = { bg = "NONE" }
          highlights.SignColumn = { bg = "NONE" }
          highlights.LineNr = { bg = "NONE" }
          highlights.CursorLineNr = { bg = "NONE" }
          highlights.GitSignsAdd = { bg = "NONE" }
          highlights.GitSignsChange = { bg = "NONE" }
          highlights.GitSignsDelete = { bg = "NONE" }
          
          -- Make indent lines more visible with Solarized colors
          highlights.IblIndent = { fg = colors.base02 }
          highlights.IblScope = { fg = colors.blue, bold = true }
          
          -- Enhanced visual elements
          highlights.CursorLine = { bg = colors.base02 }
          highlights.Visual = { bg = colors.base01 }
          highlights.MatchParen = { fg = colors.blue, bg = "NONE", bold = true }
          highlights.Search = { fg = colors.base03, bg = colors.yellow }
          highlights.IncSearch = { fg = colors.base03, bg = colors.blue }
          
          -- Popup menu transparency
          highlights.Pmenu = { fg = colors.base0, bg = "NONE" }
          highlights.PmenuSel = { fg = "NONE", bg = colors.base02 }
          highlights.PmenuSbar = { bg = colors.base01 }
          highlights.PmenuThumb = { bg = colors.base02 }
          
          -- Telescope transparency
          highlights.TelescopeTitle = { fg = colors.magenta, bold = true }
          highlights.TelescopePromptNormal = { bg = "NONE" }
          highlights.TelescopePromptBorder = { fg = colors.base02, bg = "NONE" }
          highlights.TelescopeResultsNormal = { fg = colors.base0, bg = "NONE" }
          highlights.TelescopeResultsBorder = { fg = colors.base01, bg = "NONE" }
          highlights.TelescopePreviewNormal = { bg = "NONE" }
          highlights.TelescopePreviewBorder = { bg = "NONE", fg = colors.base01 }
        end,
      })
      vim.cmd.colorscheme("solarized-osaka")
    end,
  },
  -- Auto-pairs plugin for brackets, quotes, etc.
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      local autopairs = require("nvim-autopairs")
      autopairs.setup({
        check_ts = true, -- Use treesitter to check for valid pairs
        ts_config = {
          lua = { "string", "source" },
          javascript = { "string", "template_string" },
          java = false, -- Don't add pairs in java
        },
        disable_filetype = { "TelescopePrompt", "spectre_panel" },
        disable_in_macro = true,  -- Disable when recording or executing a macro
        disable_in_visualblock = false,
        disable_in_replace_mode = true,
        ignored_next_char = [=[[%w%%%'%[%"%.%`%$]]=],
        enable_moveright = true,
        enable_afterquote = true,  -- Add bracket pairs after quote
        enable_check_bracket_line = true,  -- Check bracket in same line
        enable_bracket_in_quote = true,
        enable_abbr = false, -- Trigger abbreviations by pressing the closing pair
        break_undo = true, -- Switch for basic rule break undo sequence
        check_comma = true,
        map_cr = true,
        map_bs = true,  -- Map the <BS> key
        map_c_h = false,  -- Map the <C-h> key to delete a pair
        map_c_w = false, -- Map <C-w> to delete a pair if possible
        -- Enhanced Tab functionality for closing brackets
        map_tab = true,   -- Enable Tab to close brackets
      })

      -- Custom rules for specific cases
      local Rule = require("nvim-autopairs.rule")
      local cond = require("nvim-autopairs.conds")

      -- Add spaces between parentheses
      autopairs.add_rules({
        Rule(" ", " ")
          :with_pair(function(opts)
            local pair = opts.line:sub(opts.col - 1, opts.col)
            return vim.tbl_contains({ "()", "[]", "{}" }, pair)
          end),
        Rule("( ", " )")
          :with_pair(function() return false end)
          :with_move(function(opts)
            return opts.prev_char:match(".%)") ~= nil
          end)
          :use_key(")"),
        Rule("{ ", " }")
          :with_pair(function() return false end)
          :with_move(function(opts)
            return opts.prev_char:match(".%}") ~= nil
          end)
          :use_key("}"),
        Rule("[ ", " ]")
          :with_pair(function() return false end)
          :with_move(function(opts)
            return opts.prev_char:match(".%]") ~= nil
          end)
          :use_key("]")
      })
    end,
  },
  -- Git integration
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({
        signs = {
          add          = { text = '┃' },
          change       = { text = '┃' },
          delete       = { text = '_' },
          topdelete    = { text = '‾' },
          changedelete = { text = '~' },
          untracked    = { text = '┆' },
        },
        current_line_blame = false,
        current_line_blame_opts = {
          virt_text = true,
          virt_text_pos = 'eol',
          delay = 1000,
          ignore_whitespace = false,
        },
      })
    end,
  },
  -- Subtle indent guides with low opacity
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    config = function()
      -- Subtle highlight groups with low opacity using Solarized colors
      local highlight = {
        "IndentSubtle1",
        "IndentSubtle2", 
        "IndentSubtle3",
        "IndentSubtle4",
      }
      
      local hooks = require("ibl.hooks")
      -- Create Solarized-compatible colors for indent guides
      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        -- Solarized dark palette colors for indent guides
        vim.api.nvim_set_hl(0, "IndentSubtle1", { fg = "#073642" }) -- base02
        vim.api.nvim_set_hl(0, "IndentSubtle2", { fg = "#586e75" }) -- base01
        vim.api.nvim_set_hl(0, "IndentSubtle3", { fg = "#657b83" }) -- base00
        vim.api.nvim_set_hl(0, "IndentSubtle4", { fg = "#839496" }) -- base0
        vim.api.nvim_set_hl(0, "IndentCurrent", { fg = "#268bd2", bold = true }) -- Solarized blue for current scope
      end)
      
      require("ibl").setup({
        indent = {
          highlight = highlight,
          char = "│", -- Thicker, more visible line character
          tab_char = "│",
          smart_indent_cap = true,
        },
        whitespace = {
          remove_blankline_trail = true,
        },
        scope = {
          enabled = true,
          show_start = true, -- Show scope start for better function identification
          show_end = false,
          show_exact_scope = true,
          injected_languages = false,
          highlight = "IndentCurrent",
          priority = 1000,
          include = {
            node_type = {
              lua = { "return_statement", "table_constructor", "function_definition" },
              python = { "function_definition", "class_definition", "if_statement", "for_statement" },
              javascript = { "function_declaration", "arrow_function", "class_declaration", "if_statement" },
              c = { "function_definition", "if_statement", "for_statement", "while_statement" },
              cpp = { "function_definition", "class_specifier", "if_statement", "for_statement" },
            },
          },
        },
        exclude = {
          filetypes = {
            "help", "alpha", "dashboard", "neo-tree", "Trouble", "trouble",
            "lazy", "mason", "notify", "toggleterm", "lazyterm", "lspinfo",
          },
          buftypes = { "terminal", "nofile" },
        },
      })
      
      hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
    end,
  },
  -- Better syntax highlighting and permanent code context
  {
    "nvim-treesitter/nvim-treesitter-context",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("treesitter-context").setup({
        enable = true,
        max_lines = 5, -- Show up to 5 lines of context (increased for functions)
        min_window_height = 0,
        line_numbers = true,
        multiline_threshold = 1, -- Show context even for single-line functions
        trim_scope = "outer", -- Which context lines to discard if `max_lines` is exceeded
        mode = "cursor", -- Line used to calculate context
        separator = "─", -- Add separator line between context and content
        zindex = 20, -- The Z-index of the context window
        on_attach = nil, -- Disable attaching on certain buffers if needed
        -- Always show function context
        patterns = {
          default = {
            'class',
            'function',
            'method',
            'for',
            'while',
            'if',
            'switch',
            'case',
            'interface',
            'struct',
            'enum',
          },
        },
      })
      
      -- Ensure context is always visible with Solarized custom highlighting
      vim.api.nvim_set_hl(0, 'TreesitterContext', { bg = '#002b36', italic = true }) -- base03
      vim.api.nvim_set_hl(0, 'TreesitterContextLineNumber', { fg = '#586e75', bg = '#002b36' }) -- base01 on base03
      vim.api.nvim_set_hl(0, 'TreesitterContextSeparator', { fg = '#586e75' }) -- base01
    end,
  },
  -- Enhanced colorizer for better visual feedback
  {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup({
        "*", -- Apply to all filetypes
      }, {
        RGB = true, -- #RGB hex codes
        RRGGBB = true, -- #RRGGBB hex codes
        names = false, -- "Name" codes like Blue
        RRGGBBAA = true, -- #RRGGBBAA hex codes
        rgb_fn = true, -- CSS rgb() and rgba() functions
        hsl_fn = true, -- CSS hsl() and hsla() functions
        css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
        css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
      })
    end,
  },
  -- Smooth scrolling for better user experience
  {
    "karb94/neoscroll.nvim",
    config = function()
      require("neoscroll").setup({
        mappings = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "<C-y>", "<C-e>", "zt", "zz", "zb" },
        hide_cursor = true,
        stop_eof = true,
        respect_scrolloff = false,
        cursor_scrolls_alone = true,
        easing_function = "sine", -- Options: linear, quadratic, cubic, quartic, quintic, circular, sine
        pre_hook = nil,
        post_hook = nil,
      })
    end,
  },
  -- File icons
  {
    "nvim-tree/nvim-web-devicons",
    config = function()
      require("nvim-web-devicons").setup({
        default = true,
      })
    end,
  },
})

-- Line numbers: relative and absolute for expert navigation
vim.o.number = true           -- Show absolute line number on current line
vim.o.relativenumber = true   -- Show relative line numbers on other lines
vim.o.numberwidth = 4         -- Set width of line number column
vim.o.signcolumn = "yes:1"    -- Always show sign column (for git signs, diagnostics)

-- Minimize command line height to avoid large message area
vim.o.cmdheight = 1

-- Avoid swap and backup files in the working directory
vim.o.backup = false
vim.o.writebackup = false
vim.o.swapfile = false

-- Enable mouse support (helpful for many)
vim.o.mouse = "a"

-- Reduce command message clutter (for example, no press-enter prompts)
vim.o.shortmess = vim.o.shortmess .. "cI"

-- Better search behavior
vim.o.hlsearch = true
vim.o.incsearch = true
vim.o.ignorecase = true
vim.o.smartcase = true

-- Better editing experience with 4-space tabs
vim.o.expandtab = true
vim.o.shiftwidth = 4      -- Number of spaces for each indentation level
vim.o.tabstop = 4         -- Number of spaces a tab counts for
vim.o.softtabstop = 4     -- Number of spaces a tab counts for in editing
vim.o.autoindent = true
vim.o.smartindent = true

-- Better cursor line for code navigation
vim.o.cursorline = true

-- Enhanced visual settings (removed column guides)
-- vim.o.colorcolumn = "80,120" -- Column guides removed for cleaner look

-- Smooth cursor movement
vim.o.scrolloff = 8
vim.o.sidescrolloff = 8

-- Better fold settings for code structure
vim.o.foldmethod = "expr"
vim.o.foldexpr = "nvim_treesitter#foldexpr()"
vim.o.foldenable = false -- Start with folds open
vim.o.foldlevel = 99

-- Enhanced visual feedback
vim.o.showmatch = true -- Highlight matching brackets
vim.o.matchtime = 2 -- Time to show matching bracket

-- Split behavior
vim.o.splitbelow = true
vim.o.splitright = true

-- Update time for better experience
vim.o.updatetime = 250

-- Enable persistent undo
vim.o.undofile = true

-- Better completion experience (basic Vim completion)
vim.o.completeopt = "menu,menuone,noselect"

-- Key mappings
local keymap = vim.keymap.set

-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
keymap("n", "<C-j>", "<C-w>j", { desc = "Move to bottom window" })
keymap("n", "<C-k>", "<C-w>k", { desc = "Move to top window" })
keymap("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- Resize windows
keymap("n", "<C-Up>", ":resize -2<CR>", { desc = "Decrease window height" })
keymap("n", "<C-Down>", ":resize +2<CR>", { desc = "Increase window height" })
keymap("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "Decrease window width" })
keymap("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Increase window width" })

-- Better indenting
keymap("v", "<", "<gv", { desc = "Indent left and reselect" })
keymap("v", ">", ">gv", { desc = "Indent right and reselect" })

-- Clear search highlighting
keymap("n", "<leader>h", ":nohlsearch<CR>", { desc = "Clear search highlighting" })

-- Show system information
keymap("n", "<leader>si", ":SystemInfo<CR>", { desc = "Show system information" })

-- Move lines up/down
keymap("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down" })
keymap("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up" })
keymap("i", "<A-j>", "<Esc>:m .+1<CR>==gi", { desc = "Move line down" })
keymap("i", "<A-k>", "<Esc>:m .-2<CR>==gi", { desc = "Move line up" })
keymap("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
keymap("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Enhanced Tab functionality for better navigation
keymap("i", "<Tab>", function()
  -- Check if we're inside brackets and can jump out
  local line = vim.api.nvim_get_current_line()
  local col = vim.api.nvim_win_get_cursor(0)[2]
  local next_char = line:sub(col + 1, col + 1)
  
  if next_char:match('[%)%]%}"\']') then
    -- Jump out of bracket/quote
    return "<Right>"
  else
    -- Insert tab
    return "<Tab>"
  end
end, { expr = true, desc = "Smart tab completion" })

-- Auto-save when leaving insert mode or text changes
vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
  pattern = "*",
  command = "silent! wall",
  nested = true,
})

-- Highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank({ higroup = "Visual", timeout = 200 })
  end,
})

-- Auto-format on save for supported filetypes
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.lua", "*.py", "*.js", "*.ts", "*.json" },
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})

-- Enhanced line number styling with 60% opacity
vim.api.nvim_set_hl(0, "LineNr", { 
  fg = "#839496",  -- Solarized base0 color
  bg = "NONE",
  blend = 40,      -- 60% transparency (100 - 60 = 40 blend)
})

vim.api.nvim_set_hl(0, "CursorLineNr", { 
  fg = "#93a1a1",  -- Solarized base1 color (brighter for current line)
  bg = "NONE", 
  blend = 40,      -- 60% transparency
  bold = true
})

vim.api.nvim_set_hl(0, "SignColumn", { 
  bg = "NONE",
  blend = 40,      -- 60% transparency to match line numbers
})

-- Optional: Make the number column background slightly visible but transparent
vim.api.nvim_set_hl(0, "LineNrBackground", {
  bg = "#002b36",  -- Solarized base03
  blend = 40,      -- 60% transparency
})

-- Apply the background to the entire number column area
vim.api.nvim_set_hl(0, "NormalNC", {
  bg = "NONE",
})

-- Ensure the main code area stays at 100% opacity
vim.api.nvim_set_hl(0, "Normal", {
  bg = "NONE",
  blend = 0,       -- 0% transparency = 100% opacity
})

vim.api.nvim_set_hl(0, "NormalFloat", {
  bg = "NONE",
  blend = 0,
})
