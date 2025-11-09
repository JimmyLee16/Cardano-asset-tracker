@echo off
:: Mở PowerShell trực tiếp thay vì dùng Windows Terminal (wt)
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0Gui.ps1"
pause
