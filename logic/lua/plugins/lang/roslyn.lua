local utils = require("plugins.lang.dotnet-utils")

local M = {}

M.treesitter = {
  "nvim-treesitter/nvim-treesitter",
  opts = function(_, opts)
    table.insert(opts.ensure_installed, "c_sharp")
  end,
}

M.roslyn = {
  M.treesitter,
  {
    "jmederosalvarado/roslyn.nvim",
    build = ":CSInstallRoslyn"
  },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      local roslyn = {
        setup = function(capabilities, on_attach)
          require("roslyn").setup({
            capabilities = capabilities,
            on_attach = on_attach,
          })
        end
      }

      if type(opts.rouge) == "table" then
        table.insert(opts.rouge, roslyn)
      else
        opts.rouge = { roslyn }
      end
    end
  },
  {
    "nvim-neotest/neotest",
    dependencies = { "Issafalcon/neotest-dotnet" },
    opts = function(_, opts)
      local dotnet = {
        test_adapter = utils.test_adapter()
      }

      if type(opts.lang_opts) == "table" then
        table.insert(opts.lang_opts, dotnet)
      else
        opts.lang_opts = { dotnet }
      end
    end
  },
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = { "williamboman/mason.nvim", },
        opts = function(_, opts)
          local dotnet = {
            ensure_installed = utils.debug_adapter().ensure_installed,
            dap_options = utils.debug_adapter().dap_options,
            test_dap = utils.debug_adapter().test_dap
          }

          if type(opts.lang_opts) == "table" then
            table.insert(opts.lang_opts, dotnet)
          else
            opts.lang_opts = { dotnet }
          end
        end
      },
    },
  },
}

if vim.fn.executable("dotnet") == 1 then
  return M.roslyn
end

return M.treesitter
