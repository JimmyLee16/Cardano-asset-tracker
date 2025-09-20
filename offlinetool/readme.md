Cardano-Address One-Click Tool
==============================

Giới thiệu
----------
Tài liệu này hướng dẫn cách tải xuống và sử dụng công cụ `cardano-address` để sinh mnemonic, khóa, và địa chỉ (payment, stake, delegated).

Nguồn chính thức:
- Download tool: https://github.com/IntersectMBO/cardano-addresses/releases
- Tài liệu gốc: https://github.com/IntersectMBO/cardano-addresses?tab=readme-ov-file
- script 1_click là script tạo địa chỉ tự động với dẫn xuất stake & payment = 0 (giống như khi tạo 1 ví mới từ đầu)
- script manual là script tạo địa chỉ tùy biến dẫn xuất theo ý của người dùng ( người dùng cần phải có hiểu biết cơ bản về kiến thức này)

Yêu cầu
-------
- Windows PowerShell (có thể chạy trên Windows 10/11).
- File script `1_click.ps1`.
- Công cụ `cardano-address.exe` (đặt trong cùng thư mục với script).

Cài đặt
-------
1. Truy cập link download ở trên.
2. Chọn bản phù hợp với hệ điều hành (Windows).
3. Giải nén và copy file `cardano-address.exe` vào bất kỳ thư mục nào bạn muốn).
4. Copy script `1_click.ps1` vào cùng thư mục.

5. Hoặc tải file 1_click.hta về lưu tại cùng thư mục với file ps1 và cardano-address.exe và chạy file.

Cách chạy
---------
1. Mở PowerShell (Run as Administrator để tránh lỗi policy).
2. Nếu gặp lỗi "running scripts is disabled", bật quyền chạy script:
  ```powershell
powershell Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass```

3. Chạy script:
   .\1_click.ps1

Quy trình
---------
- Tạo mnemonic (15 từ) hoặc dùng mnemonic đã có trong `phrase.prv`.
- Sinh root.xsk (root private key).
- Sinh payment key (addr.xsk + addr.xvk).
- Sinh stake key (stake.xsk + stake.xvk).
- Sinh địa chỉ payment-only (payment.addr).
- Sinh stake address (stake.addr).
- Sinh địa chỉ delegated (base) gồm payment + stake (addr.delegated).

Lưu ý bảo mật
-------------
- Các file *.xsk là private key, tuyệt đối KHÔNG chia sẻ.
- Sau khi dùng xong, nên xoá các file nhạy cảm (phrase.prv, *.xsk).
- Nếu có dùng passphrase, script KHÔNG lưu ra file, chỉ giữ trong bộ nhớ tạm thời.

Tham khảo thêm
---------------
- Tài liệu đầy đủ về `cardano-address`: 
  https://github.com/IntersectMBO/cardano-addresses?tab=readme-ov-file
