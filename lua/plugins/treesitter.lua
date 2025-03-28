return {
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

        vim.api.nvim_create_autocmd({'BufRead', 'BufNewFile'}, {
            pattern = { '*.vert', '*.frag' },
            callback = function()
                vim.cmd('setlocal filetype=glsl')
            end,
        })
    end,
}
