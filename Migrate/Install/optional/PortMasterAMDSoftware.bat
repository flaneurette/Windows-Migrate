@echo off
setlocal

set /p dummy=Safety prompt: Press Enter to install Portmaster...

:: ---- Configuration ----
set PORTMASTER_URL=https://updates.safing.io/latest/windows_amd64/packages/Portmaster_2.0.25_x64-setup.exe
set PORTMASTER_EXE=%TEMP%\Portmaster_2.0.25_x64-setup.exe
set EXPECTED_HASH=28edd7e52db783065269b250ff1901277eae5c9770a1e8b7b6aa171f10586ce5

:: ---- Download using PowerShell ----
echo Downloading Portmaster...
powershell -Command "Invoke-WebRequest -Uri '%PORTMASTER_URL%' -OutFile '%PORTMASTER_EXE%'"

if not exist "%PORTMASTER_EXE%" (
    echo Failed to download Portmaster.
    pause
    exit /b 1
)

:: ---- Verify SHA256 hash ----
echo Verifying SHA256 hash...
for /f "tokens=*" %%i in ('certutil -hashfile "%PORTMASTER_EXE%" SHA256 ^| findstr /v "hash of" ^| findstr /v "CertUtil"') do set "FILE_HASH=%%i"
set FILE_HASH=%FILE_HASH: =%
echo Expected: %EXPECTED_HASH%
echo Actual:   %FILE_HASH%

if /i "%FILE_HASH%" neq "%EXPECTED_HASH%" (
    echo ERROR: SHA256 hash mismatch! Installation aborted.
    pause
    exit /b 1
)

echo Hash verified successfully.

:: ---- Install ----
echo Launching Portmaster installer...
powershell -Command "Start-Process '%PORTMASTER_EXE%' -Verb RunAs -Wait"

echo Cleaning up...
del "%PORTMASTER_EXE%"

echo Done. Portmaster installed.
pause
