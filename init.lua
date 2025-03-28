function Map(key, action, desc)
    vim.keymap.set('n', key, action, { desc = desc })
end

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true

vim.opt.scrolloff = 10
vim.opt.breakindent = true

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.list = true
vim.opt.listchars = { trail = '·', tab = '> ' }

vim.opt.showmode = false

vim.opt.termguicolors = true

vim.opt.guicursor = ''

vim.opt.inccommand = 'split'

vim.opt.hlsearch = true
Map('<Esc>', function() vim.cmd('nohlsearch') end)

vim.o.clipboard = 'unnamedplus'

Map('<C-h>', '<C-w><C-h>', 'Move to window [H]')
Map('<C-j>', '<C-w><C-j>', 'Move to window [J]')
Map('<C-k>', '<C-w><C-k>', 'Move to window [K]')
Map('<C-l>', '<C-w><C-l>', 'Move to window [L]')

Map('<C-d>', '<C-d>zz', 'Go down and center')
Map('<C-u>', '<C-u>zz', 'Go up and center')

Map('<C-Space>', '<C-6>', 'Switch between two buffers')

vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight text after yanking',
    callback = function()
        vim.highlight.on_yank()
    end
})

require('config.lazy')

-- Map('<leader>mk', function() vim.cmd('make') end, 'Build the current project')
-- Map('<leader>mo', function() vim.cmd('copen') end, 'View the compilation window')
-- local function load_local_makeprg()
--     local project_file = vim.fn.getcwd() .. '/makeprg'
--     if vim.fn.filereadable(project_file) == 1 then
--         local text = table.concat(vim.fn.readfile(project_file), '\n')
--         vim.opt_local.makeprg = text
--     end
-- end
--
-- vim.api.nvim_create_augroup('ProjectConfig', { clear = true })
-- vim.api.nvim_create_autocmd('BufEnter', {
--     group = 'ProjectConfig',
--     callback = load_local_makeprg,
-- })

if vim.g.neovide then
    vim.opt.guifont = 'JetBrains Mono NL:h11'
end

Map('<leader>ds', vim.diagnostic.open_float, 'Show the whole diagnostic msg')
