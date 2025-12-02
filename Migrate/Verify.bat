@echo off
setlocal enabledelayedexpansion

set "migrateFolder=%USERPROFILE%\Desktop\Migrate"
set "checksumFile=%migrateFolder%\checksums.txt"

if not exist "%checksumFile%" (
    echo ERROR: %checksumFile% not found
    pause
    exit /b
)

echo Verifying file integrity in %migrateFolder%...
set /a okCount=0
set /a failCount=0
set /a missingCount=0

for /f "usebackq tokens=1,*" %%A in ("%checksumFile%") do (
    set "expectedHash=%%A"
    set "relPath=%%B"

    rem Remove leading 'Migrate\' if present
    if "!relPath:~0,8!"=="Migrate\" set "relPath=!relPath:~8!"

    set "fullPath=%migrateFolder%\!relPath!"

    if not exist "!fullPath!" (
        echo [MISSING] !fullPath!
        set /a missingCount+=1
    ) else (
        for /f %%H in ('certutil -hashfile "!fullPath!" SHA256 ^| find /i /v "hash" ^| find /i /v ":"') do set "actualHash=%%H"
        set "actualHash=!actualHash: =!"

        if /i "!actualHash!"=="!expectedHash!" (
            set /a okCount+=1
        ) else (
            echo [FAIL]  !fullPath!
            echo   Expected: !expectedHash!
            echo   Actual:   !actualHash!
            set /a failCount+=1
        )
    )
)

echo.
echo Verification complete.
echo [SUMMARY] OK: %okCount%   FAIL: %failCount%   MISSING: %missingCount%
pause
