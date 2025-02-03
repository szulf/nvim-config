local function map(key, action, desc)
    vim.keymap.set('n', key, action, { desc = desc })
end

return {
    {
        'andreypopp/vim-colors-plain',
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd('colorscheme plain')
        end,
    },

    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        opts = {
            ensure_installed = { 'lua', 'cpp', 'glsl', 'vim', 'vimdoc', 'markdown', 'bash' },
            auto_install = true,
            highlight = { enable = 'true' },
        },
        config = function(_, opts)
            require('nvim-treesitter.configs').setup(opts)
            vim.treesitter.language.register("angular", { "html" })
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
