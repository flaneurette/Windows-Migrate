@echo off

:: Import hosts file from migration folder
set /p dummy=Safety prompt: Press Enter to continue...

:: --- Check for admin rights ---
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo This script must be run as Administrator!
    pause
    exit /b
)

:: --- Paths ---
set SOURCE=%USERPROFILE%\Desktop\Migrate\Data\Lists\hosts
set TARGET=C:\Windows\System32\drivers\etc\hosts

:: --- Backup old hosts file ---
echo === Backing up current hosts file... ===
copy /y "%TARGET%" "%TARGET%.backup" >nul

:: --- Take ownership & grant permissions ---
takeown /f "%TARGET%" >nul
icacls "%TARGET%" /grant administrators:F >nul

:: --- Copy new hosts file ---
echo === Importing hosts file from migration folder... === 
copy /y "%SOURCE%" "%TARGET%" >nul

if %errorlevel%==0 (
    echo Hosts file imported successfully.
) else (
    echo ERROR: Could not import hosts file!
)

pause
