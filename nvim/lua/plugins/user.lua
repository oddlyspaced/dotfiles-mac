return {
  -- Inline color swatches for Tailwind / CSS (carried over from the old LunarVim setup)
  {
    "norcalli/nvim-colorizer.lua",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("colorizer").setup({
        "css",
        "scss",
        "html",
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
      })
    end,
  },
}
