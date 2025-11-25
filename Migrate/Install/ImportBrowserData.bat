@echo off
set TARGET=%USERPROFILE%\Desktop\Migrate\Data

set /p dummy=Press Enter to continue...

echo === Importing Browser profiles ===

:: Chrome
if exist "%TARGET%\Browser\Chrome" (
    robocopy "%TARGET%\Browser\Chrome" "%LOCALAPPDATA%\Google\Chrome\User Data" /MIR /R:2 /W:2
    echo Chrome profiles restored.
) else echo Chrome backup not found.

:: Edge
if exist "%TARGET%\Browser\Edge" (
    robocopy "%TARGET%\Browser\Edge" "%LOCALAPPDATA%\Microsoft\Edge\User Data" /MIR /R:2 /W:2
    echo Edge profiles restored.
) else echo Edge backup not found.

:: Firefox (Roaming + Local)
if exist "%TARGET%\Browser\Firefox_Roaming" (
    robocopy "%TARGET%\Browser\Firefox_Roaming" "%APPDATA%\Mozilla\Firefox" /MIR /R:2 /W:2
    echo Firefox Roaming profiles restored.
) else echo Firefox Roaming backup not found.

if exist "%TARGET%\Browser\Firefox_Local" (
    robocopy "%TARGET%\Browser\Firefox_Local" "%LOCALAPPDATA%\Mozilla\Firefox" /MIR /R:2 /W:2
    echo Firefox Local profiles restored.
) else echo Firefox Local backup not found.

echo === Browser import complete ===
pause
