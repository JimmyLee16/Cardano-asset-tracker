# 🧰 Midnight Address Checker

Một công cụ nhỏ giúp kiểm tra danh sách địa chỉ ví thông qua API của **Midnight**.  
Hỗ trợ nhập danh sách địa chỉ theo 2 cách — thủ công hoặc từ file `.csv`.

---

## 📦 Chuẩn bị

1. Tải về **2 file** (ví dụ: `check_addresses.ps1` và `run_check.bat`).  
2. Đặt cả 2 file vào **cùng một thư mục**.

---

## ⚙️ Cách sử dụng

CHẠY FILE .bat là vào tool

### Cách 1 — Dùng file CSV
1. Tạo file `address_list.csv` trong cùng thư mục với 2 file script.  
2. Nội dung file CSV **phải** có header `Address` ở cột A, các dòng sau là địa chỉ ví cần kiểm tra.

**Ví dụ `address_list.csv`:**
Address
addr1q...
addr1z...
addr1xy...

css
Copy code

### Cách 2 — Nhập địa chỉ thủ công
- Chạy `run_check.bat` (hoặc chạy `check_addresses.ps1` trong PowerShell) — script sẽ yêu cầu nhập địa chỉ từng cái một trong cửa sổ CMD/PowerShell.

---

## 🔄 Cơ chế hoạt động

- Tool gọi **API của Midnight** để kiểm tra thông tin từng địa chỉ.
- Hiện tại tool **gọi API liên tục** khi quét danh sách — với danh sách quá dài có thể gây lỗi do giới hạn API hoặc timeout.
- **Chưa có** hệ thống log chi tiết cho các địa chỉ bị lỗi (sẽ cập nhật sau).

---

## ⚠️ Lưu ý an toàn & vận hành

- **Kiểm tra thủ công** nội dung `check_addresses.ps1` và `run_check.bat` trước khi chạy — code chạy trực tiếp trong CMD/PowerShell.
- Nếu bạn có **danh sách lớn**, hãy chia nhỏ CSV (ví dụ 50–100 địa chỉ mỗi file) để giảm rủi ro lỗi do rate-limit.
- Không sử dụng công cụ cho mục đích trái pháp luật hoặc gây quá tải API.

---

## 🧩 Roadmap (dự kiến)

- v1.0 — Đọc từ CSV / nhập tay — **Hoàn thành**  
- v1.1 — Thêm log cho các địa chỉ check lỗi — **Planned**  
- v1.2 — Thêm throttle/limit gọi API (delay, retry) — **Planned**

---

## 🛠 Ví dụ lệnh chạy

**PowerShell (chạy script trực tiếp):**
```powershell
# Mở PowerShell → chuyển đến thư mục chứa file → chạy:
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass 
./check_addresses.ps1
CMD (dùng .bat):

cmd
Copy code
cd C:\path\to\folder
run_check.bat

## **⚖️ Disclaimer / Miễn trừ trách nhiệm**

Tool này được cung cấp miễn phí và chỉ nhằm mục đích học tập & kiểm thử API.

Tác giả không chịu trách nhiệm cho mọi thiệt hại, mất mát dữ liệu, hoặc hành vi sử dụng sai mục đích.

Người dùng phải tự chịu trách nhiệm khi chạy script trên hệ thống của mình.

Không có bảo đảm nào về độ chính xác, tính ổn định, hoặc tính liên tục của dịch vụ API Midnight được sử dụng trong công cụ này.

Việc sử dụng tool đồng nghĩa bạn đồng ý với các điều khoản miễn trừ trách nhiệm nêu trên.

📜 License
MIT License © 2025
