return {
    'nvim-lualine/lualine.nvim',

    opts = {
        theme = 'catpuccin'
    },

    config = function(_, opts)
        require('lualine').setup(opts)
    end
}
