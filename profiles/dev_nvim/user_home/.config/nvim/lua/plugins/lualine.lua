return {
  "nvim-lualine/lualine.nvim",
  opts = function(_, opts)
    -- Remove the directory from lualine_c first if you added it previously
    -- to prevent it from showing up twice.
    
    -- Insert the root directory at the beginning of lualine_c (the left side)
    table.insert(opts.sections.lualine_c, 1, {
      function()
        -- Gets the current working directory and replaces /home/user with ~
        return vim.fn.fnamemodify(vim.fn.getcwd(), ":~")
      end,
      icon = "󱉭", -- Optional folder/root icon, you can remove or change this
      color = { fg = "#ff9e64", gui = "bold" }, -- Orange color (matches TokyoNight/LazyVim orange)
    })
  end,
}
