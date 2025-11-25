@echo off
set source=%USERPROFILE%

:askDestination
set /p destination="Enter destination path (e.g., D:\ or E:\Backup): "

:: Make sure path does not start with C:
if /i "%destination:~0,2%"=="C:" (
    echo You cannot use C: as the destination. Please choose another drive.
    goto askDestination
)

:: Ensure the path ends with a backslash
if not "%destination:~-1%"=="\" set destination=%destination%\

echo === Starting Backup ===

:: Make destination folders if needed
mkdir "%destination%\AppData" >nul 2>&1
mkdir "%destination%\Desktop" >nul 2>&1

:: Remove system + hidden flags from destination folders
attrib -h -s "%destination%\AppData" /S /D
attrib -h -s "%destination%\Desktop" /S /D

echo.
echo === Copying AppData (NO ACLs, NO audit info) ===
robocopy "%source%\AppData" "%destination%\AppData" /E /COPY:DAT /R:3 /W:5 /XJ

echo.
echo === Copying Desktop ===
robocopy "%source%\Desktop" "%destination%\Desktop" /E /COPY:DAT /R:3 /W:5 /XJ

:: Remove system + hidden flags from destination folders
attrib -h -s "%destination%\AppData" /S /D
attrib -h -s "%destination%\Desktop" /S /D

echo.
echo === Backup Complete ===
pause
