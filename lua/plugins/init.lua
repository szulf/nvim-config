local function map(key, action, desc)
    vim.keymap.set('n', key, action, { desc = desc })
end

return {
    {
        'aktersnurra/no-clown-fiesta.nvim',
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd('colorscheme no-clown-fiesta')
        end,
    },

    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        opts = {
            ensure_installed = { 'lua', 'nix' },
            auto_install = true,
        },
        config = function(_, opts)
            require('nvim-treesitter.configs').setup(opts)
        end,
    },

    {
        'nvim-telescope/telescope.nvim',

        dependencies = {
            { 'nvim-lua/plenary.nvim' },

            { 'BurntSushi/ripgrep' },

            {
                'nvim-telescope/telescope-fzf-native.nvim',
                build = 'make',
            },

            { 'nvim-telescope/telescope-ui-select.nvim' },
        },

        opts = {
            pickers = {
                find_files = {
                    hidden = true
                },
            },
        },

        config = function()
            pcall(require('telescope').load_extension, 'fzf')
            pcall(require('telescope').load_extension, 'ui-select')

            local builtin = require('telescope.builtin')
            map('<leader>ff', builtin.find_files, '[F]uzzy find [F]iles')
            map('<leader>fg', builtin.git_files, '[F]uzzy find [G]it')
            map('<leader>fs', builtin.grep_string, '[F]uzzy find [S]tring')
            map('<leader>fl', builtin.live_grep, '[F]uzzy find [L]ive grep')
            map('<leader>fd', builtin.diagnostics, '[F]uzzy find [D]iagnostics')
        end,
    },

    {
        'neovim/nvim-lspconfig',
        dependencies = {
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',
            'WhoIsSethDaniel/mason-tool-installer.nvim',
            { 'j-hui/fidget.nvim', opts = {} },
        },

        config = function()
            vim.api.nvim_create_autocmd('LspAttach', {
                callback = function(event)
                    local builtin = require('telescope.builtin')
                    map('gd', builtin.lsp_definitions, '[G]oto [D]efinition')
                    map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
                    map('gr', builtin.lsp_references, '[G]oto [R]eferences')
                    map('gi', builtin.lsp_implementations, '[G]oto [I]mplementation')
                    map('<leader>D', builtin.lsp_type_definitions, '[G]oto type [D]efinition')
                    map('K', vim.lsp.buf.hover, '[H]over documentation')
                    map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
                    map('<leader>rn', vim.lsp.buf.rename, '[R]e[N]ame')

                    local client = vim.lsp.get_client_by_id(event.data.client_id)
                    if client and client.server_capabilities.documentHighlightProvider then
                        vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                            buffer = event.buf,
                            callback = vim.lsp.buf.document_highlight,
                        })

                        vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                            buffer = event.buf,
                            callback = vim.lsp.buf.clear_references,
                        })
                    end
                end
            })

            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

            local servers = {
                lua_ls = {},
            }

            require('mason').setup()

            local ensure_installed = vim.tbl_keys(servers or {})
            vim.list_extend(ensure_installed, {})
            require('mason-tool-installer').setup({ ensure_installed = ensure_installed })

            require('mason-lspconfig').setup({
                handlers = {
                    function(server_name)
                        local server = servers[server_name] or {}
                        server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
                        require('lspconfig')[server_name].setup(server)
                    end
                }
            })
        end,
    },

    {
        'hrsh7th/nvim-cmp',

        event = 'InsertEnter',

        dependencies = {
            { 
                'L3MON4D3/LuaSnip',
                build = (function()
                    return 'make install_jsregexp'
                end)(),
            },
            'saadparwaiz1/cmp_luasnip',

            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-path',
        },

        config = function()
            local cmp = require('cmp')
            local luasnip = require('luasnip')
            luasnip.config.setup({})

            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end
                },

                completion = { completeopt = 'menu, menuone, noinsert' },

                mapping = {
                    ['<C-n>'] = cmp.mapping.select_next_item(),
                    ['<C-p>'] = cmp.mapping.select_prev_item(),
                    ['<C-Space>'] = cmp.mapping.confirm({ select = true }),
                    ['<C-Alt>'] = cmp.mapping.complete({}),
                },

                sources = {
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' },
                    { name = 'path' },
                },
            })
        end,
    },

    {
        'folke/lazydev.nvim',
        ft = 'lua',
        opts = {
            library = {
                { path = 'luvit-meta/library', words = { 'vim%.uv' }},
            },
        },
    },

    {
        'lewis6991/gitsigns.nvim',
        opts = {
            signs = {
                add = { text = '+' },
                change = { text = '~' },
                delete = { text = '_' },
                topdelete    = { text = '‾' },
                changedelete = { text = '~' },
                untracked    = { text = '┆' },
            },

            current_line_blame = true,

            current_line_blame_opts = {
                virt_text = true,
                virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
                delay = 1000,
                ignore_whitespace = false,
                virt_text_priority = 100,
            },

            current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
        }
    },

    {
		'nvim-lualine/lualine.nvim',
        opts = {
            options = {
                theme = 'iceberg_dark',
                icons_enabled = false,
                component_separators = { left = ' ', right = ' ' },
                section_separators = { left = ' ', right = ' ' },
            },
        },
	},

    {
        'stevearc/oil.nvim',
        opts = {
            view_options = {
                show_hidden = true,
            },
        },
    },

    {
        'numToStr/Comment.nvim',
        opts = {},
    },
}
