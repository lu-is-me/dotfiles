return {
  {
    "folke/snacks.nvim",
    opts = function(_, opts)
      opts.picker = opts.picker or {}
      -- opts.picker.hidden = true -- show dotfiles
      opts.picker.ignored = false -- show gitignored files
    end,
  },
}
