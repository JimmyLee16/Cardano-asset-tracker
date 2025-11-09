@echo off
powershell -NoProfile -Command "Start-Process wt -ArgumentList 'powershell -NoProfile -ExecutionPolicy Bypass -File \"%~dp0Gui.ps1\"' -Verb RunAs"
