Cardano-Address offline Tool
==============================

Introduction
------------
This document explains how to download and use the `cardano-address` tool to generate mnemonic phrases, keys, and addresses (payment, stake, delegated).

Official sources:
- Download tool: https://github.com/IntersectMBO/cardano-addresses/releases  
- Original docs: https://github.com/IntersectMBO/cardano-addresses?tab=readme-ov-file  
- `1_click` script: creates an address automatically with stake & payment indexes set to 0 (same as creating a brand-new wallet).  
- `manual` script: allows users to generate addresses with custom derivation indexes (requires some understanding of derivation paths).  

Requirements
------------
- Windows PowerShell (works on Windows 10/11).  
- Script file `1_click.ps1`.  
- The tool `cardano-address.exe` (placed in the same folder as the script).  

Installation
------------
1. Go to the download link above.  
2. Choose the version for your OS (Windows).  
3. Extract and copy `cardano-address.exe` to any folder you want.  
4. Copy the script `1_click.ps1` into the same folder.  

5. Alternatively, download `1_click.hta`, place it in the same folder with `1_click.ps1` and `cardano-address.exe`, then run it.  

Usage
-----
1. Open PowerShell (Run as Administrator to avoid policy errors).  
2. If you get the error "running scripts is disabled", enable script execution:  
   ```powershell
   powershell Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass 
3. Run script
   ```powershell
   .\1_click.ps1
   ```

   or
   ```powershell
   .\manual.ps1

***Process***
- Generate a new mnemonic (15 words) or reuse an existing one from phrase.prv.
- Derive root.xsk (root private key).
- Derive payment key (addr.xsk + addr.xvk).
- Derive stake key (stake.xsk + stake.xvk).
- Generate payment-only address (payment.addr).
- Generate stake address (stake.addr).
- Generate delegated/base address (addr.delegated) combining payment + stake.

Security Notes

Files ending with *.xsk are private keys — NEVER share them.

After use, delete sensitive files (phrase.prv, *.xsk).

If you use a passphrase, it is NOT written to disk, only kept in memory temporarily.

References

Full documentation of cardano-address:
https://github.com/IntersectMBO/cardano-addresses?tab=readme-ov-file


Cardano-Address offline Tool
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
   powershell Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

3. Chạy script:
   ```powershell
   .\1_click.ps1
      ```
hoặc
   ```powershell
   .\manual.ps1
```

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
