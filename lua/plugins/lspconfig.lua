return {
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
                Map('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
                Map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
                Map('K', vim.lsp.buf.hover, '[H]over documentation')
                Map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

                -- local builtin = require('telescope.builtin')
                -- Map('gd', builtin.lsp_definitions, '[G]oto [D]efinition')
                -- Map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
                -- Map('gr', builtin.lsp_references, '[G]oto [R]eferences')
                -- Map('gi', builtin.lsp_implementations, '[G]oto [I]mplementation')
                -- Map('<leader>D', builtin.lsp_type_definitions, '[G]oto type [D]efinition')
                -- Map('K', vim.lsp.buf.hover, '[H]over documentation')
                -- Map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
                -- Map('<leader>rn', vim.lsp.buf.rename, '[R]e[N]ame')

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
                    'clangd',
                    '--clang-tidy',
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

            csharp_ls = {},
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
}
