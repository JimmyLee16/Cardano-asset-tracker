🧰 Midnight Address Checker

Một công cụ nhỏ giúp kiểm tra danh sách địa chỉ ví thông qua API của Midnight.
Hỗ trợ nhập danh sách địa chỉ theo 2 cách — thủ công hoặc từ file .csv.

📦 Chuẩn bị

Tải về 2 file (script .ps1 và .bat)

Đặt cả 2 file vào cùng một thư mục

⚙️ Cách sử dụng
Cách 1: Dùng file CSV

Tạo file address_list.csv

Ở cột A, đặt header là Address

Dán các địa chỉ ví cần kiểm tra vào dưới cột đó
(mỗi dòng một địa chỉ)

Cách 2: Nhập địa chỉ thủ công

Chạy file .bat

Khi được yêu cầu, nhập từng địa chỉ ví cần kiểm tra trực tiếp trong cửa sổ CMD

🔄 Cơ chế hoạt động

Tool gọi API từ Midnight để kiểm tra thông tin địa chỉ

Hiện tại tool đang ở chế độ call API liên tục, nên nếu danh sách quá dài có thể dẫn đến lỗi tạm thời

Chưa hỗ trợ log lỗi cho các địa chỉ thất bại (tính năng này sẽ được bổ sung trong bản cập nhật tiếp theo)

⚠️ Lưu ý

Vui lòng tự kiểm tra nội dung file .ps1 và .bat trước khi chạy
→ Code chạy trực tiếp trong môi trường CMD/PowerShell, không có sandbox an toàn

Không sử dụng tool này cho mục đích tấn công hoặc spam API

🧩 Roadmap
Phiên bản	Tính năng	Trạng thái
v1.0	Kiểm tra địa chỉ từ CSV / thủ công	✅
v1.1	Ghi log địa chỉ lỗi	🕓 Planned
v1.2	Giới hạn tần suất API / Delay tự động	🕓 Planned
🧠 Gợi ý

Nếu bạn kiểm tra danh sách rất dài, hãy chia nhỏ CSV thành nhiều phần (mỗi file 50–100 địa chỉ) để tránh lỗi từ API Midnight.

📜 License

MIT License © 2025
Developed by the Community 🛠️
