return {
  -- easy-dotnet: comandos de build/run/test/etc
  {
    "GustavEikaas/easy-dotnet.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      require("easy-dotnet").setup()
    end,
  },

  -- explorer.dotnet: árvore navegável estilo Solution Explorer
  {
    "xentropic-dev/explorer.dotnet.nvim",
    config = function()
      require("dotnet_explorer").setup({
        renderer = {
          width = 40,
          side = "left",
        },
      })
    end,
    keys = {
      { "<leader>ne", "<cmd>ToggleSolutionExplorer<cr>", desc = "Solution Explorer" },
    },
  },
}
