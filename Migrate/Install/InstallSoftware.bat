@echo off
setlocal enabledelayedexpansion

set /p dummy=Safety prompt: Press Enter to continue...
:: -----------------------
:: Paths
:: -----------------------
set TARGET=%USERPROFILE%\Desktop\Migrate\Data
set LIST64=%TARGET%\Lists\installed_programs_registry.txt
set LIST32=%TARGET%\Lists\installed_programs_wow64.txt
set SKIPPED=%TARGET%\SkippedPrograms.txt

:: -----------------------
:: Prepare skipped file
:: -----------------------
if exist "%SKIPPED%" del "%SKIPPED%"

echo Installing programs from lists...
echo.

:: -----------------------
:: Function to process a list
:: -----------------------
:processList
set "FILE=%1"
for /f "usebackq delims=" %%P in ("%FILE%") do (
    set "program=%%P"
    if not "!program!"=="" (
        :: ---- Clean program name ----
        set "program_clean=!program!"
        :: Remove parentheses and everything inside
        for /f "tokens=1 delims=(" %%A in ("!program_clean!") do set "program_clean=%%A"
        :: Trim trailing spaces
        set "program_clean=!program_clean:~0,-1!"
        if "!program_clean!"=="" set "program_clean=!program!"
        
        echo Searching Winget for: !program_clean!
        winget search --name "!program_clean!" > "%TEMP%\winget_search.txt" 2>nul

        :: Check if search found anything
        findstr /R /C:"^[A-Za-z0-9]" "%TEMP%\winget_search.txt" >nul
        if %errorlevel%==0 (
            for /f "tokens=1" %%I in ('findstr /R /C:"^[A-Za-z0-9]" "%TEMP%\winget_search.txt"') do (
                set "wingetId=%%I"
                echo Installing: !program_clean! (!wingetId!)...
                winget install --id "!wingetId!" --silent --accept-package-agreements --accept-source-agreements
                goto nextProgram
            )
        ) else (
            echo Skipping (not found in Winget): !program!
            echo !program!>>"%SKIPPED%"
        )
    )
    :nextProgram
    del "%TEMP%\winget_search.txt" 2>nul
)
goto :eof

:: -----------------------
:: Process both lists
:: -----------------------
call :processList "%LIST64%"
call :processList "%LIST32%"

:: -----------------------
:: Done
:: -----------------------
echo.
echo Installation complete!
if exist "%SKIPPED%" (
    echo Some programs were not found in Winget: %SKIPPED%
) else (
    echo All programs installed successfully!
)

pause
exit /b
