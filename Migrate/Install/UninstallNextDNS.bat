@echo off
setlocal enabledelayedexpansion

:ask
set /p config=Do you want to remove the installed Next DNS settings? press Y .. 
if "%config%"=="" goto ask

:askdnsid1
set /p dnsid1=Enter your NextDNS DNS server 1: 
if "%dnsid1%"=="" goto askdnsid1

:askdnsid2
set /p dnsid2=Enter your NextDNS DNS server 2: 
if "%dnsid2%"=="" goto askdnsid2

echo === Removing DNS settings... ===
powershell -Command "Remove-DnsClientDohServerAddress -ServerAddress %dnsid1%"
powershell -Command "Remove-DnsClientDohServerAddress -ServerAddress %dnsid2%"
echo Done!

pause
