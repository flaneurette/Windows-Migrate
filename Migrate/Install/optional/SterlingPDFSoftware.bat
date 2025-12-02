@echo off
setlocal

set "product_name=Sterling PDF"

set /p dummy=Safety prompt: Press Enter to install %product_name%...

:: ---- Configuration ----
set "SOFTWARE_URL=https://files.stirlingpdf.com/win-installer.exe"
set "SOFTWARE_EXE=%TEMP%\win-installer.exe"

:: ---- Download using PowerShell ----
echo Downloading %product_name%...
powershell -Command "Invoke-WebRequest -Uri '%SOFTWARE_URL%' -OutFile '%SOFTWARE_EXE%' -UseBasicParsing"

if not exist "%SOFTWARE_EXE%" (
    echo Failed to download %product_name%.
    pause
    exit /b 1
)

:: ---- Generate SHA256 hash ----
echo Generating SHA256 hash of downloaded file...
for /f "tokens=*" %%A in ('powershell -Command "Get-FileHash -Path '%SOFTWARE_EXE%' -Algorithm SHA256 | Select-Object -ExpandProperty Hash"') do set "FILE_HASH=%%A"

echo SHA256 hash of %product_name% installer:
echo %FILE_HASH%
echo.

:: Optional: Ask user to confirm before installing
set /p CONFIRM=Do you want to continue with installation? (Y/N): 
if /i not "%CONFIRM%"=="Y" (
    echo Installation cancelled.
    del "%SOFTWARE_EXE%"
    exit /b 0
)

:: ---- Install ----
echo Launching %product_name% installer...
powershell -Command "Start-Process '%SOFTWARE_EXE%' -Verb RunAs -Wait"

:: ---- Cleanup ----
echo Cleaning up...
del "%SOFTWARE_EXE%"

echo Done. %product_name% installed.
pause
