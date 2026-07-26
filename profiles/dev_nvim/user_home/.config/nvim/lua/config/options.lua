-- lua/config/options.lua

-- Cho phép tự động hoàn thành (wildmenu) hiển thị cả file ẩn
vim.opt.wildignorecase = true -- Không phân biệt chữ hoa chữ thường khi tab file
vim.o.wildoptions = "pum"     -- Hiển thị gợi ý dạng menu Pop-up (gọn gàng hơn)
-- Mặc định Neovim KHÔNG ẩn dotfiles khi hoán thiện lệnh, nhưng nếu bạn dùng các plugin bên thứ ba 
-- hoặc muốn ép hệ thống quét sâu hơn, dòng dưới đây đảm bảo không loại trừ file ẩn:
vim.opt.wildignore:remove({ ".*" })

