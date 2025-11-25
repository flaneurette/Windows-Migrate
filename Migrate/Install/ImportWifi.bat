@echo off
set /p dummy=Safety prompt: Press Enter to continue...
set TARGET=%USERPROFILE%\Desktop\Migrate\Data

echo === Importing Wi-Fi profiles ===

if exist "%TARGET%\WiFi\*.xml" (
    for %%f in ("%TARGET%\WiFi\*.xml") do (
        echo Importing %%~nxf...
        netsh wlan add profile filename="%%f" user=current
    )
    echo === Wi-Fi profiles imported ===
) else (
    echo No Wi-Fi profiles found to import.
)

pause
