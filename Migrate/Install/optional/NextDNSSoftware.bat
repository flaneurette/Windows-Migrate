@echo off
setlocal enabledelayedexpansion

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
