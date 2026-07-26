-- lua/config/keymaps.lua

-- Nhấn Space + p để mở Projects
vim.keymap.set("n", "<leader>p", function()
  Snacks.picker.projects()
end, { desc = "Mở Projects" })

-- Hàm bổ trợ để kiểm tra xem menu autocomplete (Pop-up Menu) có đang mở hay không
local pumvisible = function()
  return vim.fn.pumvisible() == 1
end

-- 1. ĐIỀU HƯỚNG LÊN / XUỐNG (Bằng mũi tên hoặc j/k)
-- Nhấn Mũi tên xuống hoặc Ctrl+j để xuống dưới trong menu
vim.keymap.set("c", "<Down>", function()
  return pumvisible() and "<C-n>" or "<Down>"
end, { expr = true })
vim.keymap.set("c", "<C-j>", function()
  return pumvisible() and "<C-n>" or "<C-j>"
end, { expr = true })

-- Nhấn Mũi tên lên hoặc Ctrl+k để lên trên trong menu
vim.keymap.set("c", "<Up>", function()
  return pumvisible() and "<C-p>" or "<Up>"
end, { expr = true })
vim.keymap.set("c", "<C-k>", function()
  return pumvisible() and "<C-p>" or "<C-k>"
end, { expr = true })

-- 2. CHẤP NHẬN VÀ TIẾP TỤC GỢI Ý (Mũi tên phải hoặc Ctrl+l)
-- Khi bấm Mũi tên phải hoặc Ctrl+l: Chấp nhận từ đang chọn hiện tại và tự động kích hoạt đợt gợi ý tiếp theo (nếu có thư mục con)
vim.keymap.set("c", "<Right>", function()
  if pumvisible() then
    return "<C-y>" -- "<C-y>" là lệnh gốc của Neovim để "Confirm" lựa chọn trong PUM
  end
  return "<Right>"
end, { expr = true })

vim.keymap.set("c", "<C-l>", function()
  if pumvisible() then
    return "<C-y>"
  end
  return "<C-l>"
end, { expr = true })

-- 3. DỪNG GỢI Ý / ĐÓNG MENU (Mũi tên trái hoặc Ctrl+h)
-- Bấm Mũi tên trái hoặc Ctrl+h để đóng menu gợi ý lại và giữ nguyên những gì đang gõ
vim.keymap.set("c", "<Left>", function()
  if pumvisible() then
    return "<C-e>" -- "<C-e>" là lệnh gốc để tắt (Abort/Exit) menu autocomplete
  end
  return "<Left>"
end, { expr = true })

vim.keymap.set("c", "<C-h>", function()
  if pumvisible() then
    return "<C-e>"
  end
  return "<C-h>"
end, { expr = true })



-- 4
-- Disable automatic Snacks dashboard when all buffers are closed
vim.api.nvim_create_autocmd("BufDelete", {
  callback = function()
    local bufs = vim.t.bufs or {}
    if #bufs == 0 then
      -- Do nothing, leaving you with an empty space/buffer
      return
    end
  end,
})
