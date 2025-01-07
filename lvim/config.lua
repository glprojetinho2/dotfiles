-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Example configs: https://github.com/LunarVim/starter.lvim
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny

lvim.plugins = {
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {}
  },
  { "mcchrish/zenbones.nvim", dependencies = "rktjmp/lush.nvim" },
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter"
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require "neotest-deno"
        }
      })
    end
  },
  { "markemmons/neotest-deno" },
  { "norcalli/nvim-colorizer.lua" },
  {
    "nvim-pack/nvim-spectre",
    dependencies = {
      "BurntSushi/ripgrep",
      "kyazdani42/nvim-web-devicons",
      "folke/trouble.nvim"
    }
  },
  {
    'mrcjkb/rustaceanvim',
    version = '^5',
    lazy = false
  }, {
  "jay-babu/mason-null-ls.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "williamboman/mason.nvim",
    "nvimtools/none-ls.nvim",
  },
},
  {
    'klen/nvim-config-local',
    config = function()
      require('config-local').setup {
        -- Default options (optional)

        -- Config file patterns to load (lua supported)
        config_files = { ".nvim.lua", ".nvimrc", ".exrc" },

        -- Where the plugin keeps files data
        hashfile = vim.fn.stdpath("data") .. "/config-local",

        autocommands_create = true, -- Create autocommands (VimEnter, DirectoryChanged)
        commands_create = true,     -- Create commands (ConfigLocalSource, ConfigLocalEdit, ConfigLocalTrust, ConfigLocalIgnore)
        silent = false,             -- Disable plugin messages (Config loaded/ignored)
        lookup_parents = false,     -- Lookup config files in parent directories
      }
    end
  },
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function() vim.fn["mkdp#util#install"]() end,
  }
}

-- colors
require'colorizer'.setup()

lvim.colorscheme = "randombones"

-- Bindings
lvim.keys.normal_mode["<TAB>"] = ":bn<CR>"
lvim.keys.normal_mode["<S-TAB>"] = ":bp<CR>"
lvim.keys.normal_mode["<leader>y"] = ":%y<CR>"
lvim.keys.normal_mode["<leader>zh"] = ":set cmdheight=1<CR>"
lvim.keys.normal_mode["<leader>h"] = ":nohlsearch<CR>"
lvim.keys.normal_mode["<leader>r"] = ":e<CR>"
lvim.keys.normal_mode["<leader>a"] =
":call system(\"deno test --allow-all /home/ferramentas/Downloads/sankhyasul/scriptsts/tests/experimentos/experimentos.test.ts --filter t123\")<CR>"
lvim.keys.normal_mode["<leader>sT"] = ":TodoTelescope<CR>"
lvim.keys.normal_mode["<leader>tq"] = ":copen<CR>"
lvim.keys.normal_mode["<leader>tn"] = ":cn<CR>"
lvim.keys.normal_mode["<leader>tp"] = ":cp<CR>"
lvim.keys.normal_mode["\""] =
":s/ignore: \\(true\\|false\\)/\\=submatch(1) == 'true' ? 'ignore: false' : 'ignore: true'/g<CR>"
lvim.keys.normal_mode["<C-y>"] = ":w !bash<CR>"

-- Options
lvim.format_on_save = true
vim.opt.number = true
vim.opt.wrap = true


-- Mason
require("mason-null-ls").setup({
  ensure_installed = {
    "black",
    "prettier",
    "xmlformat",
    "flake8",
  },
  automatic_installation = false,
  handlers = {},
})

-- Formatters
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  { name = "black" },
  { name = "prettier" },
  { name = "xmlformat" },
}

-- Linters
local linters = require "lvim.lsp.null-ls.linters"
linters.setup {
  { name = "flake8" },
}

-- LSP
vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "tailwindcss", "tsserver", "ts_ls" })
lvim.lsp.automatic_configuration.skipped_servers = vim.tbl_filter(function(server)
  return server ~= "denols" and server ~= "sqlls"
end, lvim.lsp.automatic_configuration.skipped_servers)
local nvim_lsp = require('lspconfig')
nvim_lsp.denols.setup({})

nvim_lsp.tsserver.setup {
  on_attach = on_attach,
  root_dir = nvim_lsp.util.root_pattern("package.json"),
  single_file_support = false
}
