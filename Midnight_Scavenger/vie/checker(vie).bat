@echo off
:: Force UTF-8 mode in console
chcp 65001 >nul

:: Run PowerShell with explicit UTF-8 encoding and bypass policy
powershell -NoProfile -ExecutionPolicy Bypass ^
    -Command "$OutputEncoding=[Console]::OutputEncoding=[Text.UTF8Encoding]::new($false); & '%~dp0Checksolution_gui(vie).ps1'"
pause
