@echo off
setlocal enabledelayedexpansion

:: Re-launch as admin if needed
openfiles >nul 2>&1
if errorlevel 1 (
    echo Requesting administrative privileges...
    powershell -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)

:: Config
set TARGET=%USERPROFILE%\Desktop\Migrate\Data
set LOG=%TARGET%\Logs\migrate_log.txt
set EXCLUDE_DESKTOP=%USERPROFILE%\Desktop\Migrate
set TIMESTAMP=
for /f "tokens=1-4 delims=/: " %%a in ('echo %date% %time%') do (
    rem build a basic timestamp yyyyMMdd_HHmmss - relies on locale; we'll also use PowerShell later for zip filename
)
echo Migration started at %DATE% %TIME% > "%LOG%"

:: Create folders
echo Creating folders... >> "%LOG%"
mkdir "%TARGET%" 2>nul
mkdir "%TARGET%\Registry" 2>nul
mkdir "%TARGET%\Paths" 2>nul
mkdir "%TARGET%\System" 2>nul
mkdir "%TARGET%\Browser" 2>nul
mkdir "%TARGET%\AppData" 2>nul
mkdir "%TARGET%\WiFi" 2>nul
mkdir "%TARGET%\Lists" 2>nul
mkdir "%TARGET%\Users" 2>nul
mkdir "%TARGET%\Logs" 2>nul
mkdir "%TARGET%\Archive" 2>nul
mkdir "%TARGET%\Firewall" 2>nul
mkdir "%TARGET%\Drivers" 2>nul
set BACKUP_REG=%TARGET%\Registry
mkdir "%BACKUP_REG%" 2>nul

:: Export user PATH
set "OUTFILE=%TARGET%\Paths\PATH_user.txt"
echo %PATH% > "%OUTFILE%"
echo === PATH exported to %OUTFILE% === 

echo === Copying Installed Programs (registry) ===
echo Installed Programs (registry) > "%TARGET%\Lists\installed_programs_registry.txt"
powershell -Command "Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName } | Select-Object -ExpandProperty DisplayName" >> "%TARGET%\Lists\installed_programs_registry.txt"
echo === Copying Installed Programs (Wow6432Node) ===
echo Installed Programs (Wow6432Node) > "%TARGET%\Lists\installed_programs_wow64.txt" 
powershell -Command "Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName } | Select-Object -ExpandProperty DisplayName" >> "%TARGET%\Lists\installed_programs_registry_wow64.txt"

:: Browser profiles
:: -----------------------
echo === Copying browser profiles... === 
echo Copying browser profiles... >> "%LOG%"
rem Chrome
if exist "%LOCALAPPDATA%\Google\Chrome\User Data" (
    robocopy "%LOCALAPPDATA%\Google\Chrome\User Data" "%TARGET%\Browser\Chrome" /MIR /R:2 /W:2 >> "%LOG%" 2>&1
) else echo Chrome profile not found >> "%LOG%"

rem Edge
if exist "%LOCALAPPDATA%\Microsoft\Edge\User Data" (
    robocopy "%LOCALAPPDATA%\Microsoft\Edge\User Data" "%TARGET%\Browser\Edge" /MIR /R:2 /W:2 >> "%LOG%" 2>&1
) else echo Edge profile not found >> "%LOG%"

rem Firefox (Roaming + Local)
if exist "%APPDATA%\Mozilla\Firefox" (
    robocopy "%APPDATA%\Mozilla\Firefox" "%TARGET%\Browser\Firefox_Roaming" /MIR /R:2 /W:2 >> "%LOG%" 2>&1
) else echo Firefox roaming not found >> "%LOG%"

if exist "%LOCALAPPDATA%\Mozilla\Firefox" (
    robocopy "%LOCALAPPDATA%\Mozilla\Firefox" "%TARGET%\Browser\Firefox_Local" /MIR /R:2 /W:2 >> "%LOG%" 2>&1
) else echo Firefox local not found >> "%LOG%"


:: Exporting the entire registry :: 
echo === Exporting registry hives to "%BACKUP_REG%"... === 

reg export HKLM "%BACKUP_REG%\HKLM.reg" /y
reg export HKCU "%BACKUP_REG%\HKCU.reg" /y
reg export HKCR "%BACKUP_REG%\HKCR.reg" /y
reg export HKU  "%BACKUP_REG%\HKU.reg" /y
reg export HKCC "%BACKUP_REG%\HKCC.reg" /y

:: Exporting firewall ::
echo === Exporting Firewall Rules ===
netsh advfirewall export "%TARGET%\Firewall\FirewallRules.wfw"
echo === Firewall Rules Exported ===

:: Wi-Fi profiles
echo === Exporting Wi-Fi profiles (with clear keys)... ===
echo === Exporting Wi-Fi profiles (with clear keys)... >> "%LOG%" === 
netsh wlan export profile key=clear folder="%TARGET%\WiFi" >> "%LOG%" 2>&1

echo === Exporting driverlist... ===
driverquery /v /fo list > "%TARGET%\Lists\drivers.txt"
echo === Exporting services... ===
sc query type= service state= all > "%TARGET%\Lists\services.txt"
echo === Exporting printers... ===
wmic printer list brief > "%TARGET%\Lists\printers.txt"
echo === Exporting scheduled tasks... ===
schtasks /query /fo LIST /v > "%TARGET%\Lists\scheduled_tasks.txt"
echo === Exporting startup programs... ===
wmic startup get caption,command > "%TARGET%\Lists\startup_programs.txt"
echo === Exporting IP config... ===
ipconfig /all > "%TARGET%\Lists\ipconfig_all.txt"
echo === Exporting hosts file... ===
type "%WINDIR%\System32\drivers\etc\hosts" > "%TARGET%\Lists\hosts.txt"

echo === Exporting tasks scheduler config... ===
:: Copy Task Scheduler tasks (configuration)
robocopy "%WINDIR%\System32\Tasks" "%TARGET%\System\Tasks" /E /R:2 /W:2 >> "%LOG%" 2>&1

:: Export all drivers
set "EXPORT_DIR_DRIVERS=%TARGET%\Drivers"

mkdir "%EXPORT_DIR_DRIVERS%" 2>nul
dism /online /export-driver /destination:"%EXPORT_DIR_DRIVERS%"

echo === Drivers exported to: %EXPORT_DIR_DRIVERS% ===

:: Printers export (drivers list)
echo === Exporting printer config via powershell... ===
echo === Exporting printer config via powershell... >> "%LOG%"  === 
powershell -Command "Get-Printer | Format-Table Name,DriverName,PortName,Shared -AutoSize" > "%TARGET%\Lists\printers_ps.txt"

:: Other useful dumps
echo === Saving Windows activation status and restore points... ===
echo === Saving Windows activation status and restore points... >> "%LOG%"  === 
slmgr /dlv > "%TARGET%\Lists\windows_activation.txt"
vssadmin list shadows > "%TARGET%\Lists\restore_points.txt" 2>nul

echo === Compressing collected data into a zip on the Desktop.. ===

set DATAFOLDER=%USERPROFILE%\Desktop\Migrate\Data
set ZIPDEST=%USERPROFILE%\Desktop\Migrate
for /f "tokens=1-4 delims=/: " %%a in ('echo %date% %time%') do set TIMESTAMP=%DATE:~-4%%DATE:~3,2%%DATE:~0,2%_%TIME:~0,2%%TIME:~3,2%%TIME:~6,2%
set TIMESTAMP=%TIMESTAMP: =0%
set ZIPFILE=%ZIPDEST%\Migrate_Export_%TIMESTAMP%.zip
:: ----------------------
:: Detect 7-Zip
:: ----------------------
set "SEVENZIP="
if exist "C:\Program Files\7-Zip\7z.exe" set "SEVENZIP=C:\Program Files\7-Zip\7z.exe"
if exist "C:\Program Files (x86)\7-Zip\7z.exe" set "SEVENZIP=C:\Program Files (x86)\7-Zip\7z.exe"

echo Compressing collected data into a zip...
if defined SEVENZIP (
    echo 7-Zip detected: %SEVENZIP%
    "%SEVENZIP%" a -tzip "%ZIPFILE%" "%DATAFOLDER%\*" -mx=3
    if errorlevel 1 (
        echo 7-Zip failed, falling back to Compress-Archive...
        powershell -Command "Compress-Archive -Path '%DATAFOLDER%\*' -DestinationPath '%ZIPFILE%' -Force"
    )
) else (
    echo 7-Zip not found, using Compress-Archive...
    powershell -Command "Compress-Archive -Path '%DATAFOLDER%\*' -DestinationPath '%ZIPFILE%' -Force"
)

echo Done! Created archive: %ZIPFILE%

:: Finalize
echo Migration finished at %DATE% %TIME% >> "%LOG%"
echo Done! All data is in:
echo %TARGET%
echo A timestamped zip was created in: %USERPROFILE%\Desktop\Migrate
echo See log: %LOG%
pause
exit /b
