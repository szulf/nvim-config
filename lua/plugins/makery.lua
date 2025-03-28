return {
    'igemnace/vim-makery',

    config = function()
        local cfg = {
            ['~/projects/botman'] = {
                build = { makeprg = 'cmake --build build --config Debug' },
            },
        }

        vim.g.makery_config = cfg

        Map('<leader>mo', function() vim.cmd('copen') end, 'Open the quickfix window')
    end
}
