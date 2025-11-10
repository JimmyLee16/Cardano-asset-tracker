## 🧰 Midnight-Scavenger Address Checker

- Công cụ nhỏ giúp kiểm tra danh sách địa chỉ ví thông qua API của **Midnight**.  
Hỗ trợ nhập danh sách địa chỉ theo 2 cách — thủ công hoặc từ file `.csv`.
- Tool được tạo bới VCC pool vì mục đích cộng đồng

---

## 📦 Chuẩn bị

1. Tải về **2 file** Checksolution_gui(vie).ps1 và checker.bat ( bạn có thể tự đặt tên khác nhưng lưu ý phải đổi tên file .ps1 lại trong file .bat ví dụ: `check_addresses.ps1` và `run_check.bat`).  
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
```

## **⚖️ Disclaimer / Miễn trừ trách nhiệm**

- Tool này được cung cấp miễn phí và chỉ nhằm mục đích học tập & kiểm thử API.
- Tác giả không chịu trách nhiệm cho mọi thiệt hại, mất mát dữ liệu, hoặc hành vi sử dụng sai mục đích.
- Người dùng phải tự chịu trách nhiệm khi chạy script trên hệ thống của mình.
- Không có bảo đảm nào về độ chính xác, tính ổn định, hoặc tính liên tục của dịch vụ API Midnight được sử dụng trong công cụ này.
- Việc sử dụng tool đồng nghĩa bạn đồng ý với các điều khoản miễn trừ trách nhiệm nêu trên.

  ## ** Liên hệ
  - Cardano ADA Việt Nam telegram group https://t.me/ADA_VIET
 
---------------------------------------------------------------------------------------------------------------------------

## 🧰 Midnight-Scavenger Address Checker

- A small tool that helps check a list of wallet addresses through the **Midnight API**.  
Supports two input methods — manual entry or importing from a `.csv` file.  
- Created by **VCC Pool** for community purposes.

---

## 📦 Preparation

1. Download **2 files**: `Checksolution_gui(vie).ps1` and `checker.bat` (you can rename them, but make sure to update the `.ps1` filename inside the `.bat` file accordingly, e.g. `check_addresses.ps1` and `run_check.bat`).  
2. Place both files in the **same directory**.

---

## ⚙️ How to Use

Run the `.bat` file to start the tool.

### Method 1 — Using a CSV file
1. Create a file named `address_list.csv` in the same folder as the two script files.  
2. The CSV file **must** have a header `Address` in column A, and subsequent rows should contain the wallet addresses you want to check.

**Example `address_list.csv`:**
Address
addr1q...
addr1z...
addr1xy...

yaml
Copy code

### Method 2 — Manual input
- Run `run_check.bat` (or execute `check_addresses.ps1` directly in PowerShell) — the script will prompt you to enter wallet addresses one by one in the CMD/PowerShell window.

---

## 🔄 How It Works

- The tool calls the **Midnight API** to check each address.  
- Currently, the tool **continuously calls the API** while scanning the list — for long lists, this may cause errors due to API rate limits or timeouts.  
- There is **no detailed log system yet** for failed addresses (to be added in future updates).

---

## ⚠️ Safety & Usage Notes

- **Manually review** `check_addresses.ps1` and `run_check.bat` before running — they execute directly in CMD/PowerShell.  
- If you have a **large list**, split it into smaller CSV files (e.g., 50–100 addresses per file) to avoid rate-limit issues.  
- Do **not** use this tool for illegal purposes or actions that may overload the API.

---

## 🧩 Roadmap (Planned)

- v1.0 — Read from CSV / Manual input — **Completed**  
- v1.1 — Add logging for failed address checks — **Planned**  
- v1.2 — Add API throttling/limiting (delay, retry) — **Planned**

---

## 🛠 Example Commands

**PowerShell (run the script directly):**
```powershell
# Open PowerShell → navigate to the folder → run:
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass 
./check_addresses.ps1
CMD (using .bat file):

cmd
Copy code
cd C:\path\to\folder
run_check.bat
⚖️ Disclaimer
This tool is provided free of charge and intended solely for educational and API testing purposes.

The author is not responsible for any damages, data loss, or misuse.

Users are fully responsible for executing scripts on their own systems.

No guarantee is provided for the accuracy, stability, or uptime of the Midnight API used in this tool.

By using this tool, you agree to the above terms of disclaimer.

📞 Contact
Cardano ADA Vietnam Telegram Group: https://t.me/ADA_VIET

📜 License
MIT License © 2025


📜 License
MIT License © 2025
