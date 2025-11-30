@echo off
setlocal enabledelayedexpansion

:ask
set /p config=Do you want to remove the installed Next DNS settings? press Y .. 
if "%config%"=="" goto ask

echo === Removing DNS settings... ===
powershell -Command "Remove-DnsClientDohServerAddress -ServerAddress 45.90.30.0"
powershell -Command "Remove-DnsClientDohServerAddress -ServerAddress 45.90.28.0"
echo Done!

pause
