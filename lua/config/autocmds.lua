-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Guardar sesión automáticamente al salir
vim.api.nvim_create_autocmd({ "VimLeavePre" }, {
  group = vim.api.nvim_create_augroup("AutoSaveSession", { clear = true }),
  pattern = "*",
  callback = function()
    -- Solo guardar si estamos en un directorio válido
    local cwd = vim.fn.getcwd()
    if cwd and cwd ~= "" then
      vim.cmd("silent! mksession! " .. cwd .. "/Session.vim")
    end
  end,
})

-- Cargar sesión automáticamente al abrir (deshabilitado temporalmente)
-- vim.api.nvim_create_autocmd({ "VimEnter" }, {
--   group = vim.api.nvim_create_augroup("AutoLoadSession", { clear = true }),
--   pattern = "*",
--   callback = function()
--     -- Esperar a que los plugins se carguen
--     vim.defer_fn(function()
--       local cwd = vim.fn.getcwd()
--       local session_file = cwd .. "/Session.vim"
--       if vim.fn.filereadable(session_file) == 1 then
--         vim.cmd("source " .. session_file)
--       end
--     end, 100)
--   end,
-- })
