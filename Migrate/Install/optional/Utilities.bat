@echo off
pause
setlocal enabledelayedexpansion

echo === Please be patient when installing, sometimes it takes a while to open the installer! ===

:: -------------------------------
:: Installer definitions
:: -------------------------------
set "name1=7-Zip"
set "url1=https://www.7-zip.org/a/7z2301-x64.exe"
set "file1=%TEMP%\7ZipSetup.exe"

set "name2=KeePassXC"
set "url2=https://github.com/keepassxreboot/keepassxc/releases/download/2.7.11/KeePassXC-2.7.11-Win64.msi"
set "file2=%TEMP%\KeePassXC-2.7.11-Win64.msi"

set "name3=VeraCrypt"
set "url3=https://launchpad.net/veracrypt/trunk/1.26.24/+download/VeraCrypt_Setup_x64_1.26.24.msi"
set "file3=%TEMP%\VeraCrypt_Setup_x64_1.26.24.msi"

set "name4=Foobar2000"
set "url4=https://www.foobar2000.org/downloads/foobar2000-x64_v2.25.3.exe"
set "file4=%TEMP%\foobar2000-x64_v2.25.3.exe"

set "name5=Malwarebytes"
set "url5=https://downloads.malwarebytes.com/file/mb-windows"
set "file5=%TEMP%\MalwarebytesSetup.exe"

set "name6=OpenVPN"
set "url6=https://openvpn.net/downloads/openvpn-connect-v3-windows.msi"
set "file6=%TEMP%\openvpn-connect-v3-windows.msi"

set "name7=WireGuard"
set "url7=https://download.wireguard.com/windows-client/wireguard-installer.exe"
set "file7=%TEMP%\wireguard-installer.exe"

set "name8=Termius"
set "url8=https://termi.us/win"
set "file8=%TEMP%\Install Termius.exe"

set "name9=Audacity"
set "url9=https://github.com/audacity/audacity/releases/download/Audacity-3.7.5/audacity-win-3.7.5-64bit.exe"
set "file9=%TEMP%\audacity-win-3.7.5-64bit.exe"

set "name10=LibreOffice"
set "url10=https://download.documentfoundation.org/libreoffice/stable/25.8.3/win/x86_64/LibreOffice_25.8.3_Win_x86-64.msi"
set "file10=%TEMP%\LibreOffice_25.8.3_Win_x86-64.msi"

set "name11=Notepad++"
set "url11=https://github.com/notepad-plus-plus/notepad-plus-plus/releases/download/v8.8.8/npp.8.8.8.Installer.x64.exe"
set "file11=%TEMP%\npp.8.8.8.Installer.x64.exe"

set "name12=Everything"
set "url12=https://www.voidtools.com/Everything-1.4.1.1016.x64-Setup.exe"
set "file12=%TEMP%\Everything-1.4.1.1016.x64-Setup.exe"

set "name13=ShareX"
set "url13=https://github.com/ShareX/ShareX/releases/download/v18.0.1/ShareX-18.0.1-setup.exe"
set "file13=%TEMP%\ShareX-18.0.1-setup.exe"

set "name14=OBS Studio"
set "url14=https://cdn-fastly.obsproject.com/downloads/OBS-Studio-32.0.2-Windows-x64-Installer.exe"
set "file14=%TEMP%\OBS-Studio-32.0.2-Windows-x64-Installer.exe"

set "name15=Visual Studio Code"
set "url15=https://update.code.visualstudio.com/latest/win32-x64-user/stable"
set "file15=%TEMP%\VSCodeUserSetup-x64-1.106.3.exe"

set "name16=Git for Windows"
set "url16=https://github.com/git-for-windows/git/releases/download/v2.42.0.windows.1/Git-2.42.0-64-bit.exe"
set "file16=%TEMP%\Git-2.42.0-64-bit.exe"

set "name17=VLC Media Player"
set "url17=https://get.videolan.org/vlc/3.0.21/win64/vlc-3.0.21-win64.exe"
set "file17=%TEMP%\vlc-3.0.21-win64.exe"

set "name18=Python"
set "url18=https://www.python.org/ftp/python/3.12.0/python-3.12.0-amd64.exe"
set "file18=%TEMP%\python-3.12.0-amd64.exe"

set "name19=Node.js"
set "url19=https://nodejs.org/dist/v20.6.0/node-v20.6.0-x64.msi"
set "file19=%TEMP%\node-v20.6.0-x64.msi"

set "name20=Vivaldi Browser"
set "url20=https://downloads.vivaldi.com/stable/Vivaldi.7.7.3851.56.x64.exe"
set "file20=%TEMP%\Vivaldi.7.7.3851.56.x64.exe"

set "count=20"

:: -------------------------------
:: Loop installers
:: -------------------------------
set i=1
:loop
if %i% GTR %count% goto end

call set "name=%%name%i%%%"
call set "url=%%url%i%%%"
call set "file=%%file%i%%%"

echo.
echo ===========================
echo Installing !name!
echo ===========================
:askinstall
set /p choice=Do you want to install !name!? [Y=Yes, S=Skip, N=Abort]: 

if /i "!choice!"=="S" (
    echo Skipping !name!...
    set /a i+=1
    goto loop
)
if /i "!choice!"=="N" (
    echo Aborting installation process.
    goto end
)
if /i not "!choice!"=="Y" (
    echo Invalid choice. Please enter Y, S, or N.
    goto askinstall
)

echo Downloading !name!...
curl -L -A "Mozilla/5.0" -o "!file!" "!url!"

if not exist "!file!" (
    echo ERROR: Download failed for !name!.
) else (
    echo Launching !name! installer...
    set "ext=!file:~-4!"
    if /i "!ext!"==".msi" (
        powershell -Command "Start-Process msiexec -ArgumentList '/i \"!file!\" /norestart /quiet' -Verb RunAs -Wait"
    ) else (
        powershell -Command "Start-Process '!file!' -Verb RunAs -Wait"
    )
    del "!file!"
)

set /a i+=1
goto loop

:end
echo.
echo All installations finished.
pause
