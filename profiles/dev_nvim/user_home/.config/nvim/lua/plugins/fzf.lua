return {
  "ibhagwan/fzf-lua",
  -- Cấu hình các phím tắt theo ý bạn
  keys = {
    -- Gán lại <leader>sg để chạy live_grep của fzf-lua
    { "<leader>sg", "<cmd>FzfLua live_grep<cr>", desc = "Search Grep (fzf-lua)" },

    -- Bạn cũng có thể đặt lại các phím tìm kiếm khác nếu thích:
    { "<leader>sf", "<cmd>FzfLua files<cr>", desc = "Search Files (fzf-lua)" },
    { "<leader>sb", "<cmd>FzfLua buffers<cr>", desc = "Search Buffers" },
    { "<leader>sh", "<cmd>FzfLua help_tags<cr>", desc = "Search Help" },
  },
}
