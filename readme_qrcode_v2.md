1. Nghiên cứu công nghệ về QR code (tạo mã QR) sử dụng trong flutter
* Thư viện qr_flutter (lib): tạo 1 mã QR từ 1 chuỗi (render a QR code from a string)
 - Nền tảng được hỗ trợ: android, iOS, web, linux, macOS
 - Hỗ trợ QR code từ version 1 - 40 (from Version 1 (21 × 21 modules) to Version 40 (177 × 177 modules))
 - Một mã QR có khả năng mã hóa tối đa 2953 byte dữ liệu, 4296 ký tự chữ và số, 7089 ký tự số hoặc 1817 ký tự Kanji (bộ ký tự theo JIS X 0208).
 - Ưu điểm: 
   + Hỗ trợ giúp tạo mã QR 1 cách nhanh chóng và đơn giản trên flutter với đa nền tảng (android, iOS, web, linux, macOS)
   + Hỗ trợ tuỳ chỉnh QR version 
 - Hạn chế: chỉ hỗ trợ tạo mã QR từ 1 chuỗi
