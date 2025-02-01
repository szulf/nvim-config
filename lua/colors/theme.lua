local colors = {
  gray = '#708090',
  brown = '#645452',
  cyan = '#88afa2',
  red = '#ffc0b9',
  statement = '#a96571',
  functions = '#bc9a5f',
  constants = '#81a3a0',
  types = '#ceab6f',
}

-- vim.api.nvim_set_hl(0, 'Normal', { bg = colors.dark_bg })
-- vim.api.nvim_set_hl(0, 'Statement', { fg = colors.statement })
-- vim.api.nvim_set_hl(0, 'Function', { fg = colors.func })
-- vim.api.nvim_set_hl(0, 'Identifier', { fg = colors.white })
-- vim.api.nvim_set_hl(0, 'Constant', { fg = colors.constant })
-- vim.api.nvim_set_hl(0, '@type', { fg = colors.cyan })
-- vim.api.nvim_set_hl(0, '@type.builtin', { fg = colors.cyan })
-- vim.api.nvim_set_hl(0, 'Structure', { fg = colors.white })
-- vim.api.nvim_set_hl(0, 'Todo', { fg = colors.white, bold = true })

vim.api.nvim_set_hl(0, 'Statement', { fg = colors.statement })
vim.api.nvim_set_hl(0, '@type', { fg = colors.types })
vim.api.nvim_set_hl(0, '@type.builtin', { fg = colors.types })
vim.api.nvim_set_hl(0, 'Constant', { fg = colors.constants })
vim.api.nvim_set_hl(0, 'Function', { fg = colors.functions })
vim.api.nvim_set_hl(0, 'ErrorMsg', { fg = colors.red })
vim.api.nvim_set_hl(0, 'Operator', { fg = colors.statement })
