@echo off
setlocal enabledelayedexpansion

REM ================================
REM Ask user whether to install NextDNS
REM ================================
:installprompt
set /p installChoice=Do you want to install NextDNS software for encrypted DNS? (Y/N): 
if /i "%installChoice%"=="Y" goto proceed
if /i "%installChoice%"=="N" (
    echo Skipping NextDNS installation.
    pause
    exit /b
)
echo Please enter Y or N.
goto installprompt

:proceed

REM ================================
REM Ask for CONFIG ID if not set
REM ================================
if "%CONFIG_ID%"=="" (
    set /p CONFIG_ID=Enter your NextDNS Configuration ID: 
)

REM ================================
REM Download Installer
REM ================================
set MSI_URL=https://nextdns.io/download/windows/stable.msi
set MSI_FILE=%~dp0NextDNS.msi

echo Downloading NextDNS installer to "%MSI_FILE%" ...
powershell -Command "Invoke-WebRequest -Uri '%MSI_URL%' -OutFile '%MSI_FILE%'"

if not exist "%MSI_FILE%" (
    echo ERROR: Download failed. MSI not found.
    pause
    exit /b
)

REM ================================
REM Install NextDNS silently
REM ================================
echo Installing NextDNS...
msiexec /i "%MSI_FILE%" /qn /norestart PROFILE=%CONFIG_ID% UI=0 ARP=0

REM ================================
REM Wait for service to appear
REM ================================
echo Waiting for NextDNS service to be installed...

:waitservice
sc query NextDNSService >nul 2>&1
if %errorlevel% NEQ 0 (
    timeout /t 2 /nobreak >nul
    goto waitservice
)

REM ================================
REM Start service
REM ================================
echo Starting NextDNS service...
sc start NextDNSService >nul 2>&1

echo.
echo NextDNS has been installed and configured for ID: %CONFIG_ID%
pause
