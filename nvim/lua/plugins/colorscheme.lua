return {
  -- Catppuccin theme
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      flavour = "mocha", -- latte / frappe / macchiato / mocha
      integrations = {
        cmp = true,
        gitsigns = true,
        treesitter = true,
        native_lsp = { enabled = true },
        which_key = true,
      },
    },
  },
  -- Make LazyVim use it
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
}
