-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.g.mapleader = " "

vim.scriptencoding = "utf-8"
vim.opt.encoding = "utf-8"
vim.optfileencoding = "utf-8"

vim.opt.number = true

vim.opt.title = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.hlsearch = true
vim.opt.scrolloff = 10
vim.opt.showcmd = true
vim.opt.autowrite = true

vim.opt.ignorecase = true

vim.g.snacks_animate = false
vim.opt.wrap = true
-- this prevents crashing with weird folds
-- vim.opt.foldmethod = "manual"
-- vim.g.root_spec = { { "uv.lock", ".git" }, "lsp", "cwd" }

vim.g.root_lsp_ignore = { "copilot", "basedpyright", "pyright", "ruff" }
