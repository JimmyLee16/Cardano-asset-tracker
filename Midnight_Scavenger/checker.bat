@echo off
powershell -NoProfile -Command "Start-Process wt -ArgumentList 'powershell -NoProfile -ExecutionPolicy Bypass -File \"%~dp0Checksolution_gui.ps1\"' -Verb RunAs"
