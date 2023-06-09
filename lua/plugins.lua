local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
      fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
      vim.cmd [[packadd packer.nvim]]
      return true
    end
    return false
  end
  
local packer_bootstrap = ensure_packer()

vim.cmd([[
augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
augroup end
]])

-- Only required if you have packer configured as `opt`
vim.cmd.packadd('packer.nvim')

function get_setup(name)
    return string.format("require('config.%s')", name)
end

return require('packer').startup(function(use)
  -- Packer can manage itself
  use ('wbthomason/packer.nvim')

  use ({
	  'nvim-telescope/telescope.nvim', tag = '0.1.0',
	  -- or                            , branch = '0.1.x',
	  requires = { {'nvim-lua/plenary.nvim'} },
      config = get_setup("telescope")
  })

  
  use ({ "catppuccin/nvim", as = "catppuccin", config = get_setup("catppuccin") })
 
  use({
      "folke/trouble.nvim",
      config = function()
          require("trouble").setup {
              icons = false,
              }
      end
  })

  use ({
        'nvim-treesitter/nvim-treesitter',
        run = function()
            local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
            ts_update()
        end,
        config = get_setup("treesitter")
    })

  use({"nvim-treesitter/playground", config = get_setup("treesitter-playground")})
  use({"theprimeagen/harpoon", config = get_setup("harpoon")})
  use({"theprimeagen/refactoring.nvim", config = get_setup("refactoring")})
  use({"mbbill/undotree", config = get_setup("undotree")})
  use({"tpope/vim-fugitive", config = get_setup("fugitive")})
  use({"nvim-treesitter/nvim-treesitter-context", config = get_setup("treesitter-context")})

  use ({
	  'VonHeikemen/lsp-zero.nvim',
      config = get_setup("lsp"),
	  branch = 'v1.x',
	  requires = {
		  -- LSP Support
		  {'neovim/nvim-lspconfig'},
		  {'williamboman/mason.nvim'},
		  {'williamboman/mason-lspconfig.nvim'},

		  -- Autocompletion
		  {'hrsh7th/nvim-cmp'},
		  {'hrsh7th/cmp-buffer'},
		  {'hrsh7th/cmp-path'},
		  {'saadparwaiz1/cmp_luasnip'},
		  {'hrsh7th/cmp-nvim-lsp'},
		  {'hrsh7th/cmp-nvim-lua'},

		  -- Snippets
		  {'L3MON4D3/LuaSnip'},
		  {'rafamadriz/friendly-snippets'},
	  }
  })

  use({"github/copilot.vim", config = get_setup("copilot")})

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)
