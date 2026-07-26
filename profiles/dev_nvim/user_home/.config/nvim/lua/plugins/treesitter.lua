return {
  'nvim-treesitter/nvim-treesitter',
  lazy = false,
  build = ':TSUpdate',
  opts = {
    ensure_installed = {
      "lua", "bash"
    },

    auto_install = true,

    highlight = {
      enable = true,
    },
  },
  config = function(_, opts)
    require('nvim-treesitter').setup(opts)
  end,
}