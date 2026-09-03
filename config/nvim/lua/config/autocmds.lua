-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

vim.api.nvim_create_autocmd("BufWinEnter", {
  group = vim.api.nvim_create_augroup("snacks_explorer_autorefresh", { clear = true }),
  callback = function(event)
    local picker = Snacks.picker.get({ source = "explorer" })[1]
    if not picker or picker:cwd() == LazyVim.root() then
      return
    end
    -- Variant 1: change directory
    local A = require("snacks.explorer.actions")
    pcall(function()
      picker:set_cwd(vim.fn.expand("%:p:h"))
      A.actions.explorer_update(picker)
    end)
    -- Variant 2: reveal the buffer/file
    -- local E = require 'snacks.explorer'
    -- E.reveal(event.buf)
  end,
})

-- Projekt-Woerterbuch: `zg` legt neue Woerter unter <git-root>/spell/de.utf-8.add ab,
-- damit Fachbegriffe (ROS, Odometrie, ...) im Repo versioniert werden.
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("project_spellfile", { clear = true }),
  pattern = { "typst", "markdown", "text", "plaintex", "tex" },
  callback = function(event)
    local root = vim.fs.root(event.buf, ".git")
    if not root then
      return
    end
    local dir = root .. "/spell"
    vim.fn.mkdir(dir, "p")
    vim.opt_local.spellfile = dir .. "/de.utf-8.add"
  end,
})
