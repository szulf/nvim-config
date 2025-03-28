return {
    'folke/noice.nvim',

    opts = {
        presets = {
            command_palette = true,
        },
    },

    config = function(_, opts)
        require('noice').setup(opts)
    end
}
