Cardano Multi-Signature Address Tool
================================

Introduction
------------
This document explains how to use the `cardano-address` tool to generate multi-signature addresses for the Cardano blockchain, including payment and stake addresses.

Official sources:
- Download tool: https://github.com/IntersectMBO/cardano-addresses/releases  
- Original docs: https://github.com/IntersectMBO/cardano-addresses?tab=readme-ov-file  
- `multi-sig-payment-manual.ps1`: script for creating multi-signature payment addresses with customizable derivation paths
- `multi-sig-stake-manual.ps1`: script for creating multi-signature stake addresses with customizable derivation paths

Requirements
------------
- Windows PowerShell (works on Windows 10/11)
- Script files (`multi-sig-payment-manual.ps1` and `multi-sig-stake-manual.ps1`)
- The tool `cardano-address.exe` (placed in the same folder as the scripts)

Preparation
------------
1. Go to the download link above
2. Choose the version for your OS (Windows)
3. Extract and copy `cardano-address.exe` to any folder you want
4. Copy both multi-sig scripts into the same folder

Usage
-----
1. Open PowerShell (Run as Administrator to avoid policy errors)
2. If you get the error "running scripts is disabled", enable script execution:
   ```powershell
   Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
   ```
3. Run scripts:
   For payment address:
   ```powershell
   .\multi-sig-payment-manual.ps1
   ```
   For stake address:
   ```powershell
   .\multi-sig-stake-manual.ps1
   ```

Process
-------
- Generate mnemonics for each participant or use existing ones from phrase files
- Derive root keys for each participant
- Derive payment/stake keys with custom derivation paths
- Combine public keys according to the M-of-N multi-signature scheme
- Generate multi-signature addresses (payment and/or stake)
- Generate verification files for each participant

Security Notes
-------------
- Files ending with *.xsk are private keys — NEVER share them
- After use, delete sensitive files (phrase files, *.xsk)
- If you use passphrases, they are NOT written to disk, only kept in memory temporarily
- Each participant should keep their keys secure and separate
- Share only public keys (*.xvk) when creating multi-sig addresses

References
----------
Full documentation of cardano-address:
https://github.com/IntersectMBO/cardano-addresses?tab=readme-ov-file

=================================

Công Cụ Tạo Địa Chỉ Multi-Signature Cardano
=========================================

Giới thiệu
----------
Tài liệu này hướng dẫn cách sử dụng công cụ `cardano-address` để tạo địa chỉ đa chữ ký (multi-signature) trên blockchain Cardano, bao gồm cả địa chỉ payment và stake.

Nguồn chính thức:
- Download tool: https://github.com/IntersectMBO/cardano-addresses/releases
- Tài liệu gốc: https://github.com/IntersectMBO/cardano-addresses?tab=readme-ov-file
- script multi-sig-payment-manual là script tạo địa chỉ payment đa chữ ký với đường dẫn dẫn xuất tùy chỉnh
- script multi-sig-stake-manual là script tạo địa chỉ stake đa chữ ký với đường dẫn dẫn xuất tùy chỉnh

Yêu cầu
-------
- Windows PowerShell (có thể chạy trên Windows 10/11)
- Các file script (`multi-sig-payment-manual.ps1` và `multi-sig-stake-manual.ps1`)
- Công cụ `cardano-address.exe` (đặt trong cùng thư mục với các script)

Chuẩn bị
--------
1. Truy cập link download ở trên
2. Chọn bản phù hợp với hệ điều hành (Windows)
3. Giải nén và copy file `cardano-address.exe` vào bất kỳ thư mục nào bạn muốn
4. Copy cả hai script multi-sig vào cùng thư mục

Cách thực hiện
---------
1. Mở PowerShell (Run as Administrator để tránh lỗi policy)
2. Nếu gặp lỗi "running scripts is disabled", bật quyền chạy script:
   ```powershell
   Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
   ```
3. Chạy script:
   Cho địa chỉ payment:
   ```powershell
   .\multi-sig-payment-manual.ps1
   ```
   Cho địa chỉ stake:
   ```powershell
   .\multi-sig-stake-manual.ps1
   ```

Quy trình
---------
- Tạo mnemonic cho mỗi người tham gia hoặc sử dụng mnemonic có sẵn từ file
- Tạo root key cho mỗi người tham gia
- Tạo khóa payment/stake với đường dẫn dẫn xuất tùy chỉnh
- Kết hợp các public key theo mô hình đa chữ ký M-of-N
- Tạo địa chỉ đa chữ ký (payment và/hoặc stake)
- Tạo file xác minh cho mỗi người tham gia

Lưu ý Bảo mật
------------
- Các file có đuôi *.xsk là private key - TUYỆT ĐỐI KHÔNG chia sẻ
- Sau khi sử dụng, xóa các file nhạy cảm (file phrase, *.xsk)
- Nếu sử dụng passphrase, chúng KHÔNG được lưu vào ổ đĩa, chỉ lưu tạm thời trong bộ nhớ
- Mỗi người tham gia phải giữ khóa của mình an toàn và riêng biệt
- Chỉ chia sẻ public key (*.xvk) khi tạo địa chỉ multi-sig

Tài liệu tham khảo
-----------------
Tài liệu đầy đủ về cardano-address:
https://github.com/IntersectMBO/cardano-addresses?tab=readme-ov-file
