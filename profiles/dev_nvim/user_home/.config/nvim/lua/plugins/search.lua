return {
  -- snacks
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        -- hidden = true, -- Show hidden files by default (equivalent to pressing 'H')
        -- ignored = true, -- Show git-ignored files by default (equivalent to pressing 'I')

        sources = {
          -- This targets the file Explorer specifically
          explorer = {
            hidden = true, -- Ensure explorer shows hidden files
            ignored = true, -- Ensure explorer shows git-ignored files
          },
          -- This targets the fast file finder (<leader><space>)
          files = {
            hidden = true, -- Ensure file finder shows hidden files
            ignored = true, -- Ensure file finder shows git-ignored files
          },
        },
        win = {
          -- 1. Cấu hình cho cửa sổ LIST (Vì Explorer mặc định focus vào đây)
          list = {
            keys = {
              ["<Left>"] = { "explorer_close", mode = { "n", "i" } },
              ["<Right>"] = { "confirm", mode = { "n", "i" } },
            },
          },
          -- 2. Cấu hình thêm cho cửa sổ INPUT (Phòng trường hợp bạn nhảy lên ô tìm kiếm)
          input = {
            keys = {
              ["<Left>"] = { "explorer_close", mode = { "n", "i" } },
              ["<Right>"] = { "confirm", mode = { "n", "i" } },
            },
          },
        },
      },
    },
  },
  -- fzf-lua
  {
    "ibhagwan/fzf-lua",
    -- Cấu hình các phím tắt theo ý bạn
    opts = {
      winopts = {
        title_flags = true,
      },
    },
    keys = {
      -- Gán lại <leader>sg để chạy live_grep của fzf-lua
      { "<leader>sg", "<cmd>FzfLua live_grep<cr>", desc = "Search Grep (fzf-lua)" },

      -- Bạn cũng có thể đặt lại các phím tìm kiếm khác nếu thích:
      { "<leader>sf", "<cmd>FzfLua files<cr>", desc = "Search Files (fzf-lua)" },
      { "<leader>sb", "<cmd>FzfLua buffers<cr>", desc = "Search Buffers" },
      { "<leader>sh", "<cmd>FzfLua help_tags<cr>", desc = "Search Help" },
    },
  },
}
