@echo off
:: Mở PowerShell trực tiếp thay vì dùng Windows Terminal (wt)
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0Checksolution_gui(vie).ps1"
pause
