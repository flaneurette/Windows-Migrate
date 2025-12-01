@echo off
setlocal enabledelayedexpansion

REM === List connected adapters ===
set count=0
for /f "tokens=1,2,3*" %%A in ('netsh interface show interface ^| findstr /R /C:"Connected"') do (
    set /a count+=1
    set adapter!count!=%%D
    echo !count!. %%D
)

if %count%==0 (
    echo No connected network adapters found.
    pause
    exit /b
)

REM === Ask user to choose an adapter ===
:ask
set /p choice=Select the adapter to enable NextDNS servers (1-%count%): 
if "%choice%"=="" goto ask
if %choice% GTR %count% goto ask
if %choice% LSS 1 goto ask

set selected=!adapter%choice%!
echo You selected: %selected%


:askdnsid1
set /p dnsid1=Enter your NextDNS DNS server 1: 
if "%dnsid1%"=="" goto askdnsid1

:askdnsid2
set /p dnsid2=Enter your NextDNS DNS server 2: 
if "%dnsid2%"=="" goto askdnsid2

REM === Set standard DNS first ===
echo === Setting NextDNS records ===
netsh interface ip set dns name="%selected%" static %dnsid1% primary
netsh interface ip add dns name="%selected%" %dnsid2%  index=2
echo Successfully changed the DNS adapter settings!
echo Next step.
:askid
set /p configid=Enter your NextDNS config ID: 
if "%configid%"=="" goto askid

echo You entered: %configid%
echo Setting DNS over HTTPS templates (may not show in Network Settings)...

echo Adding DNS-over-HTTPS servers...
:: powershell -NoProfile -Command "netsh dns add encryption %dnsid1%  'https://dns.nextdns.io/%configid%'"
:: powershell -NoProfile -Command "netsh dns add encryption %dnsid2%  'https://dns.nextdns.io/%configid%'"

echo Attempting to add DoH templates (may fail on older Windows)...
powershell -NoProfile -Command "Add-DnsClientDohServerAddress -ServerAddress '%dnsid1%' -DohTemplate 'https://dns.nextdns.io/%configid%' -AutoUpgrade $true"
powershell -NoProfile -Command "Add-DnsClientDohServerAddress -ServerAddress '%dnsid2%' -DohTemplate 'https://dns.nextdns.io/%configid%' -AutoUpgrade $true"

echo Done! DNS queries to NextDNS are now encrypted.

:: Not working... powershell -Command "Set-DnsClientDohPreference -InterfaceAlias "%selected%" -DohSettings Preferred"

echo === Checking DNS... NextDNS should say True at AutoUpgrade. Please confirm. If not, then manually edit the adapter! ===
powershell -NoProfile -Command "Get-DnsClientDohServerAddress"
echo === Checking global DoH/DoT. Please confirm if enabled. If not, then manually edit the adapter! ===
powershell -Command "netsh dns show global"

echo == Done. ==
pause

