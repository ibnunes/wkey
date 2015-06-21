@echo off

REM  ===== WKey =====
REM  Ver: 1.0.0
REM    By: Igor Nunes
REM  Date: June 21st, 2015
REM  Windows Key Decoder - for when your label wore out or doesn't even exist (e.g., laptops with Windows 8/8.1).
REM  Must be used only for genuine Windows when you need your original key to reinstall the OS.
REM  License: WTFPL 2

if exist mykey.txt (
   del mykey.txt
)
powershell (Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion' -Name DigitalProductId).DigitalProductId >> mykey.txt
wkey --FromBatch
pause