-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.g.mapleader = " "

vim.opt.fileencoding = "utf-8"

vim.opt.number = true -- line numbers

vim.opt.title = true
vim.opt.autoindent = true
vim.opt.hlsearch = true
vim.opt.scrolloff = 10
vim.opt.showcmd = true
vim.opt.autowrite = true

vim.opt.ignorecase = true -- makes searche case insensitive

vim.g.snacks_animate = false
vim.g.ai_cmp = false -- remove ai completion from regular completion menu

-- Auto root folder detection
-- vim.g.root_spec = { { "uv.lock", ".git" }, "lsp", "cwd" }
vim.g.root_lsp_ignore = { "copilot", "basedpyright", "pyright", "ruff" }

vim.g.lazyvim_python_lsp = "pyrefly"
-- vim.g.lazyvim_python_lsp = "basedpyright"
