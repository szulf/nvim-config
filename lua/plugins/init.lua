local function map(key, action, desc)
    vim.keymap.set('n', key, action, { desc = desc })
end

return {
    {
        'catppuccin/nvim',
        lazy = false,
        priority = 1000,
        opts = {
            color_overrides = {
                mocha = {
                    base = "#181818",
                    mantle = "#181818",
                    crust = "#181818",
                },
            },
        },
        config = function(_, opts)
            require('catppuccin').setup(opts)
            vim.cmd('colorscheme catppuccin')
        end
    },

    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        opts = {
            ensure_installed = { 'lua', 'cpp', 'glsl', 'vim', 'vimdoc', 'markdown', 'bash' },
            auto_install = true,
            highlight = { enable = true },
        },
        config = function(_, opts)
            require('nvim-treesitter.configs').setup(opts)
            vim.treesitter.language.register('angular', { 'html' })

            vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
                pattern = { "*.vert", "*.frag" },
                callback = function()
                    vim.cmd("setlocal filetype=glsl")
                end,
            })
        end,
    },

    {
        "ibhagwan/fzf-lua",
        opts = {},
        config = function()
            map('<leader>ff', function() vim.cmd('FzfLua files') end, "search files")
            map('<leader>fg', function() vim.cmd('FzfLua grep') end, "grep files")
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
                    local fzf = require('fzf-lua')

                    map('gd', fzf.lsp_definitions,'[G]oto [D]efinition')
                    map('gD', fzf.lsp_declarations, '[G]oto [D]eclaration')
                    map('K', vim.lsp.buf.hover, '[H]over documentation')
                    map('<leader>ca', fzf.lsp_code_actions, '[C]ode [A]ction')

                    -- local builtin = require('telescope.builtin')
                    -- map('gd', builtin.lsp_definitions, '[G]oto [D]efinition')
                    -- map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
                    -- map('gr', builtin.lsp_references, '[G]oto [R]eferences')
                    -- map('gi', builtin.lsp_implementations, '[G]oto [I]mplementation')
                    -- map('<leader>D', builtin.lsp_type_definitions, '[G]oto type [D]efinition')
                    -- map('K', vim.lsp.buf.hover, '[H]over documentation')
                    -- map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
                    -- map('<leader>rn', vim.lsp.buf.rename, '[R]e[N]ame')

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
            -- capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

            local servers = {
                lua_ls = {},

                clangd = {
                    cmd = {
                        "clangd",
                        "--clang-tidy",
                    },
                },

                pylsp = {
                    settings = {
                        pylsp = {
                            plugins = {
                                pycodestyle = {
                                    enabled = true,
                                    ignore = {'E501'},
                                    maxLineLength = 120,
                                },
                            },
                        }
                    },
                },

                cmake = {},

                glsl_analyzer = {},

                html = {},

                ts_ls = {},
            }

            require('mason').setup()

            local ensure_installed = vim.tbl_keys(servers or {})
            vim.list_extend(ensure_installed, {})
            require('mason-tool-installer').setup({ ensure_installed = ensure_installed })

            require('mason-lspconfig').setup({
                ensure_installed = ensure_installed,
                automatic_installation = false,
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
        'nvim-tree/nvim-tree.lua',
        opts = {
            view = {
                width = 40,
            },
        },
        config = function(_, opts)
            require('nvim-tree').setup(opts)
            map('<leader>fe', function() vim.cmd('NvimTreeToggle') end, 'Open the file explorer')

            -- im so proud of myself for writing this
            -- first autocommand thats actually written by myself
            vim.api.nvim_create_autocmd({"BufEnter"}, {
                callback = function()
                    local api = require('nvim-tree.api')
                    local bufnr = vim.api.nvim_get_current_buf()

                    if not api.tree.is_tree_buf(bufnr) then
                        api.tree.close()
                    end
                end
            })
        end
    },

    {
        'numToStr/Comment.nvim',
        opts = {},
    },
}
