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

REM === Set standard DNS first ===
echo === Setting NextDNS records ===
netsh interface ip set dns name="%selected%" static 45.90.28.0 primary
netsh interface ip add dns name="%selected%" 45.90.30.0 index=2
echo Successfully changed the DNS adapter settings!
echo Next step.
:askid
set /p configid=Enter your NextDNS config ID: 
if "%configid%"=="" goto askid

echo You entered: %configid%
echo Setting DNS over HTTPS templates (may not show in Network Settings)...

powershell -Command "Add-DnsClientDohServerAddress -ServerAddress '45.90.28.0' -DohTemplate \"https://dns.nextdns.io/%configid%\""
powershell -Command "Add-DnsClientDohServerAddress -ServerAddress '45.90.30.0' -DohTemplate \"https://dns.nextdns.io/%configid%\""

echo == Done. ==
pause

REM === Ask user if they want to install NextDNS ===
:installprompt
set /p installChoice=Do you want to install NextDNS software for encrypted DNS? optional. (Y/N): 
if /i "%installChoice%"=="Y" goto proceed
if /i "%installChoice%"=="N" (
    echo Skipping NextDNS installation.
    pause
    exit /b
)
echo Please enter Y or N.
goto installprompt

:proceed

REM === Download NextDNS installer ===
set MSI_URL=https://nextdns.io/download/windows/stable.msi
set MSI_FILE=%~dp0NextDNS.msi

echo Downloading NextDNS installer...
powershell -Command "Invoke-WebRequest -Uri '%MSI_URL%' -OutFile '%MSI_FILE%'"

REM === Install NextDNS silently with profile ID ===
echo === Installing NextDNS... ===
msiexec /i "%MSI_FILE%" /qn /norestart PROFILE=%CONFIG_ID% UI=0 ARP=0

REM === Wait until the NextDNS service exists ===
echo Waiting for NextDNS service to be installed...
:waitservice
sc query NextDNSService >nul 2>&1
if errorlevel 1060 (
    timeout /t 2 /nobreak >nul
    goto waitservice
)

REM === Start NextDNS service ===
echo Starting NextDNS service...
sc start NextDNSService

echo.
echo NextDNS has been installed and configured for %selected%.

pause
