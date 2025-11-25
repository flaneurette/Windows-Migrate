@echo off
set TARGET=%USERPROFILE%\Desktop\Migrate\Data

set /p dummy=Safety prompt: Press Enter to continue with Firewall rules import...

echo === Backing up current Firewall rules ===
netsh advfirewall export "%TARGET%\Firewall\FirewallRules_BACKUP.wfw"

echo === Importing saved Firewall rules ===
if exist "%TARGET%\Firewall\FirewallRules.wfw" (
    netsh advfirewall import "%TARGET%\Firewall\FirewallRules.wfw"
    echo === Firewall rules imported successfully ===
) else (
    echo No saved firewall rules found to import.
)

pause
