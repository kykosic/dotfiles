-- Map leader to space
vim.keymap.set("n", "<Space>", "<Nop>", { silent = true})
vim.g.mapleader = " "

--------------------
-- Options
--------------------

-- Used for NvimTree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Colors
vim.opt.termguicolors = true
vim.opt.background = "dark"

-- Visual guides
vim.opt.colorcolumn = "100"
vim.opt.cursorline = true
vim.opt.number = true
vim.opt.numberwidth = 1
vim.opt.signcolumn = "yes"
vim.opt.laststatus = 3
vim.opt.fillchars:append({ vert = "║", horiz = "═" })

-- Misc
vim.opt.shell = "/bin/zsh"
vim.opt.backspace = "indent,eol,start"
vim.opt.hidden = true
vim.opt.viewoptions = "folds,options,cursor,unix,slash"
vim.opt.encoding = "utf-8"

-- Permanent undo
vim.opt.undodir = vim.fn.expand("~/.vimdid")
vim.opt.undofile = true

-- Tabs/spaces settings, default to 4 spaces
vim.opt.expandtab = true
vim.opt.tabstop = 8 
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
-- Override some filetypes for 2 spaces
vim.api.nvim_create_autocmd(
  "FileType",
  {
    pattern = { 
      "javascript",
      "lua",
      "svelte",
      "terraform",
      "typescript",
      "yaml",
    },
    command = "setlocal shiftwidth=2 softtabstop=2",
  }
)
-- Override some filetypes for tabs
vim.api.nvim_create_autocmd(
  "FileType",
  {
    pattern = {
      "make",
    },
    command = "setlocal noexpandtab",
  }
)

-- Add new filetypes
vim.filetype.add({
  extension = {
    tfvars = "hcl",
  },
})

-- Enable spellcheck on certain filetypes
vim.opt.spelllang = "en_us"
vim.api.nvim_create_autocmd("FileType", { pattern = "markdown", command = "setlocal spell" })

-- Split panes right/below
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Mouse usage
vim.opt.mouse = "nicr"

-- Format cursor
vim.opt.guicursor = "n-v-c:block-Cursor/lCursor-blinkon0,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor"

-- Search settings
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Highlight search replacements while typing
vim.opt.inccommand = "nosplit"

-- Better completion experience
vim.opt.completeopt = "menu,menuone,noinsert"

-- Limit message display
vim.opt.cmdheight = 1
-- Decrease diagnostics latency
vim.opt.updatetime=300

-- Show hidden characters
vim.opt.listchars = "tab:^ ,nbsp:¬,extends:»,precedes:«,trail:•"


-- Highlight text on yank
vim.api.nvim_create_autocmd(
  "TextyankPost",
  {
    pattern = "*",
    command = "silent! lua vim.highlight.on_yank({ timeout = 500 })",
  }
)


--------------------
-- Hotkeys
--------------------

-- Clear highlights
vim.keymap.set("n", "<C-z>", "<cmd>nohlsearch<cr>")
-- New file
vim.keymap.set("n", "<leader>n", "<cmd>enew<cr>")
-- Save file
vim.keymap.set("n", "<leader>w", "<cmd>w<cr>")
-- Close all
vim.keymap.set("", "<C-q>", "<cmd>confirm qall<cr>")

-- Copy to clipboard
vim.keymap.set("", "<leader>c", '"+y')
vim.keymap.set("v", "<leader>c", '"+y')

-- Show and hide invisible characters
vim.keymap.set("n", "<leader>c", "<cmd>set invlist<cr>")

-- Fix pasted slack snippets
vim.keymap.set("n", "<leader>sk", "<cmd>%s/​//g<cr>")


--------------------
-- Plugins
--------------------

-- Plugin manager init
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Plugin configs
require("lazy").setup({

  -- Color theme
  {
    "navarasu/onedark.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd([[colorscheme onedark]])
    end
  },

  -- Vim/tmux split flattening
  {
    "christoomey/vim-tmux-navigator",
    lazy = false,
  },

  -- Status bar
  {
    "nvim-lualine/lualine.nvim",
    lazy = false,
    dependencies = { 
      "nvim-tree/nvim-web-devicons",
      "linrongbin16/lsp-progress.nvim",
    },
    config = function()
      require("lsp-progress").setup()
      require("lualine").setup({
        options = {
          icons_enabled = false,
          theme = "onedark",
          component_separators = { left = "|", right = "|"},
          section_separators = { left = " ", right = " "},
        },
        sections = {
          lualine_a = {"mode"},
          lualine_b = {"branch"},
          lualine_c = {"filename"},
          lualine_x = {
            function()
              return require('lsp-progress').progress()
            end
          },
          lualine_y = {"diagnostics", "filetype"},
          lualine_z = {"progress", "location"}
        },
        extensions = {"nvim-tree"},
      })

      vim.api.nvim_create_augroup("lualine_augroup", { clear = true })
      vim.api.nvim_create_autocmd("User", {
        group = "lualine_augroup",
        pattern = "LspProgressStatusUpdated",
        callback = require("lualine").refresh,
      })

    end
  },

  -- File tree
  {
    "nvim-tree/nvim-tree.lua",
    config = function()
      -- global keybindings
      vim.keymap.set("", "<C-f>", "<cmd>NvimTreeToggle<cr>")
      vim.keymap.set("", "<C-s>", "<cmd>NvimTreeFindFile<cr>")

      -- keybindings applied on buffer attach
      local function on_attach(bufnr)
        local api = require("nvim-tree.api")

        local function opts(desc)
          return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end

        vim.keymap.set("n", "<C-k>", api.node.show_info_popup, opts("Info"))
        vim.keymap.set("n", "<C-t>", api.node.open.tab, opts("Open: New Tab"))
        vim.keymap.set("n", "v", api.node.open.vertical, opts("Open: Vertical Split"))
        vim.keymap.set("n", "x", api.node.open.horizontal, opts("Open: Horizontal Split"))
        vim.keymap.set("n", "<CR>", api.node.open.edit, opts("Open"))
        vim.keymap.set("n", "a", api.fs.create, opts("Create"))
        vim.keymap.set("n", "d", api.fs.remove, opts("Delete"))
        vim.keymap.set("n", "I", api.tree.toggle_gitignore_filter, opts("Toggle Git Ignore"))
        vim.keymap.set("n", "r", api.fs.rename, opts("Rename"))
        vim.keymap.set("n", "R", api.tree.reload, opts("Refresh"))
        vim.keymap.set("n", "s", api.node.run.cmd, opts("Run Command"))
        vim.keymap.set("n", "W", api.tree.collapse_all, opts("Collapse"))
        vim.keymap.set("n", "<2-LeftMouse>",  api.node.open.edit, opts("Open"))
        vim.keymap.set("n", "<2-RightMouse>", api.tree.change_root_to_node, opts("CD"))

      end

      -- options
      require("nvim-tree").setup({
        on_attach = on_attach,
        renderer = {
          icons = {
            show = {
              file = false,
              folder = false,
              git = false,
            },
          },
        },
      })

    end
  },

  -- Fuzzy file finder
  {
    "junegunn/fzf.vim",
    dependencies = { "junegunn/fzf", build = "./install --bin" },
    config = function()
      -- don't show previews of files next to the list
      vim.g.fzf_preview_window = {}
      -- override default file search command
      vim.env.FZF_DEFAULT_COMMAND = 'rg --files --hidden --follow -g "!.git/*" 2>/dev/null'
      -- hotkeys
      vim.keymap.set("n", "<C-p>", "<cmd>Files<cr>", { silent = true } )
      vim.keymap.set("n", "<C-g>", "<cmd>GFiles<cr>", { silent = true } )
      vim.keymap.set("n", "<C-b>", "<cmd>Buffers<cr>", { silent = true } )
      vim.keymap.set("n", "<leader>rg", "<cmd>Rg<cr>", { silent = true } )
    end
  },

  -- Indentation visual guides
  { 
    "lukas-reineke/indent-blankline.nvim", 
    main = "ibl", 
    config = function()
      require("ibl").setup({
        scope = {
          enabled = false,
        },
      })
    end
  },

  -- Align around characters
  {
    "Vonr/align.nvim",
    branch = "v2",
    init = function()
      local align_to_string = function()
        require("align").align_to_string({
          preview = true,
          regex = false,
        })
      end
      vim.keymap.set("x", "<leader>ga", align_to_string, { noremap = true, silent = true })
    end
  },

  -- Reopen files to last edited line
  {
    "farmergreg/vim-lastplace",
  },

  -- Open current line on Github
  {
    "ruanyl/vim-gh-line",
  },

  -- Treesitter syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter", 
    -- dependencies = {
    --   "hiphish/rainbow-delimiters.nvim",
    -- },
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { 
          "c", 
          "comment", 
          "cpp", 
          "go", 
          "hcl",
          "javascript",
          "just",
          "lua", 
          "markdown", 
          "python", 
          "query",
          "rust", 
          "svelte",
          "terraform", 
          "tsx",
          "typescript",
          "vim", 
          "vimdoc",
        },
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        indent = {
          enable = false,
        },
      })
    end
  },

  -- LSP
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      -- LSP server manager
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      -- Global mappings
      vim.keymap.set("n", "gl", vim.diagnostic.open_float)
      vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
      vim.keymap.set("n", "]d", vim.diagnostic.goto_next)

      local disable_lsp = function()
        vim.lsp.stop_client(vim.lsp.get_active_clients())
      end

      -- Apply configs on LSP attach to buffer
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(event)
          local opts = { buffer = event.buf }
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
          vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
          vim.keymap.set("n", "go", vim.lsp.buf.type_definition, opts)
          vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
          vim.keymap.set("n", "gs", vim.lsp.buf.signature_help, opts)
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
          vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format, opts)
          vim.keymap.set("n", "<leader>a", vim.lsp.buf.code_action, opts)
          vim.keymap.set("n", "<leader>lr", "<cmd>LspRestart<cr>", opts)
          vim.keymap.set('n', '<leader>ld', disable_lsp, opts)

          -- auto-format on save
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = event.buf,
            callback = function()
              vim.lsp.buf.format({ async = false, id = event.data.client_id })
            end
          })

          -- no semantic tokens please, just use treesitter
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          client.server_capabilities.semanticTokensProvider = nil

        end
      })

      vim.diagnostic.config({ 
        -- Don't show inline diagnostic messages
        virtual_text = false,  
        severity_sort = true, 
      })

      -- Show diagnostic messsages on hover
      vim.api.nvim_create_autocmd("CursorHold", {
        callback = function()
          -- Only open diagnostics if there are no other open floating windows
          for _, winid in pairs(vim.api.nvim_tabpage_list_wins(0)) do
            if vim.api.nvim_win_get_config(winid).zindex then
              return
            end
          end

          vim.diagnostic.open_float(0, {
            focusable = false,
            close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
            border = "single",
            source = "always",
            prefix = "- ",
            scope = "cursor",
          })
        end
      })

      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local default_setup = function(server)
        require("lspconfig")[server].setup({
          capabilities = capabilities,
        })
      end

      -- Server manager
      require("mason").setup()
      require("mason-lspconfig").setup({
        handlers = {
          default_setup,
        },
        ensure_installed = {
          "pyright",
          "ruff_lsp",
          "rust_analyzer",
        },
      })

      -- Language configs
      local lspconfig = require("lspconfig")

      -- Python
      lspconfig.pyright.setup({
        settings = {
          python = {
            analysis = {
              exclude = {"**", "*", "**/*"},
            },
            pythonPath = os.getenv('VIRTUAL_ENV') and (os.getenv('VIRTUAL_ENV') .. '/bin/python') or os.getenv('PYRIGHT_PYTHON'),
          },
        },
      })

      lspconfig.ruff_lsp.setup({
        settings = {
          lint = {
            -- only use ruff for formatting
            enable = false,
          }
        }
      })

      -- Rust
      lspconfig.rust_analyzer.setup({
        capabilities = capabilities,
        settings = {
          ["rust-analyzer"] = {
            cargo = {
              features = "all",
            },
            imports = {
              granularity = {
                group = "module",
              },
            },
          },
        },
      })

    end
  },

  -- LSP completions
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
    },
    config = function()
      local cmp = require("cmp")
      
      -- function to filter completion suggestions
      local nvim_lsp_entry_filter = function(entry, ctx)
        return cmp.lsp.CompletionItemKind.Keyword ~= entry:get_kind()
      end

      cmp.setup({
        snippet = {
          expand = function(args)
            vim.snippet.expand(args.body)
          end
        },
        completion = {
          completeopt = "menu,menuone,noinsert",
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-d>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-e>"] = cmp.mapping.abort(),
          -- ["<cr>"] = cmp.mapping.confirm({ select = true }),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              local entry = cmp.get_selected_entry()
              if not entry then
                cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
              else
                cmp.confirm({ select = true })
              end
            else
              fallback()
            end
          end, { "i", "s"}),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp", entry_filter = nvim_lsp_entry_filter },
          { name = "path" },
        }, {
          { name = "buffer" },
        }),
        experimental = {
          ghost_text = false,
        },
      })

      -- Enable completing paths in :
      cmp.setup.cmdline(":", {
        sources = cmp.config.sources({
          { name = "path" },
        })
      })
    end
  },

})
