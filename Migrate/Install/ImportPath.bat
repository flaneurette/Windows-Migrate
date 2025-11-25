@echo off
set /p dummy=Safety prompt: Press Enter to continue...
set INFILE=%USERPROFILE%\Desktop\Migrate\Data\Paths\PATH_user.txt

:: Read exported PATH
set /p OLDPATH=<"%INFILE%"

:: Append it to the current user PATH safely
echo Current PATH: %PATH%
echo Adding old PATH to user PATH...

:: Use setx to permanently add to user PATH
setx PATH "%PATH%;%OLDPATH%"

echo PATH updated! You may need to log off and log back in for changes to take effect.
pause
