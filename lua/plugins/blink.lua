return {
    'saghen/blink.cmp',

    dependencies = {
        'rafamadriz/friendly-snippets',
    },

    opts = {
        keymap = {
            preset = 'default',
            ['<C-space>'] = { 'accept' },
            ['<C-k>'] = { 'show_documentation' },
        },

        fuzzy = {
            implementation = 'rust',
        },
    },
}
