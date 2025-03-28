return {
    'catppuccin/nvim',

    lazy = false,

    priority = 1000,

    opts = {
        color_overrides = {
            mocha = {
                base = '#181818',
                mantle = '#181818',
                crust = '#181818',
            },
        },
    },

    config = function(_, opts)
        require('catppuccin').setup(opts)
        vim.cmd('colorscheme catppuccin')
    end
}
