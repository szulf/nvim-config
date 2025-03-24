local function map(key, action, desc)
    vim.keymap.set('n', key, action, { desc = desc })
end

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

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

vim.opt.termguicolors = true

vim.opt.guicursor = ''

vim.opt.inccommand = 'split'

vim.opt.hlsearch = true
map('<Esc>', function() vim.cmd('nohlsearch') end)

vim.o.clipboard = 'unnamedplus'

map('<C-h>', '<C-w><C-h>', 'Move to window [H]')
map('<C-j>', '<C-w><C-j>', 'Move to window [J]')
map('<C-k>', '<C-w><C-k>', 'Move to window [K]')
map('<C-l>', '<C-w><C-l>', 'Move to window [L]')

map('<C-d>', '<C-d>zz', 'Go down and center')
map('<C-u>', '<C-u>zz', 'Go up and center')

map('<C-Space>', '<C-6>', 'Switch between two buffers')

vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight text after yanking',
    callback = function()
        vim.highlight.on_yank()
    end
})

require('config.lazy')

map('<leader>mk', function() vim.cmd('make') end, 'Build the current project')
map('<leader>mo', function() vim.cmd('copen') end, 'View the compilation window')
local function load_local_makeprg()
    local project_file = vim.fn.getcwd() .. '/makeprg'
    if vim.fn.filereadable(project_file) == 1 then
        local text = table.concat(vim.fn.readfile(project_file), '\n')
        vim.opt_local.makeprg = text
    end
end

vim.api.nvim_create_augroup('ProjectConfig', { clear = true })
vim.api.nvim_create_autocmd('BufEnter', {
    group = 'ProjectConfig',
    callback = load_local_makeprg,
})

if vim.g.neovide then
    vim.opt.guifont = "JetBrains Mono NL:h11"
end

map('<leader>ds', vim.diagnostic.open_float, 'Show the whole diagnostic msg')
