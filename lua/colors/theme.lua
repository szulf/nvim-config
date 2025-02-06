-- mostly gray, blue functions, nice slightly yellow strings tho
-- local colors = {
--   constants = '#dec7a0',
--   error = '#ffc0b9',
--   functions = '#7e97ab',
--   statement = '#727272',
--   types = '#c3c3c3'
-- }
--
-- vim.api.nvim_set_hl(0, 'Statement', { fg = colors.statement })
-- vim.api.nvim_set_hl(0, '@type', { bold = true })
-- vim.api.nvim_set_hl(0, '@type.builtin', { bold = true })
-- vim.api.nvim_set_hl(0, 'Constant', { fg = colors.constants })
-- vim.api.nvim_set_hl(0, 'Function', { fg = colors.functions })
-- vim.api.nvim_set_hl(0, 'ErrorMsg', { fg = colors.error })

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

vim.api.nvim_set_hl(0, 'Statement', { fg = colors.statement })
vim.api.nvim_set_hl(0, '@type', { fg = colors.types })
vim.api.nvim_set_hl(0, '@type.builtin', { fg = colors.types })
vim.api.nvim_set_hl(0, 'Constant', { fg = colors.constants })
vim.api.nvim_set_hl(0, 'Function', { fg = colors.functions })
vim.api.nvim_set_hl(0, 'ErrorMsg', { fg = colors.red })
vim.api.nvim_set_hl(0, 'Operator', { fg = colors.statement })
