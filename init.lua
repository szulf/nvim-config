-- Leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Tab size
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

-- Indenting on line wrap
vim.opt.breakindent = true

-- Not case sensitive search unless /C
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Screen splits on bottom, not really sure what that does
vim.opt.splitbelow = true

-- A way of displaying whitespace
vim.opt.list = true
vim.opt.listchars = { trail = '·', tab = '│ ' }

-- Mode already shown in status line
vim.opt.showmode = false

-- Needed for feline
vim.opt.termguicolors = true

-- Showing the cursor line
vim.opt.cursorline = true

-- Showing the signcolumn
vim.opt.signcolumn = 'yes'

-- Substituting(:s) shows the preview live
vim.opt.inccommand = 'split'

-- Minimal lines shown when scrolling
vim.opt.scrolloff = 10

-- Disabling highlight with <Esc> after searching
vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Keymaps for diagnostics(like when it shows you an error or something i think)
vim.keymap.set('n', '<leader>dn', vim.diagnostic.goto_next, { desc = '[D]iagnostic [N]ext' })
vim.keymap.set('n', '<leader>dp', vim.diagnostic.goto_prev, { desc = '[D]iagnostic [P]revious' })
vim.keymap.set('n', '<leader>de', vim.diagnostic.open_float, { desc = '[D]iagnostic [E]rror' })
vim.keymap.set('n', '<leader>dq', vim.diagnostic.setloclist, { desc = '[D]iagnostic [Q]uickfix' })

-- Keymaps for moving around split windows
vim.keymap.set('n', '<C-h>', '<C-w><C-h>')
vim.keymap.set('n', '<C-j>', '<C-w><C-j>')
vim.keymap.set('n', '<C-k>', '<C-w><C-k>')
vim.keymap.set('n', '<C-l>', '<C-w><C-l>')

-- File Explorer
vim.keymap.set('n', '<leader>fe', '<cmd>:Ex<CR>')

-- More organized file navigation
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')

-- Highlighting the text after yanking
vim.api.nvim_create_autocmd('TextYankPost', {
	desc = 'Highlight text after yanking',
	callback = function()
		vim.highlight.on_yank()
	end
})

-- Installation of lazy.nvim(plugin manager)
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		'git',
		'clone',
		'--filter=blob:none',
		'https://github.com/folke/lazy.nvim.git',
		'--branch=stable', -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Plugin configuration
require('lazy').setup({
	-- opts = {} to force a plugin to be loaded

	-- Easy way to comment(gc)
	{ 'numToStr/Comment.nvim', opts = {}},

	-- Theme
	{ 'rebelot/kanagawa.nvim', opts = {}},

	-- Signs to represent github changes
	{ 'lewis6991/gitsigns.nvim', opts = {
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
	}},

	-- Transparent Background
	{ 'xiyaowong/transparent.nvim', opts = {}},

	-- Fuzzy finder
	{ 'nvim-telescope/telescope.nvim',
		-- event = 'VimEnter',
		-- branch = '0.1.x',
		dependencies = {
			-- Required dependency
			{ 'nvim-lua/plenary.nvim' },

			-- Required dependency for grep
			{ 'BurntSushi/ripgrep' },

			-- Faster file sorting algorithm
			{
				'nvim-telescope/telescope-fzf-native.nvim',
				build = 'make'
			},

			-- Using telescope in more vim places
			{ 'nvim-telescope/telescope-ui-select.nvim' },
		},
		config = function()
			-- Dont really know whats this for
			-- telescope.setup({
			-- 	extensions = {
			-- 		['ui-select'] = {
			-- 			require('telescope.themes').get_dropdown()
			-- 		}
			-- 	},
			-- })

			-- Loading telescope extensions
			-- pcall runs a function only if it doesnt throw an error
			pcall(require('telescope').load_extension, 'fzf')
			pcall(require('telescope').load_extension, 'ui-select')

			-- Requiring builtin functions
			local builtin = require('telescope.builtin')

			-- Some keymaps to move around
			vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = '[F]uzzy find [F]iles' })
			vim.keymap.set('n', '<leader>fg', builtin.git_files, { desc = '[F]uzzy find [G]it' })
			vim.keymap.set('n', '<leader>fs', builtin.grep_string, { desc = '[F]uzzy find [S]tring' })
			vim.keymap.set('n', '<leader>fl', builtin.live_grep, { desc = '[F]uzzy find [L]ive grep' })
			vim.keymap.set('n', '<leader>fd', builtin.diagnostics, { desc = '[F]uzzy search [D]iagnostics' })
		end
	},

	-- LSP :)
	{
		'neovim/nvim-lspconfig',
		dependencies = {
			-- Autoinstalling of Langunage Servers
			'williamboman/mason.nvim',
			'williamboman/mason-lspconfig.nvim',
			'WhoIsSethDaniel/mason-tool-installer.nvim',

			-- LSP notifications
			{ 'j-hui/fidget.nvim', opts = {}},

			-- Tools for lua nvim development
			{ 'folke/neodev.nvim', opts = {}},
		},
		config = function()
			vim.api.nvim_create_autocmd('LspAttach', {
				callback = function(event)

					-- Some basic keymaps
					local function map(key, func, desc)
						vim.keymap.set('n', key, func, { desc = 'LSP: ' .. desc })
					end

					local builtin = require('telescope.builtin')
					map('gd', builtin.lsp_definitions, '[G]oto [D]efinition')
					map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
					map('gr', builtin.lsp_references, '[G]oto [R]eference')
					map('gi', builtin.lsp_implementations, '[G]oto [I]mplementation')
					map('<leader>D', builtin.lsp_type_definitions, 'Goto type [D]efinition')
					map('H', vim.lsp.buf.hover, '[H]over Documentation')
					map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
					map('<leader>rn', vim.lsp.buf.rename, '[R]e[N]ame')

					-- Highlight hovered over text in a file
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

			-- Updating and sending LSP capabilities to the server
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

			local servers = {
				clangd = {},
				jdtls = {},
				lua_ls = {
					settings = {
						Lua = {
							completion = {
								callSnippet = 'Replace',
							}
						}
					}
				},
			}

			require('mason').setup()

			-- Can add things like code formaters and other tools here
			local ensure_installed = vim.tbl_keys(servers or {})
			vim.list_extend(ensure_installed, {})
			require('mason-tool-installer').setup({ ensure_installed = ensure_installed })

			require('mason-lspconfig').setup({
				-- Overriding only values explicitly passed by the server config above
				-- Dont really know what that means tho
				handlers = {
					function(server_name)
						local server = servers[server_name] or {}
						server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
						require('lspconfig')[server_name].setup(server)
					end
				}
			})
		end,
	},

	-- Autocompletion :)
	{
		'hrsh7th/nvim-cmp',
		event = 'InsertEnter',
		dependencies = {
			{ 'L3MON4D3/LuaSnip',
				build = (function()
					return 'make install_jsregexp'
				end)(),
			},
			'saadparwaiz1/cmp_luasnip',

			'hrsh7th/cmp-nvim-lsp',
			'hrsh7th/cmp-path',
		},
		config = function()
			local cmp = require('cmp')
			local luasnip = require('luasnip')
			luasnip.config.setup({})

			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end
				},
				completion = { completeopt = 'menu, menuone, noinsert' },
				mapping = {
					['<C-n>'] = cmp.mapping.select_next_item(),
					['<C-p>'] = cmp.mapping.select_prev_item(),
					['<C-Space>'] = cmp.mapping.confirm({ select = true }),
					['<C-Alt>'] = cmp.mapping.complete({}),
				},
				sources = {
					{ name = 'nvim_lsp' },
					{ name = 'luasnip' },
					{ name = 'path' },
				}
			})
		end
	},

	{
		'nvim-lualine/lualine.nvim',
		config = function()
			require('lualine').setup({
				-- options = { theme = grubox },
				options = {
					theme = 'gruvbox_dark',
					icons_enabled = false,
					component_separators = { left = ' ', right = ' ' },
					section_separators = { left = ' ', right = ' ' },
				},
			})
		end
	},

	{
		'nvim-treesitter/nvim-treesitter',
		build = ':TSUpdate',
		opts = {
			ensure_installed = { 'bash', 'c', 'html', 'lua', 'markdown', 'vim', 'vimdoc', },
			auto_install = true,
			highlight = { enable = 'true' },
			indent = { enable = 'true' },
		},
		config = function(_, opts)
			require('nvim-treesitter.configs').setup(opts)
		end
	},

	{ 'ThePrimeagen/vim-be-good' },

}, {})

-- Command needed to get the theme working
vim.cmd('colorscheme kanagawa')

-- Enable the transparent background
vim.cmd('TransparentEnable')
