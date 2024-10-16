return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      -- Remove snippet expansion section
      opts.snippet = nil

      -- Change the keybinding for completion confirmation
      opts.mapping["<C-CR>"] = cmp.mapping.confirm {
        behavior = cmp.ConfirmBehavior.Insert,
        select = true,
      }
    end,
  },

  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
   		ensure_installed = {
   			"vim", "lua", "vimdoc",
        "html", "css",
        "cpp", "python",
        "javascript", "typescript"
   		},
   	},
   },

  {
    "folke/zen-mode.nvim",
    event = "VimEnter",
    opts = {
      window = {
        backdrop = 1.0,
        options = {
          number = false,
        }
      }
    }
  },

}
