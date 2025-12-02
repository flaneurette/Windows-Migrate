@echo off
setlocal

:: -------------------------------
:: Configuration
:: -------------------------------
set "product_name=Sterling PDF"
set "SOFTWARE_URL=https://files.stirlingpdf.com/win-installer.exe"
set "SOFTWARE_EXE=%TEMP%\Stirling-PDF-windows-x86_64.msi"

:: -------------------------------
:: Safety prompt
:: -------------------------------
set /p dummy=Safety prompt: Press Enter to download and install %product_name%...

:: -------------------------------
:: Download
:: -------------------------------
echo Downloading %product_name%...
powershell -Command "Invoke-WebRequest -Uri '%SOFTWARE_URL%' -OutFile '%SOFTWARE_EXE%' -UseBasicParsing"

if not exist "%SOFTWARE_EXE%" (
    echo Failed to download %product_name%.
    pause
    exit /b 1
)

:: -------------------------------
:: Generate SHA256 hash
:: -------------------------------
echo Generating SHA256 hash of downloaded file...
for /f "tokens=*" %%A in ('powershell -Command "Get-FileHash -Path '%SOFTWARE_EXE%' -Algorithm SHA256 | Select-Object -ExpandProperty Hash"') do set "FILE_HASH=%%A"

echo SHA256 hash of downloaded file:
echo %FILE_HASH%
echo.

:: Optional: ask user to continue
set /p CONFIRM=Do you want to continue with installation? (Y/N): 
if /i not "%CONFIRM%"=="Y" (
    echo Installation cancelled.
    del "%SOFTWARE_EXE%"
    exit /b 0
)

:: -------------------------------
:: Install using msiexec
:: -------------------------------
echo Installing %product_name%...
msiexec /i "%SOFTWARE_EXE%" /quiet /norestart

:: Check exit code
if %ERRORLEVEL% neq 0 (
    echo Installation may have failed. Exit code: %ERRORLEVEL%
) else (
    echo Installation completed successfully.
)

:: -------------------------------
:: Cleanup
:: -------------------------------
echo Cleaning up...
del "%SOFTWARE_EXE%"

echo Done.
pause
