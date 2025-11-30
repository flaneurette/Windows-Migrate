@echo off

echo === Checking DNS... NextDNS should say True at AutoUpgrade. Please confirm. If not, then manually edit the adapter! ===
powershell -NoProfile -Command "Get-DnsClientDohServerAddress"
echo.
echo Press any key to exit...
pause >nul

for /f "tokens=* usebackq" %%A in (`powershell -Command "(Invoke-WebRequest -UseBasicParsing 'https://test.nextdns.io').Content"`) do set output=%%A

echo %output% | findstr /i "\"DOH\":\"ok\"" >nul
if %errorlevel%==0 (
    echo DNS-over-HTTPS is ENABLED (DoH OK).
) else (
    echo DNS-over-HTTPS is NOT enabled.
)

echo.
echo Press any key to exit...
pause >nul
