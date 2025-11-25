@echo off
setlocal enabledelayedexpansion

:: Folder to scan
set FOLDER=%USERPROFILE%\Downloads

set TARGET=%USERPROFILE%\Desktop\Migrate\Data
mkdir "%TARGET%\Checksums" 2>nul

:: Output file
set OUTPUT=%TARGET%\Checksums\checksums.txt

echo Creating checksum list...
echo Checksums for files in %FOLDER% > "%OUTPUT%"
echo ---------------------------------------------------- >> "%OUTPUT%"

for %%F in ("%FOLDER%\*") do (
    echo Processing: %%~nxF

    set HASH=
    for /f "skip=1 tokens=1" %%H in ('certutil -hashfile "%%F" SHA256') do (
        if not defined HASH (
            set HASH=%%H
        )
    )

    if defined HASH (
        echo %%~nxF : !HASH!>> "%OUTPUT%"
    ) else (
        echo %%~nxF : [NO HASH] >> "%OUTPUT%"
    )
)

echo Done!
echo Results saved to: %OUTPUT%
pause
