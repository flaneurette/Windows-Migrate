@echo off
setlocal enabledelayedexpansion

set "product_name=WinSCP"
set "DOWNLOAD_URL=https://altushost-bul.dl.sourceforge.net/project/winscp/WinSCP/6.5.5/WinSCP-6.5.5-Setup.exe?viasf=1"
set "OUTPUT_FILE=%TEMP%\WinSCP-6.5.5-Setup.exe"
set "EXPECTED_HASH=8c223402d933df4430f2c6e3cad17ed1db17710abfd13d62acc707ea480a092f"

set /p dummy=Safety prompt: Press Enter to install %product_name%...

echo Downloading %product_name%...
curl -L -A "Mozilla/5.0" -o "%OUTPUT_FILE%" "%DOWNLOAD_URL%"

if not exist "%OUTPUT_FILE%" (
    echo ERROR: Download failed.
    pause
    exit /b 1
)

:: Validate file size
for %%A in ("%OUTPUT_FILE%") do set size=%%~zA
if %size% LSS 200000 (
    echo ERROR: File too small - likely HTML instead of installer.
    pause
    exit /b 1
)

:: Check first bytes for HTML
powershell -Command ^
    "$bytes = Get-Content -Path '%OUTPUT_FILE%' -Encoding Byte -TotalCount 20;" ^
    "$txt = [System.Text.Encoding]::ASCII.GetString($bytes);" ^
    "if ($txt.StartsWith('<') -or $txt.Contains('HTML')) { exit 99 }"

if %ERRORLEVEL%==99 (
    echo ERROR: Download returned HTML instead of installer.
    pause
    exit /b 1
)

:: Verify SHA256
echo Verifying SHA256 hash...
for /f "tokens=*" %%i in ('certutil -hashfile "%OUTPUT_FILE%" SHA256 ^| findstr /v "hash of" ^| findstr /v "CertUtil"') do set "FILE_HASH=%%i"
set "FILE_HASH=%FILE_HASH: =%"
echo Expected: %EXPECTED_HASH%
echo Actual:   %FILE_HASH%
if /I not "%FILE_HASH%"=="%EXPECTED_HASH%" (
    echo ERROR: SHA256 hash mismatch!
    pause
    exit /b 1
)

echo Hash OK.

:: Install
echo Launching %product_name% installer...
powershell -Command "Start-Process '%OUTPUT_FILE%' -Verb RunAs -Wait"

echo Cleaning up...
del "%OUTPUT_FILE%"

echo Done. %product_name% installed.
pause
