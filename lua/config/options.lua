-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Configurar scrolloff para centrar el cursor
vim.opt.scrolloff = 20
vim.opt.sidescrolloff = 10

-- Solucionar problemas de renderizado al cambiar ventanas
vim.opt.termguicolors = true
vim.opt.cursorline = true
vim.opt.cursorcolumn = false
vim.opt.lazyredraw = false
vim.opt.ttyfast = true

-- Configuración para mejor renderizado
vim.opt.updatetime = 100
vim.opt.timeoutlen = 300

-- Deshabilitar Netrw completamente (usar solo Neo-tree)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3
vim.g.netrw_browse_split = 4
vim.g.netrw_altv = 1
vim.g.netrw_winsize = 25

-- Evitar que Netrw se abra automáticamente
vim.g.netrw_keepdir = 0
vim.g.netrw_silent = 1
